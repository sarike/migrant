//
//  KKRosters.m
//  XmppDemo
//
//  Created by comger on 13-8-29.
//  Copyright (c) 2013年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "KKRosters.h"
#import "AppDelegate.h"
#import "MessageDelegate.h"

@interface KKRosters ()

@end

@implementation KKRosters

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设定在线用户委托
    AppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
    del.messageDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([[self appDelegate] connect]) {
        NSLog(@"show buddy list");
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//取得当前程序的委托
-(AppDelegate *)appDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
