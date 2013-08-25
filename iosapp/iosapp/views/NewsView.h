//
//  NewsView.h
//  iosapp
//
//  Created by comger on 13-8-23.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "ListViewController.h"
#import "AFJSONRequestOperation.h"
#import "NewsCell.h"

@interface NewsView : ListViewController <UITableViewDataSource, UITableViewDelegate>{
}

@property NSMutableArray * datalist;
@property int catalog;
@property NSString *since;
@property NSString *url;

- (void)reloadType:(int)ncatalog;
- (void)loadData;
@end
