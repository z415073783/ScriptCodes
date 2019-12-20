import Foundation
import MMScriptFramework
//MMLOG.info("Hello, world!")
//print("Hello, world!")
ProcessInfo.processInfo.isHelp(helpStr: """
功能:根据配置进行文件copy,根据仓库已有版本号进行自增,并修改.podspec文件版本号,将本地代码及版本号推送到远端仓库,推送版本配置文件到远端版本库


commit    提交信息
version    自定义版本号
""")

MMLOG.info("开始执行")

let arguments = ProcessInfo.processInfo.getDictionary()

guard let plist = NSDictionary(contentsOfFile: kShellPath + "/PushPodSpecSetup.plist") else {
    MMLOG.error("未找到PushPodSpecSetup.plist文件")
    exit(1)
}
MMLOG.info("PushPodSpecSetup.plist信息: \(plist)")

guard let projectRootPath = plist["LocalRepository"] as? String, let gitUrl = plist["GitUrl"] as? String, let projectName = plist["RepositoryName"], let cocoaPodName = plist["CocoaPods"] as? String else {
    MMLOG.error("参数信息不完整")
    exit(1)
}

var commitText = arguments["commit"] ?? (plist["Commit"] as? String ?? "update")

//移动文件
if let moveList: [[String: String]] = plist["MoveList"] as? [[String: String]] {
    for dic in moveList {
        guard let resourcePath = dic["ResourcePath"], let goalRelativePath = dic["GoalRelativePath"], let fileName = dic["FileName"] else {
            MMLOG.error("文件路径未配置完整")
            exit(2)
        }
        do {
            //删除目标路径已有文件
            try FileManager.default.removeItem(atPath: "\(projectRootPath)/\(goalRelativePath)/\(fileName)")
        } catch {
            MMLOG.error("文件删除失败")
        }


        do {

            MMScript.runScript(model: ScriptModel(path: kChmodPath, arguments: ["-R", "777", "\(resourcePath)"], showOutData: true))
            MMScript.runScript(model: ScriptModel(path: kChmodPath, arguments: ["-R", "777", "\(projectRootPath)/\(goalRelativePath)"], showOutData: true))

            MMLOG.info("resoure = \(resourcePath)/\(fileName), goal = \(projectRootPath)/\(goalRelativePath)/\(fileName)")
            try FileManager.default.copyItem(atPath: "\(resourcePath)/\(fileName)", toPath: "\(projectRootPath)/\(goalRelativePath)/\(fileName)")
        } catch {
            MMLOG.error("文件拷贝失败")
            exit(3)
        }

    }
}

//修改podspec版本号 根据tag||info.plist 只能选择其中一种
//判断版本号修改类型
var newTag: String?
//如果脚本传入版本号,则使用传入的版本
if let version = arguments["version"] as? String {
    newTag = version
} else {
    if let versionInfoPath = plist["VersionInfoPath"] as? String {
        //读取info文件
        if let infoPlist = NSDictionary(contentsOfFile: versionInfoPath), let bundleVersion = infoPlist["CFBundleVersion"] as? String {
            newTag = bundleVersion
        } else {
            MMLOG.error("版本信息获取失败 versionInfoPath = \(versionInfoPath)")
            exit(4)
        }
    } else {
        //获取最新tag
        newTag = VersionControl.getLastTag(gitUrl: gitUrl, branch: "master", projectRootPath: projectRootPath) ?? ""
    }
}



guard let newTag = newTag else {
    MMLOG.error("版本号为nil")
    exit(5)
}
//修改.podspec文件
let fileList = FileControl.getFilePath(rootPath: projectRootPath, selectFile: "\(projectName).podspec", isSuffix: false, onlyOne: true)
guard let specFile = fileList.first else {
    MMLOG.error("未搜索到\(projectName).podspec文件")
    exit(6)
}
var specFileStr: String?
do {
    specFileStr = try String(contentsOfFile: specFile.fullPath(), encoding: String.Encoding.utf8)
} catch {
    exit(7)
}
guard let specFileStr = specFileStr else {
    exit(8)
}
MMLOG.info("specFileStr = \(specFileStr)")
let regular = "s.version\\s{0,}=\\s{0,}'.*'"
guard let newStr = specFileStr.regularExpressionReplace(pattern: regular, with: "s.version          = '\(newTag)'") else {
    exit(9)
}
MMLOG.info("newspecFileStr = \(newStr)")
do {
    try newStr.write(toFile: specFile.fullPath(), atomically: true, encoding: String.Encoding.utf8)
} catch {
    MMLOG.error("版本号写入podspec文件失败")
    exit(10)
}

//上传到仓库
//git add -u
var result = MMScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["add", "."], scriptRunPath: projectRootPath, showOutData: true))
guard result.status == true else {
    MMLOG.error("git操作 add失败")
    exit(11)
}
//git commit -m "描述"
result = MMScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["commit", "-m", commitText], scriptRunPath: projectRootPath, showOutData: true))
if result.status == false {
    MMLOG.error("git操作 commit失败")
}
//guard result.status == true else {
//    MMLOG.error("git操作 commit失败")
//    exit(12)
//}
//git push origin master
result = MMScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["push", "origin", "master"], scriptRunPath: projectRootPath, showOutData: true))
if result.status == false {
    MMLOG.error("git操作 push失败")
}


//增加tag
result = MMScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["tag", "-a", newTag, "-m", "【Chore】添加\(newTag)"], scriptRunPath: projectRootPath, showOutData: true))
guard result.status == true else {
    MMLOG.error("git操作 添加tag标签失败")
    exit(14)
}
result = MMScript.runScript(model: ScriptModel(path: kGitShellPath, arguments: ["push", "origin", "--tags", "master"], scriptRunPath: projectRootPath, showOutData: true))
guard result.status == true else {
    MMLOG.error("git操作 推送tag失败")
    exit(15)
}



//将podspec推送到cocospod
//pod repo push 196-ios-base-mgdmspecs *.podspec --sources='http://112.5.196.26:10080/ios/base/MGDMSpecs.git',master --use-libraries --allow-warnings

guard let cocoaPodUrl = plist["CocoaPodUrl"] as? String else {
    MMLOG.error("未配置CocoaPodUrl")
    exit(16)
}
if let isLibrary = plist["IsLibrary"] as? Bool, isLibrary == true {
    result = MMScript.runScript(model: ScriptModel(path: kCocoapodsShellPath, arguments: ["repo", "push", cocoaPodName, "\(projectName).podspec", "--sources='\(cocoaPodUrl)',master", "--use-libraries", "--allow-warnings"], scriptRunPath: projectRootPath, showOutData: true))
} else {
    result = MMScript.runScript(model: ScriptModel(path: kCocoapodsShellPath, arguments: ["repo", "push", cocoaPodName, "\(projectName).podspec", "--sources='\(cocoaPodUrl)',master", "--allow-warnings"], scriptRunPath: projectRootPath, showOutData: true))
}

guard result.status == true else {
    MMLOG.error("git操作 推送podspec文件失败")
    exit(16)
}

MMLOG.info("结束")
