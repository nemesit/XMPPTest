//
//  XTViewController.h
//  XMPPTest
//
//  Created by Felix Grabowski on 12/05/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "XTAppDelegate.h"
#import "XTChatViewController.h"

@interface XTBuddyListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, XTChatDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tView;
@property (nonatomic, strong) NSMutableArray *onlineBuddies;

- (IBAction)showLogin;

- (XTAppDelegate *)appDelegate;
- (XMPPStream *)xmppStream;

@end
