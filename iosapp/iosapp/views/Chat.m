//
//  Chat.m
//  iosapp
//
//  Created by comger on 13-8-30.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "Chat.h"
#import "AppDelegate.h"
#import "MessageCell.h"
#import "Statics.h"

#define padding 20

@interface Chat ()

@end

@implementation Chat
@synthesize tfbody;
@synthesize table;

//取得当前程序的委托
-(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"聊天";
    }
    return self;
}

-(void)setChatUser:(NSString *)name{
    username = name;
    self.title = name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.table.dataSource = self;
    self.table.delegate = self;
    
    [self.tfbody becomeFirstResponder];
    //AppDelegate *del = [self appDelegate];
    [NSFetchedResultsController deleteCacheWithName:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTfbody:nil];
    [self setTable:nil];
    [super viewDidUnload];
}


- (IBAction)send:(id)sender {
    //本地输入框中的信息
    NSString *message = self.tfbody.text;
    
    if (message.length > 0) {
        
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:username];
        
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[defaults objectForKey:USERID]];
        //组合
        [mes addChild:body];
        
        //发送消息
        [[self xmppStream] sendElement:mes];
        
        self.tfbody.text=@"";
        [self.tfbody resignFirstResponder];
    }
}



-(IBAction)closekb:(id)sender{
    [self.tfbody resignFirstResponder];
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
    
    static NSString *identifier = @"msgCell";
    
    MessageCell *cell =(MessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
  	XMPPMessageArchiving_Message_CoreDataObject *obj = nil;
    obj=[[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    NSString *sender = [obj.message.from bare];
    NSString *message = obj.message.body;
    

    NSString *time =  [Statics parseTime:obj.timestamp];
    
    
    
    CGSize textSize = {260.0 ,10000.0};
    CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    
    size.width +=(padding/2);
    
    cell.messageContentView.text = message;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    
    UIImage *bgImage = nil;
    
    //发送消息
    if (![sender isEqualToString:username]) {
        //背景图
        bgImage = [[UIImage imageNamed:@"BlueBubble2.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
        [cell.messageContentView setFrame:CGRectMake(padding, padding*2, size.width, size.height)];
        
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2, cell.messageContentView.frame.origin.y - padding/2, size.width + padding, size.height + padding)];
    }else {
        sender = username;
        bgImage = [[UIImage imageNamed:@"GreenBubble2.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:15];
        
        [cell.messageContentView setFrame:CGRectMake(320-size.width - padding, padding*2, size.width, size.height)];
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2, cell.messageContentView.frame.origin.y - padding/2, size.width + padding, size.height + padding)];
    }
    
    cell.bgImageView.image = bgImage;
    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
    
    return cell;
    
}

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPMessageArchiving_Message_CoreDataObject *obj = nil;
    
    obj=[[self fetchedResultsController] objectAtIndexPath:indexPath];
    NSString *msg = obj.message.body;
    
    CGSize textSize = {260.0 , 10000.0};
    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    
    size.height += padding*2;
    
    CGFloat height = size.height < 65 ? 65 : size.height;
    
    return height;
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFetchedResultsController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSFetchedResultsController *)fetchedResultsController
{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (fetchedResultsController == nil)
	{
        XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                             inManagedObjectContext:moc];
        
        //按时间排序
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1,nil];
        
       
        //添加过滤条件
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bareJidStr == %@ AND streamBareJidStr == %@",username,[defaults objectForKey:USERID]];
        
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        [request setEntity:entityDescription];
        [request setPredicate:predicate];
		[request setSortDescriptors:sortDescriptors];
		[request setFetchBatchSize:10];
        

		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:nil
                                                                            cacheName:@"Messages"];
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
    CGRect frame = self.table.frame;
    frame.size.height = self.view.bounds.size.height;
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    //[UIView setAnimationDuration:0.250000];
    self.table.frame = frame;
    
    
    int row = [[[[self fetchedResultsController] sections] objectAtIndex:0] numberOfObjects];
    
    NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.table scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [UIView commitAnimations];
}
@end
