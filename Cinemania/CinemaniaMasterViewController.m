//
//  CinemaniaMasterViewController.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/12/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "CinemaniaMasterViewController.h"
#import "CinemaniaDetailViewController.h"
#import "MovieTableViewCell.h"
#import "MoviesDataController.h"
#import "Movie.h"

@interface CinemaniaMasterViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIColor *tableViewSeparatorColor;

@end

@implementation CinemaniaMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];

}

- (void)initialize
{
    [self showActivityIndicator];
    [self addObservers];
    [self setDefaults];
}

- (void)showActivityIndicator
{
    self.tableViewSeparatorColor=self.tableView.separatorColor;
    self.tableView.separatorColor = [UIColor clearColor];
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    [self.tableView addSubview:self.overlayView];
}

- (void)setDefaults
{
    if ([[[MoviesDataController sharedManager] getMovies] count] == 0)
    {
        [[MoviesDataController sharedManager] fetchPopularMoviesFromServer];
    }
    else
    {
        NSLog(@"load complete %@", [[MoviesDataController sharedManager] getMovies]);
    }
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviesLoadComplete:)
                                                 name:MoviesDataControllerMoviesLoadedNotification
                                               object:nil];
}

- (void)moviesLoadComplete:(NSNotification *)data
{
    self.fetchedResultsController = nil;
    self.fetchedResultsController = [[MoviesDataController sharedManager] fetchMovies];
    [self hideActivityIndicator];
    [self.tableView reloadData];
}

- (void)hideActivityIndicator
{
    [self.activityIndicator stopAnimating];
    [self.overlayView removeFromSuperview];
    self.tableView.separatorColor=self.tableViewSeparatorColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    Movie *movie=[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.movieNameLabel.text=movie.originalTitle;
    cell.movieReleaseDateLabel.text=[NSString stringWithFormat:@"%@",[movie getFormattedReleaseDate:movie.releaseDate]];
    cell.movieFanRatingLabel.text=[NSString stringWithFormat:@"Fan Rating: ⭐︎%.1f", movie.voteAverage.floatValue];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error])
        {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Movie *movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:movie];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil)
    {
        _fetchedResultsController = [[MoviesDataController sharedManager] fetchMovies];
    }

    return _fetchedResultsController;
}    

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate
{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;

    float reload_distance = 50;
    if(y > h + reload_distance)
    {
        [[MoviesDataController sharedManager] fetchPopularMoviesFromServer];//load more movies from server
    }
}

@end
