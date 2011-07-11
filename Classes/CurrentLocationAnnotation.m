//
//  CurrentLocationAnnotation.m
//  iOS4DragDrop
//
//  Created by Trent Kocurek on 7/21/10.
//  Copyright Urban Coding 2010. All rights reserved.
//

#import "CurrentLocationAnnotation.h"


@implementation CurrentLocationAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord addressDictionary:(NSDictionary *)addressDictionary {
	
	if ((self = [super initWithCoordinate:coord addressDictionary:addressDictionary])) {
		// NOTE: self.coordinate is now different from super.coordinate, since we re-declare this property in header, 
		// self.coordinate and super.coordinate don't share same ivar anymore.
		self.coordinate = coord;
	}
	return self;
}
@end
