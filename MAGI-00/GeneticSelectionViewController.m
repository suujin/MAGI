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

@implementation GeneticSelectionViewController
@synthesize dataSelectionTableView;
@synthesize toolbar;
@synthesize searchDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [dataSelectionTableView release];
    [toolbar release];
    self.searchDelegate = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do additional setup after loading the view from its nib.
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
    UIBarButtonItem *info = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                             style:UIBarButtonItemStyleBordered 
                                                            target:self 
                                                            action:@selector(showInfo:)];
    [self.toolbar setItems:[[NSArray alloc] initWithObjects:adder, flex, title, flex2, info, nil]];
}

- (void)viewDidUnload
{
    [self setDataSelectionTableView:nil];
    [self setSearchDelegate:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Screen Orientation Handling

- (void)handleInterfaceRotationForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Handle custom orientation updates here
    NSLog(@"Rotating!");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self handleInterfaceRotationForOrientation:toInterfaceOrientation];
}

- (IBAction)performSearch:(id)sender {
    // Perform search here, assuming search parameters and target data set
    NSLog(@"Performing Search");
    [self.searchDelegate performSearchWithParameters:[[NSDictionary alloc] init]];
}

- (IBAction)addSNPFile:(id)sender {
    NSLog(@"Adding SNP File");
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

@end
