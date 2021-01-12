//
//  YZFileHandle.h
//  DSYMTools
//
//  Created by yanzhen on 2021/1/12.
//  Copyright © 2021 answer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UUIDInfo;
@class ArchiveInfo;
@interface YZFileHandle : NSObject

@property (nonatomic, strong) UUIDInfo *uuid;
@property (nonatomic, strong) ArchiveInfo *archive;

- (instancetype)initWithContentOfFile:(NSString *)file;
- (void)start;
@end

