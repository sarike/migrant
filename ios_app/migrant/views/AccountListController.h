//
//  AccountListController.h
//  UIBase
//
//  Created by Zk Huang on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountListController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
 @property (retain, nonatomic)  NSArray *dataList;
@property (retain, nonatomic) NSMutableArray *heigthList;
@property (retain, nonatomic) IBOutlet UITableView *tableview;

@end
