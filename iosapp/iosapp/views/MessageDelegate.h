//
//  MessageDelegate.h
//  iosapp
//
//  Created by comger on 13-8-24.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@protocol MessageDelegate <NSObject>
    -(void)newMessageReceived:(XMPPMessage *)messageContent;
@end
