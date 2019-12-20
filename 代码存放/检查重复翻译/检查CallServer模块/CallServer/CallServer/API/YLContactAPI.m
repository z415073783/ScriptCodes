//
//  UCContactInterface.m
//  Odin-UC
//
//  Created by 姜祥周 on 17/1/5.
//  Copyright © 2017年 yealing. All rights reserved.
//

#import "YLContactAPI.h"
#import "contactInterface.h"
#import "YLSdkLogAPI.h"
@implementation YLContactAPI

/**
 *  添加联系人
 *
 *  @param dataContact dataContact description
 *
 *  @return true or false
 */
+ (bool)addContact:(IDataContact*)dataContact
{
    [YLSdkLogAPI loginfo:@"addContact"];

    return addContact(dataContact);
}

/**
 *  删除联系人
 *
 *  @param pData pData description
 *
 *  @return return value description
 */
+ (bool)deleteContact:(IPhoneBookData*)pData
{
    [YLSdkLogAPI loginfo:@"deleteContact"];

    return deleteContact(pData);
}

/**
 *  搜索联系人
 *
 *  @param nsstrKey <#nsstrKey description#>
 *
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)searchContact:(NSString*)nsstrKey
{
    [YLSdkLogAPI loginfo:@"searchContact"];

    return searchContact(nsstrKey);
}

/**
 *  以号码的形式返回搜索结果，如果一个联系人包含多个号码，匹配几个号码显示几条
 *
 *  @param nsstrKey nsstrKey description
 *
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)searchContactList:(NSString*)nsstrKey
{
    [YLSdkLogAPI loginfo:@"searchContactList"];

    return searchContactList(nsstrKey);
}

/**
 *  搜索本地联系人
 *
 *  @param nsstrKey nsstrKey description
 *
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)searchLocalContact:(NSString*)nsstrKey
{
    [YLSdkLogAPI loginfo:@"searchLocalContact"];

    return searchLocalContact(nsstrKey);
}

/**
 *  根据号码在本地联系人中搜索完全匹配号码的显示名
 *
 *  @param nsstrKey nsstrKey description
 *
 *  @return IPhoneBookData* array
 */
+ (NSString*)searchContactNameByNumber:(NSString*)nsstrKey isCloud:(bool)bSearchCloud
{
    [YLSdkLogAPI loginfo:@"searchContactNameByNumber"];

    return searchContactNameByNumber(nsstrKey, bSearchCloud);
}

/**
 *  根据号码在云联系人中搜索完全匹配号码的显示名
 *  @param strNumber nsstrKey description
 *  @return NSString* array
 */
+ (NSString*)searchCloudNameByNumber:(NSString*)strNumber
{
    [YLSdkLogAPI loginfo:@"searchCloudNameByNumber"];

    return searchCloudNameByNumber(strNumber);
}

/*是否云帐号登录
 ＊
 */
+ (bool)isCloudContactAvailable
{
    [YLSdkLogAPI loginfo:@"isCloudContactAvailable"];

    return isCloudContactAvailable();
}

/**
 *  搜索云联系人
 *
 *  @param nsstrKey <#nsstrKey description#>
 *
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)searchCloudContact:(NSString*)nsstrKey
{
    [YLSdkLogAPI loginfo:@"searchCloudContact"];

    return searchCloudContact(nsstrKey);
}

/**
 *  查找通话记录
 *
 *  @param eCallType <#eCallType description#>
 *  @param nsstrKey  <#nsstrKey description#>
 *
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)searchCallLog:(int)eCallType searchKey:(NSString*)nsstrKey
{
    [YLSdkLogAPI loginfo:@"searchCallLog"];

    return searchCallLog(eCallType, nsstrKey);
}

/** function
 *  @brief:搜索呼叫记录
 *  @iCallType @in @brief:呼叫记录类型 0:Unknown;1:outGoing;2:inComing;4:Miss;8:conference;15:all
 *  @strKey @in @brief:搜索关键字，如果内容为空，则返回所有
 *  @return:呼叫记录信息列表,成员ICallLogData
 **/
+ (NSMutableArray*)searchCallLogs:(int)iCallType searchKey:(NSString*)strKey
{
    [YLSdkLogAPI loginfo:@"searchCallLogs"];

    return searchCallLogs(iCallType, strKey);
}

/**
 *  根据名字查找联系人
 *
 *  @param nsstrName 联系人名字
 *
 *  @return IDataContact
 */
+ (IDataContact*)searchContactByName:(NSString*)nsstrName
{
    [YLSdkLogAPI loginfo:@"searchContactByName"];

    return searchContactByName(nsstrName);
}

/**
 *  根据号码查找联系人
 *
 *  @param nsstrName 联系人注册号码
 *
 *  @return IDataContact
 */
+ (IDataContact*)searchContactByNumber:(NSString*)nsstrName
{
    [YLSdkLogAPI loginfo:@"searchContactByNumber"];

    return searchContactByNumber(nsstrName);
}

/**
 *  联系人转换
 *
 *  @param pData pData description
 *
 *  @return IDataContact
 */
+ (IDataContact*)toContactData:(IPhoneBookData*)pData
{
    [YLSdkLogAPI loginfo:@"toContactData"];

    return toContactData(pData);
}

/**
 *  云联系人转换
 *
 *  @param pData pData description
 *
 *  @return IDataContact
 */
+ (IDataContact*)toCloudContactData:(IPhoneBookData*)pData
{
    [YLSdkLogAPI loginfo:@"toCloudContactData"];

    return toCloudContactData(pData);
}

