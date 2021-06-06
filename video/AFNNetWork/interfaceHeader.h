//
//  interfaceHeader.h
//  video
//
//  Created by nian on 2021/5/31.
//

#ifndef interfaceHeader_h
#define interfaceHeader_h


//  服务器地址
//#define FWQURL @"http://192.168.1.8:8012" ///局域网地址
#define FWQURL @"http://51.79.223.179:8012" ///公网地址
/////  POST 请求
#define  zhuceURL @"/passport/signup" //通过用户名、密码以及图形验证码注册应用账号
#define emailzhuce @"/passport/signupByEmail" //邮箱注册
#define resetemaliPW @"/passport/resetPasswordByEmail" // 通过邮箱和邮箱验证码重置密码
#define loginURL @"/passport/signin" // 登录
#define bangdingEmail @"/secrity/bindEmail"  ///绑定邮箱
#define xiugaiPwURL @"/secrity/changePassword" ///修改登录密码

#define tuxingYZMurl @"/captcha"  ///图形验证码
#define emailYZMurl @"/captcha/email" //电子邮箱验证码
/// 个人中心
#define rechargeRecordurl @"/user/rechargeRecord"  //取得用户充值记录
#define videoHistoryurl @"/user/videoHistory"  //取得用户观看视频的历史记录
#define videoFavoriteurl @"/user/videoFavorite"  //取得用户收藏的视频
#define changeNicknameurl @"/user/changeNickname"  //修改用户昵称
#define changeAvatarurl @"/user/changeAvatar"  //修改用户头像
#define changeGenderurl @"/user/changeGender"  //修改用户性别
#define infourl @"/user/info"  //取得用户信息
//消息
//#define url @""  //
//#define url @""  //
//#define url @""  //
//#define url @""  //
//#define url @""  //
//#define url @""  //
//#define url @""  //
//#define url @""  //
//#define url @""  //
//#define url @""  //



//#define resetemaliPW @"/passport/signin" // 
//#define resetemaliPW @"/passport/signin" //
//#define resetemaliPW @"/passport/signin" //
//#define resetemaliPW @"/passport/signin" //
//#define resetemaliPW @"/passport/signin" //
//#define resetemaliPW @"/passport/signin" //
//#define resetemaliPW @"/passport/signin" //
//#define resetemaliPW @"/passport/signin" //
//#define resetemaliPW @"/passport/signin" //

///// GET 请求


#endif /* interfaceHeader_h */
