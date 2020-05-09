import Foundation
import MMScriptFramework
MMLOG.info("Hello, world!")

ProcessInfo.processInfo.isHelp(helpStr: """
执行文件必须放在工程根路径中

projectName     工程名 包括后缀 如:MMLibrary.xcodeproj或MMSandBoxHTTP.xcworkspace
targetName      target名称

rootPath(可选)  项目根目录, 默认和执行文件在同一目录下
onlyActiveArch(可选)   NO | YES   默认NO
buildDir(可选)      默认Build目录
configType(可选)     Debug | Release 默认Release
libraryConfigPlist(可选)   配置文件名称 默认AutoBuildLibrary.plist


""")
var dictionary = ProcessInfo.processInfo.getDictionary()

let configUrl = URL(fileURLWithPath: kShellPath).appendingPathComponent("ScriptConfig")
let libraryConfigPlist = dictionary["libraryConfigPlist"] ?? "AutoBuildLibrary.plist"
let cachePath = configUrl.appendingPathComponent(libraryConfigPlist)
let cacheDictionary: [String: String] = NSDictionary(contentsOf: cachePath) as? [String : String] ?? [:]


let buildDir = dictionary["buildDir"] ?? cacheDictionary["buildDir"] ?? "Build"

let onlyActiveArch = dictionary["onlyActiveArch"] ?? cacheDictionary["onlyActiveArch"] ?? "NO"
let configType = dictionary["configType"] ?? cacheDictionary["configType"] ?? "Release"
let rootPath = dictionary["rootPath"] ?? cacheDictionary["rootPath"] ?? kShellPath
//拉取文件缓存, 如果dictionary中没有读取到数据, 则通过缓存读取
guard let projectName = dictionary["projectName"] ?? cacheDictionary["projectName"],
    let targetName = dictionary["targetName"] ?? cacheDictionary["targetName"] else {
        MMLOG.error("传入参数有误 dictionary = \(dictionary), cacheDictionary = \(cacheDictionary)")
    exit(1)
}
//编译结果输出路径
let buildUrl = URL(fileURLWithPath: kShellPath).appendingPathComponent(buildDir)
//检查配置路径是否存在
if !FileControl.isExist(atPath: configUrl.path) {
    do {
        try FileManager.default.createDirectory(at: configUrl, withIntermediateDirectories: true, attributes: nil)
    } catch  {
        MMLOG.error("文件夹创建失败 error = \(error)")
    }
}


//清除上一次编译结果
MMLOG.info("清除上一次编译结果 buildUrl.path = \(buildUrl.path)/*")
if FileControl.isExist(atPath: buildUrl.path) {
    do {
        try FileManager.default.removeItem(at: buildUrl)
    } catch {
        MMLOG.error("清除失败 error = \(error)")
    }
}

//检查生成路径是否存在
if !FileControl.isExist(atPath: buildUrl.path) {
    do {
        try FileManager.default.createDirectory(at: buildUrl, withIntermediateDirectories: true, attributes: nil)
    } catch  {
        MMLOG.error("文件夹创建失败 error = \(error)")
    }
}


//配置写入文件
if let _ = dictionary["rootPath"] ?? cacheDictionary["rootPath"] {
    dictionary["rootPath"] = rootPath
}

dictionary["projectName"] = projectName
dictionary["targetName"] = targetName
dictionary["onlyActiveArch"] = onlyActiveArch
dictionary["buildDir"] = buildDir
dictionary["configType"] = configType
MMLOG.info("保存配置: \(dictionary) -> \(cachePath)")
(dictionary as NSDictionary).write(to: cachePath, atomically: true)


var projectType = "-project"
var targetType = "-target"
if projectName.hasSuffix(".xcworkspace") {
    projectType = "-workspace"
    targetType = "-scheme"
}
let projectPaths = FileControl.getFilePath(rootPath: rootPath, selectFile: projectName, isSuffix: false, onlyOne: true, isDirectory: true)

guard var projectRootPath = projectPaths.first?.fullPath() else {
    MMLOG.error("未找到工程文件->\(projectName)")
    exit(2)
}

let buildSdks = ["iphoneos", "iphonesimulator"]
struct BuildFrameworkStruct {
    var frameworkPath: URL
    func swiftModule() -> URL {
        return frameworkPath.appendingPathComponent("Modules").appendingPathComponent("\(targetName).swiftmodule")
    }
}
var swiftModulePaths: [BuildFrameworkStruct] = []


for sdk in buildSdks {
    MMLOG.info("编译 \(sdk)")
    let result = MMScript.runScript(model: ScriptModel(path: kCodebuildPath, arguments: [projectType, projectRootPath, targetType, targetName, "-configuration", configType, "-sdk", sdk, "ONLY_ACTIVE_ARCH=\(onlyActiveArch)", "BUILD_DIR=\(buildUrl.path)", "BUILD_ROOT=\(buildUrl.path)", "clean", "build"]))
    if (result.error != nil) {
        MMLOG.info("result = \(result)")
    } else {
        let frameworkPath = buildUrl.appendingPathComponent("\(configType)-\(sdk)").appendingPathComponent("\(targetName).framework")
        let model = BuildFrameworkStruct(frameworkPath: frameworkPath)
        swiftModulePaths.append(model)
    }
}
//清理编译缓存
MMScript.runScript(model: ScriptModel(path: kCodebuildPath, arguments: [projectType, projectRootPath, "clean"]))

//找到需要合入的目标framework
let goalFramework = "\(buildUrl.path)/\(targetName).framework"
if !FileControl.isExist(atPath: goalFramework) && swiftModulePaths.count > 0 {
    //将第一个编译的移入目标目录下
    if let needCpFrameworkPath = swiftModulePaths.first?.frameworkPath {
        let result = MMScript.runScript(model: ScriptModel(path: kCPPath, arguments: ["-Rf", needCpFrameworkPath.path, buildUrl.path]))
        if result.error != nil {
            MMLOG.error("result = \(result)")
        }
    }
}

let goalSwiftModuleURL = URL(fileURLWithPath: goalFramework).appendingPathComponent("Modules").appendingPathComponent("\(targetName).swiftmodule")
//准备合并
for item in swiftModulePaths {
    let list = FileControl.getFilePath(rootPath: item.swiftModule().path, selectFile: "", isSuffix: false, onlyOne: false, recursiveNum: 0, isDirectory: false)
    
    for needCopyItem in list {
        let result = MMScript.runScript(model: ScriptModel(path: kCPPath, arguments: ["-n", needCopyItem.fullPath(), goalSwiftModuleURL.path], showOutData: true))
        if result.status == false {
            if result.terminationStatus == 1 {
                MMLOG.error("目标已存在 = \(result)")
            } else {
                MMLOG.error("cp失败 = \(result)")
            }
        }
    }
    
    let infoList = FileControl.getFilePath(rootPath: item.swiftModule().appendingPathComponent("Project").path, selectFile: "", isSuffix: false, onlyOne: false, recursiveNum: 0, isDirectory: false)
    
    for needCopyItem in infoList {
        let result = MMScript.runScript(model: ScriptModel(path: kCPPath, arguments: ["-n", needCopyItem.fullPath(), goalSwiftModuleURL.appendingPathComponent("Project").path], showOutData: true))
        if result.status == false {
            if result.terminationStatus == 1 {
                MMLOG.error("目标已存在 = \(result)")
            } else {
                MMLOG.error("cp失败 = \(result)")
            }
        }
    }
}


MMLOG.info("脚本运行完成")








