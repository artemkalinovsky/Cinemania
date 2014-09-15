//
//  CinemaniaDetailViewController.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/12/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Movie;

@interface CinemaniaDetailViewController : UIViewController

@property (strong, nonatomic) Movie* detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
