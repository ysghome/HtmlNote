//
//  HTMLElement.h
//  HtmlNote
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple/TFHpple.h"
#import "TFHpple/TFHppleElement.h"
#import "TFHpple/XPathQuery.h"

typedef NS_ENUM(NSInteger , HTMLElementClickType) {
    HTMLElementClickTypeUrl = 1,//超链接
    HTMLElementClickTypeImage,//图片
};

@class HTMLElement;

@protocol HTMLElementDelegate <NSObject>
@optional
/**
 *  点击 图片，链接
 */
- (void)htmlElement:(HTMLElement*)htmlElement withType:(HTMLElementClickType)type;
/**
 *  刷新
 */
- (void)htmlElement:(HTMLElement*)htmlElement refreshAttributed:(NSAttributedString *)attributedText withReplaceRange:(NSRange)range;

@end

@interface HTMLElement : NSObject

- (instancetype)initWithElement:(TFHppleElement *)element;

- (instancetype)initWithElement:(TFHppleElement *)element withDelegate:(id<HTMLElementDelegate>)delegate;

@property (nonatomic, weak) id<HTMLElementDelegate> delegate;

@property (nonatomic, strong) TFHppleElement *element;

@property (nonatomic, strong) NSMutableAttributedString *attributedText;

//图片集合
@property (nonatomic, strong) NSArray *imageArray;
/**
 *  标签 “a”
 */
@property (nonatomic, strong) NSString *tagName;
/**
 *  文字内容
 */
@property (nonatomic, strong) NSString *text;
/**
 *  链接地址显示文字
 */
@property (nonatomic, strong) NSString *content;
/**
 *  默认字体的大小 默认 15
 */
@property (nonatomic, assign) CGFloat fontSize;

//@property (nonatomic, assign) NSInteger length;

#pragma mark - ------------------------------超链接属性------------------------------

/**
 *  链接地址
 */
@property (nonatomic, strong) NSString *href;
/**
 *  超链接颜色
 */
@property (nonatomic, strong) UIColor *color;

@end
