//
//  YZFileHandle.m
//  DSYMTools
//
//  Created by yanzhen on 2021/1/12.
//  Copyright © 2021 answer. All rights reserved.
//

#import "YZFileHandle.h"
#import "ArchiveInfo.h"
#import "UUIDInfo.h"

@interface YZFileHandle ()
@property (nonatomic, copy) NSString *file;
@end

@implementation YZFileHandle

-(instancetype)initWithContentOfFile:(NSString *)file {
    self = [super init];
    if (self) {
        _file = file;
        
    }
    return self;
}

- (void)start {
    NSString *content = [NSString stringWithContentsOfFile:_file encoding:NSUTF8StringEncoding error:nil];
    NSArray *strings = [content componentsSeparatedByString:@"\n"];
    if (strings.count <= 0) {
        NSLog(@"XXX ___ :%@ is not a crash file", _file);
    } else {
        [self dealWithCrashStrings:strings];
    }
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
    //NSLog(@"%@", results);
    NSString *result = [results componentsJoinedByString:@""];
    NSLog(@"%@", result);
}

- (NSString *)getResult:(NSString *)str {
    NSArray *contents = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t"]];
    NSMutableArray<NSString *> *analyse = [NSMutableArray arrayWithArray:contents];
    [analyse removeObject:@""];
    if (analyse.count > 0) {
        NSString *index = analyse.firstObject;
        if ([index isEqualToString:@"0"] || index.intValue > 0) {
            //NSLog(@"xx:%@:%@", analyse[2], analyse[5]);
            NSString *result = [self getOri:analyse[2] index:analyse[5]];
            //NSLog(@"1234__:%@  %@", index, result);
            return result ? [index stringByAppendingFormat:@"  %@", result] : @"\n";
        }
    }
//    NSLog(@"__:%@", analyse);
    return str;
}

- (NSString *)getOri:(NSString *)error index:(NSString *)index {
    NSString *result;
    if (![error hasPrefix:@"0x"] && ![error hasPrefix:@"0X"]) {
        NSString *memoryAddressToTen = [self sixtyToTen:error];
        NSInteger memoryAddressTenInt = memoryAddressToTen.integerValue;
        
        NSInteger slideAddressTenInt = memoryAddressTenInt - error.integerValue;
        NSString *slideAddressSixTyStr = [self tenToSixTy:slideAddressTenInt];
        
        NSString *commandString = [NSString stringWithFormat:@"xcrun atos -arch %@ -o \"%@\" -l %@ %@", self.uuid.arch, self.uuid.executableFilePath, slideAddressSixTyStr, error];
        //NSLog(@"xxx__%@", commandString);//0x0000000102d1bfe8  1376232
        result = [self runCommand:commandString];
        
    }else{
        NSString *memoryAddressToTen = [self sixtyToTen:error];
        NSInteger memoryAddressTenInt = memoryAddressToTen.integerValue + index.integerValue;
        NSString *slideAddressSixTyStr = [self tenToSixTy:memoryAddressTenInt];
        
        NSString *commandString = [NSString stringWithFormat:@"xcrun atos -arch %@ -o \"%@\" -l %@ %@", self.uuid.arch, self.uuid.executableFilePath, error, slideAddressSixTyStr];
        result = [self runCommand:commandString];
    }
    return result;
}

- (NSString *)runCommand:(NSString *)commandToRun
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    
    NSArray *arguments = @[@"-c",
            [NSString stringWithFormat:@"%@", commandToRun]];
//    NSLog(@"run command:%@", commandToRun);
    [task setArguments:arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}

-(NSString *)sixtyToTen:(NSString *)sixTyStr{
    NSString *temp10 = [NSString stringWithFormat:@"%lu",strtoul([sixTyStr UTF8String],0,16)];
    return temp10;
}
//2个空格 。。。 6个空格

-(NSString *)tenToSixTy:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}
@end