/**
 *  通话记录转换
 *
 *  @param pData pData description
 *
 *  @return IDataContact
 */
+ (IDataCallLog*)toCallLog:(IPhoneBookData*)pData
{
    [YLSdkLogAPI loginfo:@"toCallLog"];

    return toCallLog(pData);
}

/**
 *  删除单个通话记录
 *
 *  @param pICallLog pICallLog description
 */
+ (void)deleteCallLog:(IDataCallLog*)pICallLog
{
    [YLSdkLogAPI loginfo:@"deleteCallLog"];

    deleteCallLog(pICallLog);
}

/** function
 *  @brief:根据呼叫记录信息进行呼叫记录删除
 *  @callLog @in @brief:呼叫记录信息
 **/
+ (void)deleteCallLogs:(ICallLogData*)callLogs
{
    [YLSdkLogAPI loginfo:@"deleteCallLogs"];

    deleteCallLogs(callLogs);
}

/** function
 *  @brief:删除对应类型的所有呼叫记录
 *  @callType @in @brief:删除类型0:Unknown;1:outGoing;2:inComing;4:Miss;8:conference;15:all
 **/
+ (void)deleteAllCallLog:(int)eCallType
{
    [YLSdkLogAPI loginfo:@"deleteAllCallLog"];

    deleteAllCallLog(eCallType);
}

/**
 *  重置漏接记录
 */
+ (void)resetMissCallCount
{
    [YLSdkLogAPI loginfo:@"resetMissCallCount"];

    resetMissCallCount();
}

/**
 *  获取搜索匹配上的字符，即字符串中哪些字符可以搜索匹配上
 *  @param text  description
 *  @param strKey  description
 */
+ (NSString*)getMatchSubKey:(NSString*)text strKey:(NSString*)strKey
{
    [YLSdkLogAPI loginfo:@"getMatchSubKey"];

    return getMatchSubKey(text, strKey);
}

/**
 *  历史联系人转换
 *  @param pData pData description
 *  @return IDataHistoryContact
 */
+ (IDataHistoryContact*)toHistoryContact:(IPhoneBookData*)pData
{
    [YLSdkLogAPI loginfo:@"toHistoryContact"];

    return toHistoryContact(pData);
}

/**
 *  添加历史联系人
 *  @param dataHistoryContact IDataHistoryContact description
 *  @return true or false
 */
+ (bool)addHistoryContact:(IDataHistoryContact*)dataHistoryContact
{
    [YLSdkLogAPI loginfo:@"addHistoryContact"];

    return addHistoryContact(dataHistoryContact);
}

/**
 *  删除历史联系人
 *  @param pData pData description
 */
+ (void)deleteHistoryContact:(IPhoneBookData*)pData
{
    [YLSdkLogAPI loginfo:@"deleteHistoryContact"];

    deleteHistoryContact(pData);
}

/**
 *  删除所有同类型的历史联系人
 *  @param iType int description
 */
+ (void)deleteAllHistoryContact:(int)iType
{
    [YLSdkLogAPI loginfo:@"deleteAllHistoryContact"];

    deleteAllHistoryContact(iType);
}

/**
 *  获取历史联系人列表
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)getHistoryContactList:(int)iType
{
    [YLSdkLogAPI loginfo:@"getHistoryContactList"];

    return getHistoryContactList(iType);
}

/**
 *功能：获取云联系人类型，用于区分显示一般和组织联系人
 *参数：无
 *返回：返回云联系人类型：enum CLOUD_DIR_TYPE {CDT_UNKNOWN=0, CDT_GENERAL=1, CDT_ORG=2}
 *备注：无
 */
+ (int)get_CloudDirType
{
    [YLSdkLogAPI loginfo:@"get_CloudDirType"];

    return getCloudDirType();
}

/**
 *功能：根据节点id获取节点信息
 *参数：nodeId: NSString, 节点的唯一标示符，如果为空，则表示获取根节点
 *返回：返回云联系人节点信息
 *备注：返回节点的id为空，则表示该节点不可用
 */
+ (IOrgTreeInfo*)getOrgNodeInfo:(NSString*)strNodeId
{
    [YLSdkLogAPI loginfo:@"getOrgNodeInfo"];

    return getOrgNodeInfo(strNodeId);
}

/**
 *功能：搜索组织联系人
 *参数：searchKey: string, 搜索内容，如果为空则表示全部
 *参数：nodeId: string, 节点的唯一标示符，如果为空，则表示搜索整个组织架构
 *参数：extRequire:string, 附件的搜索条件，格式为json字符串，当前存在的字段有：
 *                bGetName：是否根据号码获取显示名，值是0或者1，默认0，该值为1时，一般searchKey和nodeId为空
 *                bGetLeaves: 是否获取叶子结点，值是0或者1，默认0，该值为1时，一般searchKey为空
 *                     该参数格式是”{"bGetName":0,"bGetOrg":0}”,该字段可以为空或者只填一个字段
 *返回：返回搜索后的组织联系人，如果根节点id为空，则表示列表联系人
 *备注：列表中的叶子节点只可以获取父节点属性，不可以获取祖父和兄弟节点属性
 */
+ (IOrgTreeInfo*)search:(NSString*)strKey nodeId:(NSString*)nodeId strExtension:(NSString*)strExtRequire
{
    [YLSdkLogAPI loginfo:@"search nodeId"];

    return search(strKey, nodeId, strExtRequire);
}
@end
