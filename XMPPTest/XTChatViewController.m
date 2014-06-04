//
//  XTChatViewController.m
//  XMPPTest
//
//  Created by Felix Grabowski on 12/05/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

#import "XTChatViewController.h"

@interface XTChatViewController ()

@end

@implementation XTChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self tView] setDelegate:self];
    [[self tView] setDataSource:self];
    [self setMessages:[[NSMutableArray alloc] init]];
    
    [[self messageField] becomeFirstResponder];
    // Do any additional setup after loading the view.
    XTAppDelegate *del = [self appDelegate];
    [del setMessageDelegate:self];
    [[self messageField] becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

# pragma mark - Actions

- (IBAction)closeChat:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMessage:(id)sender{
    NSString *messageStr = [[self messageField] text];
    if ([messageStr length] > 0) {
        //Send message through XMPP
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:[self chatWithUser]];
        [message addChild:body];
        
        [[self xmppStream] sendElement:message];
        
        [[self messageField] setText:@""];
        

        
        
        
        [[self messageField] setText:@""];
        //NSString *string = [NSString stringWithFormat:@"%@:%@", messageStr, @"you"];
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:messageStr forKey:@"msg"];
        [m setObject:@"you" forKey:@"sender"];
        [[self messages] addObject:m];
        [[self tView] reloadData];
    }
}

# pragma mark - TableView delegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *s = (NSDictionary *) [[self messages] objectAtIndex:[indexPath row]];
    static NSString *CellIdentifier = @"MessageCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText:[s objectForKey:@"msg"]];
    [[cell detailTextLabel] setText:[s objectForKey:@"sender"]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setUserInteractionEnabled:NO];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self messages] count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (XTAppDelegate *)appDelegate {
    return (XTAppDelegate *) [[UIApplication sharedApplication] delegate];
}
- (XMPPStream *)xmppStream {
    return [[self appDelegate] xmppStream];
}

#pragma mark - Chat delegate methods

// react to the message received
- (void)newMessageReceived:(NSDictionary *)messageContent {
    //NSString *messageStr = [messageContent objectForKey:@"msg"];
    
    [[self messages] addObject:messageContent];
    [[self tView] reloadData];
    
    NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:[[self messages] count]-1 inSection:0];
    [[self tView] scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

}

@end
