//
//  VWWWelcomeCollectionViewCell.m
//  BusSnooze
//
//  Created by Zakk Hoyt on 6/8/14.
//  Copyright (c) 2014 Zakk Hoyt. All rights reserved.
//

#import "VWWWelcomeCollectionViewCell.h"


@interface VWWWelcomeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation VWWWelcomeCollectionViewCell


-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

-(void)setImage:(UIImage *)image{
    self.imageView.image = image;
}



@end
