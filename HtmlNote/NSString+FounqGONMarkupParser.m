//
//  NSString+FounqGONMarkupParser.m
//  FounqGameForum
//
//  Created by ysghome on 9/23/16.
//  Copyright © 2016 com.fangqu. All rights reserved.
//

#import "NSString+FounqGONMarkupParser.h"

@implementation NSString (FounqGONMarkupParser)

- (NSMutableAttributedString *)createAttributedString {
    return [[GONMarkupParserManager sharedParser] attributedStringFromString:self error:nil];
}

@end
