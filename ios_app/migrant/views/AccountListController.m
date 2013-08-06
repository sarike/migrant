//
//  AccountListController.m
//  UIBase
//
//  Created by Zk Huang on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountListController.h"
#import "AFJSONRequestOperation.h"
#import "PostCell.h"

@interface AccountListController ()

@end

@implementation AccountListController

@synthesize heigthList;
@synthesize dataList;
@synthesize tableview;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
        self.tabBarItem = item;
    }
    return self;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [NSString stringWithFormat:@"Section %i", section];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"city for china";

    self.dataList =[[NSArray alloc] init];
    NSString *url = @"http://192.168.1.166:8888/m/post/city?";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] ];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog([self.dataList length]);
        
        self.dataList = [JSON valueForKey:@"data"];
        
        [self.tableview reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"network faild" );
    }];
    
    [operation start];
    
}



- (void)viewDidUnload
{ 
    [super viewDidUnload];
    self.dataList = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  dataList.count;
}

//计算text field 的高度。
-(CGFloat)cellHeight:(NSString*)contentText with:(CGFloat)with
{
    UIFont * font=[UIFont  systemFontOfSize:14];
    CGSize size = [contentText sizeWithFont:font constrainedToSize:CGSizeMake(with - 10, 300000.0f) lineBreakMode:10];
    CGFloat height = size.height;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"PostCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    NSUInteger row = [indexPath row];
    NSLog(@"%@",self.dataList);
    NSDictionary *info = [self.dataList objectAtIndex:row];
    [cell setValue:info];
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    NSString *body = [[self.dataList objectAtIndex:row] valueForKey:@"body"];
    NSLog(@"H:%f",[self cellHeight:body with:300]);
    return 40 + [self cellHeight:body with:300];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    UIViewController *vc = [[AccountListController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];

}

@end

