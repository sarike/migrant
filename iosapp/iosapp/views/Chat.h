//
//  Chat.h
//  iosapp
//
//  Created by comger on 13-8-30.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageDelegate.h"

@interface Chat : UIViewController<UITableViewDelegate, UITableViewDataSource,MessageDelegate>{
    NSString *username;
}
@property (weak, nonatomic) IBOutlet UITextField *tfbody;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *messages;

- (IBAction)send:(id)sender;
-(IBAction)closekb:(id)sender;
-(void)setChatUser:(NSString *)name;
@end
