//
//  MyPublicClass.h
//  KTexpress
//
//  Created by 刘欢 on 2017/4/1.
//  Copyright © 2017年 huan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight     [UIScreen mainScreen].bounds.size.height
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define ImageName(imageName) [UIImage imageNamed:imageName]

//判断 是否是IPhoneX以上和是否是ios11以上
#define Current_IOS11_AND_X_XR_XS_XMax ({\
int current = 0;\
if (@available(iOS 11.0, *)) {\
if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom >0.0) {\
current = 1;\
}else{\
current = 0;\
}\
}else{\
current = 0;\
}\
current;\
})

//导航栏
#define K_Height_NavContentBar 44.0f
//X以上状态栏高度
#define K_Height_StatusBar (Current_IOS11_AND_X_XR_XS_XMax ? 44.0:20.0)
//X以上导航栏高度
#define K_Height_NavBar (Current_IOS11_AND_X_XR_XS_XMax ? 88.0:64.0)
//X以上标签栏高度
#define K_Height_TabBar (Current_IOS11_AND_X_XR_XS_XMax ? 83.0:49.0)
//X以上标签栏预留高度
#define K_Height_Origin_TabBar (Current_IOS11_AND_X_XR_XS_XMax ? 34.0:0.0)


@interface MyPublicClass : NSObject

/**
 自定义文字的宽高
 
 @param width label的宽度
 @param title 字符串
 @param font 字体大小
 @return 返回尺寸
 */
+ (CGRect)stringHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

/**
 获取文字宽度
 
 @param font 字体大小
 @param height 高度
 @param content 文字
 */
+ (CGFloat)widthWithFont:(UIFont *)font
     constrainedToHeight:(CGFloat)height
                 content:(NSString *)content;

/**
 计算文字的CGSize
 
 @param size 宽高
 @param font  字体(默认为系统字体)
 @return 宽高
 */
+ (CGSize)boundingRectWithSize:(CGSize)size
                  withTextFont:(UIFont *)font
                       content:(NSString *)content;

/**
 自定义文字尺寸(根据不同屏幕进行改变)
 
 @param fontSize 最初始字体大小
 @return 根据不同屏幕返回font
 */
+(CGFloat)customSystemFontOfSize:(CGFloat)fontSize;

/**
 切边距和边框
 边框可以传0
 
 @param sender 需要切边距的控件
 @param cornerRadius 具体需要切多少
 */
+(void)layerMasksToBoundsForAnyControls:(UIView *)sender cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 获取当前系统语言
 
 @return 返回当前语言为 "en"、"zh"、“zh-Hans"、"zh-Hant"等等
 */
+ (NSString *)getCurrentLanguage;


/**
 设置语言本地化
 
 @param language 需要国际化的参数
 @param key UserDefault KEY
 @return 多语言
 */
+(NSString *)localizedLanguage:(NSString *)language userDefaultsForKey:(NSString *)key;

/**
 修改占位符颜色，添加左边imageview
 
 @param attString 内容
 @param textField textField description
 @param imageString 图片名
 */
+(void)attributedString:(NSString *)attString andHolderColor:(UIColor *)color placeholder:(UITextField *)textField imageString:(NSString *)imageString andImageRect:(CGRect)imageRect;

/**
 隐藏文字中间部分 多用于电话 隐藏中间
 
 @prame Demo [MyPublicClass hidesThePartialInformations:@"13333333333" andLocation:3 andLength:4 writingChangeStyle:@"xxxx"]
 
 @param information 需要隐藏的字符串
 @param location 从哪里开始
 @param length 隐藏多少个
 @param style 隐藏的样式(注:与length对应) 如：***** ，......
 @return return 136******1133
 */
+(NSString *)hidesThePartialInformations:(NSString *)information andLocation:(NSUInteger)location andLength:(NSInteger)length writingChangeStyle:(NSString *)style;

