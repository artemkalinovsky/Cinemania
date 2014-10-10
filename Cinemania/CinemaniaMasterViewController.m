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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

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

-(void) showActivityIndicator
{
    tableViewSeparatorColor=self.tableView.separatorColor;
    self.tableView.separatorColor = [UIColor clearColor];
    overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = overlayView.center;
    [overlayView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [self.tableView addSubview:overlayView];
}

- (void) setDefaults
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

- (void) addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviesLoadComplete:)
                                                 name:MoviesDataControllerMoviesLoadedNotification
                                               object:nil];
}

- (void) moviesLoadComplete:(NSNotification *)data
{
    self.fetchedResultsController = nil;
    self.fetchedResultsController = [[MoviesDataController sharedManager] fetchMovies];
    [self hideActivityIndicator];
    [self.tableView reloadData];
}

-(void) hideActivityIndicator
{
    [activityIndicator stopAnimating];
    [overlayView removeFromSuperview];
    self.tableView.separatorColor=tableViewSeparatorColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch((int)type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
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
    if(y > h + reload_distance) {
        [[MoviesDataController sharedManager] fetchPopularMoviesFromServer];//load more movies from server
    }
}

@end
