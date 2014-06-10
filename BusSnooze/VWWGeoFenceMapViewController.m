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


@interface VWWGeoFenceMapViewController () <MKMapViewDelegate, VWWGeoFenceDetailsViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) VWWLocationController *locationController;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) VWWMKUserLocationBlock userLocationBlock;
@property (nonatomic, strong) VWWGeofenceView *geoFenceView;
@property (nonatomic, strong) VWWGeoFenceDetailsViewController *detailsViewController;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) VWWGeoFence *geoFence;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) BOOL hasLoaded;
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
    CGFloat h = 215;
    CGFloat x = 0;
    CGFloat y = 64 - 215;
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.visualEffectView.frame = CGRectMake(x, y, w, h);
    [self.view addSubview:self.visualEffectView];

    
    self.detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VWWGeoFenceDetailsViewController"];
    self.detailsViewController.delegate = self;
    self.detailsViewController.geoFence = self.geoFence;
    self.detailsViewController.mapView = self.mapView;
    [self.visualEffectView.contentView addSubview:self.detailsViewController.view];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if(self.hasLoaded == NO){
        self.hasLoaded = YES;
        CGFloat x = 0;
        CGFloat y = 215;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height - 215;
        CGRect frame = CGRectMake(x, y, w, h);
        
        self.searchResults = [@[]mutableCopy];
        self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.alpha = 0.0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
    }
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
    self.geoFenceView = [[VWWGeofenceView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    self.geoFenceView.center = self.view.center;
    [self.view addSubview:self.geoFenceView];

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


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    MKMapItem *item = self.searchResults[indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}




#pragma mark VWWGeoFenceDetailsViewControllerDelegate
-(void)geoFenceDetailsViewControllerDetailButtonAction:(VWWGeoFenceDetailsViewController*)sender{
    if(sender.detailsVisible == NO){
        CGRect frame = self.visualEffectView.frame;
        frame.origin.y = 0;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.visualEffectView.frame = frame;
            self.tableView.alpha = 1.0;
            self.geoFenceView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.detailsViewController.detailsVisible = YES;
        }];
    } else {
        CGRect frame = self.visualEffectView.frame;
        frame.origin.y = 64 - 215;
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.visualEffectView.frame = frame;
            self.tableView.alpha = 0.0;
            self.geoFenceView.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.detailsViewController.detailsVisible = NO;
        }];
    }
}


-(void)geoFenceDetailsViewControllerDoneButtonAction:(VWWGeoFenceDetailsViewController*)sender{
    [self.delegate geoFenceMapViewController:self didAddGeoFence:self.geoFence];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)geoFenceDetailsViewController:(VWWGeoFenceDetailsViewController*)sender didUpdateSearch:(NSString*)searchText{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchText;
    request.region = self.mapView.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        [self.searchResults removeAllObjects];
        [self.searchResults addObjectsFromArray:response.mapItems];
        [self.tableView reloadData];
    }];
}


@end
