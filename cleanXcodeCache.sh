#!/bin/sh

cd ~/Library/Developer/Xcode/Archives
rm -rfv *
cd ~/Library/Developer/Xcode/DerivedData
rm -rfv *
cd ~/Library/Developer/Xcode/"iOS Device Logs"
rm -rfv *
rm -rfv ~/Library/Developer/CoreSimulator/Devices/*
rm -rfv ~/Library/Developer/Xcode/iOS DeviceSupport/*
rm -rfv ~/Library/Caches/QQBrowser2/Default/Cache/*
rm -rfv ~/Library/Caches/*
rm -rfv ~/Library/Developer/Xcode/iOS\ DeviceSupport/*

echo 清理垃圾桶
sudo rm -rfv ~/.Trash /Volumes/*/.Trashes


echo 清理微信聊天缓存
sudo rm -rfv ~/Library/Containers/com.tencent.xinWeChat/Data/Library/Application\ Support/com.tencent.xinWeChat/*