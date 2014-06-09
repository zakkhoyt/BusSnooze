//
//  VWWGeoFence.m
//  BusSnooze
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWGeoFence.h"
#import "VWW.h"

static NSString *VWWGeoFenceTitleKey = @"title";
static NSString *VWWGeoFenceEnabledKey = @"enabled";
static NSString *VWWGeoFenceLatitudeKey = @"latitude";
static NSString *VWWGeoFenceLongitudeKey = @"longitude";
static NSString *VWWGeoFenceRadiusKey = @"radius";


@interface VWWGeoFence ()

@end


@implementation VWWGeoFence


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enabled = YES;
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    if(self){
        self.title = dictionary[VWWGeoFenceTitleKey];
        NSNumber *enabled = dictionary[VWWGeoFenceEnabledKey];
        self.enabled = enabled.integerValue == 0 ? NO : YES;
        NSNumber *latitude = dictionary[VWWGeoFenceLatitudeKey];
        NSNumber *longitude = dictionary[VWWGeoFenceLongitudeKey];
        if(latitude && longitude){
            self.coordinate = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
        } else {
            VWW_LOG_WARNING(@"Not enough dictionary info to make coordinate");
        }
        NSNumber *radius = dictionary[VWWGeoFenceRadiusKey];
        self.radius = radius.doubleValue;
    }
    return self;
}
-(NSDictionary*)dictionaryRepresentation{
    NSMutableDictionary *dictionary = [@{}mutableCopy];
    if(self.title){
        dictionary[VWWGeoFenceTitleKey] = self.title;
    } else {
        VWW_LOG_WARNING(@"Can't set title in dictionary");
    }
    dictionary[VWWGeoFenceEnabledKey] = @(self.enabled ? 1 : 0);
    dictionary[VWWGeoFenceLatitudeKey] = @(self.coordinate.latitude);
    dictionary[VWWGeoFenceLongitudeKey] = @(self.coordinate.longitude);
    dictionary[VWWGeoFenceRadiusKey] = @(self.radius);
    return dictionary;
}


-(BOOL)isLocationInGeoFence:(CLLocationCoordinate2D)coorinate{
    VWW_LOG_TODO;
    return NO;
}



@end
