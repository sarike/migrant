//
//  Friends.h
//  iosapp
//
//  Created by comger on 13-8-30.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MessageDelegate.h"


@interface Friends : UIViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,MessageDelegate>
{
	NSFetchedResultsController *fetchedResultsController;
}


@property (nonatomic, retain) UITableView *table;

@end
