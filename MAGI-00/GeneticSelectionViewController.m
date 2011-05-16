//
//  GeneticSelectionViewController.m
//  MAGI-00
//
//  Created by Dev on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeneticSelectionViewController.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "GeneticTableViewController.h"
#import "ImageDemoFilledCell.h"
#import "AQGridViewCell.h"
#import "SelectionUtility.h"
#import <QuartzCore/CAGradientLayer.h>
#import "MAGI_00AppDelegate.h"

@implementation GeneticSelectionViewController
@synthesize tableView;
@synthesize toolbar;
@synthesize searchDelegate;
@synthesize geneticTableViewController;
@synthesize pickerView;
@synthesize searchButton;
@synthesize importButton;
@synthesize diseaseLabel;
@synthesize chromosomeBrowserTextView;
@synthesize gradientLayer;
@synthesize diseasesPickerArray;
@synthesize chromosomeBrowserButton;
@synthesize coverImage;
@synthesize leftSideBackgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [toolbar release];
    self.searchDelegate = nil;
    [tableView release];
    [geneticTableViewController release];
    [pickerView release];
    [searchButton release];
    [importButton release];
    [diseaseLabel release];
    [chromosomeBrowserTextView release];
    [gradientLayer release];
    [diseasesPickerArray release];
    [chromosomeBrowserButton release];
    [coverImage release];
    [leftSideBackgroundView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)setupView:(UIInterfaceOrientation) orientation
{
    CGFloat longBound = MAX(self.view.bounds.size.width, self.view.bounds.size.height) + 20;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], 
                            (id)[[UIColor colorWithRed:12./255 green:66./255 blue:110./255 alpha:1.0] CGColor], nil];
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        // landscape
        NSLog(@"portraitizing");
        gradientLayer.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, longBound, longBound);
    } else if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        // portrait
        NSLog(@"landscaping");
        gradientLayer.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, longBound, longBound);
    } 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do additional setup after loading the view from its nib.
    self.gradientLayer = [CAGradientLayer layer];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    UIBarButtonItem *adder = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                           target:self
                                                                           action:@selector(addSNPFile:)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                          target:nil 
                                                                          action:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, 23)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor colorWithRed:229./255 green:231./255 blue:222./255 alpha:1.0];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textColor = [UIColor colorWithRed:113./255 green:120./255 blue:128./255 alpha:1.0];
    label.text = @"MAGI";
    label.font = [UIFont boldSystemFontOfSize:20.0];
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:label];
    [label release];
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil 
                                                                           action:nil];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                             style:UIBarButtonItemStyleBordered 
                                                            target:self 
                                                            action:@selector(toggleEdit:)];
    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                             style:UIBarButtonItemStyleBordered 
                                                            target:self 
                                                            action:@selector(showInfo:)];
    [self.toolbar setItems:[[NSArray alloc] initWithObjects:adder, flex, title, flex2, edit, info, nil]];
    geneticTableViewController = [[GeneticTableViewController alloc] init];
    geneticTableViewController.view = self.tableView;
    tableView.dataSource = geneticTableViewController;
    tableView.delegate = geneticTableViewController;
    [geneticTableViewController reloadDirectory];
    
    self.diseasesPickerArray = [[[((MAGI_00AppDelegate *)[UIApplication sharedApplication].delegate) diseases] allKeys] 
                                sortedArrayUsingSelector:@selector(compare:)];
    [chromosomeBrowserButton setBackgroundImage:[UIImage imageNamed:@"file_icon.png"] forState:UIControlStateNormal];
    chromosomeBrowserButton.layer.cornerRadius = 5.0;
    chromosomeBrowserButton.layer.masksToBounds = YES;
    chromosomeBrowserButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    chromosomeBrowserButton.layer.borderWidth = 1.0;
    coverImage.layer.cornerRadius = 5.0;
    coverImage.layer.masksToBounds = YES;
    coverImage.hidden = YES;
    
    leftSideBackgroundView.layer.cornerRadius = 5.0;
    leftSideBackgroundView.layer.masksToBounds = YES;
    
    pickerView.layer.cornerRadius = 5.0;
    pickerView.layer.masksToBounds = YES;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:geneticTableViewController selector:@selector(reloadDirectory) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    [self setupView:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)reloadAfterSearch {
    [geneticTableViewController reloadDirectory];
}

