//
//  MergeControl.swift
//  zlm_commit
//
//  Created by zlm on 2018/12/29.
//  Copyright © 2018 zlm. All rights reserved.
//

import Foundation




class MergeControl {
    class func merge() {
        //http://gitlab.leucs.com/yl1231/SwiftShellFramework/merge_requests/new?utf8=%E2%9C%93&merge_request%5Bsource_project_id%5D=368&merge_request%5Bsource_branch%5D=zenglm%2F2018_12_29_10_24_03&merge_request%5Btarget_project_id%5D=368&merge_request%5Btarget_branch%5D=master
        //open -a "/Applications/Safari.app" "http://www.baidu.com"
//        open http://gitlab.leucs.com/yl1231/SwiftShellFramework
        //需要合入的z分支名
        let mergeToBranch = CacheData.getBranch()

        guard let url = getProjectUrl(), let newBranch = CacheData.shared.newBranch else {
            YLLOG.error("未获取到工程的git连接")
            return
        }



//gitlab.leucs.com/yl1231/SwiftShellFramework/merge_requests/new?utf8=✓&merge_request[source_branch]=zenglm%2F2018_12_29_10_24_03&merge_request[target_branch]=master&private_token=z5nmXsuK5KbZ79pSZu_R
        YLLOG.info("url = \(url)")

        let fullUrl = "\(url)/merge_requests/new?utf8=✓&merge_request[source_branch]=\(newBranch)&merge_request[target_branch]=\(mergeToBranch)&private_token=\(CacheData.getPrivateToken())"
         YLLOG.info("fullUrl = \(fullUrl)")
        guard let utf8Url = fullUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            YLLOG.error("链接转utf8失败")
            return
        }
        YLScript.runScript(model: ScriptModel(path: kOpenPath, arguments: [utf8Url]))

        YLLOG.info("打开合并请求连接操作完成")

    }

//    class func getProjectID(urlStr: String) ->String? {
//        guard let url = URL(string: urlStr) else {
//            return nil
//        }
//        do {
//
//            let urlStr = try String(contentsOf:  url, encoding: String.Encoding.utf8)
//            YLLOG.info("urlStr = \(urlStr)")
//            let list = urlStr.regularExpressionFind(pattern: "project_id")
//            for item in list {
//                YLLOG.info("item = \(item)")
//            }
//
////z5nmXsuK5KbZ79pSZu_R
//
//
//        } catch {
//            YLLOG.error("error = \(error)")
//        }
//        return nil
//    }


    class func getProjectUrl() -> String? {
        //当前项目路径
        let task = Process()
        let currentPath = task.currentDirectoryPath
        YLLOG.info("当前路径为 = \(currentPath)")
        guard let model = FileControl.findFile(beginPath: currentPath, goalFileName: ".git") else {
            return nil
        }
        YLLOG.info("model = \(model)")
        guard let configModel = FileControl.getFilePath(rootPath: model.fullPath(), selectFile: "config", isSuffix: false, onlyOne: true).first else {
            return nil
        }

        //取出config内容
        var configContainer = ""
        //http://gitlab.leucs.com/yl1231/SwiftShellFramework
        do {
            configContainer = try String(contentsOfFile: configModel.fullPath(), encoding: String.Encoding.utf8)
        } catch {
            YLLOG.error("error = \(error)")
        }
        YLLOG.info("configContainer = \(configContainer)")

        guard let urlResult = configContainer.regularExpressionFind(pattern: "url =.*").first else {
            YLLOG.error("未获到url")
            return nil
        }
//http://gitlab.leucs.com/VCLibrary/VCBasicCommonUtility.git
        let urlStr = (configContainer as NSString).substring(with: urlResult.range) as String
        var urlNoGit = urlStr.split("@").last
        YLLOG.info("urlNoGit_1 = \(String(describing: urlNoGit))")
        urlNoGit = urlNoGit?.regularExpressionReplace(pattern: "url = ", with: "")
        YLLOG.info("urlNoGit_2 = \(String(describing: urlNoGit))")
//        urlNoGit = urlNoGit?.regularExpressionReplace(pattern: "[a-z]\\..*", with: "/")
//        YLLOG.info("urlNoGit_3 = \(String(describing: urlNoGit))")
        urlNoGit = urlNoGit?.regularExpressionReplace(pattern: "\\.git$", with: "")

        if urlNoGit?.hasPrefix("http://") == false && urlNoGit?.hasPrefix("https://") == false && urlNoGit?.hasPrefix("ssh:") == false  {
            urlNoGit = "http://" + (urlNoGit ?? "")
        }
        return urlNoGit
    }

}

