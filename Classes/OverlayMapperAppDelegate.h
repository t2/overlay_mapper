//
//  OverlayMapperAppDelegate.h
//  OverlayMapper
//
//  Created by Trent Kocurek on 7/24/10.
//  Copyright (c) 2010 Urban Coding. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface OverlayMapperAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;

    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@end

