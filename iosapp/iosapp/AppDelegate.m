//
//  AppDelegate.m
//  iosapp
//
//  Created by comger on 13-8-23.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "AppDelegate.h"
#import "ChatDelegate.h"
#import "MessageDelegate.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize xmppStream;
@synthesize chatDelegate;
@synthesize messageDelegate;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppMessageArchiving;
@synthesize xmppMessageArchivingStorage;
@synthesize unReadMsg;

//在应用程序启动后，要执行的委托调用。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupStream];
    
    unReadMsg = [[NSMutableDictionary alloc] initWithCapacity:0];
    
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

//在应用程序将要由活动状态切换到非活动状态时候，要执行的委托调用，如 按下 home 按钮，返回主屏幕，或全屏之间切换应用程序等。
- (void)applicationWillResignActive:(UIApplication *)application
{
    //[self disconnect];
}

//在应用程序已进入后台程序时，要执行的委托调用。
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

//在应用程序将要进入前台时(被激活)，要执行的委托调用，刚好与 applicationWillResignActive 方法相对应。
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//在应用程序已被激活后，要执行的委托调用，刚好与  applicationDidEnterBackground 方法相对应。
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[self connect];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}



-(void)setupStream{
    //初始化XMPPStream
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_current_queue()];
    [xmppStream setEnableBackgroundingOnSocket:YES];
    
    //好友处理
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];

    [xmppRoster activate:xmppStream];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    //消息处理
    xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingStorage];
    [xmppMessageArchiving setClientSideMessageArchivingOnly:YES];
    
    [xmppMessageArchiving activate:xmppStream];
    [xmppMessageArchiving addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
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
//    [[LocalConfig Instance] setconfig:USERID :@"kpages@sos360.com"];
//    [[LocalConfig Instance] setconfig:PASS :@"111qqq"];
    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults setObject:@"kpages@sos360.com" forKey:USERID];
    //[defaults setObject:@"111qqq" forKey:PASS];
    
    //NSString *userId = @"kpages@sos360.com";
    //NSString *pass = @"111qqq";
    NSString *server = @"sos360.com";
    
    NSString *userId = [[LocalConfig Instance]shareconfig:USERID];
    NSString *pass = [[LocalConfig Instance]shareconfig:PASS];
    
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
    NSLog(@"receiver msg:%@",message);
    XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
                                                             xmppStream:xmppStream
                                                   managedObjectContext:[self managedObjectContext_roster]];
    NSString *from = [user jidStr];
    int unReadNum = [[unReadMsg objectForKey:from] intValue];
    [unReadMsg setObject:[NSNumber numberWithInt:unReadNum + 1] forKey:from];
    [messageDelegate newMessageReceived:message];
    //程序运行在前台，消息正常显示
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
       
        
    }else{//如果程序在后台运行，收到消息以通知类型来显示
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Ok";
        localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",@"test",message.body];//通知主体
        localNotification.soundName = @"crunch.wav";//通知声音
        localNotification.applicationIconBadgeNumber = 1;//标记数
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];//发送通知
    }
    
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
            //用户列表委托
            [chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, [xmppStream hostName]]];
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托
            [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, [xmppStream hostName]]];
        }
        
    }
    
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

//获取用户的未读消息数，如果user 为空，则返回未读总数
- (NSInteger)getUnReadNum:(NSString *)user{
    if(user==nil){
        NSInteger total = 0;
        for(NSNumber *i in [self.unReadMsg allValues])
        {
            total = total + [i intValue];
        }
        
        return total;
    }else{
        return [[self.unReadMsg objectForKey:user] intValue];
    }
}


- (void)readUserMsg:(NSString *)oneUser
{
    [self.unReadMsg removeObjectForKey:oneUser];
    
    NSString *unReadNum = [NSString stringWithFormat:@"%d", [self getUnReadNum:nil]];
    if([unReadNum intValue] == 0) unReadNum = nil;
    [[[self.tabBarController.viewControllers objectAtIndex:0] tabBarItem] setBadgeValue:unReadNum];
}

@end
