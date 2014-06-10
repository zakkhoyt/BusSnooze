//
//  VWWLiveViewController.m
//  BusSnooze
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWLiveViewController.h"
#import "VWW.h"
#import "VWWGeoFence.h"

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

    const NSUInteger kCount = 360;
    
    for(VWWGeoFence *geoFence in self.geoFences){
        CLLocationCoordinate2D coordinates[kCount];
        NSUInteger counter = 0;
        for(NSUInteger index = 0; index < kCount; index++){
            float angle = 2 * M_PI * index / 360.0;
        
            CLLocationDegrees x = geoFence.coordinate.latitude + 0.01 * sin(angle);
            CLLocationDegrees y = geoFence.coordinate.longitude + 0.01 * cos(angle);
            coordinates[index] = CLLocationCoordinate2DMake(x, y);
            VWW_LOG_INFO(@"Adding point for polygon: %ld %f %f,%f", (long)counter++, angle, x, y);
        }
        MKPolygon *worldOverlay = [MKPolygon polygonWithCoordinates:coordinates count:kCount];
        [self.mapView addOverlay:worldOverlay];
    }
    
//    CLLocationCoordinate2D worldCoords[4] = { {-122.368685,37.750941},
//        {-122.466939,37.850926},
//        {-122.568669,37.752687},
//        {-122.470430,37.650957}};
    
//    CLLocationCoordinate2D worldCoords[4] = {
//        {37,-122},
//        {36,-122},
//        {36,-121},
//        {27,-121},
//    };
//    MKPolygon *worldOverlay = [MKPolygon polygonWithCoordinates:worldCoords count:4];
//    [self.mapView addOverlay:worldOverlay];
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
//    MKOverlayRenderer *renderer = [[MKOverlayRenderer alloc]initWithOverlay:overlay];
//    
//    
//    return renderer;
    
    
    if (![overlay isKindOfClass:[MKPolygon class]]) {
        return nil;
    }
    MKPolygon *polygon = (MKPolygon *)overlay;
    MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:polygon];
    renderer.fillColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
    return renderer;
}


@end
