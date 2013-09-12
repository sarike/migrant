//
//  Friends.h
//  iosapp
//
//  Created by comger on 13-8-30.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface Friends : UIViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
{
	NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) NSMutableArray *datalist;
@property (nonatomic, retain) UITableView *table;

@end
