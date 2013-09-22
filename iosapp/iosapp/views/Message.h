//
//  Message.h
//  iosapp
//
//  Created by comger on 13-9-21.
//  Copyright (c) 2013年 comger. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "SSMessagesViewController.h"

@interface Message : SSMessagesViewController <NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *fetchedResultsController;
    NSString *username;
}

-(void)setChatUser:(NSString *)name;

@end
