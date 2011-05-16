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

@implementation ChromosomeBrowserViewController
@synthesize navigationBar;
@synthesize gridView;

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
    [navigationBar release];
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
    self.gridView.separatorStyle = AQGridViewCellSeparatorStyleSingleLine;
    self.gridView.resizesCellWidthToFit = YES;
    self.gridView.separatorColor = [UIColor colorWithWhite: 0.85 alpha: 1.0];
    gridView.delegate = self;
    gridView.dataSource = self;
    [gridView reloadData];
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setGridView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
