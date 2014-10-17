//
//  CinemaniaMasterViewController.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/12/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


#import "CinemaniaMasterViewController.h"
#import "CinemaniaDetailViewController.h"
#import "MovieTableViewCell.h"
#import "Movie.h"
#import "TMDBMoviesServerStore.h"

@interface CinemaniaMasterViewController ()
@property (strong, nonatomic) NSArray *popularMovies;
@property (strong,nonatomic)  NSMutableArray *filteredMoviesArray;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIColor *tableViewSeparatorColor;
@end

@implementation CinemaniaMasterViewController

- (NSMutableArray *)filteredMoviesArray
{
    if(!_filteredMoviesArray)
        _filteredMoviesArray=[[NSMutableArray alloc] init];
    return _filteredMoviesArray;
}

- (NSArray *)popularMovies
{
    if(!_popularMovies)
        _popularMovies=[[NSArray alloc] init];
    return _popularMovies;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [MoviesDataController sharedManager].delegate=self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
}

- (void)initialize
{
    [self showActivityIndicator];
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
    [[MoviesDataController sharedManager] fetchPopularMoviesFromRemoteStore];
}

- (void)moviesLoadingComplete
{
    self.popularMovies=[[MoviesDataController sharedManager] fetchMoviesFromLocalStore];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.popularMovies.count;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.filteredMoviesArray count];
    }
    else
    {
        return [self.popularMovies count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Movie *movie = nil;
    static NSString *cellIdentifier = @"MovieCell";
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( cell == nil )
    {
        cell = [[MovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
   
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        movie = [self.filteredMoviesArray objectAtIndex:indexPath.row];
    }
    else
    {
        movie = [self.popularMovies objectAtIndex:indexPath.row];
    }
    // Configure the cell
    cell.movieNameLabel.text=movie.originalTitle;
    cell.movieReleaseDateLabel.text=[NSString stringWithFormat:@"%@",[movie getFormattedReleaseDate:movie.releaseDate]];
    cell.movieFanRatingLabel.text=[NSString stringWithFormat:@"Fan Rating: ⭐︎%.1f", movie.voteAverage.floatValue];
    cell.movieRuntimeLabel.text=[movie getFormattedRuntime:movie.runtime];
    
    if([[MoviesDataController sharedManager] fetchPosterFromDiskWithName:movie.posterPath])
    {
        cell.moviePosterImageView.image=[[MoviesDataController sharedManager] fetchPosterFromDiskWithName:movie.posterPath];
    }
    else
    {
        [[TMDBMoviesServerStore sharedManager] fetchMoviePosterWithFileName:movie.posterPath
                                                         usingResponseBlock:^(NSURLResponse *response, NSData *imgData, NSError *error)
         {
             if (imgData)
             {
                 [[MoviesDataController sharedManager] saveAtDiskMoviePoster:imgData withName:movie.posterPath];
                 UIImage *image = [UIImage imageWithData:imgData];
                 if (image)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         MovieTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                         if (updateCell)
                             updateCell.moviePosterImageView.image = image;
                     });
                 }
                 
             }
         }];
    }
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
        Movie *movie = [self.popularMovies objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:movie];
    }
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
        [[MoviesDataController sharedManager] fetchPopularMoviesFromRemoteStore];//load more movies from server
    }
}

- (IBAction)segmentedCategoriesControlValueChanged:(id)sender
{
    NSArray *sortedArray=nil;
    if([self.segmentedCategoriesControl selectedSegmentIndex] == 0)
    {
        sortedArray = [self.popularMovies sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                       {
                           NSDate *first = [(Movie*)a releaseDate];
                           NSDate *second = [(Movie*)b releaseDate];
                           return [second compare:first];
                       }];
        self.popularMovies=sortedArray;
    }
    else if([self.segmentedCategoriesControl selectedSegmentIndex] == 1)
    {
        sortedArray = [self.popularMovies sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
                       {
                           NSNumber *first = [(Movie*)a voteAverage];
                           NSNumber *second = [(Movie*)b voteAverage];
                           return [second compare:first];
                       }];
        self.popularMovies=sortedArray;
        
    }
    [self.tableView reloadData];
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredMoviesArray removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.originalTitle contains %@",searchText];
    self.filteredMoviesArray = [NSMutableArray arrayWithArray:[self.popularMovies filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 100;
}
@end
