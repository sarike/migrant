//
//  PostViewController.h
//  iosmigrant
//
//  Created by comger on 13-7-22.
//
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface PostViewController : ListViewController <UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic)  NSMutableArray *dataList;
@property (retain, nonatomic)  NSString *since;

@property (retain, nonatomic)  NSString *url;

-(void)setsince:(NSString *)_since;

@end
