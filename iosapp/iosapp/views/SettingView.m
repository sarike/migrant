//
//  SettingView.m
//  oschina
//
//  Created by wangjun on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingView.h"


@implementation SettingView
@synthesize tableSettings;
@synthesize settings;
@synthesize settingsInSection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"更多";
        self.tabBarItem.title = @"更多";
        self.tabBarItem.image = [UIImage imageNamed:@"more"];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.settingsInSection = [[NSMutableDictionary alloc] initWithCapacity:3];
    isLogin = [[LocalConfig Instance] shareconfig:@"uid"]?YES:NO;

    NSArray *first = [[NSArray alloc] initWithObjects:
                      [[SettingModel alloc] initWith:isLogin ? @"我的资料 ":@"登录" andImg:@"account" andTag:1 andTitle2:nil],
                      [[SettingModel alloc] initWith: @"注销" andImg:@"exit" andTag:2 andTitle2:nil],
                      nil];
    NSArray *second = [[NSArray alloc] initWithObjects:
                       [[SettingModel alloc] initWith:@"项目" andImg:@"software" andTag:3 andTitle2:nil],
                       [[SettingModel alloc] initWith:@"职位" andImg:@"software" andTag:4 andTitle2:nil],
                       [[SettingModel alloc] initWith:@"搜索" andImg:@"search" andTag:5 andTitle2:nil],
                       nil];
    NSArray *third = [[NSArray alloc] initWithObjects:
                      [[SettingModel alloc] initWith:@"意见反馈" andImg:@"feedback" andTag:6 andTitle2:nil],
                      [[SettingModel alloc] initWith:@"关于我们" andImg:@"logo" andTag:7 andTitle2:nil],
                      [[SettingModel alloc] initWith:@"检测更新" andImg:@"setting" andTag:8 andTitle2:nil],
                      nil];
    [self.settingsInSection setObject:first forKey:@"帐号"];
    [self.settingsInSection setObject:second forKey:@"反馈"];
    [self.settingsInSection setObject:third forKey:@"关于"];
    self.settings = [[NSArray alloc] initWithObjects:@"帐号",@"反馈",@"关于",nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:[Config Instance].isCookie ? @"1" : @"0"];
    [self refresh];
}
- (void)viewDidUnload
{
    [self setTableSettings:nil];
    [super viewDidUnload];
}
- (void)refresh
{
    NSArray *first = [self.settingsInSection objectForKey:@"帐号"];
    SettingModel *firstLogin = [first objectAtIndex:0];
    firstLogin.title = [[LocalConfig Instance] shareconfig:@"uid"] ? @"我的资料" : @"登录";
    [self.tableSettings reloadData];
}
#pragma TableView的处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger section = [indexPath section];
    NSString *key = [settings objectAtIndex:section];
    NSArray *sets = [settingsInSection objectForKey:key];
    SettingModel *action = [sets objectAtIndex:[indexPath row]];
    switch (action.tag) {
        case 1:{
            if(!isLogin){
                LoginView *login = [[LoginView alloc] init];
                login.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:login animated:YES];
            }

        }
            break;

        case 2:
        {
            
            [self refresh];
            
            
        }
            break;
        default:
            break;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [settings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [settings objectAtIndex:section];
    NSArray *set = [settingsInSection objectForKey:key];
    return [set count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *SettingTableIdentifier = @"SettingTableIdentifier";
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSString *key = [settings objectAtIndex:section];
    NSArray *sets = [settingsInSection objectForKey:key];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingTableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    }
    SettingModel *model = [sets objectAtIndex:row];
    cell.textLabel.text = model.title;
    cell.imageView.image = [UIImage imageNamed:model.img];
    cell.tag = model.tag;
    return cell;
}

#pragma 按钮点击后的API方法

- (void)checkVersionNeedUpdate
{
    
}
+ (int)getVersionNumber:(NSString *)version
{
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    }
@end
