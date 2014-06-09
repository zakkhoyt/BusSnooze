//
//  VWWGeoFenceMapViewController.m/Users/zacharyhoyt/Downloads
//  SwiftObjC
//
//  Created by Zakk Hoyt on 6/6/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWGeoFenceMapViewController.h"
#import "VWWLocationController.h"
@import MapKit;
#import "VWW.h"
#import "VWWGeoFence.h"
#import "VWWGeofenceView.h"
#import "VWWGeoFenceDetailsViewController.h"


@interface VWWGeoFenceMapViewController () <MKMapViewDelegate, VWWGeoFenceDetailsViewControllerDelegate>
@property (nonatomic, strong) VWWLocationController *locationController;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) VWWMKUserLocationBlock userLocationBlock;
@property (nonatomic, strong) VWWGeofenceView *geoFenceView;
@property (nonatomic, strong) VWWGeoFenceDetailsViewController *detailsViewController;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) VWWGeoFence *geoFence;
@end

@implementation VWWGeoFenceMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if(self.geoFence == nil){
        self.geoFence = [[VWWGeoFence alloc]init];
    }

    
    _locationController = [VWWLocationController sharedInstance];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self performAfterFindingLocation:^(MKUserLocation *userLocation) {
        [self zoomToLocation:userLocation.location animated:NO];
        [self addGeoFence];
    }];
    
    

    CGFloat w = self.view.bounds.size.width;
    CGFloat h = 193;
    CGFloat x = 0;
    CGFloat y = self.view.bounds.size.height - 44;
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.visualEffectView.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:self.visualEffectView];

    
    self.detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VWWGeoFenceDetailsViewController"];
    self.detailsViewController.delegate = self;
    self.detailsViewController.geoFence = self.geoFence;
    [self.visualEffectView.contentView addSubview:self.detailsViewController.view];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)getNameForMapRegionWithCompletionBlock:(VWWStringBlock)completionBlock{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:self.mapView.centerCoordinate.latitude
                                                     longitude:self.mapView.centerCoordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if(placemarks.count){
                           CLPlacemark *placemark = placemarks[0];
                            if(placemark.thoroughfare){
                               return completionBlock(placemark.thoroughfare);
                           } else if(placemark.subThoroughfare){
                               return completionBlock(placemark.subThoroughfare);
                           } else if(placemark.subLocality){
                               return completionBlock(placemark.subLocality);
                           } else if(placemark.administrativeArea){
                               return completionBlock(placemark.administrativeArea);
                           } else if(placemark.postalCode){
                               return completionBlock(placemark.postalCode);
                           } else if(placemark.ISOcountryCode){
                               return completionBlock(placemark.ISOcountryCode);
                           } else if(placemark.country){
                               return completionBlock(placemark.country);
                           } else if(placemark.inlandWater){
                               return completionBlock(placemark.inlandWater);
                           } else if(placemark.ocean){
                               return completionBlock(placemark.ocean);
                           }
                       }
                   }];
}


-(CLLocationDistance)getMapRadiusForVisibleRect{
    MKMapPoint edgePoint = MKMapPointMake(self.mapView.visibleMapRect.origin.x,
                                          self.mapView.visibleMapRect.origin.y + self.mapView.visibleMapRect.size.height / 2.0);
    
    MKMapPoint centerPoint = MKMapPointMake(self.mapView.visibleMapRect.origin.x + self.mapView.visibleMapRect.size.width / 2.0,
                                            self.mapView.visibleMapRect.origin.y + self.mapView.visibleMapRect.size.height / 2.0);
    
    CLLocationDistance radius =  MKMetersBetweenMapPoints(edgePoint, centerPoint);
    VWW_LOG_INFO(@"Map radius is %fm", radius);
    return radius;
}


- (IBAction)addButtonAction:(id)sender {
//    VWWGeofenceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VWWGeofenceViewController"];
//    [self addChildViewController:vc];
//    [self.view addSubview:vc.view];
//    [vc didMoveToParentViewController:self];
//    
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        self.navigationController.navigationBarHidden = YES;
//    }];
    
    
}

-(IBAction)doneButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}




-(void)addGeoFence{
    VWWGeofenceView *geofence = [[VWWGeofenceView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    geofence.center = self.view.center;
    [self.view addSubview:geofence];

}

- (void)performAfterFindingLocation:(VWWMKUserLocationBlock)userLocationBlock{
    if (self.mapView.userLocation.location != nil) {
        if (userLocationBlock) {
            userLocationBlock(self.mapView.userLocation);
        }
    } else {
        self.userLocationBlock = [userLocationBlock copy];
    }
}


-(void)zoomToLocation:(CLLocation*)location animated:(BOOL)animated{
    VWW_LOG_DEBUG(@"Zooming to location is %f,%f", location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(VWW_COORDINATE_REGION_SPAN, VWW_COORDINATE_REGION_SPAN);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [self.mapView setRegion:region animated:animated];
}


-(void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated{
    VWW_LOG_DEBUG(@"Zooming to location is %f,%f", coordinate.latitude, coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(VWW_COORDINATE_REGION_SPAN, VWW_COORDINATE_REGION_SPAN);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:animated];
}



#pragma mark MapViewDelegate

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    if(self.userLocationBlock){
        self.userLocationBlock(aUserLocation);
        _userLocationBlock = nil;
    }
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    self.geoFence.radius = [self getMapRadiusForVisibleRect];
    self.geoFence.coordinate = self.mapView.centerCoordinate;
    [self getNameForMapRegionWithCompletionBlock:^(NSString *title) {
        [self.detailsViewController updateTitle:title];
        self.geoFence.title = title;
    }];
}


#pragma mark VWWGeoFenceDetailsViewControllerDelegate
-(void)geoFenceDetailsViewControllerDetailButtonAction:(VWWGeoFenceDetailsViewController*)sender{
    if(sender.detailsVisible == NO){
        CGRect frame = self.visualEffectView.frame;
        frame.origin.y = self.view.bounds.size.height - frame.size.height;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.visualEffectView.frame = frame;
        } completion:^(BOOL finished) {
            self.detailsViewController.detailsVisible = YES;
        }];
    } else {
        CGRect frame = self.visualEffectView.frame;
        frame.origin.y = self.view.bounds.size.height - 44;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.visualEffectView.frame = frame;
        } completion:^(BOOL finished) {
            self.detailsViewController.detailsVisible = NO;
        }];
    }
}


-(void)geoFenceDetailsViewControllerDoneButtonAction:(VWWGeoFenceDetailsViewController*)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    
    
    [self.delegate geoFenceMapViewController:self didAddGeoFence:self.geoFence];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
