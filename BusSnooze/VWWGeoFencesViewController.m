//
//  VWWGeoFencesViewController.m
//  BusSnooze
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWGeoFencesViewController.h"
#import "VWWGeoFenceMapViewController.h"
#import "VWWGeoFenceTableViewCell.h"
#import "VWWGeoFence.h"
#import "VWWGeoFencesTableViewCell.h"
#import "VWWLiveViewController.h"

static NSString *VWWGeoFencesViewControllerGeoFencesKey = @"geoFences";
static NSString *VWWSegueGeofencesToMap = @"VWWSegueGeofencesToMap";
static NSString *VWWSegueGeofencesToLive = @"VWWSegueGeofencesToLive";

@interface VWWGeoFencesViewController () <VWWGeoFenceMapViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *geoFences;
@end

@implementation VWWGeoFencesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readGeoFencesFromUserDefaults];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;

    // Deselect all cells
    for(NSUInteger section = 0; section < 2; section++){
        for(NSUInteger row = 0; row < [self.tableView numberOfRowsInSection:section]; row++){
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:NO];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:VWWSegueGeofencesToMap]){
        VWWGeoFenceMapViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    } else if([segue.identifier isEqualToString:VWWSegueGeofencesToLive]){
        VWWLiveViewController *vc = segue.destinationViewController;
        vc.geoFences = sender;
    }
}


-(void)readGeoFencesFromUserDefaults{
    if(self.geoFences){
        [self.geoFences removeAllObjects];
    } else {
        self.geoFences = [@[]mutableCopy];
    }
    
    
    // Load geofences
    NSArray *dictionaries = [[NSUserDefaults standardUserDefaults] objectForKey:VWWGeoFencesViewControllerGeoFencesKey];
    for(NSDictionary *dictionary in dictionaries){
        VWWGeoFence *geoFence = [[VWWGeoFence alloc]initWithDictionary:dictionary];
        [self.geoFences addObject:geoFence];
    }
}


-(void)writeGeoFencesToUserDefaults{
    if(self.geoFences == nil) return;
    
    NSMutableArray *dictionaries = [@[]mutableCopy];
    for(VWWGeoFence *geoFence in self.geoFences){
        NSDictionary *dictionary = [geoFence dictionaryRepresentation];
        [dictionaries addObject:dictionary];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:dictionaries forKey:VWWGeoFencesViewControllerGeoFencesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)addButtonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:VWWSegueGeofencesToMap sender:self];
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.geoFences.count;
    } else if(section == 1){
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        VWWGeoFenceTableViewCell *cell = (VWWGeoFenceTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"VWWGeoFenceTableViewCell" forIndexPath:indexPath];
        cell.geoFence = self.geoFences[indexPath.row];
        return cell;
    } else if(indexPath.section == 1){
        VWWGeoFencesTableViewCell *cell = (VWWGeoFencesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"VWWGeoFencesTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        VWWGeoFence *geoFence = self.geoFences[indexPath.row];
        [self performSegueWithIdentifier:VWWSegueGeofencesToLive sender:@[geoFence]];
    } else if(indexPath.section == 1){
        [self performSegueWithIdentifier:VWWSegueGeofencesToLive sender:self.geoFences];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return YES;
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.geoFences removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


#pragma mark VWWGeoFenceMapViewControllerDelegate
-(void)geoFenceMapViewController:(VWWGeoFenceMapViewController*)sender didAddGeoFence:(VWWGeoFence*)geoFence{
    [self.geoFences addObject:geoFence];
    NSLog(@"self.geoFences.count: %ld", (long)self.geoFences.count);
    NSLog(@"self.geofences: %@", self.geoFences);
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.geoFences.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    [self writeGeoFencesToUserDefaults];
}


@end
