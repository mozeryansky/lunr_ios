//
//  TreatTableViewCell.h
//  Lunr iOS
//
//  Created by Michael Ozeryansky on 3/1/15.
//  Copyright (c) 2015 Lunr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView* borderView;
@property (weak, nonatomic) IBOutlet UIView* containerView;

@property (weak, nonatomic) IBOutlet UIImageView* logoImageView;
@property (weak, nonatomic) IBOutlet UILabel* eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* placeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* timeLabel;
@property (weak, nonatomic) IBOutlet UILabel* drivingDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel* categoryLabel;

+ (NSString*)cellIdentifer;

@end
