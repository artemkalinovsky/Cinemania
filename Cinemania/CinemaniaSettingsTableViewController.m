//
//  CinemaniaSettingsTableViewController.m
//  Cinemania
//
//  Created by Artem Kalinovsky on 11/10/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import "CinemaniaSettingsTableViewController.h"
#import "CinemaniaLanguagesTableViewController.h"

@implementation CinemaniaSettingsTableViewController



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showLanguagesList" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showLanguagesList"])
    {
        NSIndexPath *indexPath = nil;
        //Movie *movie = nil;
        
        if (self.searchDisplayController.active)
        {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
           // movie = [self.filteredMoviesArray objectAtIndex:indexPath.row];
        }
        else
        {
            indexPath = [self.tableView indexPathForSelectedRow];
           // movie = [self.popularMovies objectAtIndex:indexPath.row];
        }
        
        CinemaniaLanguagesTableViewController *destViewController = segue.destinationViewController;
       // destViewController.detailItem = movie;
    }
}

@end
