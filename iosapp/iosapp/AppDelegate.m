//
//  AppDelegate.m
//  iosapp
//
//  Created by comger on 13-8-23.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    NewsBase *newsbase = [[NewsBase alloc] initWithNibName:@"NewsBase" bundle:nil];
    UINavigationController * newsNav = [[UINavigationController alloc] initWithRootViewController:newsbase];
    
    XMPPBase *xmppbase = [[XMPPBase alloc] initWithNibName:@"XMPPBase" bundle:nil];
    UINavigationController * xmppNav = [[UINavigationController alloc] initWithRootViewController:xmppbase];
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             xmppNav,
                                             newsNav,
                                             nil];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(BOOL)connect{
    xmppStream = [[XMPPStream alloc]init];
    [xmppStream setMyJID:[XMPPJID jidWithString:@"test1@sos360.com"]];
    NSError *error = nil;
    
    if(![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        NSLog(@"connect faild");
        return NO;
    }
    return YES;
}

-(void)disconnect{
    [xmppStream disconnect];
}

/**
 * Sent when a presence subscription request is received.
 * That is, another user has added you to their roster,
 * and is requesting permission to receive presence broadcasts that you send.
 *
 * The entire presence packet is provided for proper extensibility.
 * You can use [presence from] to get the JID of the user who sent the request.
 *
 * The methods acceptPresenceSubscriptionRequestFrom: and rejectPresenceSubscriptionRequestFrom: can
 * be used to respond to the request.
 **/
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{

}

/**
 * Sent when a Roster Push is received as specified in Section 2.1.6 of RFC 6121.
 **/
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq{

}

/**
 * Sent when the initial roster is received.
 **/
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender{
}

/**
 * Sent when the initial roster has been populated into storage.
 **/
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{

}

/**
 * Sent when the roster recieves a roster item.
 *
 * Example:
 *
 * <item jid='romeo@example.net' name='Romeo' subscription='both'>
 *   <group>Friends</group>
 * </item>
 **/
- (void)xmppRoster:(XMPPRoster *)sender didRecieveRosterItem:(NSXMLElement *)item{

}

@end
