//
//  LMConst.h
//  实体联盟
//
//  Created by 贾斌 on 2017/7/20.
//  Copyright © 2017年 贾斌. All rights reserved.
//


#import <Foundation/Foundation.h>

//调试用类



// 用户信息
//#import "LMUserInfo.h"
//#import "LMLoginInfo.h"
//购物车工具类



#define UserInfoData [LMUserInfo findAll].lastObject
#define CURRENT_USER [LMLoginInfo currentUser]


#define SHOPPING_MANAGER [LMShopDataTool manager]



// 偏好设置
#define kDataPersistence(object,key) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]
#define kGetData(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

//提醒框

#define MGPS(obj) [SVProgressHUD showSuccessWithStatus:obj];
#define MGPE(obj) [SVProgressHUD showErrorWithStatus:obj];


/** 通知中心 */
#define YWNotificationCenter [NSNotificationCenter defaultCenter]

/**登录成功*/
extern NSString *const YWLoginSucesesNSNotification;

//用户信息
extern NSString *const YWLogUserNotification;
extern NSString *const YWLogUser;
//我的电站
extern NSString *const YWMystationChangeNotification;
extern NSString *const YWMystationChange;
//平均值改变
extern NSString *const YWAvegeValueDidChangeNotification;
extern NSString *const YWAvegeValueDidChange;

//周改变
extern NSString *const YWWeekValueDidChangeNotification;
extern NSString *const YWWeekValueDidChange;

//年值改变
extern NSString *const YWYearValueDidChangeNotification;
extern NSString *const YWYearValueDidChange;

//收藏变化
extern NSString *const YWCollectStateChangeNotification;
extern NSString *const YWCollectStateChange;






/**退出登录*/
extern NSString *const LMLoginOutNSNotification;
/**添加银行卡成功*/
extern NSString *const LMAddCardSucesesNSNotification;

/**清空购物车*/
extern NSString *const LMClearShopCartNSNotification;



/**删除商品*/
extern NSString *const LMShopCarDidRemoveProductNSNotification;

//商品价格
extern NSString *const LMShopCarBuyPriceDidChangeNotification;
extern NSString *const LMShopCarBuyPriceDidChange;

//商品排序
extern NSString *const LMGoodSortChangeNotification;
extern NSString *const LMGoodSortChange;

//商品价格
extern NSString *const LMHomeGoodsInventoryProblem;

//商品选择属性发生改变
extern NSString *const LMGoodAttrDidChangeNotification;
extern NSString *const LMGoodAttrDidChange;




extern NSString *const LMNicknameChangeNotification;
extern NSString *const LMNicknameChange;
//付款方式改变
extern NSString *const LMPayTypeChangeNotification;
extern NSString *const LMPayTypeChange;

//支付方式改变
extern NSString *const LMOrderPayTypeChangeNotification;
extern NSString *const LMOrderPayTypeChange;

//配送方式改变
extern NSString *const LMSendTypeChangeNotification;
extern NSString *const LMSendTypeChange;

extern NSString *const LMCardChangeNotification;
extern NSString *const LMCardChange;


//城市区域
extern NSString *const LMCityDidChangeNotification;
extern NSString *const LMSelectCityName;

extern NSString *const LMSortDidChangeNotification;
extern NSString *const LMSelectSort;

extern NSString *const LMCategoryDidChangeNotification;
extern NSString *const LMSelectCategory;
extern NSString *const LMSelectSubcategoryName;

extern NSString *const LMRegionDidChangeNotification;
extern NSString *const LMSelectRegion;
extern NSString *const LMSelectSubregionName;

extern NSString *const LMCollectStateDidChangeNotification;
extern NSString *const LMIsCollectKey;
extern NSString *const LMCollectDealKey;

extern NSString *const LMScroDetailsPageNotification;
extern NSString *const LMScroDetailsPage;

// 地址
extern NSString *const LMAddAddressNotification;
extern NSString *const LMAddAddress;


extern NSString *const LMEditAddressNotification;
extern NSString *const LMEditAddress;


extern NSString *const LMCityLocNotification;
extern NSString *const LMCityLocName;



// 基本URL
#define YWBaseURL           @"http://app.connel.cn/api/"

// appKey
#define LMClient_id         @"AB4E85FAC0FE0B4C1B29906283622BBA"

#define YWDocumentsPath         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define YWAccountFilePath       [SCDocumentsPath stringByAppendingPathComponent:@"AccountInfo.data"]


#define ISLOGIN   @"islogin"
#define LoginFile  @"LoginFile.plist"


//邮箱匹配验证
#define MSGCONTENT(i) [NSString stringWithFormat:@"尊敬的用户，您的短信验证码为:%d",i]
#define EMAILCHECK(email) \
[[NSPredicate predicateWithFormat:@"SELF MATCHES%@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"] evaluateWithObject:email]
//手机号码验证
#define TELNUMCHECK(telNum)  \
[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(13[0-9]|14[57]|15[012356789]|17[678]|18[012356789])\\d{8}"]  evaluateWithObject:telNum]
#define BACK_DATA_SUCCESS [result[@"ret"] intValue] == 0
#define WEBFIALED     @"网络连接失败"

//数据存储

#define USER_TABLE_SQL @"CREATE TABLE IF NOT EXISTS `user` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `user_id` VARCHAR(20) UNIQUE NOT NULL,`user_phone` VARCHAR(20) NOT NULL,`user_pwd` NOT NULL,`time` VARCHAR(20) NOT NULL,'user_name' VARCHAR(20) ,commodity,shop,record)"
