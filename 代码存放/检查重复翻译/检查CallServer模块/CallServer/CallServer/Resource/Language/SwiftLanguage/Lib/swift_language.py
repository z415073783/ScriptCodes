#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import os
import sys
import time
import datetime
import subprocess
import atexit
import shutil
import shlex
import getopt
import re
import io
import argparse
import plistlib

SELF_DIR_PATH = os.path.dirname(os.path.realpath(__file__))
SELF_NAME = os.path.basename(__file__)

sys.path.append("%s/.." % SELF_DIR_PATH)

from langconv import *


#######################################################################################################################
# 生成 LanguageIdentifiers.swift 文件
def plist_to_swift(root_path, plist_file_name, swift_file_name, swift_module_name):
    print("生成 LanguageIdentifiers.swift 文件")

    all_string_item_dict = dict()

    plist_index = 0
    while True:
        if plist_index == 0:
            index_plist_file_name = plist_file_name
        else:
            li = plist_file_name.rsplit(".plist", 1)
            index_plist_file_name = "".join(li) + "{0}.plist".format(plist_index)
            pass

        if not os.path.exists(index_plist_file_name):
            break

        plist_index += 1

        print("读取plist: {0}".format(index_plist_file_name))
        with open(index_plist_file_name, 'rb') as fp:
            plist_dict = plistlib.load(fp)
            pass

        print("备份plist")
        backup_plist_file_name = index_plist_file_name + ".backup.plist"
        with open(backup_plist_file_name, 'wb') as fp:
            plistlib.dump(plist_dict, fp)
            pass

        string_item_dict = plist_dict["Language"]

        add_missing_region(string_item_dict)

        all_string_item_dict.update(string_item_dict)

        print("写入plist")
        with open(index_plist_file_name, 'wb') as fp:
            plistlib.dump(plist_dict, fp)
            pass

        pass

    print("生成swift文件")
    print("使用合法命名生成swift变量")
    swift_property_content = ""

    appended_name_array = []  # 记录已存在的key
    for key, value in all_string_item_dict.items():
        var_name = key

        # 所有非字母数字下划线替换为下划线
        var_name = re.sub(r"\W", r'_', var_name)

        # 所有下划线后的字母转为大写
        legal_name = var_name[0]
        for c in var_name[1:]:
            if legal_name[-1] == "_" and c != "_":
                c = c.upper()
            legal_name += c

        # 移除所有下划线
        var_name = legal_name.replace("_", "")

        # 移除首部所有数字
        while var_name[0].isdigit():
            var_name = var_name[1:]

        # 首字母大写
        var_name = var_name[0].upper() + var_name[1:]

        var_name = "YL" + var_name

        # 若在处理后出现同名,首部添加下划线
        while var_name in appended_name_array:
            var_name += "_"
            pass

        appended_name_array.append(var_name)

        var_comment = ''
        for region, region_value in value.items():
            var_comment += '    /// '
            var_comment += '【'
            var_comment += region + '：'
            var_comment += format_string_to_swift(region_value)
            var_comment += '】\n'
            pass

        var_key = format_string_to_swift(key)

        swift_property_content += var_comment
        swift_property_content += "    public static var %s: String = swiftLanguageLocalizedString(forKey: \"%s\")\n\n" % (var_name, var_key)
        pass

    # 文件头注释
    swift_file_content = """//
// Autogenerated YL%sLanguage
//

""" % swift_module_name

    # 类定义
    swift_file_content += "import Foundation\n"

    if not swift_module_name:
        swift_module_name = ""
        pass

    if swift_module_name != "Base":
        swift_file_content += "import YLBaseFramework\n\n\n"
        pass

    swift_file_content += "public struct YL%sLanguage {\n" % swift_module_name

    # 本地化方法
    swift_file_content += """
    public static func swiftLanguageLocalizedString(forKey key: String) -> String {
        return localized%s(key:key)
    }

""" % swift_module_name

    # 变量
    swift_file_content += swift_property_content

    # 文件尾
    swift_file_content += """
}
"""

    print('写入swift文件: {0}'.format(swift_file_name))
    # 写入swift文件
    with open(swift_file_name, 'w+') as fp:
        fp.write(swift_file_content)
        fp.truncate()
        pass

    if not root_path:
        return

    print("写回已有的系统string文件")

    language_files = get_all_language_files(root_path)

    for language_file in language_files:
        print("写回: {0}".format(language_file.file_path))
        content = """/*
 String.strings

 Created by python script from plist.
 Copyright © 2016年 yealink. All rights reserved.
 */

"""

        for key, value in string_item_dict.items():
            content += "\"{0}\" = \"{1}\";\n".format(format_string_to_swift(key),
                                                     format_string_to_swift(value[language_file.region]))
            pass

        content += "\n"

        with open(language_file.file_path, 'w+') as fp:
            fp.write(content)
            fp.truncate()
            pass

        pass

    pass


