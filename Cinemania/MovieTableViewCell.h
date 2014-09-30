//
//  MovieTableViewCell.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/15/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRuntimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieReleaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieFanRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRatingLabel;


@end
