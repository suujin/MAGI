//
//  ChromosomeBrowserViewController.m
//  MAGI-00
//
//  Created by Dev on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChromosomeBrowserViewController.h"
#import "ImageDemoFilledCell.h"
#import "SelectionUtility.h"
#import "GeneticSelectionViewController.h"

@implementation ChromosomeBrowserViewController
@synthesize gridView;
@synthesize gridItems;
@synthesize searchDelegate;
@synthesize backgroundImageView;
@synthesize toolbar;
@synthesize gridImages;
@synthesize settings;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [gridView release];
    [gridItems release];
    [gridImages release];
    searchDelegate = nil;
    [backgroundImageView release];
    [toolbar release];
    [settings release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)fillGridItems 
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:28];
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:28];
    for (int i = 1; i < 25; i++) {
        if (i == 4) {
            [items addObject:[NSNumber numberWithInt:-1]];
            [items addObject:[NSNumber numberWithInt:-1]];
            [images addObject:[UIImage imageNamed:@"whiteImage.png"]];
            [images addObject:[UIImage imageNamed:@"whiteImage.png"]];
        } else if (i == 16 || i == 21) {
            [items addObject:[NSNumber numberWithInt:-1]];
            [images addObject:[UIImage imageNamed:@"whiteImage.png"]];
        }
        [items addObject:[NSNumber numberWithInt:i]];
        NSString *imgName;
        if (i == 23) imgName = @"chrX.png";
        else if (i == 24) imgName = @"chrY.png";
        else imgName = [NSString stringWithFormat:@"chr%i.png", i];
        UIImage *img = [UIImage imageNamed:imgName];
        [images addObject:img];
    }
    self.gridItems = items;
    self.gridImages = images;
    [items release];
    [images release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do additional setup after loading the view from its nib.
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                          target:nil 
                                                                          action:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, 23)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor colorWithRed:229./255 green:231./255 blue:222./255 alpha:1.0];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textColor = [UIColor colorWithRed:113./255 green:120./255 blue:128./255 alpha:1.0];
    label.text = @"     Chromosome Browser";
    label.font = [UIFont boldSystemFontOfSize:20.0];
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithCustomView:label];
    [label release];
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil 
                                                                           action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(goBack)];
    [self.toolbar setItems:[NSArray arrayWithObjects:flex, title, flex2, done, nil]];
    
    self.gridView.separatorStyle = AQGridViewCellSeparatorStyleSingleLine;
    self.gridView.resizesCellWidthToFit = YES;
    self.gridView.separatorColor = [UIColor colorWithWhite: 0.85 alpha: 1.0];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
    gridView.delegate = self;
    gridView.dataSource = self;
    
    [backgroundImageView setAlpha:.8];
    
    [self fillGridItems];
    [self handleInterfaceRotationForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [gridView reloadData];
}

- (void)viewDidUnload
{
    [self setGridView:nil];
    [self setGridItems:nil];
    [self setGridImages:nil];
    [self setSearchDelegate:nil];
    [self setBackgroundImageView:nil];
    [self setToolbar:nil];
    [self setSettings:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)handleInterfaceRotationForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Handle custom orientation updates here
    NSLog(@"Rotating!");
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        backgroundImageView.image = [UIImage imageNamed:@"helices.png"];
    else
        backgroundImageView.image = [UIImage imageNamed:@"helicesVertical.png"];
    [gridView reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self handleInterfaceRotationForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    NSLog(@"count is %i", gridItems.count);
    return gridItems.count;
}

- (CGRect) getFrameForImageCell {
    return CGRectMake(15., 0., 50., 60.);
    
    NSLog(@"getting frame");
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) 
        return CGRectMake(10., 0., 120., 180.);
    else
        return CGRectMake(10., 0., 160., 140.);
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    NSLog(@"getting for index %i", index);
    AQGridViewCell * cell = nil;
    NSString *filledCellIdentifier = @"FilledCellIdentifier";
    
    ImageDemoFilledCell * filledCell = (ImageDemoFilledCell *)[aGridView dequeueReusableCellWithIdentifier:filledCellIdentifier];
    if ( filledCell == nil )
    {
        filledCell = [[[ImageDemoFilledCell alloc] initWithFrame:[self getFrameForImageCell]
                                                 reuseIdentifier:filledCellIdentifier] autorelease];
        filledCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    filledCell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    NSNumber *val = [gridItems objectAtIndex:index];
    if ([val intValue] > 0) {
        NSString *imgName;
        if ([val intValue] == 23) imgName = @"chrX.png";
        else if ([val intValue] == 24) imgName = @"chrY.png";
        else imgName = [NSString stringWithFormat:@"chr%i.png", [val intValue]];
        filledCell.title  = imgName;
        filledCell.image = [gridImages objectAtIndex:index];
    } else {
        filledCell.title = @"";
    }
    
    cell = filledCell;  
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return CGSizeMake(100., 80.);
    NSLog(@"portrait cell size");
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) 
        return CGSizeMake(100., 160.);
    else
        return CGSizeMake(140., 120.);
}

#pragma mark -
#pragma mark Grid View Delegate


- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index {
    //NSDictionary *settings
}

#pragma mark - Other Methods

- (void) reloadAfterSearch {
    // TODO: fill in
}
 
- (void) goBack {
    [self.searchDelegate returnFromChromosomeBrowser];
}


@end
