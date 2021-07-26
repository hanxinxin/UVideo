//
//  interfaceHeader.h
//  video
//
//  Created by nian on 2021/5/31.
//

#ifndef interfaceHeader_h
#define interfaceHeader_h



//1 所有请求都是post方式
//2 传输的数据以 request body 的形式，跟不加密时的 Content-Type:application/json 这种类似
//3 生成一个随机的32长度的aes key，用这个aes key去加密 json字符串，得到crypted_data (经过base64编码的)
//4 用rsa加密上面的aes key，得到crypted_key (经过base64编码的)
//5 把crypted_data和crypted_key这两个字符串拼接起来，中间用点号分隔，解密时就是依据这个确定哪个是加密后的key，哪个是加密后的json数据
//6 对传输的参数进行去除空值(整形0 浮点型0 字符串0 null undefined 空字符串 false)，然后进行铵键名字典排序，再组合成 http query格式的data，如a=xxx&b=xxxx&c=xxxxx
//7 套用公式生成签名 md5(token + '-' + data + '-' + timestamp)
//8 请求头信息 X-TOKEN 值是token, X-TIMESTAMP值是timestamp,X-SIGNATURE值是签名
//9 请求body 就是刚刚拼接的加密的数据





#define usertoken [[NSUserDefaults standardUserDefaults] valueForKey:@"UserToken"]
#define nickname_loca [[NSUserDefaults standardUserDefaults] valueForKey:@"nickname"]
#define username_loca [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]
#define UserZH_loca [[NSUserDefaults standardUserDefaults] valueForKey:@"UserZH"]

#define avatar_loca [[NSUserDefaults standardUserDefaults] valueForKey:@"avatar"]
#define expired_time_loca [[NSUserDefaults standardUserDefaults] valueForKey:@"expired_time"]
#define vip_expired_time_loca [[NSUserDefaults standardUserDefaults] valueForKey:@"vip_expired_time"]
//  服务器地址
#define FWQURL @"https://api-h5.uvod.tv" ///正式服务器地址
//#define FWQURL @"http://51.79.223.179:8012" ///公网地址
/////  POST 请求
#define  zhuceURL @"/passport/signup" //通过用户名、密码以及图形验证码注册应用账号

#define emailzhuce @"/passport/signupByEmail" //邮箱注册
#define resetemaliPW @"/passport/resetPasswordByEmail" // 通过邮箱和邮箱验证码重置密码
#define loginURL @"/passport/signin" // 登录
#define bangdingEmail @"/secrity/bindEmail"  ///绑定邮箱
#define xiugaiPwURL @"/secrity/changePassword" ///修改登录密码

#define signoutURL @"/secrity/signout"  ///退出登录

#define GetUserInfoURL @"/user/info" ///获取用户信息


#define tuxingYZMurl @"/captcha"  ///图形验证码
#define emailYZMurl @"/captcha/email" //电子邮箱验证码
#define getbannerurl @"/banner"  // 轮播图
/// 个人中心
#define rechargeRecordurl @"/user/rechargeRecord"  //取得用户充值记录
#define videoHistoryurl @"/user/videoHistory"  //取得用户观看视频的历史记录
#define videoFavoriteurl @"/user/videoFavorite"  //取得用户收藏的视频
#define changeNicknameurl @"/user/changeNickname"  //修改用户昵称
#define changeGenderurl @"/user/changeGender"  //修改用户性别
#define infourl @"/user/info"  //取得用户信息

#define YHupdateavatar @"/upload/avatar" ///上传用户头像  file 不用加密


