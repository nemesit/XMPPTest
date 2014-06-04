//
//  XTAppDelegate.m
//  XMPPTest
//
//  Created by Felix Grabowski on 12/05/14.
//  Copyright (c) 2014 Felix Grabowski. All rights reserved.
//

#import "XTAppDelegate.h"

@interface XTAppDelegate ()

- (void)setupStream;
- (void)goOnline;
- (void)goOffline;

@end

@implementation XTAppDelegate

- (BOOL)              application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
    [self disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
    [self connect];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - XMPP

- (void)setupStream {
    [self setXmppStream:[[XMPPStream alloc] init]];
    [[self xmppStream] addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];

    [[self xmppStream] sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];

    [[self xmppStream] sendElement:presence];
}

- (BOOL)connect {
    [self setupStream];
    NSString *jabberID =
        [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    NSString *myPassword =
        [[NSUserDefaults standardUserDefaults] stringForKey:@"userPassword"];

    if (![[self xmppStream] isDisconnected]) {
        return YES;
    }

    if (jabberID == nil || myPassword == nil) {
        return NO;
    }

    [[self xmppStream] setMyJID:[XMPPJID jidWithString:jabberID]];
    [self setPassword:myPassword];

    NSError *error = nil;

    if (![[self xmppStream] connectWithTimeout:XMPPStreamTimeoutNone
                                         error:&error]) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                               message:[NSString
                                           stringWithFormat:@"Cannot connect to server %@",
                                                     [error localizedDescription]]
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
        [alertView show];

        return NO;
    }

    return YES;
}

- (void)disconnect {
    [self goOffline];
    [[self xmppStream] disconnect];
}

#pragma mark - XMPPStream delegate methdods

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    // connection to the server successful
    [self setIsOpen:YES];
    NSError *error = nil;
    [[self xmppStream] authenticateWithPassword:[self password] error:&error];
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    // authentication successful
    [self goOnline];
    
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    // message received
    if (![message elementForName:@"body"]) {
        return;
    }
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    [m setObject:msg forKey:@"msg"];
    [m setObject:from forKey:@"sender"];
    
    [[self messageDelegate] newMessageReceived:m];
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    // a buddy went offline/online
    NSString *presenceType = [presence type];   // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:myUsername]) {
        if ([presenceType isEqualToString:@"available"]) {
            [[self chatDelegate] newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jabber.mafiasi.de"]];      // ToDo: get servername from somewhere else
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            [[self chatDelegate] buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jabber.mafiasi.de"]];    // ToDo: get servername from somewhere else
        }
    }
}


@end
