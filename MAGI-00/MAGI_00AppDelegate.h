//
//  MAGI_00AppDelegate.h
//  MAGI-00
//
//  Created by Dev on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GeneticSelectionViewController;
@class RootViewController;
@class DetailViewController;
@protocol GeneticSelectionSearchDelegate;
@protocol TopLevelDelegate;

@interface MAGI_00AppDelegate : NSObject <UIApplicationDelegate, GeneticSelectionSearchDelegate, TopLevelDelegate> {
    
    UISplitViewController *_splitViewController;
    RootViewController *_rootViewController;
    DetailViewController *_detailViewController;
}
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet GeneticSelectionViewController *geneticViewController;

@end
