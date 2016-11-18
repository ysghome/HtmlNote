//
//  HTMLElement.m
//  HtmlNote
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HTMLElement.h"
#import "YYKit.h"
#import "NSString+FounqGONMarkupParser.h"

//论坛点击消息通知
NSString *const FORUM_CLICK_HTML_NOTIFI_NAME = @"clickHtmlNoteNotification";
//刷新图片大小
NSString *const FORUM_REFRESH_HTML_NOTIFI_NAME =@"refreshHtmlNoteNotification";

@interface HTMLElement ()

@property (nonatomic, assign) NSInteger length;

@end

@implementation HTMLElement

@synthesize tagName = _tagName;
@synthesize text = _text;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithElement:(TFHppleElement *)element withDelegate:(id<HTMLElementDelegate>)delegate
{
    self = [super init];
    if (self) {
        NSAssert(element != nil, @"element cannot be nil");
        _element = element;
        _delegate = delegate;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickHtmlNotification:) name:FORUM_CLICK_HTML_NOTIFI_NAME object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHtmlNotification:) name:FORUM_REFRESH_HTML_NOTIFI_NAME object:nil];
        [self _setupAttribute];
    }
    return self;
}

- (instancetype)initWithElement:(TFHppleElement *)element
{
    self = [super init];
    if (self) {
        NSAssert(element != nil, @"element cannot be nil");
        _element = element;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickHtmlNotification:) name:FORUM_CLICK_HTML_NOTIFI_NAME object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHtmlNotification:) name:FORUM_REFRESH_HTML_NOTIFI_NAME object:nil];
        [self _setupAttribute];
    }
    return self;
}

/**
 *  系统有新的消息
 *
 *  @param notification <#notification description#>
 */
- (void)clickHtmlNotification:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    HTMLElementClickType type = [object[@"type"] integerValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(htmlElement:withType:)]) {
        [self.delegate htmlElement:self withType:type];
    }
}

- (void)refreshHtmlNotification:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    NSAttributedString *attributedText = object[@"attributedText"];
    NSRange range = [object[@"replaceRange"] rangeValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(htmlElement:refreshAttributed:withReplaceRange:)]) {
        [self.delegate htmlElement:self refreshAttributed:attributedText withReplaceRange:range];
    }
}

/**
 配置属性
 */
- (void)_setupAttribute {
    _fontSize = 15;
    [self text];
    [self tagName];
}

- (NSString *)text {
    if (!_text) {
        _text = _element.text;
    }
    return _text;
}

- (NSString *)tagName {
    if (!_tagName) {
        _tagName = _element.tagName;
    }
    return _tagName;
}

- (NSString *)content {
    if (!_content) {
        _content = _element.content;
    }
    return _content;
}

- (NSString *)href {
    if (!_href) {
        _href = _element.attributes[@"href"];
    }
    return _href;
}

- (NSMutableAttributedString *)attributedText {
    if (!_attributedText) {
        _attributedText = [NSMutableAttributedString new];
        TFHppleElement *element = _element.firstChild;
        if (_element.children.count == 1 && element.children.count == 0) {
            NSLog(@"_tagName is %@",self.tagName);
            NSLog(@"self text is %@",self.text);
            [self childrenAattributedText];
            NSLog(@"_length is %@",@(_length));
        } else {
            for (TFHppleElement *element in _element.children) {
                HTMLElement *hElement = [[HTMLElement alloc] initWithElement:element];
                hElement.length = _length;
                hElement.imageArray = self.imageArray;
                _length += hElement.attributedText.length;
                [_attributedText appendAttributedString:hElement.attributedText];
                NSLog(@"_length is %@",@(_length));
            }
            NSLog(@"children _tagName is %@",self.tagName);
            NSLog(@"children self text is %@",self.text);
            
            if ([self.tagName isEqualToString:@"a"]) {
                NSLog(@"进入超链接");
            } else if ([self.tagName isEqualToString:@"br"]) {
                [_attributedText appendAttributedString:[self padding]];
            } else if ([self.tagName isEqualToString:@"div"]) {
                NSLog(@"进入div");
                NSLog(@"_element.children is %@",_element.children);
            } else if ([self.tagName isEqualToString:@"img"]) {
                NSLog(@"进入图片");
            } else if ([self.tagName isEqualToString:@"audio"]) {
                NSLog(@"进入声音");
            } else if ([self.tagName isEqualToString:@"video"]) {
                NSLog(@"进入视频");
            } else if ([self.tagName isEqualToString:@"font"]) {
                NSLog(@"进入字体设置");
                [_attributedText setFont:[UIFont systemFontOfSize:self.fontSize]];
                [_attributedText setColor:[self fontColor]];
            } else if ([self.tagName isEqualToString:@"p"]) {
                [_attributedText insertAttributedString:[self padding] atIndex:0];
                [_attributedText appendAttributedString:[self padding]];
            } else if ([self.tagName containsString:@"h"] && self.tagName.length == 2) {
                [_attributedText insertAttributedString:[self padding] atIndex:0];
                [_attributedText appendAttributedString:[self padding]];
            } else if (self.text) {
                NSMutableAttributedString *contentAttributed = [self.text createAttributedString];
                [contentAttributed setFont:[UIFont systemFontOfSize:self.fontSize]];
                [_attributedText appendAttributedString:contentAttributed];
            } else if (self.content) {//纯文字，不带标签
                NSMutableAttributedString *contentAttributed = [self.content createAttributedString];
                [contentAttributed setFont:[UIFont systemFontOfSize:self.fontSize]];
                [_attributedText appendAttributedString:contentAttributed];
            } else {
                NSLog(@"其他的情况。。。");
            }
        }
        [_attributedText setLineSpacing:10];
        [_attributedText setMinimumLineHeight:10];
    }
    return _attributedText;
}

