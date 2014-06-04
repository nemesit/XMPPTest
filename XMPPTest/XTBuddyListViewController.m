//
//  XTViewController.m
//  XMPPTest
//
//  Created by Felix Grabowski on 12/05/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

#import "XTBuddyListViewController.h"
#import "XTLoginViewController.h"

@interface XTBuddyListViewController ()

@end

@implementation XTBuddyListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[self tView] setDelegate:self];
    [[self tView] setDataSource:self];
    [self setOnlineBuddies:[[NSMutableArray alloc] init]];
    XTAppDelegate *del = [self appDelegate];
    [del setChatDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (login) {
        if ([[self appDelegate] connect]) {
            //show buddy list
        }
    } else {
        [self showLogin];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showLogin{
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XTLoginViewController *loginController = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self presentViewController:loginController animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark Table view delegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *s = (NSString *) [[self onlineBuddies] objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"UserCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = s;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self onlineBuddies] count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // start a chat
    NSString *userName = (NSString *) [[self onlineBuddies] objectAtIndex:[indexPath row]];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    XTChatViewController *chatController = [storyBoard instantiateViewControllerWithIdentifier:@"chatViewController"];
    [chatController setChatWithUser:userName];
    
    
    
    [self presentViewController:chatController animated:YES completion:nil];
    
}


- (void)newBuddyOnline:(NSString *)buddyName {
    [[self onlineBuddies] addObject:buddyName];
    NSLog(@"%@", buddyName);
    [[self tView] reloadData];
}

- (void)buddyWentOffline:(NSString *)buddyName {
    [[self onlineBuddies] removeObject:buddyName];
    [[self tView] reloadData];
}


- (XTAppDelegate *)appDelegate {
    return (XTAppDelegate *) [[UIApplication sharedApplication] delegate];
}
- (XMPPStream *)xmppStream {
    return [[self appDelegate] xmppStream];
}

- (void)didDisconnect {
    [[self onlineBuddies] removeAllObjects];
    [[self tView] reloadData];
}

@end
