//
//  LocalConfig.h
//  iosmigrant
//
//  Created by comger on 13-7-24.
//
//

#import <Foundation/Foundation.h>

@interface LocalConfig : NSObject
-(NSString *)shareconfig:(NSString *)name;
-(void)setconfig:(NSString *)key:(NSString *)value;
+(LocalConfig *)Instance;
+(id)allocWithZone:(NSZone *)zone;
@end