- (NSMutableAttributedString *)childrenAattributedText{
    NSLog(@"_tagName is %@",self.tagName);
    NSString *text = nil;
    @weakify(self);
    if (_element.children.count == 1) {//可以
        if ([self.tagName isEqualToString:@"a"]) {
            NSLog(@"进入超链接");
            NSMutableAttributedString *link = [[NSMutableAttributedString alloc] initWithString:self.text];
            link.font = [UIFont systemFontOfSize:self.fontSize];
            link.underlineStyle = NSUnderlineStyleSingle;
            
            NSString *href = _element.attributes[@"href"];
            [link setTextHighlightRange:link.rangeOfAll
                                  color:[self fontColor]
                        backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                              tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                                  NSLog(@"点击超链接。。。%@",[text.string substringWithRange:range]);
                                  NSMutableDictionary *bodys = [NSMutableDictionary dictionary];
                                  [bodys setObject:@(HTMLElementClickTypeUrl) forKey:@"type"];
                                  [bodys setObject:href forKey:@"href"];
                                  [[NSNotificationCenter defaultCenter] postNotificationName:FORUM_CLICK_HTML_NOTIFI_NAME object:bodys];
                              }];
            
            [_attributedText appendAttributedString:link];
        } else if ([self.tagName isEqualToString:@"br"]) {
            [_attributedText appendAttributedString:[self padding]];
        } else if ([self.tagName isEqualToString:@"div"]) {
            NSLog(@"进入div");
            TFHppleElement *element = _element.firstChild;//添加图片
            NSLog(@"_element.children is %@",element);
            if ([element.tagName isEqualToString:@"img"]) {//图片
                NSLog(@"进入图片");
                NSString *urlString = element.attributes[@"src"];
                NSString *type = @"-h";
                NSString *url = [NSString stringWithFormat:@"%@%@", urlString, type];
                
                NSArray *imageArray = self.imageArray;
                YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
                [imageView setUserInteractionEnabled:YES];
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id _Nonnull sender) {
                        NSLog(@"点击图片");
                    NSMutableDictionary *bodys = [NSMutableDictionary dictionary];
                    [bodys setObject:@(HTMLElementClickTypeImage) forKey:@"type"];
                    [bodys setObject:imageArray forKey:@"imageArray"];
                    [bodys setObject:urlString forKey:@"src"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:FORUM_CLICK_HTML_NOTIFI_NAME object:bodys];
                }];
                [imageView addGestureRecognizer:tapGesture];
                
                UIImage *image = [self imageWithPart:urlString];
                
                if (image) {
                    imageView.image = image;
                } else {
                    NSRange replaceRange = NSMakeRange(self.length, 1);
                    __block YYAnimatedImageView *blockImageView = imageView;
                    [imageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"founq_posts_logo"] options:YYWebImageOptionAvoidSetImage
                                    completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                        //更新图片大小
                                        [blockImageView setImage:image];
                                        [blockImageView setSize:image.size];
                                        NSMutableAttributedString *attachText2 = [NSMutableAttributedString attachmentStringWithContent:blockImageView
                                                                                                                            contentMode:UIViewContentModeScaleAspectFit
                                                                                                                         attachmentSize:blockImageView.size
                                                                                                                            alignToFont:[UIFont systemFontOfSize:weak_self.fontSize]                                                                                                                              alignment:YYTextVerticalAlignmentCenter];
                                        [weak_self.attributedText replaceCharactersInRange:replaceRange withAttributedString:attachText2];
                                        
                                        NSMutableDictionary *bodys = [NSMutableDictionary dictionary];
                                        [bodys setObject:attachText2 forKey:@"attributedText"];
                                        [bodys setObject:[NSValue valueWithRange:replaceRange] forKey:@"replaceRange"];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:FORUM_REFRESH_HTML_NOTIFI_NAME object:bodys];
                                    }];
                }
                if (!image) {
                    image = [UIImage imageNamed:@"founq_posts_logo"];
                }
                [imageView setSize:image.size];
                NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeLeft attachmentSize:imageView.size alignToFont:[UIFont systemFontOfSize:self.fontSize] alignment:YYTextVerticalAlignmentCenter];
                [_attributedText appendAttributedString:attachText];
            } else if ([element.tagName isEqualToString:@"audio"]) {
                NSLog(@"进入声音");
            } else if ([element.tagName isEqualToString:@"video"]) {
                NSLog(@"进入视频");
            }
        } else if ([self.tagName isEqualToString:@"img"]) {
            NSLog(@"进入图片");
        } else if ([self.tagName isEqualToString:@"audio"]) {
            NSLog(@"进入声音");
        } else if ([self.tagName isEqualToString:@"video"]) {
            NSLog(@"进入视频");
        } else if ([self.tagName isEqualToString:@"font"]) {
            NSLog(@"进入字体设置");
            if (self.text) {
                text = [NSString stringWithFormat:@"<%@>%@<%@/>",self.tagName,self.text,self.tagName];
                NSMutableAttributedString *contentAttributed = [text createAttributedString];
                //获取字体大小，字体颜色
                [contentAttributed setFont:[UIFont systemFontOfSize:self.fontSize]];
                [contentAttributed setColor:[self fontColor]];
                [_attributedText appendAttributedString:contentAttributed];
            } else if (self.content){
                text = [NSString stringWithFormat:@"<%@>%@<%@/>",self.tagName,self.content,self.tagName];
                NSMutableAttributedString *contentAttributed = [text createAttributedString];
                //获取字体大小，字体颜色
                [contentAttributed setFont:[UIFont systemFontOfSize:self.fontSize]];
                [contentAttributed setColor:[self fontColor]];
                [_attributedText appendAttributedString:contentAttributed];
            }
        } else if (self.text) {
            BOOL paragraph = NO;//是否是段落
            if ([self.tagName isEqualToString:@"p"]) {
                paragraph = YES;
            } else if ([self.tagName containsString:@"h"] && self.tagName.length == 2) {
                paragraph = YES;
            }
            if (paragraph) {
                text = self.text;
                NSMutableAttributedString *contentAttributed = [text createAttributedString];
                [contentAttributed setFont:[UIFont systemFontOfSize:self.fontSize]];
                [contentAttributed insertAttributedString:[self padding] atIndex:0];
                [contentAttributed appendAttributedString:[self padding]];
                [_attributedText appendAttributedString:contentAttributed];
            } else {
                text = _element.raw;
                NSMutableAttributedString *contentAttributed = [text createAttributedString];
                [contentAttributed setFont:[UIFont systemFontOfSize:self.fontSize]];
                if ([self.tagName isEqualToString:@"b"]) {//加粗标签
                    [contentAttributed setFont:[UIFont boldSystemFontOfSize:self.fontSize]];
                }
                [_attributedText appendAttributedString:contentAttributed];
            }
        } else if (self.content) {//纯文字，不带标签
            NSMutableAttributedString *contentAttributed = [self.content createAttributedString];
            [contentAttributed setFont:[UIFont systemFontOfSize:self.fontSize]];
            [_attributedText appendAttributedString:contentAttributed];
        } else {//文字为空的时候，但是还有子标签。
            text = _element.raw;
            NSMutableAttributedString *contentAttributed = [text createAttributedString];
            [contentAttributed setFont:[UIFont systemFontOfSize:self.fontSize]];
            [_attributedText appendAttributedString:contentAttributed];
            if ([self.tagName isEqualToString:@"b"]) {//加粗标签
                NSLog(@"加粗标签。。。");
            }
            NSLog(@"其他的情况。。。");
        }
    }
    _length +=_attributedText.length;
    return _attributedText;
}

