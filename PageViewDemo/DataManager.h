//
//  DataManager.h
//  PageViewDemo
//
//  Created by lojsk on 03/07/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DataManager : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

+ (DataManager *)sharedInstance;

@property CLLocationCoordinate2D location;

@end
