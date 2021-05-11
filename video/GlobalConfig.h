//
//  GlobalConfig.h
//  iSmartHome
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 crazyit.org. All rights reserved.
//

#ifndef GlobalConfig_h
#define GlobalConfig_h

#import "LocalStringObj.h"

//1.获取屏幕宽度与高度
//#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
//#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

//5.自定义高效率的 NSLog
#ifdef DEBUG
#define LRLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define LRLog(...)
#endif


#ifdef DEBUG // 调试状态, 打开LOG功能
#define ZQLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define ZQLog(...)
#endif


#define RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define RGB(r,g,b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

//字体
#define ZQFont(x) [UIFont systemFontOfSize:x]

#define ImageDir [NSString stringWithFormat:@"%@/Documents/capturepng", NSHomeDirectory()]
//datacache
#define dataCache  @"t_dataCache"
//RecordingTable
#define RecordingTable  @"t_RecordingTable"


// 启动图路径
#define klaunch_path     [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]  stringByAppendingPathComponent:@"launch.archiver"]


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IOS_11  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f)

#define IS_IPHONE_X (IS_IOS_11 && IS_IPHONE && (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 && MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812))

//需要横屏或者竖屏，获取屏幕宽度与高度
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif

#define NEW_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define NEW_SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

//2.获取通知中心
#define LRNotificationCenter [NSNotificationCenter defaultCenter]

//3.设置随机颜色
#define LRRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

//4.设置RGB颜色/设置RGBA颜色
#define LRRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LRRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
// clear背景颜色
#define LRClearColor [UIColor clearColor]


#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//6.弱引用/强引用
#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;

//7.设置 view 圆角和边框
#define LRViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//8.由角度转换弧度 由弧度转换角度
#define LRDegreesToRadian(x) (M_PI * (x) / 180.0)
#define LRRadianToDegrees(radian) (radian*180.0)/(M_PI)

//9.设置加载提示框（第三方框架：Toast）
#define LRToast(str)              CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle]; \
[kWindow  makeToast:str duration:0.6 position:CSToastPositionCenter style:style];\
kWindow.userInteractionEnabled = NO; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
kWindow.userInteractionEnabled = YES;\
});\

//10.设置加载提示框（第三方框架：MBProgressHUD）
// 加载
#define kShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
// 收起加载
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
// 设置加载
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

#define kWindow [UIApplication sharedApplication].keyWindow

#define kBackView         for (UIView *item in kWindow.subviews) { \
if(item.tag == 10000) \
{ \
[item removeFromSuperview]; \
UIView * aView = [[UIView alloc] init]; \
aView.frame = [UIScreen mainScreen].bounds; \
aView.tag = 10000; \
aView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3]; \
[kWindow addSubview:aView]; \
} \
} \

#define kShowHUDAndActivity kBackView;[MBProgressHUD showHUDAddedTo:kWindow animated:YES];kShowNetworkActivityIndicator()

#define kHiddenHUD [MBProgressHUD hideAllHUDsForView:kWindow animated:YES]

#define kRemoveBackView         for (UIView *item in kWindow.subviews) { \
if(item.tag == 10000) \
{ \
[UIView animateWithDuration:0.4 animations:^{ \
item.alpha = 0.0; \
} completion:^(BOOL finished) { \
[item removeFromSuperview]; \
}]; \
} \
} \

#define kHiddenHUDAndAvtivity kRemoveBackView;kHiddenHUD;HideNetworkActivityIndicator()


//11.获取view的frame/图片资源
//获取view的frame（不建议使用）
//#define kGetViewWidth(view)  view.frame.size.width
//#define kGetViewHeight(view) view.frame.size.height
//#define kGetViewX(view)      view.frame.origin.x
//#define kGetViewY(view)      view.frame.origin.y

//获取图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

#define CollectionName @"Geneinno"// Geneinno

//12.获取当前语言
#define LRCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//13.使用 ARC 和 MRC
#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif

//14.判断当前的iPhone设备/系统版本
//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是否为ipod

