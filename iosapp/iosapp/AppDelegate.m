//
//  AppDelegate.m
//  iosapp
//
//  Created by comger on 13-8-23.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "AppDelegate.h"
#import "Statics.h"
#import "ChatDelegate.h"
#import "MessageDelegate.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize xmppStream;
@synthesize chatDelegate;
@synthesize messageDelegate;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppRosterMemStorage;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    NewsBase *newsbase = [[NewsBase alloc] initWithNibName:@"NewsBase" bundle:nil];
    UINavigationController * newsNav = [[UINavigationController alloc] initWithRootViewController:newsbase];
    
    
    Friends *xmppbase = [[Friends alloc] initWithNibName:@"Friends" bundle:nil];
    UINavigationController * xmppNav = [[UINavigationController alloc] initWithRootViewController:xmppbase];
    
    
    SettingView *settingview = [[SettingView alloc] initWithNibName:@"SettingView" bundle:nil];
    UINavigationController * settingNav = [[UINavigationController alloc] initWithRootViewController:settingview];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             xmppNav,
                                             newsNav,
                                             settingNav,
                                             nil];
     self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[self connect];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setupStream{
    //初始化XMPPStream
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_current_queue()];
    [xmppStream setEnableBackgroundingOnSocket:YES];
    
    
	//xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
    xmppRosterMemStorage = [[XMPPRosterMemoryStorage alloc] init];
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterMemStorage
                                             dispatchQueue:dispatch_get_main_queue()];
	
    
    [xmppRoster activate:xmppStream];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = false;
    xmppRoster.autoFetchRoster = true;
    [xmppRoster fetchRoster];
    
    NSArray *arr= [xmppRosterMemStorage unsortedUsers];
    NSLog(@"arr:%@",arr);
}

-(void)goOnline{
    
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
    
    
}

-(void)goOffline{
    
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    
}

-(BOOL)connect{
    
    [self setupStream];
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"test1@sos360.com" forKey:USERID];
    [defaults setObject:@"111qqq" forKey:PASS];
    
    NSString *userId = @"test1@sos360.com";
    NSString *pass = @"111qqq";
    NSString *server = @"sos360.com";
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (userId == nil || pass == nil) {
        return NO;
    }
    
    //设置用户
    [xmppStream setMyJID:[XMPPJID jidWithString:userId]];
    //设置服务器
    [xmppStream setHostName:server];
    
    //密码
    password = pass;
    
	NSError *error = nil;
    /**
	if (![xmppStream connect:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		NSLog(@"Error connecting: %@", error);
        
		return NO;
	}
     **/
    
    if(![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		NSLog(@"Error connecting: %@", error);
        
		return NO;
    }
    
    return YES;
    
}

-(void)disconnect{
    [self goOffline];
    [xmppStream disconnect];
    
}

//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    isOpen = YES;
    NSError *error = nil;
    //验证密码
    [[self xmppStream] authenticateWithPassword:password error:&error];
    
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    [self goOnline];
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"message = %@", message);
    //消息接收到的时间
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:msg forKey:@"msg"];
    [dict setObject:from forKey:@"sender"];
    //消息接收到的时间
    [dict setObject:[Statics getCurrentTime] forKey:@"time"];
    
    //消息委托(这个后面讲)
    [messageDelegate newMessageReceived:dict];
    
    
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
   
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:userId]) {
        
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
            //用户列表委托(后面讲)
            [chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, [xmppStream hostName]]];
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托(后面讲)
            [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, [xmppStream hostName]]];
        }
        
    }
    
}

/**
    获取用户名单
 **/
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    NSLog(@"iq:%@",iq);
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
            NSArray *items = [query children];
            for (NSXMLElement *item in items) {
                NSString *jid = [item attributeStringValueForName:@"jid"];
                XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
                NSLog(@"%@",xmppJID);
            }
        }
    }
    return YES;
}

- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender  {
    NSLog(@"xmppRosterDidEndPopulating:%@",sender);
}

-(void)xmppRosterDidPopulate:(XMPPRosterMemoryStorage *)sender {
    NSLog(@"users: %@", [sender unsortedUsers]);
    // My subscribed users do print out
}

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence{
    NSLog(@"didReceiveBuddyRequest:%@",presence);
}
@end
