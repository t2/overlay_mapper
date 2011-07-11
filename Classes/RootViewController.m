//
//  RootViewController.m
//  OverlayMapper
//
//  Created by Trent Kocurek on 7/24/10.
//  Copyright (c) 2010 Urban Coding. All rights reserved.
//


#import "RootViewController.h"
#import "CurrentLocationAnnotation.h"
#import "AnnotationView.h"

@implementation RootViewController

@synthesize mvMapView;
@synthesize locationManager, currentLocation;

#pragma mark -
#pragma mark Core Location
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation 
{	
	[locationManager stopUpdatingLocation];
	if(currentLocation == nil) self.currentLocation = newLocation;
	else if (newLocation.horizontalAccuracy < self.currentLocation.horizontalAccuracy) self.currentLocation = newLocation;
	
	mvMapView.region = MKCoordinateRegionMake(self.currentLocation.coordinate, MKCoordinateSpanMake(0.5f, 0.5f));	
	[mvMapView setShowsUserLocation:NO];
	
	CurrentLocationAnnotation *annotation = [[[CurrentLocationAnnotation alloc] initWithCoordinate:self.currentLocation.coordinate addressDictionary:nil] autorelease];
	annotation.title = @"1";
	annotation.subtitle = @"Drag pin to set poisition.";

	[mvMapView addAnnotation:annotation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{	
	NSString* errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
	UIAlertView* locationAlert = [[UIAlertView alloc] initWithTitle:@"Error Getting Location"
															message:errorType
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
	[locationAlert show];
	[locationAlert release];
	[errorType release];
}

#pragma mark -
#pragma mark Map Kit
- (MKAnnotationView *)mapView:(MKMapView *)MapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [MapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {		
		draggablePinView = [[[AnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier] autorelease];
		if ([draggablePinView isKindOfClass:[AnnotationView class]]) {
			((AnnotationView *)draggablePinView).mapView = MapView;
		}
	}
	return draggablePinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState 
{
	if (oldState == MKAnnotationViewDragStateDragging) {
		CurrentLocationAnnotation *annotation = (CurrentLocationAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
        [self connectDots];
	}
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
    MKPolylineView *polyLineView = [[[MKPolylineView alloc] initWithOverlay:overlay] autorelease];
    polyLineView.strokeColor = [UIColor redColor];
    polyLineView.lineWidth = 5.0;
    return polyLineView;
}

#pragma mark -
#pragma mark IBActions
- (IBAction)saveOverlay:(id)sender {
    NSInteger arrayCount = [mvMapView.annotations count];
    CLLocationCoordinate2D coords[2];
    
    MKPlacemark *lastPlaceMark = [mvMapView.annotations objectAtIndex:arrayCount -1];
    MKPlacemark *firstPlaceMark = [mvMapView.annotations objectAtIndex:0];
    coords[0] = lastPlaceMark.coordinate;
    coords[1] = firstPlaceMark.coordinate;
    NSLog(@"%d, %d", coords[0].latitude, coords[0].longitude);
    NSLog(@"%d, %d", coords[1].latitude, coords[1].longitude);
    
    MKPolyline *polyLine=[MKPolyline polylineWithCoordinates:coords count:2];
    [mvMapView addOverlay:polyLine];
    
    [polyLine release];
    [lastPlaceMark release];
    [firstPlaceMark release];
}

- (IBAction)addPin:(id)sender {
    CurrentLocationAnnotation *annotation = [[[CurrentLocationAnnotation alloc] initWithCoordinate:self.currentLocation.coordinate addressDictionary:nil] autorelease];
	annotation.title = [[NSString alloc] initWithFormat:@"%d", [mvMapView.annotations count] + 1];
	annotation.subtitle = @"Drag pin to set poisition.";
    
    [mvMapView addAnnotation:annotation];
    [annotation release];
}

- (void)connectDots {
    NSInteger arrayCount = [mvMapView.annotations count];
    CLLocationCoordinate2D coords[arrayCount];
    
    NSInteger i;
    for (i=0;i<arrayCount;i++) {
        MKPlacemark *placeMark = [mvMapView.annotations objectAtIndex:i];
        coords[i] = placeMark.coordinate;
        NSLog(@"%d, %d", coords[i].latitude, coords[i].longitude);
    }
    
    MKPolyline *polyLine=[MKPolyline polylineWithCoordinates:coords count:[mvMapView.annotations count]];
    [mvMapView addOverlay:polyLine];
    [polyLine release];
}

#pragma mark -
#pragma mark View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [mvMapView setMapType:MKMapTypeHybrid];
	[mvMapView setDelegate:self];
    
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDelegate:self];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	if(!locationManager.locationServicesEnabled) {
		UIAlertView *locationServiceDisabledAlert = [[UIAlertView alloc] 
													 initWithTitle:@"Location Services Disabled"
													 message:@"Location Service is disabled on this device. To enable Location Services go to Settings -> General and set the Location Services switch to ON"
													 delegate:self
													 cancelButtonTitle:@"Ok"
													 otherButtonTitles:nil];
		[locationServiceDisabledAlert show];
		[locationServiceDisabledAlert release];
	}
    
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    mvMapView = nil;
    [super dealloc];
}

@end

