//
//  JHDeviceID.m
//  JHDeviceID
//
//  Created by Runzhi Zhao on 2018/10/18.
//

#import "JHDeviceID.h"
#import "JHKeyChainTool.h"

@implementation JHDeviceID

static NSString * const kDeviceKey = @"kDeviceKey";

+ (NSString *)getDeviceID {
    // 读取keyChain存储的UUID
    NSString * strUUID = (NSString *)[JHKeyChainTool loadForKey:kDeviceKey];
    // 首次运行生成一个UUID并用keyChain存储
    if ([strUUID isEqualToString: @""] || !strUUID) {
        // 生成uuid
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        // 将该uuid用keychain存储
        [JHKeyChainTool saveData: strUUID forKey:kDeviceKey];
    }
    return strUUID;
}

@end
