//
//  comger.h
//  IOSBoilerplate
//
//  Created by Zk Huang on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define knameTag 1
#define ksexTag 2

@interface comger : UIViewController
   @property(nonatomic,retain) NSArray *dataItems; 
   @property (nonatomic, retain) IBOutlet UITableView* table;
   @property (retain, nonatomic) IBOutlet UITableViewCell *tvCell;


-(NSInteger)getIndex :(NSArray *) array;

@end



