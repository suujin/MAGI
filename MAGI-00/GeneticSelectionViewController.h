//
//  GeneticSelectionViewController.h
//  MAGI-00
//
//  Created by Dev on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@class RootViewController;
@class DetailViewController;
@class GeneticTableViewController;

@protocol GeneticSelectionSearchDelegate <NSObject>

- (void)performSearchWithParameters:(NSDictionary *)settings;

@end

@interface GeneticSelectionViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    UIToolbar *toolbar;
    id<GeneticSelectionSearchDelegate> searchDelegate;
    UITableView *tableView;
    GeneticTableViewController *geneticTableViewController;
    AQGridView *gridView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) id<GeneticSelectionSearchDelegate> searchDelegate;
@property (nonatomic, retain) GeneticTableViewController *geneticTableViewController;
@property (nonatomic, retain) IBOutlet AQGridView *gridView;

- (IBAction)performSearch:(id)sender;
- (IBAction)addSNPFile:(id)sender;
- (void)toggleEdit:(id)sender;
- (void)showInfo:(id)sender;
- (void)reloadAfterSearch;

@end
