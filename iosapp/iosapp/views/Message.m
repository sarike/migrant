//
//  Message.m
//  iosapp
//
//  Created by comger on 13-9-21.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "Message.h"
#import "AppDelegate.h"
#import "SSMessageTableViewCell.h"
#import "Statics.h"
#import <SSToolkit/SSTextField.h>

@interface Message ()

@end

@implementation Message

int lastIndex = 0;

//取得当前程序的委托
-(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}


#pragma mark UIViewController

-(void)setChatUser:(NSString *)name{
    username = name;
    self.title = name;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = username;
    [NSFetchedResultsController deleteCacheWithName:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self scrollToBottom];
}



- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    //textView.frame = newTextViewFrame;
    self.tableView.frame = newTextViewFrame;
    
    NSIndexPath *row = [NSIndexPath indexPathForRow:lastIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:row atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    //textView.frame = self.view.bounds;
    self.tableView.frame = self.view.bounds;
    [UIView commitAnimations];
}
- (void)send:(id)sender {
    //本地输入框中的信息    
    NSString *message = [self getInputText];
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
        
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	}
	return YES;
}


#pragma mark SSMessagesViewController

- (SSMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Message_CoreDataObject *obj = nil;
    obj=[[self fetchedResultsController] objectAtIndexPath:indexPath];
    NSString *sender = [obj.message.from bare];
    if (![sender isEqualToString:username]){
        return SSMessageStyleRight;
    }
    
    return SSMessageStyleLeft;
}


- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPMessageArchiving_Message_CoreDataObject *obj = nil;
    obj=[[self fetchedResultsController] objectAtIndexPath:indexPath];
    return obj.message.body;
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [[self fetchedResultsController] sections];
	if (section < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
		return sectionInfo.numberOfObjects;
	}
	return 0;
    
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
    [self.tableView reloadData];
    [self scrollToBottom];
}

//滑动到最底部
-(void)scrollToBottom{
    int n = [self.tableView numberOfRowsInSection:0]-1;
    lastIndex = n;
    NSIndexPath *row = [NSIndexPath indexPathForRow:n inSection:0];
    [self.tableView scrollToRowAtIndexPath:row atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

@end
