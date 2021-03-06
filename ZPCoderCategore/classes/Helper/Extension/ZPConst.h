/*******************************************************************************
 Copyright (C), 2013-2015, ZP
 File name: ZPConst.h
 Author: Joy (曾 平)
 E-mail: joykerl@yahoo.com
 Description:
 常用常量
 History:
 2015-05-11
 Copyright information:
 Copyright (c) 2015年 ZP. All rights reserved.
 ********************************************************************************/

#ifndef __ZPConst__H__
#define __ZPConst__H__

#ifdef DEBUG  // 调试状态
// 打开LOG功能
#define ZPLog(...) NZPog(__VA_ARGS__)
// 打开断言功能
#define ZPAssert(condition, desc) NSAssert(condition, @"\n报错文件：%@\n报错行数：第%d行\n报错方法：%s\n错误描述：%@", [NSString stringWithUTF8String:__FILE__], __LINE__,  __FUNCTION__, desc)
#define ZPAssertParamNotNil(param) ZPAssert(param, [[NSString stringWithFormat:@#param] stringByAppendingString:@"参数不能为nil"])
#else // 发布状态
// 关闭LOG功能
#define ZPLog(...)
// 关闭断言功能
#define ZPAssert(condition, desc)
#define ZPAssertParamNotNil(param)
#endif

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS6_OR_PRIOR   ( [[[UIDevice currentDevice] systemVersion] compare:@"6.9"] != NSOrderedDescending )
#define IOS6_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS6   ( [[[UIDevice currentDevice] systemVersion] rangeOfString:@"6."].length > 0 )

// 判断是否为iphone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

// 应用程序的frame
#define APPLICATIONFRAME (IOS7_OR_LATER ? [[UIScreen mainScreen] bounds]: [[UIScreen mainScreen] applicationFrame])

// RGB转换成UIColor
#define ZPColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define ZPRandomColor ZPColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//十六进制转换成UIColor
#define ZPHex2Rgb(hexValue) [UIColor colorWithRed:((hexValue & 0xFF0000) >> 16)/255.0 green:((hexValue & 0xFF00) >> 8)/255.0 blue:((hexValue & 0xFF))/255.0 alpha:1.0]

#endif