- (void)viewDidUnload
{
    [self setSearchDelegate:nil];
    [self setToolbar:nil];
    [self setTableView:nil];
    [self setGeneticTableViewController:nil];
    [self setPickerView:nil];
    [self setSearchButton:nil];
    [self setImportButton:nil];
    [self setDiseaseLabel:nil];
    [self setChromosomeBrowserTextView:nil];
    [self setGradientLayer:nil];
    [self setDiseasesPickerArray:nil];
    [self setChromosomeBrowserButton:nil];
    [self setCoverImage:nil];
    [self setLeftSideBackgroundView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Screen Orientation Handling

- (void)handleInterfaceRotationForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Handle custom orientation updates here
    NSLog(@"Rotating!");
    [self setupView:interfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self handleInterfaceRotationForOrientation:toInterfaceOrientation];
}

- (NSDictionary *)geneticInfo:(NSArray *)lines {
    // TODO: make this stuff work for large files
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSString *line in lines) {
        NSArray *comps = [line componentsSeparatedByString:@"\t"];
        if (comps.count <= 1) continue;
        if (![((NSString *)[comps objectAtIndex:2]) isEqualToString:@"SNP"]) {
            NSLog(@"Not equal");
            continue;
        }
        // chr, feature, SNP, num, num, ., +, ., alleles;other
        NSMutableArray *other = [[[comps objectAtIndex:8] componentsSeparatedByString:@";"] mutableCopy];
        NSString *alleles = [other objectAtIndex:0];
        NSRange ran = [alleles rangeOfString:@"alleles "];
        [other replaceObjectAtIndex:0 withObject:[alleles substringFromIndex:ran.location+ran.length]];
        [dict setObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[comps objectAtIndex:0], [comps objectAtIndex:1], 
                                                             other, nil] 
                                                    forKeys:[NSArray arrayWithObjects:@"chr", @"feature", @"alleles", nil]] 
                 forKey:[comps objectAtIndex:3]];
        [other release];
    }
    return dict;
}

- (IBAction)unselectChromosomeBrowser:(id)sender {
    coverImage.hidden = YES;
}

- (IBAction)selectChromosomeBrowser:(id)sender {
    coverImage.hidden = NO;
}

- (IBAction)performSearch:(id)sender {
    // Perform search here, assuming search parameters and target data set
    NSLog(@"Performing Search");
    NSString *fileContents = [((GeneticTableViewController *)tableView.delegate) documentAtPath:[tableView indexPathForSelectedRow]];
    NSLog(@"File is done reading!");
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    NSLog(@"We have the lines");
    NSDictionary *dict = [self geneticInfo:lines];
    NSLog(@"Finished dictionary formation");
    [self.searchDelegate performSearchWithParameters:dict];
}

- (IBAction)addSNPFile:(id)sender {
}

- (IBAction)warnOnImport:(id)sender {
    UIAlertView *warning = [[UIAlertView alloc] initWithTitle:@"Import File"
                                                      message:@"Unfortunately, the only way currently available to import files is to copy them over through iTunes. Plug in your iPad, go to Apps in the iPad management bar, select MAGI, and drag the files in from your computer."
                                                     delegate:self
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil];
                                                  
    [warning show];
    [warning release];
}

- (void)toggleEdit:(id)sender {
    [tableView setEditing:!tableView.editing animated:YES];
}

- (void)showInfo:(id)sender {
    UIAlertView *info = [[UIAlertView alloc] initWithTitle:@"About MAGI"
                                                   message:@"MAGI is a tool designed to help physicians obtain a quick and convenient summary of a patient's biomarker responses based on their personal genetic information. Designed by Lucas Baker, William Ito, and Jason Wheeler of Stanford University."
                                                  delegate:self
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
    [info show];
    [info release];
}

#pragma mark -
#pragma mark Picker View Methods


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [diseasesPickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    coverImage.hidden = YES;
	return [diseasesPickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    coverImage.hidden = YES;
	NSString *obj = [diseasesPickerArray objectAtIndex:row];
	NSLog(@"Selected Disease: %@. Corresponding object: %@", obj, 
          [[((MAGI_00AppDelegate *)[UIApplication sharedApplication].delegate) diseases] objectForKey:obj]);
}

@end
