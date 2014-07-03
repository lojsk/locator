//
//  DataManager.m
//  PageViewDemo
//
//  Created by lojsk on 03/07/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

static DataManager *sharedManager = nil;

- (DataManager *)init {
    self = [super init];
	if(self) {
        [self locationModul];
	}
    return self;
}

@synthesize location;

- (void) locationModul {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   // NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        location = currentLocation.coordinate;
    }
}

+ (DataManager *)sharedInstance {
    @synchronized(self) {
        if (sharedManager == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
		if (sharedManager == nil) {
			sharedManager = [super allocWithZone:zone];
			return sharedManager;  // assignment and return on first allocation
		}
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
