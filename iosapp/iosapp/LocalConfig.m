//
//  LocalConfig.m
//  iosmigrant
//
//  Created by comger on 13-7-24.
//
//

#import "LocalConfig.h"

@implementation LocalConfig


static LocalConfig *instance=nil;

-(NSString *)shareconfig:(NSString *)name{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSLog(@"userdefault:%@",setting);
    //return [setting objectForKey:name];
    return [setting objectForKey:name];
}

-(void)setconfig:(NSString *)key :(NSString *)value{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
//    [setting removeObjectForKey:key];
    [setting setObject:value forKey:key];
    [setting synchronize];
}

+(LocalConfig *)Instance{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}
@end
