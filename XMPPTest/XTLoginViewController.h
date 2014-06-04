//
//  XTLoginViewController.h
//  XMPPTest
//
//  Created by Felix Grabowski on 12/05/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTLoginViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *loginField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

- (IBAction)login;
- (IBAction)hideLogin;

@end
