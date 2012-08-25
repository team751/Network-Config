//
//  AppDelegate.m
//  Robotics Network Config
//
//  Created by Sam Crow on 8/24/12.
//  Copyright (c) 2012 FRC Team 751. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setStatusItem:[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength]];
    [[self statusItem] setTitle:@"FRC"];
    [[self statusItem] setMenu:[self confMenu]];
    [[self statusItem] setHighlightMode:YES];
    
    //Get the team number from the preferences
    Boolean ok;
    int teamNumber = (int) CFPreferencesGetAppIntegerValue(CFSTR("team_number"), kCFPreferencesCurrentApplication, &ok);
    if(ok == false) {
        NSLog(@"Failed to read team number from the preferences. Using 751 as default.");
        [[self teamNumberField] setIntValue:751];
    } else {
        [[self teamNumberField] setIntValue:teamNumber];
    }
}

-(void) applicationWillTerminate:(NSNotification *)notification {
    
    //Save the team number to the preferences
    
    int teamNumber = [[self teamNumberField] intValue];
    
    CFNumberRef teamNumberRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &teamNumber);
    
    CFPreferencesSetAppValue(CFSTR("team_number"), teamNumberRef, kCFPreferencesCurrentApplication);
    bool ret = CFPreferencesSynchronize(kCFPreferencesCurrentApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    
    if(ret == false) {
        NSLog(@"Failed to write preferences!");
    }
}

-(IBAction)configRobotics:(id)sender {
    

    int teamNumber = [[self teamNumberField] intValue];
    
    
    //Format the xx.yy part of the IP address from the team number
    NSString *teamNumberIp = [[[NSString stringWithFormat:@"%i", teamNumber / 100] stringByAppendingString:@"."] stringByAppendingFormat:@"%i", teamNumber % 100];
    
    NSString *localIp = [[@"10." stringByAppendingString:teamNumberIp] stringByAppendingString:@".6"];
    NSString *defaultGateway = [[@"10." stringByAppendingString:teamNumberIp] stringByAppendingString:@".1"];
    
    
    
    NSTask * task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/sbin/networksetup"];
    
    NSArray *args = [[NSArray alloc] initWithObjects:@"-setmanual", @"Ethernet", localIp, @"255.255.255.0", defaultGateway, nil];
    [task setArguments:args];
    [task launch];
}

-(IBAction) configDefault:(id)sender {
    NSTask * task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/sbin/networksetup"];
    
    NSArray *args = [[NSArray alloc] initWithObjects:@"-setdhcp", @"Ethernet", nil];
    [task setArguments:args];
    [task launch];
}

@end
