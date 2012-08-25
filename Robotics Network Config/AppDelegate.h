//
//  AppDelegate.h
//  Robotics Network Config
//
//  Created by Sam Crow on 8/24/12.
//  Copyright (c) 2012 FRC Team 751. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    
}

@property (assign) IBOutlet NSMenu *confMenu;

@property (assign) IBOutlet NSWindow *preferencesWindow;
@property (assign) IBOutlet NSTextField *teamNumberField;

@property (strong) NSStatusItem *statusItem;

-(IBAction) configRobotics:(id)sender;

-(IBAction) configDefault:(id)sender;

@end
