//
//  XTChatDelegate.h
//  XMPPTest
//
//  Created by Felix Grabowski on 13/05/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XTChatDelegate <NSObject>

- (void)newBuddyOnline:(NSString *)buddyName;
- (void)buddyWentOffline:(NSString *)buddyName;
- (void)didDisconnect;

@end
