//
//  MyCell.h
//  Try
//
//  Created by Zhuoran Li on 12/22/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UILabel *toLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *typeImageView;
@property (strong, nonatomic) IBOutlet UIButton *navigationButton;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;

@end
