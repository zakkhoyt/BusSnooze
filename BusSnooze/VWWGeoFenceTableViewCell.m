//
//  VWWGeoFenceTableViewCell.m
//  BusSnooze
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWGeoFenceTableViewCell.h"
#import "VWWGeoFence.h"

@interface VWWGeoFenceTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *enabledSwitch;
@end

@implementation VWWGeoFenceTableViewCell


-(void)setGeoFence:(VWWGeoFence *)geoFence{
    _geoFence = geoFence;
    self.titleLabel.text = _geoFence.title;
    self.enabledSwitch.on = _geoFence.enabled;
}

@end
