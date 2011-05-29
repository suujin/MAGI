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
@class DiseaseTableViewController;

@protocol GeneticSelectionDelegate <NSObject>

- (void)performSearchWithDisease:(NSString *)disease withSNPs:(NSDictionary *)snps;
- (void)presentChromosomeBrowserWithSettings:(NSDictionary *)settings;
- (void)returnFromChromosomeBrowser;

@end

@interface GeneticSelectionViewController : UIViewController {
    UIToolbar *toolbar;
    id<GeneticSelectionDelegate> searchDelegate;
    UITableView *tableView;
    UITableView *diseaseTableView;
    GeneticTableViewController *geneticTableViewController;
    DiseaseTableViewController *diseaseTableViewController;
    UIButton *searchButton;
    UIButton *importButton;
    UILabel *diseaseLabel;
    UITextView *chromosomeBrowserTextView;
    CAGradientLayer *gradientLayer;
    UIButton *chromosomeBrowserButton;
    UIImageView *coverImage;
    UIImageView *backgroundImageView;
    UIView *verticalDivider;
    UIView *horizontalDivider;
    UILabel *geneticLabel;
    UILabel *orLabel;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableView *diseaseTableView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) id<GeneticSelectionDelegate> searchDelegate;
@property (nonatomic, retain) GeneticTableViewController *geneticTableViewController;
@property (nonatomic, retain) DiseaseTableViewController *diseaseTableViewController;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;
@property (nonatomic, retain) IBOutlet UIButton *importButton;
@property (nonatomic, retain) IBOutlet UILabel *diseaseLabel;
@property (nonatomic, retain) IBOutlet UITextView *chromosomeBrowserTextView;
@property (nonatomic, retain) CAGradientLayer *gradientLayer;
@property (nonatomic, retain) IBOutlet UIButton *chromosomeBrowserButton;
@property (nonatomic, retain) IBOutlet UIImageView *coverImage;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIView *verticalDivider;
@property (nonatomic, retain) IBOutlet UIView *horizontalDivider;
@property (nonatomic, retain) IBOutlet UILabel *geneticLabel;
@property (nonatomic, retain) IBOutlet UILabel *orLabel;

- (IBAction)unselectChromosomeBrowser:(id)sender;
- (IBAction)selectChromosomeBrowser:(id)sender;
- (IBAction)performSearch:(id)sender;
- (IBAction)warnOnImport:(id)sender;
- (void)toggleEdit:(id)sender;
- (void)showInfo:(id)sender;
- (void)reloadAfterSearch;

@end
