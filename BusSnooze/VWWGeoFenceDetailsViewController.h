//
//  VWWGeoFenceDetailsViewController.h
//  BusSnooze
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@class VWWGeoFenceDetailsViewController;
@class VWWGeoFence;

@protocol VWWGeoFenceDetailsViewControllerDelegate <NSObject>
-(void)geoFenceDetailsViewControllerDetailButtonAction:(VWWGeoFenceDetailsViewController*)sender;
-(void)geoFenceDetailsViewControllerDoneButtonAction:(VWWGeoFenceDetailsViewController*)sender;
-(void)geoFenceDetailsViewController:(VWWGeoFenceDetailsViewController*)sender didUpdateSearch:(NSString*)search;
@end

@interface VWWGeoFenceDetailsViewController : UIViewController
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic) BOOL detailsVisible;
@property (nonatomic, weak) id <VWWGeoFenceDetailsViewControllerDelegate> delegate;
@property (nonatomic, strong) VWWGeoFence *geoFence;
-(void)updateTitle:(NSString*)title;
@end
