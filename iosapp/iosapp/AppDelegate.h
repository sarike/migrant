//
//  AppDelegate.h
//  iosapp
//
//  Created by comger on 13-8-23.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"

#import "NewsBase.h"
#import "Friends.h"
#import "SettingView.h"




@interface AppDelegate :UIResponder <UIApplicationDelegate,XMPPRosterMemoryStorageDelegate>{
    
    XMPPStream *xmppStream;
    NSString *password;  //密码
    BOOL isOpen;  //xmppStream是否开着
    
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPRosterMemoryStorage *xmppRosterMemStorage;
    
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;


@property(nonatomic, readonly)XMPPStream *xmppStream;
@property(nonatomic, readonly)XMPPRoster *xmppRoster;
@property(nonatomic, readonly)XMPPRosterCoreDataStorage *xmppRosterStorage;
@property(nonatomic, readonly)XMPPRosterMemoryStorage *xmppRosterMemStorage;

@property(nonatomic, retain)id chatDelegate;
@property(nonatomic, retain)id messageDelegate;



//是否连接
-(BOOL)connect;
//断开连接
-(void)disconnect;

//设置XMPPStream
-(void)setupStream;
//上线
-(void)goOnline;
//下线
-(void)goOffline;

@end
