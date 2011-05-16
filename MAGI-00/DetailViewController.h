//
//  DetailViewController.h
//  MAGI-00
//
//  Created by Dev on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@protocol TopLevelDelegate

- (void) returnFromSearch;

@optional
- (void) saveSearch:(NSDictionary *)params;

@end

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, assign) id<TopLevelDelegate> topLevelDelegate;
@property (nonatomic, retain) UINavigationItem *rootNavigationItem;
@property (nonatomic, retain) RootViewController *rootViewController;

- (void) doReturnFromSearch:(id)sender;
- (void) segmentedControlIndexChanged:(id)sender;

@end
