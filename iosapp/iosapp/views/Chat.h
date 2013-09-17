//
//  Chat.h
//  iosapp
//
//  Created by comger on 13-8-30.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MessageDelegate.h"


@interface Chat : UIViewController<UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *fetchedResultsController;
    NSString *username;
}
@property (weak, nonatomic) IBOutlet UITextField *tfbody;
@property (weak, nonatomic) IBOutlet UITableView *table;


- (IBAction)send:(id)sender;
-(IBAction)closekb:(id)sender;
-(void)setChatUser:(NSString *)name;
@end
