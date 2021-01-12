//
//  YZFileHandle.h
//  DSYMTools
//
//  Created by yanzhen on 2021/1/12.
//  Copyright © 2021 answer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZFileHandle : NSObject
- (instancetype)initWithContentOfFile:(NSString *)file;
@end

