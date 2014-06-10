//
//  VWWGeoFenceDetailsViewController.m
//  BusSnooze
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWGeoFenceDetailsViewController.h"
#import "VWWGeoFence.h"

#import "VWW.h"

@interface VWWGeoFenceDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UISwitch *enabledSwitch;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation VWWGeoFenceDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailsVisible = NO;
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.enabledSwitch.on = self.geoFence.enabled;
    self.titleTextField.text = self.geoFence.title;
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

- (IBAction)detailsButtonTouchUpInside:(id)sender {
    [self.delegate geoFenceDetailsViewControllerDetailButtonAction:self];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    self.geoFence.title = textField.text;
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)doneButtonTouchUpInside:(id)sender {
    [self.delegate geoFenceDetailsViewControllerDoneButtonAction:self];
}

- (IBAction)enabledSwitchValueChanged:(UISwitch*)sender {
    self.geoFence.enabled = sender.on;
}

-(void)updateTitle:(NSString*)title{
    self.titleTextField.text = title;
    self.geoFence.title = title;
}





#pragma UISearchBarDelegate


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.delegate geoFenceDetailsViewController:self didUpdateSearch:searchText];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
