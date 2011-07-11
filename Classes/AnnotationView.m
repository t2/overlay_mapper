//
//  AnnotationView.m
//  iOS4DragDrop
//
//  Created by Trent Kocurek on 7/21/10.
//  Copyright Urban Coding 2010. All rights reserved.
//

#import "AnnotationView.h"
#import "CurrentLocationAnnotation.h"

@interface AnnotationView () 
@property (nonatomic, assign) BOOL hasBuiltInDraggingSupport;
@end

@implementation AnnotationView
@synthesize hasBuiltInDraggingSupport;
@synthesize mapView;

- (void)dealloc {
	[super dealloc];
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	
	self.hasBuiltInDraggingSupport = [[MKAnnotationView class] instancesRespondToSelector:NSSelectorFromString(@"isDraggable")];
	
	if (self.hasBuiltInDraggingSupport) {
		if ((self = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
			[self performSelector:NSSelectorFromString(@"setDraggable:") withObject:[NSNumber numberWithBool:YES]];
		}
	}
	self.canShowCallout = YES;
	
	return self;
}
@end
