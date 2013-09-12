//
//  Friends.m
//  iosapp
//
//  Created by comger on 13-8-30.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "Friends.h"
#import "AppDelegate.h"
#import "Chat.h"

@interface Friends ()

@end

@implementation Friends

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        if (self) {
            self.tabBarItem.image = [UIImage imageNamed:@"tweet"];
            self.tabBarItem.title = @"好友";
            self.title =  @"好友";
            
        }
        return self;
    }
    return self;
}

//取得当前程序的委托
-(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}

-(XMPPRoster *)xmppRoster{
    return [[self appDelegate] xmppRoster];
}

//在线好友
-(void)newBuddyOnline:(NSString *)buddyName{
    if (![self.datalist containsObject:buddyName]) {
        [self.datalist addObject:buddyName];
        [self.table reloadData];
    }
    
}

//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{
    
    [self.datalist removeObject:buddyName];
    [self.table reloadData];
    
}

- (void)queryRoster {
 
    NSError *error = [[NSError alloc] init];
    NSXMLElement *query = [[NSXMLElement alloc] initWithXMLString:@"<query xmlns='http://jabber.org/protocol/disco#items' node='all users'/>"
                                                            error:&error];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get"
                                 to:[XMPPJID jidWithString:@"sos360.com"]
                          elementID:[[self xmppStream] generateUUID] child:query];
    [[self xmppStream] sendElement:iq];

}

- (void)addRoster {
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = self.xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
    [iq addAttributeWithName:@"id" stringValue:@"1234567"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [[self xmppStream] sendElement:iq];
    
}

- (void)addNewRoster {
    /**
     <iq type="set" id="dc946448-2a71-4948-9d9a-b40435f32ea2-2">
        <query xmlns="jabber:iq:register">
            <username>test2</username>
            <password>111qqq</password>
        </query>
     </iq>
     **/
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:register"];
    
    
    NSXMLElement *username =[NSXMLElement elementWithName:@"username"];
    [username setStringValue:@"test3@sos360.com"];

    NSXMLElement *password =[NSXMLElement elementWithName:@"password"];
    [password setStringValue:@"111qqq"];
    
    NSXMLElement *name =[NSXMLElement elementWithName:@"name"];
    [name setStringValue:@"test2"];
    
    [query addChild:username];
    [query addChild:password];
    //[query addChild:name];
    
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"id" stringValue:@"dc946448-2a71-4948-9d9a-b40435f32ea2-3"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addChild:query];
    NSLog(@"%@",iq);
    [[self xmppStream] sendElement:iq];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView *_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.table = _tableView;
    
    self.datalist = [NSMutableArray array];
    AppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
    
    [self.view addSubview:self.table];
    
}

-(void)viewWillAppear:(BOOL)animated{
    if(![[self xmppStream] isConnected]){
        if ([[self appDelegate] connect]) {
            NSLog(@"show buddy list");
            //[self addNewRoster];
            [[self xmppRoster] fetchRoster];
            [self queryRoster];
            
        }
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.datalist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //文本
    cell.textLabel.text = [self.datalist objectAtIndex:[indexPath row]];
    //标记
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = [self.datalist objectAtIndex:indexPath.row];
    Chat *chatView = [[Chat alloc] init];
    [chatView setChatUser:name];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