#define IS_IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
// 判断设备是@2x还是@3x
#define kScreenScale  [UIScreen mainScreen].scale  // iphone 3gs为1；4，5，5s,6，7，8等为2；plus X为3
//判断当前设备是不是iPhone4或者4s
#define IPHONE4S    (([[UIScreen mainScreen] bounds].size.height)==480)

// 判断是否为 iPhone 5SE
#define iPhone5SE SCREEN_WIDTH == 320.0f && SCREENH_HEIGHT == 568.0f

// 判断是否为iPhone 6/6s
#define iPhone6_6s SCREEN_WIDTH == 375.0f && SCREENH_HEIGHT == 667.0f

// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus SCREEN_WIDTH == 414.0f && SCREENH_HEIGHT == 736.0f

//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))

// 判断是否是iPhone X
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)

//15.判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//AppDelegate对象
#define AppDelegateInstance [[UIApplication sharedApplication] delegate]
//一些缩写
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//16.沙盒目录文件
//获取temp
#define kPathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


#define getXibName(x) (IS_IPAD ? [[NSString alloc] initWithFormat:@"%@_ipad", x] : [[NSString alloc] initWithFormat:@"%@_iphone", x])

#define EXTRACT_OBJECT(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

static NSString *timeformat = @"yyyy-MM-dd HH:mm:ss";

static NSString *kAccessKeyAndIdRead = @"ali_oss_access_key_and_access_id_read";
static NSString *kAccessKeyAndIdWrite = @"ali_oss_access_key_and_access_id_write";

static NSString *accountBindHint = @"not_hint_bind_";

static NSString *tempUnlockKey = @"getSLInfo";

/******************* ITEM *********************/
#define ITEMRADIUS_OUTTER    70  //item的外圆直径
#define ITEMRADIUS_INNER     20  //item的内圆直径
#define ITEMRADIUS_LINEWIDTH 1   //item的线宽
#define ITEMWH               70  //item的宽高
#define ITEM_TOTAL_POSITION  130  // 整个item的顶点位置
/*********************** subItem *************************/
#define SUBITEMTOTALWH 50 // 整个subitem的大小
#define SUBITEMWH      12  //单个subitem的大小
#define SUBITEM_TOP    20 //整个的subitem的顶点位置(y点)
/*********************** 颜色 *************************/
//背景色   深蓝色
#define BACKGROUNDCOLOR [UIColor colorWithRed:0.05 green:0.2 blue:0.35 alpha:1]
//选中颜色  浅蓝色
#define SELECTCOLOR [UIColor colorWithRed:0.13 green:0.7 blue:0.96 alpha:1]
//选错的颜色  红色
#define WRONGCOLOR [UIColor colorWithRed:1 green:0 blue:0 alpha:1]
//文字错误提示颜色   浅红色
#define LABELWRONGCOLOR [UIColor colorWithRed:0.94 green:0.31 blue:0.36 alpha:1]
/*********************** 文字提示语 *************************/



//#define ip_address @"192.168.8.1"

//#pragma mark -- TITAN改成 192.168.8.8
//#define ip_address @"192.168.8.8"
////#define ip_address @"192.168.0.122"
//
//#define rtmp_address @"rtmp://" ip_address @":1935/rtmp/live"
//#define rtmp_TITAN_address @"rtmp://" ip_address @":1935/rtmp"
//
//#define http_address @"http://" ip_address
//
//#define pic_url @"http://" ip_address @"/photos/"
//#define video_url @"http://" ip_address @"/videos/"
//
//#define TITAN_pic_url @"http://" ip_address @"/media/photos/"
//#define TITAN_video_url @"http://" ip_address @"/media/videos/"

//#define samba_pic_dir @"/media/photos/"
//#define samba_video_dir @"/media/videos/"

#define  humiparam @"humi"
#define  iadc0param @"iadc0"
#define  iadc1param @"iadc1"
#define  iadc2param @"iadc2"
#define  iadc3param @"iadc3"
#define  iadc4param @"iadc4"
#define  iadc5param @"iadc5"



