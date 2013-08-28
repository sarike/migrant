//
//  AppDelegate.h
//  iosapp
//
//  Created by comger on 13-8-23.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsBase.h"
#import "XMPPBase.h"
#import "XMPPFramework.h"



@interface AppDelegate :UIResponder <UIApplicationDelegate,XMPPRosterDelegate>{
    XMPPStream *xmppStream;
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;


- (BOOL)connect;
- (void)disconnect;
@end
