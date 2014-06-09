//
//  VWWLiveViewController.m
//  BusSnooze
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWLiveViewController.h"
#import "VWW.h"
@import MapKit;

@interface VWWLiveViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) VWWMKUserLocationBlock userLocationBlock;
@end

@implementation VWWLiveViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self performAfterFindingLocation:^(MKUserLocation *userLocation) {
        [self zoomToLocation:userLocation.location animated:NO];
    }];

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




@end
