//
//  VWWLocationController.m
//  SwiftObjC
//
//  Created by Zakk Hoyt on 6/6/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWLocationController.h"

@interface VWWLocationController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@end

@implementation VWWLocationController

+ (instancetype)sharedInstance{
    static VWWLocationController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VWWLocationController alloc]init];
    });
    return instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _locations = [[NSMutableArray alloc]init];
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    [self.locations addObjectsFromArray:locations];
}


@end
