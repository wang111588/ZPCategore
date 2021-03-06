/*******************************************************************************
 Copyright (C), 2013-2015, ZP
 File name: UIBarButtonItem+ZPAddition.h
 Author: Joy (曾 平)
 E-mail: joykerl@yahoo.com
 Description:
 分类扩展
 History:
 2015-05-11
 Copyright information:
 Copyright (c) 2015年 ZP. All rights reserved.
 ********************************************************************************/

#import "UIBarButtonItem+ZPAddition.h"

@implementation UIBarButtonItem (ZPAddition)



/**
 *  创建item
 *
 *  @param norimage 默认状态的图片
 *  @param higImage 高亮状态的图片
 *  @param title    标题
 *
 *  @return item
 */
- (UIBarButtonItem *)initWithNorImage:(NSString *)norimage higImage:(NSString *)higImage title:(NSString *)title target:(id)target action:(SEL)action
{
    // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    // 2.设置按钮的默认图片和高亮图片
    if (norimage != nil &&
        ![norimage isEqualToString:@""]) {
        
        [btn setImage:[UIImage imageNamed:norimage] forState:UIControlStateNormal];
    }
    if (higImage != nil &&
        ![higImage isEqualToString:@""]) {
        
        [btn setImage:[UIImage imageNamed:higImage] forState:UIControlStateHighlighted];
    }
    // 设置标题
    [btn setTitle:title forState:UIControlStateNormal];
    
    // 3.监听按钮的点击事件
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 4.设置按钮的frame
    // 可以调用控件的sizeToFit方法来自动调整控件的大小
    [btn sizeToFit];
    
    // 5.根据按钮创建BarButtonItem
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (instancetype)itemWithNorImage:(NSString *)norimage higImage:(NSString *)higImage title:(NSString *)title target:(id)target action:(SEL)action
{
    return [[self alloc] initWithNorImage:norimage higImage:higImage title:title target:target action:action];
}

@end
