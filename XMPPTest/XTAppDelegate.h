//
//  XTAppDelegate.h
//  XMPPTest
//
//  Created by Felix Grabowski on 12/05/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"

#import "XTChatDelegate.h"
#import "XTMessageDelegate.h"

@class XTBuddyListViewController;

@interface XTAppDelegate : UIResponder <UIApplicationDelegate, XMPPStreamDelegate>

@property (nonatomic, strong) XTBuddyListViewController *viewController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *password;
@property BOOL isOpen;

@property (strong, nonatomic) XMPPStream *xmppStream;

@property (nonatomic, weak) id<XTChatDelegate> chatDelegate;
@property (nonatomic, weak) id<XTMessageDelegate> messageDelegate;

- (BOOL)connect;
- (void)disconnect;

@end
