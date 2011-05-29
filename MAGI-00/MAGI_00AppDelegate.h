//
//  MAGI_00AppDelegate.h
//  MAGI-00
//
//  Created by Dev on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@class RootViewController;
@class DetailViewController;
@class GeneticSelectionViewController;
@class ChromosomeBrowserViewController;
@protocol GeneticSelectionDelegate;

@interface MAGI_00AppDelegate : NSObject <UIApplicationDelegate, GeneticSelectionDelegate, TopLevelDelegate> {
    
    UINavigationItem *_rootNavigationItem;
    NSString *currentSelectionController;
}

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) GeneticSelectionViewController *geneticViewController;
@property (nonatomic, retain) ChromosomeBrowserViewController *chromosomeViewController;
@property (nonatomic, retain) NSDictionary *diseases;
@property (nonatomic, retain) NSDictionary *rsidToGene;
@property (nonatomic, retain) NSDictionary *rsidAlleleToMutation;
@property (nonatomic, retain) IBOutlet UINavigationItem *rootNavigationItem;



@end
