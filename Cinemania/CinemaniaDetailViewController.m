//
//  CinemaniaDetailViewController.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/12/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "CinemaniaDetailViewController.h"
#import "Movie.h"
#import "MoviesDataController.h"

@interface CinemaniaDetailViewController ()
@property (strong, nonatomic) MoviesDataController *moviesDataController;
@end

@implementation CinemaniaDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
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
        self.movieReleaseDateLabel.text=[self.detailItem getFormattedReleaseDate:self.detailItem.releaseDate];
        self.moviePosterImage.image=[self.moviesDataController fetchPosterFromDiskWithName:self.detailItem.posterPath];
        if(self.moviePosterImage.image==nil)
        {
            self.moviePosterImage.image=[UIImage imageNamed:@"movie_placeholder"];
        }
        self.movieOverviewTextField.text=self.detailItem.overview;
        self.movieCastTextField.text=[self.detailItem getNamesOfAllActors];
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

- (IBAction)watchTheTrailerButtonClicked:(id)sender
{

   [[UIApplication sharedApplication] openURL:[self.moviesDataController getTrailerUrlForMovie:self.detailItem]];
//           MPMoviePlayerController *moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:urlVideo];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
//            moviePlayer.controlStyle=MPMovieControlStyleDefault;
//           moviePlayer.shouldAutoplay=YES;
//           [self.view addSubview:moviePlayer.view];
//           [moviePlayer setFullscreen:YES animated:YES];

   //     }
   // }
}
//
//- (void) moviePlayBackDidFinish:(NSNotification*)notification
//{
//       MPMoviePlayerController *player = [notification object];
//
//   [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                   name:MPMoviePlayerPlaybackDidFinishNotification object:player];
//
//   if ([player respondsToSelector:@selector(setFullscreen:animated:)])
//   {
//        [player.view removeFromSuperview];
//    }
//}
@end
