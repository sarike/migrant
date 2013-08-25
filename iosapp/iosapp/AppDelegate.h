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



@interface AppDelegate :UIResponder <UIApplicationDelegate>{
    XMPPStream *xmppStream;
    NSString *password;
	BOOL isXmppConnected;
}

@property(nonatomic, retain)id chatDelegate;
@property(nonatomic, retain)id messageDelegate;

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;


-(BOOL)connect;
-(void)disconnect;

-(void)setupStream;
-(void)getOnline;
-(void)getOffline;


@end
