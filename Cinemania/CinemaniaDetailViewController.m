//
//  CinemaniaDetailViewController.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/12/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "CinemaniaDetailViewController.h"
#import "Movie.h"
#import "MoviesDataController.h"
#import "Actor.h"

@interface CinemaniaDetailViewController ()
@property (strong, nonatomic) MoviesDataController *moviesDataController;
@end

@implementation CinemaniaDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    self.tableView.separatorColor = [UIColor clearColor];
    // Update the user interface for the detail item.
    if (self.detailItem)
    {
        self.title=self.detailItem.originalTitle;
        self.movieReleaseDateLabel.text=[NSString stringWithFormat:@"%@",[self.detailItem getFormattedReleaseDate:self.detailItem.releaseDate]];
        self.moviePosterImage.image=[self.moviesDataController fetchPosterFromDiskWithName:self.detailItem.posterPath];
        self.movieOverviewTextField.text=self.detailItem.overview;
        
        NSMutableString *casts=[[NSMutableString alloc]init];
        for (Actor *actor in self.detailItem.actors)
        {
            [casts appendString:[NSString stringWithFormat:@"%@, ",actor.name]];
        }
        self.movieCastTextField.text=[NSString stringWithFormat:@"%@", casts];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.moviesDataController=[[MoviesDataController alloc] init];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
