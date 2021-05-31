//
//  interfaceHeader.h
//  video
//
//  Created by nian on 2021/5/31.
//

#ifndef interfaceHeader_h
#define interfaceHeader_h


//  服务器地址
#define FWQURL @"http://192.168.1.8:8012" ///局域网地址
//#define FWQURL @"http://51.79.223.179:8012" ///公网地址
/////  POST 请求
#define  zhuceURL @"/passport/signup" //通过用户名、密码以及图形验证码注册应用账号
#define emailzhuce @"/passport/signupByEmail" //邮箱注册
#define resetemaliPW @"/passport/resetPasswordByEmail" // 通过邮箱和邮箱验证码重置密码
#define loginURL @"/passport/signin" // 登录
#define bangdingEmail @"/secrity/bindEmail"  ///绑定邮箱
#define xiugaiPwURL @"/secrity/changePassword" ///修改登录密码

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