/**
 文字重复(一般与方法(hidesThePartialInformations)共生-单个无意义)

Eg: [MyPublicClass hidesThePartialInformations:@"张三丰" andLocation:1 andLength:2 writingChangeStyle:[MyPublicClass hiddenLength:2 repeatString:@"*"]
 
 @param length 需要重复的次数
 @param string 需要重复的字符
 @return 累计重复后的String
 */
+(NSString *)hiddenLength:(NSInteger)length repeatString:(nullable NSString *)string;

/**
 阿拉伯数字转汉字数字
 
 @param numeral 例：1,2,3,4
 @return return 一,二,三,四
 */
+(NSString *)arabicNumerals:(int)numeral;

/**
 汉字编码转化(简-繁-English)

 @param string 代入的字符串
 @return 一 壹 one
 */
+(NSString *)LanguageSwitchString:(NSString *)string;

/**
 转json字符串
 
 @param temps 数组或字典
 @return 返回json字符串
 */
+(NSString *)stringTOjson:(id)temps;

/**
 设置某个字体大小,只修改设置部分
 
 @param String 需要修改的字符串
 @param Size 字体大小
 @param Range 通过坐标指定修改某个或多个
 @return return value description
 */
+(NSMutableAttributedString *)attributedString:(NSString *)String andFontOfSize:(CGFloat)Size andRange:(NSRange)Range;

/**
  设置字体font,设置部分及未设置部分

 @param String 需要修改的字符串
 @param sSize 设置部分尺寸
 @param sRange 设置部分间距
 @param unRange 未设置部分尺寸
 @param unSize 未设置部分间距(注：承接设置部分的间距,间距错误时,会有遗漏)
 @return return value description
 */
+(NSMutableAttributedString *)attributedString:(NSString *)String SetTheFontOfSize:(CGFloat)sSize SetTheTextRange:(NSRange)sRange UnsetTextRange:(NSRange)unRange UnsetFontOfSize:(CGFloat)unSize;

/**
 设置某个字体颜色
 
 @param String 需要修改的字符串
 @param Color Color description
 @param Range 指定区域
 @return return value description
 */
+(NSMutableAttributedString *)attributedString:(NSString *)String andColor:(UIColor *)Color andRange:(NSRange)Range;

/**
 设置划线 多用于金额 适用于文字
 
 @param lineationString 需要修改的字符串
 @return return value description
 */
+(NSMutableAttributedString *)attributedStringOfLineation:(NSString *)lineationString;


/**
 设置 中划线 和其他的颜色
 
 @param String  String description
 @param lRange  中划线的起止点
 @param cRange  颜色起止点
 @param color   Color description
 @return return value description
 */
+(NSMutableAttributedString *)attributedString:(NSString *)String LineationRange:(NSRange)lRange colorRange:(NSRange)cRange  andColor:(UIColor *)color;

/**
 将按钮文字添加划线
 
 @param title 需要加添加的信息
 @param other 需要划线的按钮
 */
+(void)addToLineForButtonTitle:(NSString *)title selectButton:(UIButton *)other;

/**
 设置所有字体颜色
 
 @param String String description
 @param Color Color description
 @return return value description
 */
+(NSMutableAttributedString *)attributedString:(NSString *)String andColor:(UIColor *)Color;

/**
 设置某个字体大小，并且修改某个字体颜色

 @param String 需要修改字符串
 @param fontSize 需要修改的字体大小
 @param fRange 需要修改的字体大小的范围
 @param Color 需要修改的字体颜色
 @param cRange 需要修改字体颜色的范围
 @return return value description
 */
+(NSMutableAttributedString *)attributedTargetString:(NSString *)String targetFontSize:(UIFont *)fontSize fontRange:(NSRange)fRange targetColor:(UIColor *)Color colorRange:(NSRange)cRange;

/**
 判断字符串是否为空
 
 @param string string description
 @return return 空为yes  反之 no
 */
