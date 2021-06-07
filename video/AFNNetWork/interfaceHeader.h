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
#define getbannerurl @"/banner"  // 轮播图
/// 个人中心
#define rechargeRecordurl @"/user/rechargeRecord"  //取得用户充值记录
#define videoHistoryurl @"/user/videoHistory"  //取得用户观看视频的历史记录
#define videoFavoriteurl @"/user/videoFavorite"  //取得用户收藏的视频
#define changeNicknameurl @"/user/changeNickname"  //修改用户昵称
#define changeAvatarurl @"/user/changeAvatar"  //修改用户头像
#define changeGenderurl @"/user/changeGender"  //修改用户性别
#define infourl @"/user/info"  //取得用户信息
//消息
#define msgListurl @"/message/list"  //用户相关的消息
#define msgreadurl @"/message/read"  //将消息标为已读
//广告
#define guanggaoAllurl @"/ad/all"  //获取全部广告信息，无需用户处于登录状态
#define guanggaourl @"/ad"  //获取对应广告位广告信息，无需用户处于登录状态
// 公告列表
#define notice_listurl @"/notice/list"  //公告列表
#define notice_marqueeurl @"/notice/marquee"  //跑马灯公告列表
#define floatingurl @"/floating"  //首页悬浮
//支付方式
#define payment_methodurl @"/payment/method"  //可用的支付方式
#define purchaseVipCardurl @"/payment/purchaseVipCard"  //购买会员卡

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

//#define video_rankurl @"/video/rank"  //视频排行榜列表
//#define video_listurl @"/video/list"  //视频列表
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
#define video_postCommenturl @" /video/postComment"  //对视频进行评论
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
