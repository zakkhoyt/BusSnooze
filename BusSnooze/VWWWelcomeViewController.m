//
//  VWWWelcomeViewController.m
//  BusSnooze
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWWelcomeViewController.h"
#import "VWWLocationController.h"
#import "VWW.h"
#import "NSTimer+Blocks.h"
#import "VWWWelcomeCollectionViewCell.h"

static NSString *VWWWelcomeViewControllerTitleKey = @"title";
static NSString *VWWWelcomeViewControllerImageKey = @"image";

@interface VWWWelcomeViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) VWWLocationController *locationController;
@property (nonatomic, strong) UIAlertView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *content;
@end

@implementation VWWWelcomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.locationController = [VWWLocationController sharedInstance];
    
    self.content = @[@{VWWWelcomeViewControllerTitleKey : @"Never miss your bus stop again"},
                     @{VWWWelcomeViewControllerTitleKey : @"Setup a geo-fence on a map (and other optionals)"},
                     @{VWWWelcomeViewControllerTitleKey : @"Sit back and space out. Hell, take a nap. We'll let you know when you enter the geofence"}];
                     
    self.pageControl.numberOfPages = self.content.count;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:VWWNotificationApplicationDidBecomeActive
                                               object:nil];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.nextButton.alpha = 0.0;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    VWW_LOG_TRACE;
    [self verifyCoreLocationAccess];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)applicationDidBecomeActive{
    [self verifyCoreLocationAccess];
}

-(void)verifyCoreLocationAccess{
    __weak VWWWelcomeViewController *weakSelf = self;
    [self.locationController setChangeSettingsBlock:^{
        if(weakSelf.alertView == nil){
            weakSelf.alertView = [[UIAlertView alloc]initWithTitle:@"Permission problem"
                                                       message:@"In order for this app to work you must allow access to your location at all times. Press okay to go to the settings page. Navigate to \'Privacy -> Location Services\', then select Always. Return to this app afterwards"
                                                      delegate:weakSelf
                                             cancelButtonTitle:@"Okay"
                                             otherButtonTitles:nil, nil];
            [weakSelf.alertView show];
        }
    }];
    
    if([self.locationController verifyCoreLocationAccess] == YES){
        [UIView animateWithDuration:0.2 animations:^{
            self.nextButton.alpha = 1.0;
        }];
    }
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

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return self.content.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VWWWelcomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VWWWelcomeCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    NSDictionary *content = self.content[indexPath.item];
    NSString *title = content[VWWWelcomeViewControllerTitleKey];
    UIImage *image = content[VWWWelcomeViewControllerImageKey];
    cell.title = title;
    cell.image = image;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.bounds.size;
}


//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
//                     withVelocity:(CGPoint)velocity
//              targetContentOffset:(inout CGPoint *)targetContentOffset{
//    
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
//                  willDecelerate:(BOOL)decelerate{
//    
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    VWW_LOG_TRACE;
    
    NSInteger page = (self.collectionView.bounds.size.width / 2.0 + self.collectionView.contentOffset.x) / self.collectionView.bounds.size.width;
    self.pageControl.currentPage = page;
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [NSTimer scheduledTimerWithTimeInterval:0.1 block:^{
        self.alertView = nil;
        VWW_LOG_INFO(@"Oxpening app's settings page");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } repeats:NO];
    
}

@end
