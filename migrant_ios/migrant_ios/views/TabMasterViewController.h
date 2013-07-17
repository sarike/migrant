//
//  TabMasterViewController.h
//  migrant_ios
//
//  Created by comger on 13-7-17.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "MyViewController.h"

@interface TabMasterViewController : UIViewController{
    IBOutlet UITabBarController *tabBar;
}

    @property (nonatomic,retain) IBOutlet UITabBarController *tabBar;
    
    @property (strong, nonatomic) HomeViewController *homeview;

    @property (strong, nonatomic) MyViewController *myview;
@end
