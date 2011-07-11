//
//  OverlayMapperAppDelegate.m
//  OverlayMapper
//
//  Created by Trent Kocurek on 7/24/10.
//  Copyright (c) 2010 Urban Coding. All rights reserved.
//


#import "OverlayMapperAppDelegate.h"

@implementation OverlayMapperAppDelegate


@synthesize window;

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.
}

- (void)dealloc {

    [window release];
    [navigationController release];
    [super dealloc];
}

@end

