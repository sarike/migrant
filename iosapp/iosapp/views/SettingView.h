//
//  SettingView.h
//  oschina
//
//  Created by wangjun on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalConfig.h"
#import "SettingModel.h"
#import "LoginView.h"

@interface SettingView : UIViewController<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray * settings;
    NSMutableDictionary * settingsInSection;
    BOOL *isLogin;
}

@property (strong, nonatomic) IBOutlet UITableView *tableSettings;
@property (retain,nonatomic) NSArray * settings;
@property (retain,nonatomic) NSMutableDictionary * settingsInSection;

- (void)refresh;

- (void)checkVersionNeedUpdate;

+ (int)getVersionNumber:(NSString *)version;

@end