+ (BOOL)stringIsNull:(NSString *)string;

/**
 验证密码 只能是数字加字母
 
 @param passWord 密码
 @param minNum 最小长度
 @param maxNum 最大长度
 @return 返回yes正确 no 格式错误
 */
+ (BOOL)validatePassword:(NSString *)passWord minLength:(NSString *)minNum maxLength:(NSString *)maxNum;


/**
 判断手机号
 
 @param phone 手机号码
 @return yes 表示正确 no 表示错误
 
 * 手机号码:
 * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
 * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
 * 联通号段: 130,131,132,155,156,185,186,145,176,1709
 * 电信号段: 133,153,180,181,189,177,1700
 */
+(BOOL)isPhone:(NSString *)phone;

/**
 判断座机号码

 @param phone 座机号码
 @return yes or no
 */
+(BOOL)isFixedTelephone:(NSString *)phone;

/**
 拨打电话
 
 @param tel 电话或者座机
 */
+(void)callPhone:(NSString *)tel;

/**
 检查银行卡号

 @param cardNo 卡号
 @return 验证结果
 */
+(BOOL)checkCardNo:(NSString*)cardNo;

/**
 md5加密 32位
 
 @param md5String 需要加密的字符串
 @return 加密后的字符串
 */
+(NSString *)md5:(NSString *)md5String;

/**
 设置TextView超链接 E.g:XXXXXXXXXX《超链接》
 
 
 @param string 超链接和内容字符串集合
 @param target 需要设置的超链接字符串
 @param key 超链接点击时的关键字
 @param font 所有字体尺寸
 @param color 所有字体颜色(除超链接字符串)
 @param textView 当前textView
 @param linkColor 超链接字符串颜色
 @supplement 与textView代理方法(shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange)和([[URL scheme] isEqualToString:key])共用
 */
+(void)textViewSetHyperlinkString:(NSString *)string targetString:(NSString *)target schemeKey:(NSString *)key hyperlinkFont:(UIFont *)font textColor:(UIColor *)color currentTextView:(UITextView *)textView hyperlinkColor:(UIColor *)linkColor;

/**
 设置TextField_placeholder颜色

 @param field 目标UITextField
 @param color 自定义颜色
 */
+(void)setTextField:(UITextField *)field placeholderColor:(UIColor *)color;


/**
 存储沙盒

 @param timeArray 需要存储的数据
 @param documentName 路径
 */
+(void)document:(id)timeArray andDocumentName:(NSString *)documentName;


/**
 存储沙盒，提取

 @param documentName 路径
 @return 字典接收数据
 */
+(NSDictionary *)userNameRead:(NSString *)documentName;

/**
 存储沙盒，删除(属性)

 @param path 需要删除的路径
 */
+(void)clearWithFilePath:(NSString *)path;

/**
 存储沙盒，删除(set方法)
 
 @param fileName 需要删除的路径
 */
+(void)documentfolder:(NSString *)fileName;


/**
 存储沙盒，缓存头像

 @param imageName 图片文件名
 @param data 图片转data数据
 */
+(void)createDirecctoryPathImageName:(NSString *)imageName imageData:(NSData *)data;

/**
 获取路径图片

 @param path png图片名
 @return 图片路径
 */
+(NSString *)filePath:(NSString *)path;


/**
 存储沙盒，判断文件是否已经在沙盒中已经存在


 @param fileName 文件名
 @return 是否存在
 */
+(BOOL)isFileExist:(NSString *)fileName;


/**
 textfield 限定最大编辑长度
 
 @param textField 代理自身textfield
 @param range    代理自身range
 @param string 代理自身string
 @param length 需要限制的最大输入长度
 @return yes可以编辑 no 不可编辑
 @supplement 与textfield代理方法对应（textField shouldChangeCharactersInRange:(NSRange)range replacementString）共用
 */