#######################################################################################################################
# 从Language.strings生成plist文件
def strings_to_plist(root_path, plist_file_name):
    print("从Language.strings生成plist文件")

    language_files = get_all_language_files(root_path)

    print('记录所有不重复键的键值')
    string_item_dict = {}

    for language_file in language_files:
        for key, value in language_file.key_value_dict.items():
            var_key = format_string_to_plist(key)
            if var_key not in string_item_dict.keys():
                item = {}
                string_item_dict[var_key] = item
            else:
                item = string_item_dict[var_key]

            item[language_file.region] = format_string_to_plist(value)

            pass

        pass

    add_missing_region(string_item_dict)

    plist_dict = {"Language": string_item_dict}

    print("写入plist")
    with open(plist_file_name, 'wb') as fp:
        plistlib.dump(plist_dict, fp)
        pass

    pass


#######################################################################################################################
# 查找所有语言文件
def get_all_language_files(root_path):
    language_files = []

    print("查找所有语言文件")
    # 查找所有 Language.strings 文件, 生成 LanguageFile
    hit_dir = ""
    for dir_path, sub_dir_names, sub_file_names in os.walk(root_path):
        if hit_dir and not dir_path.startswith(hit_dir):
            break

        if "en.lproj" in sub_dir_names or "zh-Hans.lproj" in sub_dir_names:
            hit_dir = dir_path
            pass

        for file_name in sub_file_names:
            if file_name == "Language.strings":
                file_path = os.path.join(dir_path, file_name)
                language_file = LanguageFile(file_path)
                language_files.append(language_file)
                pass

            pass

        pass

    language_files = sorted(language_files, key=lambda x: x.order)

    print(language_files)

    return language_files


#######################################################################################################################
# 填充遗漏键值
def add_missing_region(string_item_dict):
    print("填充遗漏键值")
    region_array = []
    for key, value in string_item_dict.items():
        for region in value.keys():
            if region not in region_array:
                region_array.append(region)
                pass
            pass
        pass

    for key, value in string_item_dict.items():
        for region in region_array:
            if region in value.keys() and value[region]:
                continue

            print("Missing: {0}: {1}".format(key, region))

            region_value = ""

            if region == "zh-Hant" and "zh-Hans" in value.keys():
                region_value = Converter('zh-hant').convert(value["zh-Hans"])
            # elif "en" in value.keys():
            #     region_value = value["en"]
            # elif "zh-Hans" in value.keys():
            #     region_value = value["zh-Hans"]
                pass

            value[region] = region_value
            pass
        pass


def format_string_to_plist(value):
    value = value.replace("\\\"", "\"")
    value = value.replace("\\n", "\n")
    return value


def format_string_to_swift(value):
    value = value.replace("\"", "\\\"")
    value = value.replace("\n", "\\n")
    return value


#######################################################################################################################
# 获取命令行参数
def get_arg(*opts):
    parser = argparse.ArgumentParser(usage="")
    parser.add_argument(*opts,
                        dest='argument')
    args, unknown = parser.parse_known_args()
    return args.argument


