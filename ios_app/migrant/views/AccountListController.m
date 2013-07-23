//
//  AccountListController.m
//  UIBase
//
//  Created by Zk Huang on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountListController.h"
#import "AFJSONRequestOperation.h"


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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Cell #%d", indexPath.row];
    cell.textLabel.text = [[self.dataList objectAtIndex:indexPath.row] valueForKey:@"body"];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    UIViewController *vc = [[AccountListController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];

}

@end