//消息
#define msgListurl @"/message/list"  //用户相关的消息
#define msgreadurl @"/message/read"  //将消息标为已读
//广告
#define guanggaoAllurl @"/ad/all"  //获取全部广告信息，无需用户处于登录状态
#define guanggaoGDurl @"/ad"  //获取对应广告位广告信息，无需用户处于登录状态
// 公告列表
#define notice_listurl @"/notice/list"  //公告列表
#define notice_marqueeurl @"/notice/marquee"  //跑马灯公告列表
#define floatingurl @"/floating"  //首页悬浮
//支付方式
#define payment_methodurl @"/payment/method"  //可用的支付方式
#define purchaseVipCardurl @"/payment/purchaseVipCard"  //购买会员卡
#define vipCardcategoryurl @"/vipCard/category"  //点卡种类(全部)
#define PostCardactivateurl @"/vipCard/activate" //激活点卡

//// 反馈
#define postfeedbackcategoryurl @"/feedback/category"//// 反馈类型列表
#define postfeedbackdurl @"/feedback/post"/// 反馈

////帮助中心
#define postfaqcategoryurl @"/faq/category"  //帮助中心分类(全部)
#define postfaqlisturl @"/faq/list" ///帮助中心列表

//// 客服
#define postcustomerServicelisturl @"/customerService/list" ///获取全部客服信息
#define postcustomerServicelisturl @"/customerService/list" ///获取全部客服单个信息
#define postcustomerServiceinfourl @"/customerService/info"////获取某一个客服信息


#define video_updateHistory @"/user/updateHistory"///更新播放历史 定时 10秒轮一次，更新观看历史



////视频播放页
#define video_latesturl @"/video/latest"  //视频排行榜列表
#define video_sourceurl @"/video/source"  //视频播放资源地址
//|参数名|必须|类型|默认值|说明|
//|:----|:---|:-----|:-----|-----|
//|video_id|是|number||视频id|
//|video_fragment_id|是|number||视频分集id|
//|quality|否|number||清晰度[1=标清 2=高清 3=超清 4=蓝光], 不传默认取最低的“标清”|


#define video_infourl @"/video/info"  //视频信息
//#### 请求参数:
//|参数名|必须|类型|默认值|说明|
//|:----|:---|:-----|:-----|-----|
//|id|是|number||视频id|

#define video_favoriteurl @"/video/favorite"  //收藏视频
//|video_id|是|integer||视频id|

#define video_filterurl @"/video/filter"  //视频筛选词
#define video_keywordurl @"/video/keyword"  //视频热搜词
#define deleteFavoriteurl @"/video/deleteFavorite"  //通过视频id删除已收藏视频记录
//|参数名|必须|类型|默认值|说明|
//|:----|:---|:-----|:-----|-----|
//|video_id|是|integer||视频id

#define video_commenturl @"/video/comment"  //评论列表
//|参数名|必须|类型|默认值|说明|
//|:----|:---|:-----|:-----|-----|
//|video_id|是|number||视频id|
//|page|否|number|1|页数|
//|pagesize|否|number|50|每页数量|

#define video_evaluateurl @"/video/evaluate"  //登录后，对视频进行评价(赞或踩)
//#### 请求参数:
//|参数名|必须|类型|默认值|说明|
//|:----|:---|:-----|:-----|-----|
//|video_id|是|integer||视频id|
//|evaluate|是|integer||评价类型(1=赞 -1=踩)|

#define video_rankurl @"/video/rank"  //视频排行榜列表
#define video_listurl @"/video/list"  //视频列表
//#### 请求参数:
//|参数名|必须|类型|默认值|说明|
//|:----|:---|:-----|:-----|-----|
//|keyword|否|string||搜索关键词|
//|parent_category_id|否|number||顶级分类id|
//|category_id|否|number||分类id|
//|year|否|string||年份|
//|region|否|string||地区|
//|language|否|string||语言|
//|paid|否|number||是否付费[1=是 0=否]|
//|state|否|string||更新状态|
//|page|否|number|1|页数|
//|pagesize|否|number|50|每页数量|

