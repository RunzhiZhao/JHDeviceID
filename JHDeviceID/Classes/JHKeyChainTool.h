//
//  JHKeyChainTool.h
//  JHDeviceID
//
//  Created by Runzhi Zhao on 2018/10/18.
//

#import <Foundation/Foundation.h>

@interface JHKeyChainTool : NSObject

+ (void)saveData:(id)data forKey:(NSString *)key;

+ (id)loadForKey:(NSString *)key;

+ (void)deleteKeyData:(NSString *)key;

@end
