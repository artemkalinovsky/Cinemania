//
//  CinemaniaDetailViewController.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/12/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Movie;

@interface CinemaniaDetailViewController : UITableViewController

@property (strong, nonatomic) Movie* detailItem;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImage;
@property (weak, nonatomic) IBOutlet UILabel *movieReleaseDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieCastTextField;
@property (weak, nonatomic) IBOutlet UITextView *movieOverviewTextField;

@end