+(BOOL)textField:(UITextField *)textField customInputLength:(NSRange)range customReplacementString:(NSString *)string maxLength:(NSInteger)length;

 /**
 textfield 设置输入小数点位数
 
 @param textField 代理自身textfield
 @param range    代理自身range
 @param string 代理自身string
 @param length 需要限制的最大输入长度
 @return yes可以编辑 no 不可编辑
 @supplement 与textfield代理方法对应（textField shouldChangeCharactersInRange:(NSRange)range replacementString）共用 多用于金额的输入
 */
+(BOOL)systemTextField:(UITextField *)textField systemRange:(NSRange)range replacementString:(NSString *)string retainLength:(NSInteger)length;


/**
 textfield 银行卡样式 例:1234 5678 90

 @param textField 代理自身textfield
 @param range 代理自身range
 @param string 代理自身string
 @param length 银行卡长度
 @return yes可以编辑 no 不可编辑
 @supplement 与textfield代理方法对应（textField shouldChangeCharactersInRange:(NSRange)range replacementString）共用 多用于银行卡
 */
+(BOOL)systemTextField:(UITextField *)textField systemRange:(NSRange)range replacementString:(NSString *)string enterLength:(NSInteger)length;

/**
 倒计时
 
 @param num 多少秒
 @param sender 需要倒计时的按钮
 @param title 倒计时的提示信息
 */
+(void)countDownWithStratDate:(int)num timeButton:(UIButton *)sender buttonTitle:(NSString*)title;
//计时器销毁-一定要调用
+(void)destoryTimer;

/**
 将某个时间戳转化成 时间
 
 @param timestamp 时间戳
 @param format // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 @return 返回标准时间
 */
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

/**
 获取当前时间
 
 @param timeTpye 时间格式 例如："YYYY-MM-dd HH:mm:ss 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
 YYYY-MM-dd EEEE-获取年月日及星期几 例如2018-3-15 星期四
 @return 返回时间-已字符串类型返回
 */
+(NSString *)getSystemCurrentTime:(NSString *)timeTpye;

/**
 导航栏添加图片
 
 @param itme 当前的导航栏
 @param parentRect 当前的view
 @param imageName 图片名
 */
+(void)navigationItem:(UINavigationItem *)itme andParentRect:(CGRect )parentRect andImageName:(NSString *)imageName;


/**
 根据图片获取图片的主色调
 
 @param image png图片
 @return 返回colol
 */
+(UIColor*)mostColor:(UIImage*)image;

#pragma mark -  颜色转图片
+ (UIImage *)imgColor:(UIColor *)color;

#pragma mark -   颜色转换
+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;

/**
 抖动动画 (左右,上下)
 
 @param objectView id View
 @param xOry x轴,y轴
 @param position 坐标数组  例：@[@(coordinates-10),@(coordinates),@(coordinates+10)] 注意:(coordinates)这个字段必填 否则无效
 @param repeatCount 抖动几次
 @param duration 抖动时间
 */
+(void)interfaceDithering:(UIView *)objectView xOryAxis:(NSString *)xOry positionArray:(NSArray *)position repeatCount:(CGFloat)repeatCount duration:(CFTimeInterval)duration;

/**
 设置NSNumber小数点长度及不能四舍五入
 
 @param number NSNumberClass
 @param length 位数
 @return 相应位数字符串
 */
+(NSString *)numberDecimalLength:(NSNumber *)number length:(NSInteger)length;

@end

#pragma mark - textField类 光标不置顶

@interface MyPublicTextField :UITextField

/** 初始化时光标X轴的间距 */
@property (nonatomic ,assign) CGFloat textRectDx;

/** 初始化时光标Y轴的间距 */
@property (nonatomic ,assign) CGFloat textRectDy;

/** 编辑时光标X轴的间距 */
@property (nonatomic ,assign) CGFloat editingRectDx;

/** 编辑时光标Y轴的间距 */
@property (nonatomic ,assign) CGFloat editingRectDy;


@end


