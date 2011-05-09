//
//  GeneticSelectionViewController.h
//  MAGI-00
//
//  Created by Dev on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class DetailViewController;

@protocol GeneticSelectionSearchDelegate <NSObject>

- (void)performSearchWithParameters:(NSDictionary *)settings;

@end

@interface GeneticSelectionViewController : UIViewController {
    
    UITableView *dataSelectionTableView;
    UIToolbar *toolbar;
    id<GeneticSelectionSearchDelegate> searchDelegate;
}

@property (nonatomic, retain) IBOutlet UITableView *dataSelectionTableView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) id<GeneticSelectionSearchDelegate> searchDelegate;

- (IBAction)performSearch:(id)sender;
- (IBAction)addSNPFile:(id)sender;
- (void)showInfo:(id)sender;

@end