def has_arg(*opts):
    parser = argparse.ArgumentParser(usage="")
    parser.add_argument(*opts,
                        action='store_true',
                        dest='exist')
    args, unknown = parser.parse_known_args()
    return args.exist


#######################################################################################################################
# 国际化String文件数据
class LanguageFile(object):
    # file_path 为 */Language/zh-Hans.lproj/Language.strings
    def __init__(self, file_path):
        self.file_path = file_path
        # 取所在文件夹名称作为此语种名 zh-Hans
        self.region = os.path.splitext(os.path.basename(os.path.dirname(file_path)))[0]

        if self.region == "en":
            self.order = 0
        elif self.region == "zh-Hans":
            self.order = 1
        else:
            self.order = 999
            pass

        self.key_value_dict = {}

        with open(file_path) as f:
            self.file_content = f.read()
            pass

        lines = self.file_content.splitlines()

        # 记录所有键值对
        for index, line in enumerate(lines):
            key_value_search_result = re.search(
                "^ *\"(.*)\" *= *\"(.*)\" *; *$",
                line)

            if key_value_search_result:
                key = key_value_search_result.group(1)
                value = key_value_search_result.group(2)
                self.key_value_dict[key] = value

                pass

            pass

        self.backup()

        pass

    def __repr__(self):
        return self.file_path

    def backup(self):
        backup_file_path = self.file_path + ".backup.strings"
        print("备份系统strings文件：{0}".format(backup_file_path))
        with open(backup_file_path, 'w+') as fp:
            fp.write(self.file_content)
            fp.truncate()
            pass

        pass


#######################################################################################################################
if __name__ == "__main__":
    arg_root_path = get_arg("-l")
    arg_plist_file_name = get_arg("-p")
    arg_swift_file_name = get_arg("-s")
    arg_swift_module_name = get_arg("-m")

    print("arg_root_path")
    print(arg_root_path)
    print("arg_plist_file_name")
    print(arg_plist_file_name)
    print("arg_swift_file_name")
    print(arg_swift_file_name)
    print("arg_swift_module_name")
    print(arg_swift_module_name)
    print("has --2plist")
    print(has_arg("--2plist"))
    print("has --2swift")
    print(has_arg("--2swift"))

    if not arg_swift_module_name:
        arg_swift_module_name = ""
        pass

    if has_arg("--2plist"):
        if not arg_root_path or not arg_plist_file_name:
            print("没有输入参数，执行脚本测试")
            arg_root_path = os.path.join(SELF_DIR_PATH, "Test", "TestLanguages")
            arg_plist_file_name = os.path.join(SELF_DIR_PATH, "Test", "YLTestLanguage.plist")

        strings_to_plist(arg_root_path, arg_plist_file_name)
    elif has_arg("--2swift"):
        if not arg_plist_file_name or not arg_swift_file_name:
            print("没有输入参数，执行脚本测试")
            arg_plist_file_name = os.path.join(SELF_DIR_PATH, "Test", "YLTestLanguage.plist")
            arg_swift_file_name = os.path.join(SELF_DIR_PATH, "Test", "YLTestLanguage.swift")
            arg_swift_module_name = ""

        plist_to_swift(arg_root_path, arg_plist_file_name, arg_swift_file_name, arg_swift_module_name)
    else:
        print("没有输入参数，执行脚本测试")
        arg_root_path = os.path.join(SELF_DIR_PATH, "Test", "TestLanguages")
        arg_plist_file_name = os.path.join(SELF_DIR_PATH, "Test", "YLTestLanguage.plist")
        arg_swift_file_name = os.path.join(SELF_DIR_PATH, "Test", "YLTestLanguage.swift")
        arg_swift_module_name = ""

        strings_to_plist(arg_root_path, arg_plist_file_name)
        plist_to_swift(arg_root_path, arg_plist_file_name, arg_swift_file_name, arg_swift_module_name)
        pass

    pass
