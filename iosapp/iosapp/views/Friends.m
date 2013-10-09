//
//  Friends.m
//  iosapp
//
//  Created by comger on 13-8-30.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "Friends.h"
#import "AppDelegate.h"
#import "Message.h"
#import <SSToolkit/SSBadgeTableViewCell.h>
#import <SSToolkit/SSBadgeView.h>
#import <SSToolkit/SSLabel.h>

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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSManagedObjectContext *moc = [[self appDelegate] managedObjectContext_roster];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"sectionNum"
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
		
		
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
			NSLog(@"Error performing fetch: %@", error);
		}
        
	}
	
	return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[[self table] reloadData];
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

    
}

//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{

    
}


-(void)newMessageReceived:(XMPPMessage *)messageContent{
    AppDelegate *app = [self appDelegate];
    NSInteger total = [app getUnReadNum:nil];
    NSString *unReadNum = [NSString stringWithFormat:@"%d", total];
    if([unReadNum intValue] == 0) unReadNum = nil;
    [[[app.tabBarController.viewControllers objectAtIndex:0] tabBarItem] setBadgeValue:unReadNum];
    [self.table reloadData];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self newMessageReceived:nil];
    UITableView *_tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.table = _tableView;
    
    AppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
    del.messageDelegate = self;
    
    //添加好友的按钮
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    btnSearch.image = [UIImage imageNamed:@"searchWhite"];
    [btnSearch setAction:@selector(addroster:)];
    self.navigationItem.rightBarButtonItem = btnSearch;
    
    [self.view addSubview:self.table];
}

- (void)addroster:(id)sender{
     [[self xmppRoster] addUser:[XMPPJID jidWithString:@"comger@sos360.com" ] withNickname:@"comger"];
     
}

-(void)viewWillAppear:(BOOL)animated{
    if(![[self xmppStream] isConnected]){
        if ([[self appDelegate] connect]) {
            NSLog(@"show buddy list");            
        }else{
            LoginView *loginview = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
            //[self.navigationController pushViewController:loginview animated:YES];
            [self.navigationController presentViewController:loginview animated:YES completion:NULL];
        }
    }
    [self.table reloadData];
}

- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex
{
	NSArray *sections = [[self fetchedResultsController] sections];
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        
		int section = [sectionInfo.name intValue];
		switch (section)
		{
			case 0  : return @"在线";
			case 1  : return @"离开";
			default : return @"离线";
		}
	}
	return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[[self fetchedResultsController] sections] count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sections = [[self fetchedResultsController] sections];
	
	if (section < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
		return sectionInfo.numberOfObjects;
	}
	
	return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    SSBadgeTableViewCell *cell = (SSBadgeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
	if (cell == nil) {
		cell = [[SSBadgeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
	}
    
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    NSInteger count = [[self appDelegate] getUnReadNum:[user jidStr]];
	if(count>0){
        cell.badgeView.textLabel.text= [NSString stringWithFormat:@"%d",count];
        cell.badgeView.badgeColor = [UIColor colorWithRed:0.969f green:0.082f blue:0.078f alpha:1.0f];
    }else{
        cell.badgeView.textLabel.text=nil;
    }
    
    //文本
    cell.textLabel.text = user.displayName;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app readUserMsg:[NSString stringWithFormat:@"%@", user.jid]];
    Message *chatView = [[Message alloc] init];
    [chatView setChatUser:[user.jid bare]];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
