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

@implementation GeneticSelectionViewController
@synthesize tableView;
@synthesize toolbar;
@synthesize searchDelegate;
@synthesize geneticTableViewController;
@synthesize gridView;

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
    [gridView release];
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
    
    self.gridView.separatorStyle = AQGridViewCellSeparatorStyleSingleLine;
    self.gridView.resizesCellWidthToFit = YES;
    self.gridView.separatorColor = [UIColor colorWithWhite: 0.85 alpha: 1.0];
    gridView.delegate = self;
    gridView.dataSource = self;
    [gridView reloadData];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:geneticTableViewController selector:@selector(reloadDirectory) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
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
    [self setGridView:nil];
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
#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    // TODO: FIX THIS
    return [SelectionUtility filesDirectoryContents].count;
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    AQGridViewCell * cell = nil;
    NSString *filledCellIdentifier = @"FilledCellIdentifier";
    
    ImageDemoFilledCell * filledCell = (ImageDemoFilledCell *)[aGridView dequeueReusableCellWithIdentifier:filledCellIdentifier];
    if ( filledCell == nil )
    {
        filledCell = [[[ImageDemoFilledCell alloc] initWithFrame: CGRectMake(20.0, 0.0, 100.0, 100.0)
                                                 reuseIdentifier:filledCellIdentifier] autorelease];
        filledCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    NSString *typestr = @"kUTTypeText";
    NSArray *array = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDocumentTypes"];
    for (NSDictionary *dict in array) {
        if ([typestr isEqualToString:[[dict objectForKey:@"LSItemContentTypes"] objectAtIndex:0]])
            filledCell.image = [UIImage imageNamed:[[dict objectForKey:@"CFBundleTypeIconFiles"] objectAtIndex:0]];
    }
    filledCell.title = [[SelectionUtility filesDirectoryContents] objectAtIndex:index];
    
    cell = filledCell;  
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(120.0, 120.0) );
}

#pragma mark -
#pragma mark Grid View Delegate

// nothing here yet

@end
