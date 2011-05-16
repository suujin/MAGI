//
//  GeneticSelectionViewController.h
//  MAGI-00
//
//  Created by Dev on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import <QuartzCore/CAGradientLayer.h>

@class RootViewController;
@class DetailViewController;
@class GeneticTableViewController;

@protocol GeneticSelectionDelegate <NSObject>

- (void)performSearchWithParameters:(NSDictionary *)settings;
- (void)presentChromosomeBrowserWithSettings:(NSDictionary *)settings;

@end

@interface GeneticSelectionViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIToolbar *toolbar;
    id<GeneticSelectionDelegate> searchDelegate;
    UITableView *tableView;
    GeneticTableViewController *geneticTableViewController;
    UIPickerView *pickerView;
    UIButton *searchButton;
    UIButton *importButton;
    UILabel *diseaseLabel;
    UITextView *chromosomeBrowserTextView;
    CAGradientLayer *gradientLayer;
    NSArray *diseasesPickerArray;
    UIButton *chromosomeBrowserButton;
    UIImageView *coverImage;
    UIView *leftSideBackgroundView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) id<GeneticSelectionDelegate> searchDelegate;
@property (nonatomic, retain) GeneticTableViewController *geneticTableViewController;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;
@property (nonatomic, retain) IBOutlet UIButton *importButton;
@property (nonatomic, retain) IBOutlet UILabel *diseaseLabel;
@property (nonatomic, retain) IBOutlet UITextView *chromosomeBrowserTextView;
@property (nonatomic, retain) CAGradientLayer *gradientLayer;
@property (nonatomic, retain) NSArray *diseasesPickerArray;
@property (nonatomic, retain) IBOutlet UIButton *chromosomeBrowserButton;
@property (nonatomic, retain) IBOutlet UIImageView *coverImage;
@property (nonatomic, retain) IBOutlet UIView *leftSideBackgroundView;

- (IBAction)unselectChromosomeBrowser:(id)sender;
- (IBAction)selectChromosomeBrowser:(id)sender;
- (IBAction)performSearch:(id)sender;
- (IBAction)addSNPFile:(id)sender;
- (IBAction)warnOnImport:(id)sender;
- (void)toggleEdit:(id)sender;
- (void)showInfo:(id)sender;
- (void)reloadAfterSearch;

@end
