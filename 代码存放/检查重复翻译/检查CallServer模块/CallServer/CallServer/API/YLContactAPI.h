//
//  UCContactInterface.h
//  Odin-UC
//
//  Created by 姜祥周 on 17/1/5.
//  Copyright © 2017年 yealing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TalkDataDef.h"

@interface YLContactAPI : NSObject

/**
 *  添加联系人
 *
 *  @param dataContact dataContact description
 *
 *  @return true or false
 */
+ (bool)addContact:(IDataContact*)dataContact;

/**
 *  删除联系人
 *
 *  @param pData pData description
 *
 *  @return return value description
 */
+ (bool)deleteContact:(IPhoneBookData*)pData;

/**
 *  搜索联系人
 *
 *  @param nsstrKey <#nsstrKey description#>
 *
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)searchContact:(NSString*)nsstrKey;

/**
 *  以号码的形式返回搜索结果，如果一个联系人包含多个号码，匹配几个号码显示几条
 *
 *  @param nsstrKey nsstrKey description
 *
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)searchContactList:(NSString*)nsstrKey;

/**
 *  搜索本地联系人
 *
 *  @param nsstrKey nsstrKey description
 *
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)searchLocalContact:(NSString*)nsstrKey;

/**
 *  根据号码在本地联系人中搜索完全匹配号码的显示名
 *
 *  @param nsstrKey nsstrKey description
 *
 *  @return IPhoneBookData* array
 */
+ (NSString*)searchContactNameByNumber:(NSString*)nsstrKey isCloud:(bool)bSearchCloud;

/**
 *  根据号码在云联系人中搜索完全匹配号码的显示名
 *  @param strNumber nsstrKey description
 *  @return NSString* array
 */
+ (NSString*)searchCloudNameByNumber:(NSString*)strNumber;

/*是否云帐号登录
 ＊
 */
+ (bool)isCloudContactAvailable;

/**
 *  搜索云联系人
 *
 *  @param nsstrKey <#nsstrKey description#>
 *
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)searchCloudContact:(NSString*)nsstrKey;

//return IPhoneBookData* array
/**
 *  查找通话记录
 *
 *  @param eCallType <#eCallType description#>
 *  @param nsstrKey  <#nsstrKey description#>
 *
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)searchCallLog:(int)eCallType searchKey:(NSString*)nsstrKey;

/** function
 *  @brief:搜索呼叫记录
 *  @iCallType @in @brief:呼叫记录类型 0:Unknown;1:outGoing;2:inComing;4:Miss;8:conference;15:all
 *  @strKey @in @brief:搜索关键字，如果内容为空，则返回所有
 *  @return:呼叫记录信息列表,成员ICallLogData
 **/
+ (NSMutableArray*)searchCallLogs:(int)iCallType searchKey:(NSString*)strKey;

/**
 *  根据名字查找联系人
 *
 *  @param nsstrName 联系人名字
 *
 *  @return IDataContact
 */
+ (IDataContact*)searchContactByName:(NSString*)nsstrName;

/**
 *  根据号码查找联系人
 *
 *  @param nsstrName 联系人注册号码
 *
 *  @return IDataContact
 */
+ (IDataContact*)searchContactByNumber:(NSString*)nsstrName;

/**
 *  联系人转换
 *
 *  @param pData pData description
 *
 *  @return IDataContact
 */
+ (IDataContact*)toContactData:(IPhoneBookData*)pData;

/**
 *  云联系人转换
 *
 *  @param pData pData description
 *
 *  @return IDataContact
 */
+ (IDataContact*)toCloudContactData:(IPhoneBookData*)pData;

/**
 *  通话记录转换
 *
 *  @param pData pData description
 *
 *  @return IDataContact
 */
+ (IDataCallLog*)toCallLog:(IPhoneBookData*)pData;

/**
 *  删除单个通话记录
 *
 *  @param pICallLog pICallLog description
 */
+ (void)deleteCallLog:(IDataCallLog*)pICallLog;

/** function
 *  @brief:根据呼叫记录信息进行呼叫记录删除
 *  @callLog @in @brief:呼叫记录信息
 *
 **/
+ (void)deleteCallLogs:(ICallLogData*)callLogs;

/** function
 *  @brief:删除对应类型的所有呼叫记录
 *  @callType @in @brief:删除类型0:Unknown;1:outGoing;2:inComing;4:Miss;8:conference;15:all
 *
 **/
+ (void)deleteAllCallLog:(int)eCallType;

/**
 *  重置漏接记录
 */
+ (void)resetMissCallCount;

/**
 *  获取搜索匹配上的字符，即字符串中哪些字符可以搜索匹配上
 *  @param text NSString description
 *  @param strKey NSString description
 */
+ (NSString*)getMatchSubKey:(NSString*)text strKey:(NSString*)strKey;

/**
 *  历史联系人转换
 *  @param pData pData description
 *  @return IDataHistoryContact
 */
+ (IDataHistoryContact*)toHistoryContact:(IPhoneBookData*)pData;

/**
 *  添加历史联系人
 *  @param dataHistoryContact IDataHistoryContact description
 *  @return true or false
 */
+ (bool)addHistoryContact:(IDataHistoryContact*)dataHistoryContact;

/**
 *  删除历史联系人
 *  @param pData pData description
 */
+ (void)deleteHistoryContact:(IPhoneBookData*)pData;

/**
 *  删除所有同类型的历史联系人
 *  @param iType int description
 */
+ (void)deleteAllHistoryContact:(int)iType;

/**
 *  获取历史联系人列表
 *  @return IPhoneBookData* array
 */
+ (NSMutableArray*)getHistoryContactList:(int)iType;

/**
 *功能：获取云联系人类型，用于区分显示一般和组织联系人
 *参数：无
 *返回：返回云联系人类型：enum CLOUD_DIR_TYPE {CDT_UNKNOWN=0, CDT_GENERAL=1, CDT_ORG=2}
 *备注：无
 */
+ (int)get_CloudDirType;

/**
 *功能：根据节点id获取节点信息
 *参数：nodeId: NSString, 节点的唯一标示符，如果为空，则表示获取根节点
 *返回：返回云联系人节点信息
 *备注：返回节点的id为空，则表示该节点不可用
 */
+ (IOrgTreeInfo*)getOrgNodeInfo:(NSString*)strNodeId;

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
+ (IOrgTreeInfo*)search:(NSString*)strKey nodeId:(NSString*)nodeId strExtension:(NSString*)strExtRequire;
@end
