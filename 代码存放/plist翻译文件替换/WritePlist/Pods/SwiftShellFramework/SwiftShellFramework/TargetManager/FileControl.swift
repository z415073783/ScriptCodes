//
//  FileControl.swift
//  writePlist
//
//  Created by zlm on 2018/8/17.
//  Copyright © 2018年 zlm. All rights reserved.
//

import Foundation
public struct ProjectPathModel {
    var name: String = ""
    var path: String = ""
    func fullPath() -> String {
        return path + "/" + name
    }
}
public extension String {
    //根据文件全路径获取文件所在路径
    public func getPath() -> String? {
        guard let newPath = self.regularExpressionReplace(pattern: "/[^/]*?$", with: "") else {
            YLLOG.error("正则表达式未能匹配该路径 plistPath = \(self)")
            return nil
        }
        return newPath
    }
}
public class FileControl {

    /// 通过根节点查找每个子节点下的指定文件位置
    ///
    /// - Parameters:
    ///   - rootPath: 根目录
    ///   - selectFile: 文件名称
    ///   - isSuffix: 是否是后缀,如果为true,则搜索后缀为selectFile变量的文件
    ///   - onlyOne: 一旦查询到一个就返回
    /// - Returns: <#return value description#>
    public class func getFilePath(rootPath: String, selectFile: String, isSuffix: Bool = false, onlyOne: Bool = true) -> [ProjectPathModel] {
        var _rootPath = rootPath
        if _rootPath.count == 0 {
            _rootPath = "./"
        }
        var pathList: [ProjectPathModel] = []
        do {
            let list = try FileManager.default.contentsOfDirectory(atPath: _rootPath)
            var subDirList: [String] = []
            for item in list {
                var changeRootPath = _rootPath
                if changeRootPath == "./" {
                    changeRootPath = "."
                }
                let newPath = changeRootPath + "/" + item
                var isDir: ObjCBool = false
                let isExist = FileManager.default.fileExists(atPath: newPath, isDirectory: &isDir)

                if isSuffix == true {
                    if item.hasSuffix(selectFile) {
                        //找到后缀相同的文件
                        YLLOG.info("获取到后缀相同的文件路径: \(newPath)")
                        pathList.append(ProjectPathModel(name: item, path: changeRootPath))
                    }
                } else if item == selectFile && isDir.boolValue == false {
                    //获取到同名文件
                    YLLOG.info("获取到文件路径: \(newPath)")
                    pathList.append(ProjectPathModel(name: item, path: changeRootPath))
                } else if isDir.boolValue == true && isExist == true {
                    //当前目录是文件夹,则存入文件夹数组,以便进行递归遍历
                    subDirList.append(newPath)
                }
                if onlyOne == true, pathList.count == 1 {
                    return pathList
                }
            }

            for subDir in subDirList {
                let subList = getFilePath(rootPath: subDir, selectFile: selectFile, isSuffix: isSuffix)
                if subList.count > 0 {
                    pathList += subList
                }
            }

        } catch {
            YLLOG.error("传入的根路径不存在: rootPath = \(rootPath)")
        }
        return pathList
    }



    /// 查找指定后缀格式的文件路径 从plist文件开始往上层查找
    ///
    /// - Parameters:
    ///   - plistPath: property.plist文件路径
    ///   - findFileSuffix: 文件后缀
    /// - Returns:
    public class func getProjectPath(plistPath: String, findFileSuffix: String = ".xcworkspace") ->ProjectPathModel? {
        guard let newPath = plistPath.regularExpressionReplace(pattern: "/[^/]*?$", with: "") else {
            YLLOG.error("正则表达式未能匹配该路径 plistPath = \(plistPath)")
            return nil
        }
        do {
            let list = try FileManager.default.contentsOfDirectory(atPath: newPath)
            for item in list {
                if item.hasSuffix(findFileSuffix) {
                    YLLOG.info("已找到工程路径! newPath = \(newPath)")
                    return ProjectPathModel(name: item, path: newPath)
                }
            }
            return getProjectPath(plistPath: newPath)
        } catch {
            YLLOG.error("error = \(error)")
            return nil
        }
    }



}
