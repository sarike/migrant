//
//  XMPPBase.m
//  iosapp
//
//  Created by comger on 13-8-23.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "XMPPBase.h"
#import "AppDelegate.h"

@interface XMPPBase ()

@end

@implementation XMPPBase

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"tweet"];
        self.tabBarItem.title = @"消息";
        self.title =  @"消息";

    }
    return self;
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


////////////////// 好友上下线接口 //////////////////////
//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}


-(void)buddyWentOffline:(NSString *)buddyName{
    NSLog(@"%@:offline",buddyName);
}

-(void)disDisconnect{

}

-(void)newBuddyOnline:(NSString *)buddyName{
    NSLog(@"%@:online",buddyName);
}

@end