- (UIImage *)imageWithPart:(NSString *)urlPart {
    NSString *url = [NSString stringWithFormat:@"%@%@", urlPart, @"-h"];
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    UIImage *imageFromMemory = nil;
    if (manager.cache) {
        imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:[NSURL URLWithString:url]] withType:YYImageCacheTypeAll];
    }
    return imageFromMemory;
}

//获取字体颜色
- (UIColor *)fontColor{
    if (_element.attributes[@"color"]) {
        return [UIColor colorWithHexString:_element.attributes[@"color"]];
    }
    if ([self.tagName isEqualToString:@"a"]) {
        return [UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000];
    }
    return [UIColor blackColor];
}

- (CGFloat)fontSize {
    if (_element.attributes[@"font-size"]) {
        NSString *font = _element.attributes[@"font-size"];
        if ([font containsString:@"px"]) {
            font = [font stringByReplacingOccurrencesOfString:@"px" withString:@""];
        }
        CGFloat size= [font floatValue]/(96.0/72.0);
        return size;
    }
    //h1-h6
    if ([self.tagName containsString:@"h"] && self.tagName.length == 2) {
        NSInteger size = [[self.tagName substringWithRange:NSMakeRange(self.tagName.length - 1, 1)] integerValue];
        if (size< 1 || size > 6) {
            size = 3;
        }
        switch (size) {
            case 1:{
                _fontSize = 16;
            } break;
            case 2:{
                _fontSize = 15;
            } break;
            case 3:{
                _fontSize = 14;
            } break;
            case 4:{
                _fontSize = 13;
            } break;
            case 5:{
                _fontSize = 12;
            } break;
            case 6:{
                _fontSize = 11;
            } break;
            default:
                break;
        }
    }
    return _fontSize;
}

//添加换行
- (NSAttributedString *)padding {
    NSMutableAttributedString *pad = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    pad.font = [UIFont systemFontOfSize:4];
    return pad;
}

@end
