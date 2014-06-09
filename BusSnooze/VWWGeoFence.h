//
//  VWWGeoFence.h
//  BusSnooze
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//
//  http://hayageek.com/ios-geofencing-api/

#import <Foundation/Foundation.h>
@import CoreLocation;



@interface VWWGeoFence : NSObject

-(instancetype)init;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
-(NSDictionary*)dictionaryRepresentation;
-(BOOL)isLocationInGeoFence:(CLLocationCoordinate2D)coorinate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic) BOOL enabled;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocationDistance radius;

@end
