#!/bin/sh
#!/bin/bash
#

SELF_PATH="`dirname \"$0\"`"

LanguageDirPath="$SELF_PATH/../YLSDKLanguage.bundle"
PythonScriptPath="$SELF_PATH/Lib/swift_language.py"

echo "\n"
echo "python3 \"$PythonScriptPath\" --2swift -l \"$LanguageDirPath\" -p \"$LanguageDirPath/YLSDKLanguage.plist\" -s \"$LanguageDirPath/../YLSDKLanguage.swift\" -m \"SDK\""
echo "\n"

python3 "$PythonScriptPath" --2swift -l "$LanguageDirPath" -p "$LanguageDirPath/YLSDKLanguage.plist" -s "$LanguageDirPath/../YLSDKLanguage.swift" -m "SDK"

