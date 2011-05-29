//
//  ChromosomeBrowserViewController.h
//  MAGI-00
//
//  Created by Dev on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@protocol GeneticSelectionDelegate;

@interface ChromosomeBrowserViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    
    AQGridView *gridView;
    NSArray *gridItems;
    NSArray *gridImages;
    id<GeneticSelectionDelegate> searchDelegate;
    UIImageView *backgroundImageView;
    UIToolbar *toolbar;
    NSDictionary *settings;
}
@property (nonatomic, retain) IBOutlet AQGridView *gridView;
@property (nonatomic, retain) NSArray *gridItems;
@property (nonatomic, retain) NSArray *gridImages;
@property (nonatomic, assign) id<GeneticSelectionDelegate> searchDelegate;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) NSDictionary *settings;

- (void)handleInterfaceRotationForOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)reloadAfterSearch;
- (void)goBack;

@end
