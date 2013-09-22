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
    //设定在线用户委托
    AppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
    del.messageDelegate = self;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[self appDelegate] connect]) {
        NSLog(@"show buddy list");
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}

//在线好友
-(void)newBuddyOnline:(NSString *)buddyName{
    NSLog(@"newBuddyOnline:%@",buddyName);
}

//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{
    NSLog(@"buddyWentOffline:%@",buddyName);
    
}


-(void)newMessageReceived:(NSDictionary *)messageContent{
    NSLog(@"msg:%@",messageContent);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