#define  mtleftparam @"mtleft"
#define  mtrightparam @"mtright"
#define  mtliftparam @"mtlift"
#define  hldheadparam @"hldhead"


#define  lightparam @"light"
#define  rollparam @"roll"
#define  runtimeparam @"runtime"
#define  temp_outsideparam @"temp_outside"
#define  temp_insideparam @"temp_inside"

#define  deapparam @"deap"
#define  hlddepthparam @"hlddepth"
#define  shiftparam @"shift"
#define  pitchparam @"pitch"
#define  yawparam @"yaw"
#define  hdgdparam @"hdgd"

#define  versionparam @"version"
#define  ser_verparam @"ser_ver"
#define storageparam  @"storage"
#define  batlvlparam @"batlvl"
#define  wifidelayparam @"wifidelay"

#define userDataParam @"userData"

#define POSEIDON_NOTIFY @"POSEIDON_NOTIFY"
#define MOTOR_NOTIFY @"MOTOR_NOTIFY"
#define STORAGE_NOTIFY @"STORAGE_NOTIFY"

#define CHANGERESOLUTION @"CHANGERESOLUTION"
#define COMPASS_NOTIFY @"COMPASS_NOTIFY"
#define DELETE_FILE_NOTIFY @"DELETE_FILE_NOTIFY"

#define SETTING_STATE_NOTIFY @"SETTING_STATE_NOTIFY"
#define CPID_STATE_NOTIFY @"CPID_STATE_NOTIFY"
// 连接成功通知
#define SOCKET_CONNECTED_NOTIFY @"SOCKET_CONNECT_NOTIFY"
// 视频连接成功,但未设置代理
#define VIDEO_CONNECTED_DELE_NOTIFY @"VIDEO_CONNECTED_DELE_NOTIFY"
// mini历史记录s接收通知刷新UI
#define MINI_RECORD_NOTIFY       @"MINI_RECORD_NOTIFY"

// 启动图路径
#define klaunch_path     [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]  stringByAppendingPathComponent:@"launch.archiver"]


#define clientTime @"clientime"
/*ERROR EVENT From Server*/
#define storageFull @"storageFull"           // 设备磁盘空间
#define mtrperr @"mtrperr"
#define mtrverr @"mtrverr"
#define mtrserr @"mtrserr"
#define recordBusy @"record_busy"

#define gestureparam @"gesture"

#define needRestartRPlayer @"needRestartRPlayer"
#define operationPlayerNeedReset @"operationPlayerNeedReset"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define DEVICETYPE @"deviceType"

#define DqLocalizedString(s) [LocalStringObj LocalizedString:s]

#define PI 3.14

static const float iphoneHeight = 40;
static const float ipadHeight = 60;

//TITAN，POSEIDON II使用的是TCPSOCKET,POSEIDON使用socket.io
static const  int POSEIDON_II = 1;
static const  int TITAN = 2;
static const  int POSEIDON =  3;//老版本
static const  int MINI =  4;// MINI就是S2
static const  int CELL_B =  5;//
static const  int TITANPRO = 6; //T1 pro

typedef enum : NSUInteger {
    cam_setting = 0,//相机设置
    record_setting,//刻录设置
    environment_setting,//环境设置
    sensor_setting,//传感器设置
    mode_setting,//模式设置
    cam_photosSetting,//拍照设置
    cam_liveSeting,//直播流画质
    record_resolutionSetting,//刻录分辨率
    record_formatSetting,//刻录格式
    record_filetime,//文件时长
    depth_check,//水深校正
    accelerator_check,//加速度计
    compass_check,//指南针校正
    setting_default//默认值
} SETTING_TYPE;

typedef enum : NSUInteger {
    storage_info = 0,//存储空间
    battery_info,//电池信息
    motor_info,//马达信息
    version_info,//版本信息
    info_default//默认值
} INFO_TYPE;
#endif /* GlobalConfig_h */