#define video_categoryurl @"/video/category"  //视频分类
#define video_postCommenturl @"/video/postComment"  //对视频进行评论
//#### 请求参数:
//|参数名|必须|类型|默认值|说明|
//|:----|:---|:-----|:-----|-----|
//|video_id|是|integer||视频id|
//|content|是|string||评论内容(10-140字)|
#define video_reporturl @"/video/report"  //对视频进行提交报错
//#define url @""  //
//#define url @""  //
//#define url @""  //



///// GET 请求


#endif /* interfaceHeader_h */




//-(void)RSA{
//     //公钥
//       NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDaBP9guWQPO2jSbG1NHiWvwY9pti6B9sagVISpgXdio1amauYALYXwcgx6rybR7JfBbkmVS3Xw7yxy5WPpiVzmEwSh7xxviyot6yMeeZwhYVBdK2iOCWPATjIOsUvsb+Z6ydPFLO/Gf0CLVFScKy8UN+kzCNaor9DM/1P0hh8/+wIDAQAB";
//       //私钥
//       NSString *privateKey = @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBANoE/2C5ZA87aNJsbU0eJa/Bj2m2LoH2xqBUhKmBd2KjVqZq5gAthfByDHqvJtHsl8FuSZVLdfDvLHLlY+mJXOYTBKHvHG+LKi3rIx55nCFhUF0raI4JY8BOMg6xS+xv5nrJ08Us78Z/QItUVJwrLxQ36TMI1qiv0Mz/U/SGHz/7AgMBAAECgYEAvunza5LMkR4YC3PRPt+wZrjbydkz3rDnfEymovxxO9oGrdIcOHmkuUpVrTUljFxfA459NxQOYn4+cRp4pG+Z/W1RLWMOAk0M79Fw14CEJk9d2sJUa03As9shrxRMndqZASWEZgIGGaia6ZqfsR/OafkZGsGUDPVILSu3dzH5aPkCQQDufqq0roD629VzeZjdyrl+hTDKCCd0kujZ2SRNyGvGLr+8jVRlwX2I7C0kKhTa8WJB/RC173E616GlSFXc7gMvAkEA6gWZWry0C/5eZgoFt2MfYelyueQhG7gE42jYFzV3BbH8f4gB3PrsyS8SA212udxu5RiRkFjO4ZoMzOBlKNAM9QJBALmCe4P5bMg0cQ7WWarDgo/ASFgOCaqqj0bMmWmLaRGJ0Yh3oltYKy5zDxXfScOYGObdUr9B1aCAk/K9llQ4Ku8CQQCRXJD5L6WWnZX9Q9RxKPzhUKSWmwGFujQvHXy8TdV0kC4K+WxO2v4hqT9DKcdJg4bOfwhL5R38PDgfOnMber/RAkEA2mW2Q8VN7OQXWjRJPngOd62GQI5R7jC9uSi/w8oh6mB02spKOo6XBa9xcBHlzLRhqEJIKYAw3i//hCYG3neoHQ==";
//       //测试要加密的数据
//       NSString *sourceStr = @"iOS端RSA";
//       //公钥加密
//       NSString *encryptStr = [RSA encryptString:sourceStr publicKey:publicKey];
//       //私钥解密
//       NSString *decrypeStr = [RSA decryptString:encryptStr privateKey:privateKey];
//       NSLog(@"加密后的数据 %@ 解密后的数据 %@",encryptStr,decrypeStr);
//        
//}
//
////aes iv: abcdefghijklmnop
////加密模式: cbc
//-(void)AES{
//   NSString * string =  [AES AES128_Encrypt:@"aadhdhdgdjdhdmcb" encryptString:@"想要加密的数据123" giv:@"abcdefghijklmnop"];
//    NSLog(@"加密后的数据%@",string);
//    NSString * string1 = [AES AES128_Decrypt:@"aadhdhdgdjdhdmcb" encryptString:string giv:@"abcdefghijklmnop"];
//    NSLog(@"解密后的数据%@",string1);
//    
//}








