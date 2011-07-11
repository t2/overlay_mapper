//
//  RootViewController.h
//  OverlayMapper
//
//  Created by Trent Kocurek on 7/24/10.
//  Copyright (c) 2010 Urban Coding. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface RootViewController : UIViewController <UIAlertViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
    IBOutlet MKMapView *mvMapView;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (nonatomic, retain) IBOutlet MKMapView *mvMapView;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocation;

- (IBAction)saveOverlay:(id)sender;
- (IBAction)addPin:(id)sender;
- (void)connectDots;

@end

