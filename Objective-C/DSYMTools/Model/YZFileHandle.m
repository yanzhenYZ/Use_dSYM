//
//  YZFileHandle.m
//  DSYMTools
//
//  Created by yanzhen on 2021/1/12.
//  Copyright © 2021 answer. All rights reserved.
//

#import "YZFileHandle.h"

@interface YZFileHandle ()
@property (nonatomic, copy) NSString *content;
@end

@implementation YZFileHandle

-(instancetype)initWithContentOfFile:(NSString *)file {
    self = [super init];
    if (self) {
        NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
        NSArray *strings = [content componentsSeparatedByString:@"\n"];
        if (strings.count <= 0) {
            NSLog(@"XXX ___ :%@ is not a crash file", file);
        } else {
            [self dealWithCrashStrings:strings];
        }
    }
    return self;
}

- (void)dealWithCrashStrings:(NSArray<NSString *> *)strings {
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:strings.count];
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj containsString:@"Binary Images:"]) {
            *stop = YES;
        } else {
            NSString *result = [self getResult:obj];
            [results addObject:result];
        }
    }];
}

- (NSString *)getResult:(NSString *)str {
    NSLog(@"xx:%@", str);
    return @"";
}
@end
