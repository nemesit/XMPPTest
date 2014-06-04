//
//  XTChatViewController.h
//  XMPPTest
//
//  Created by Felix Grabowski on 12/05/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTMessageDelegate.h"
#import "XTAppDelegate.h"
#import "XMPP.h"

@interface XTChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, XTMessageDelegate>

@property (nonatomic, weak) IBOutlet UITextField *messageField;
@property (nonatomic, strong) NSString *chatWithUser;
@property (nonatomic, weak) IBOutlet UITableView *tView;
@property (nonatomic, strong) NSMutableArray *messages;

- (IBAction)sendMessage:(id)sender;
- (IBAction)closeChat:(id)sender;

- (XTAppDelegate *)appDelegate;
- (XMPPStream *)xmppStream;

@end
