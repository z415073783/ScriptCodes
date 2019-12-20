//
//  main.swift
//  zlm_commit
//
//  Created by zlm on 2018/12/28.
//  Copyright © 2018 zlm. All rights reserved.
//

import Foundation


//let fullUrl = "http://gitlab.leucs.com/yl1231/SwiftShellFramework/merge_requests/new?utf8=✓&merge_request[source_branch]=zenglm/2018_12_29_14_13_06&merge_request[target_branch]=master&private_token=z5nmXsuK5KbZ79pSZu_R"
//YLLOG.info("fullUrl = \(fullUrl)")
//guard let utf8Url = fullUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
//    YLLOG.error("链接转utf8失败")
//    exit(1)
//}
//YLScript.runScript(model: ScriptModel(path: kOpenPath, arguments: [utf8Url]))
//
//YLLOG.info("打开合并请求连接操作完成")
//exit(0)


print("begin")

ProcessInfo.processInfo.isHelp(helpStr: """
    t       类型
    d       描述
    a       影响
    r       原因
    s       方案
    u       bug链接
    b       需要合并的分支名
    token   帐号授权token,默认帐号zenglm

类型说明:
    功能类提交: 【Feat】 简写:fea 描述
    仅更新资源文件的提交: 【Res】 简写:res 描述
    仅更新工具/脚本/pod的提交: 【Chore】 简写:cho 描述
    重构: 【Refactor】 简写:ref 影响(修改的影响范围)\n 例: ref 描述 影响(修改的影响范围)
    增加测试用例的提交: 【Test】简写:tes 描述
    性能提升的提交: 【Perf】简写:per 描述
    代码缩进、风格调整的提交: 【Format】简写:for 描述
    自测bug修正提交: 【Fix】简写:bug 描述
    带bug链接的bug修正提交: 【Fix-id】简写:bugID 描述 id号 bug链接 原因(bug产生原因) 方案(修复方案) 影响(修改的影响范围)
""", needExit: true)




GitCommit.commit()
YLLOG.info("准备打开合并url")
MergeControl.merge()
