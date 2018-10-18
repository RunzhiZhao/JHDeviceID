//
//  JHKeyChainTool.m
//  JHDeviceID
//
//  Created by Runzhi Zhao on 2018/10/18.
//

#import "JHKeyChainTool.h"

@implementation JHKeyChainTool

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)key {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            key, (id)kSecAttrService,
            key, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible, nil];
}

+ (void)saveData:(id)data forKey:(NSString *)key {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)loadForKey:(NSString *)key {
    
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"存储失败，key-- %@  exception-- %@", key, e);
        } @finally {
        }
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return ret;
}

+ (void)deleteKeyData:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}


@end
