//
//  TFHppleElement.m
//  Hpple
//
//  Created by Geoffrey Grosenbach on 1/31/09.
//
//  Copyright (c) 2009 Topfunky Corporation, http://topfunky.com
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TFHppleElement.h"

static NSString *const TFHppleNodeContentKey = @"nodeContent";
static NSString *const TFHppleNodeNameKey = @"nodeName";
static NSString *const TFHppleNodeChildrenKey = @"nodeChildArray";
static NSString *const TFHppleNodeAttributeArrayKey = @"nodeAttributeArray";
static NSString *const TFHppleNodeAttributeNameKey = @"attributeName";

static NSString *const TFHppleTextNodeName = @"text";

static NSString *const TFHppleNodeAttributeContentKey = @"attributeContent";
static NSString *const TFHppleNodeChildArrayKey = @"nodeChildArray";
static NSString *const TFHppleNodeContentsKey = @"nodeContents";

@interface TFHppleElement ()
@property (nonatomic, unsafe_unretained, readwrite) TFHppleElement *parent;
@end

@implementation TFHppleElement
@synthesize parent;

- (id)initWithNode:(NSDictionary *)theNode {
    if (!(self = [super init]))
        return nil;

    node = theNode;

    return self;
}

+ (TFHppleElement *)hppleElementWithNode:(NSDictionary *)theNode {
    return [[[self class] alloc] initWithNode:theNode];
}

#pragma mark -

- (NSString *)raw {
    return [node objectForKey:@"raw"];
}

- (NSString *)content {
    return [node objectForKey:TFHppleNodeContentKey];
}

- (NSArray *)contents {
    return [node objectForKey:TFHppleNodeContentsKey];
}

- (NSString *)tagName {
    return [node objectForKey:TFHppleNodeNameKey];
}

- (TFHppleElement *)firstChild {
    NSArray *children = self.children;
    if (children.count)
        return [children objectAtIndex:0];
    return nil;
}

- (NSDictionary *)attributes {
    NSMutableDictionary * translatedAttributes = [NSMutableDictionary dictionary];
    for (NSDictionary * attributeDict in [node objectForKey:TFHppleNodeAttributeArrayKey]) {
        if ([attributeDict objectForKey:TFHppleNodeContentKey] && [attributeDict objectForKey:TFHppleNodeAttributeNameKey]) {
            [translatedAttributes setObject:[attributeDict objectForKey:TFHppleNodeContentKey]
                                     forKey:[attributeDict objectForKey:TFHppleNodeAttributeNameKey]];
        }
    }
    return translatedAttributes;
}

- (NSDictionary *)attributes2 {
    NSMutableDictionary *translatedAttributes = [NSMutableDictionary dictionary];
    for (NSDictionary *attributeDict in [node objectForKey:TFHppleNodeAttributeArrayKey]) {
        [translatedAttributes setObject:[attributeDict objectForKey:TFHppleNodeAttributeContentKey]
                                 forKey:[attributeDict objectForKey:TFHppleNodeAttributeNameKey]];
    }
    return translatedAttributes;
}

- (NSString *)objectForKey:(NSString *)theKey {
    return [[self attributes] objectForKey:theKey];
}

- (id)description {
    return [node description];
}

- (BOOL)hasChildren {
    NSArray *childs = [node objectForKey:TFHppleNodeChildArrayKey];

    if (childs) {
        return YES;
    }

    return NO;
}

- (NSArray *)children {
    NSMutableArray *children = [NSMutableArray array];
    for (NSDictionary *child in [node objectForKey:TFHppleNodeChildrenKey]) {
        TFHppleElement *element = [TFHppleElement hppleElementWithNode:child];
        element.parent = self;
        [children addObject:element];
    }
    return children;
}

- (BOOL)isTextNode {
    // we must distinguish between real text nodes and standard nodes with tha name "text" (<text>)
    // real text nodes must have content
    if ([self.tagName isEqualToString:TFHppleTextNodeName] && (self.content))
        return YES;
    else
        return NO;
}

- (NSArray *)childrenWithTagName:(NSString *)tagName {
    NSMutableArray *matches = [NSMutableArray array];

    for (TFHppleElement *child in self.children) {
        if ([child.tagName isEqualToString:tagName])
            [matches addObject:child];
    }

    return matches;
}

- (TFHppleElement *)firstChildWithTagName:(NSString *)tagName {
    for (TFHppleElement *child in self.children) {
        if ([child.tagName isEqualToString:tagName])
            return child;
    }

    return nil;
}

- (NSArray *)childrenWithClassName:(NSString *)className {
    NSMutableArray *matches = [NSMutableArray array];

    for (TFHppleElement *child in self.children) {
        if ([[child objectForKey:@"class"] isEqualToString:className])
            [matches addObject:child];
    }

    return matches;
}

- (TFHppleElement *)firstChildWithClassName:(NSString *)className {
    for (TFHppleElement *child in self.children) {
        if ([[child objectForKey:@"class"] isEqualToString:className])
            return child;
    }

    return nil;
}

- (TFHppleElement *)firstTextChild;
{
    for (TFHppleElement *child in self.children) {
        if ([child isTextNode])
            return child;
    }

    return [self firstChildWithTagName:TFHppleTextNodeName];
}

- (NSString *)text {
    return self.firstTextChild.content;
}

@end
