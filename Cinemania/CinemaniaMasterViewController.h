//
//  CinemaniaMasterViewController.h
//  Cinemania
//
//  Created by Artem Kalinovsky on 9/12/14.
//  Copyright (c) 2014 com.softserve. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface CinemaniaMasterViewController : UITableViewController
/*<NSFetchedResultsControllerDelegate>*/
{
@private
    UIView *overlayView;
    UIActivityIndicatorView* activityIndicator;
    UIColor* tableViewSeparatorColor;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
