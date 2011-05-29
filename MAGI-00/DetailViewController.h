//
//  DetailViewController.h
//  MAGI-00
//
//  Created by Dev on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@class RootViewController;

@protocol TopLevelDelegate

- (void) returnFromSearch;

@optional
- (void) saveSearch:(NSDictionary *)params;

@end

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIScrollViewDelegate> {
    UITableView *_referencesTableView;
    UIScrollView *_imageGridView;
    UILabel *_titleLabel;
    UITextView *_summaryTextView;
}


@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, assign) id<TopLevelDelegate> topLevelDelegate;
@property (nonatomic, retain) UINavigationItem *rootNavigationItem;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet UITableView *referencesTableView;
@property (nonatomic, retain) IBOutlet UIScrollView *imageGridView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextView *summaryTextView;
@property (nonatomic, retain) NSMutableArray *imageGridViewFiles;
@property (nonatomic, retain) NSMutableArray *imageGridViewTitles;
@property (nonatomic, retain) NSMutableArray *imageGridViewText;
@property (nonatomic, retain) NSMutableArray *referencesTableViewText;
@property (nonatomic, retain) NSMutableArray *referencesTableViewAddresses;

- (void) doReturnFromSearch:(id)sender;
- (void) segmentedControlIndexChanged:(id)sender;
- (void) respond:(id)sender;
- (void) loadAllForDisease:(NSString *)disease andGene:(NSString *)gene andSNP:(NSString *)snp andMutation:(NSString *)mutation;
- (void) setupScrollView;
- (void) layoutScrollImages;

@end
