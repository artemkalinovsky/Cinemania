//
//  CinemaniaMasterViewController.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/12/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "MoviesDataController.h"
@interface CinemaniaMasterViewController : UITableViewController <MoviesDataControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *moviesSearchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedCategoriesControl;
- (IBAction)segmentedCategoriesControlValueChanged:(id)sender;
@end
