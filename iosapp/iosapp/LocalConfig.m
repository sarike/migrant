//
//  LocalConfig.m
//  iosmigrant
//
//  Created by comger on 13-7-24.
//
//

#import "LocalConfig.h"

@implementation LocalConfig

static NSString * filename;
static LocalConfig *instance;

-(NSString *)shareconfig:(NSString *)name{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"%@",data);
    return [data valueForKey:name];
}

-(void)setconfig:(NSString *)key :(NSString *)value{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    [data setValue:value forKey:key];
    [data writeToFile:filename atomically:YES];
    
}

+(LocalConfig *)Instance{
    @synchronized(self)
    {
        if(nil == instance)
        {
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *plistPath1 = [paths objectAtIndex:0];
            
            //得到完整的文件名
            filename=[plistPath1 stringByAppendingPathComponent:@"localconfig.plist"];
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
