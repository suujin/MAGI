//
//  DetailViewController.m
//  MAGI-00
//
//  Created by Dev on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "Constants.h"
#import "ImageDemoFilledCell.h"
#import "RegexKitLite.h"

#define kScrollCellHeight 320
#define kScrollCellWidth 300

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar=_toolbar;
@synthesize detailItem=_detailItem;
@synthesize detailDescriptionLabel=_detailDescriptionLabel;
@synthesize popoverController=_myPopoverController;
@synthesize topLevelDelegate=_topLevelDelegate;
@synthesize rootNavigationItem=_rootNavigationItem;
@synthesize rootViewController=_rootViewController;
@synthesize referencesTableView = _referencesTableView;
@synthesize imageGridView = _imageGridView;
@synthesize titleLabel = _titleLabel;
@synthesize summaryTextView = _summaryTextView;
@synthesize imageGridViewFiles = _imageGridViewFiles;
@synthesize imageGridViewTitles = _imageGridViewTitles;
@synthesize imageGridViewText = _imageGridViewText;
@synthesize referencesTableViewText = _referencesTableViewText;
@synthesize referencesTableViewAddresses = _referencesTableViewAddresses;

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release];
        _detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    self.detailDescriptionLabel.text = [self.detailItem description];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    barButtonItem.title = @"Results";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *doneItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(doReturnFromSearch:)] autorelease];
    UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil   
                                                                               action:nil] autorelease];
    /* UISegmentedControl *menuControl = [[[UISegmentedControl alloc] initWithItems:
                                        [NSArray arrayWithObjects:ksBiomarkers, ksRisksPrognoses, ksTreatments, ksSummary, nil]] autorelease];
    menuControl.segmentedControlStyle = UISegmentedControlStyleBar;
    menuControl.selectedSegmentIndex = 0;
    [menuControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged]; 
    UIBarButtonItem *controlItem = [[[UIBarButtonItem alloc] initWithCustomView:menuControl] autorelease]; */
    self.rootNavigationItem.title = ksBiomarkers;
    [self.rootViewController updateEntries:0];
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:doneItem atIndex:0];
    [items insertObject:flexItem atIndex:0];
    [self.toolbar setItems:items animated:NO];
    [items release];
    _imageGridViewFiles = [[NSMutableArray alloc] init];
    _imageGridViewTitles = [[NSMutableArray alloc] init];
    _referencesTableViewText = [[NSMutableArray alloc] init];
    _referencesTableViewAddresses = [[NSMutableArray alloc] init];
    if (self.referencesTableViewText.count > 0) [self.referencesTableView setUserInteractionEnabled:YES];
    else [self.referencesTableView setUserInteractionEnabled:NO];
    
    [self setupScrollView];
}

- (void)viewDidUnload
{
    [self setReferencesTableView:nil];
    [self setImageGridView:nil];
    [self setTitleLabel:nil];
    [self setSummaryTextView:nil];
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
    self.toolbar = nil;
    self.detailItem = nil;
    self.detailDescriptionLabel = nil;
    self.rootNavigationItem = nil;
    self.rootViewController = nil;
    self.referencesTableViewAddresses = nil;
    self.referencesTableViewText = nil;
    self.imageGridViewFiles = nil;
    self.imageGridViewTitles = nil;
    self.imageGridViewText = nil;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_myPopoverController release];
    [_toolbar release];
    [_detailItem release];
    [_detailDescriptionLabel release];
    _topLevelDelegate = nil;
    [_rootNavigationItem release];
    [_rootViewController release];
    [_referencesTableView release];
    [_imageGridView release];
    [_titleLabel release];
    [_summaryTextView release];
    [_imageGridViewFiles release];
    [_imageGridViewTitles release];
    [_referencesTableViewAddresses release];
    [_referencesTableViewText release];
    [_imageGridViewText release];
    [super dealloc];
}

#pragma mark - Menu Item Methods

- (void) doReturnFromSearch:(id)sender {
    NSLog(@"Returning from search");
    if (_topLevelDelegate) [_topLevelDelegate returnFromSearch];
}

- (void) segmentedControlIndexChanged:(id)sender {
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case kBiomarkers:
            NSLog(@"biomarkers");
            self.rootNavigationItem.title = ksBiomarkers;
            break;
        case kRisksPrognoses:
            NSLog(@"prognoses");
            self.rootNavigationItem.title = ksRisksPrognoses;
            break;
        case kTreatments:
            NSLog(@"treatments");
            self.rootNavigationItem.title = ksTreatments;
            break;
        case kSummary:
            NSLog(@"summary");
            self.rootNavigationItem.title = ksSummary;
            break;
        default:
            break;
    }
    [self.rootViewController updateEntries:((UISegmentedControl *)sender).selectedSegmentIndex];
    if (self.referencesTableViewText.count > 0) [self.referencesTableView setUserInteractionEnabled:YES];
    else [self.referencesTableView setUserInteractionEnabled:NO];
}

#pragma mark - Interactive Methods

- (void)respond:(id)sender {
    NSLog(@"sender %@", sender);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_referencesTableViewText.count == 0) return 1;
    return _referencesTableViewText.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (_referencesTableViewText.count == 0) 
        cell.textLabel.text = @"[no references]";
    else
        cell.textLabel.text = [_referencesTableViewText objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (BOOL)isLikeURL:(NSString *)string 
{
    return ([string rangeOfString:@"http"].location < [string length]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_referencesTableViewAddresses.count == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    } else {
        NSString *entry = [_referencesTableViewAddresses objectAtIndex:indexPath.row];
        if ([entry hasPrefix:@"http"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_referencesTableViewAddresses objectAtIndex:indexPath.row]]];
        } else {
            for (int i = 0; i < _rootViewController.genes.count; i++) {
                NSString *gene = [_rootViewController.genes objectAtIndex:i];
                if ([gene isEqualToString: entry]) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.rootViewController.tableView deselectRowAtIndexPath:[self.rootViewController.tableView indexPathForSelectedRow] animated:NO];
                    [self.rootViewController.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
                    [self.rootViewController tableView:self.rootViewController.tableView didSelectRowAtIndexPath:path];
                    return;
                }
            }
        }
    }
}

#pragma mark - Scroll View Images

- (void)setupScrollView {
    [_imageGridView setBackgroundColor:[UIColor colorWithRed:.975 green:.975 blue:.975 alpha:1.]];
	[_imageGridView setCanCancelContentTouches:NO];
	_imageGridView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	_imageGridView.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	_imageGridView.scrollEnabled = YES;
	
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	_imageGridView.pagingEnabled = YES;
	
	// load all the images from our bundle and add them to the scroll view
	NSUInteger i;
	for (i = 0; i < _imageGridViewFiles.count; i++)
	{
		UIImage *image = [UIImage imageNamed:[_imageGridViewFiles objectAtIndex:i]];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScrollCellWidth, 35)];
        label.text = [_imageGridViewTitles objectAtIndex:i];
        label.tag = 2*i+2;
		
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		CGRect rect = imageView.frame;
        double scale = MIN(kScrollCellWidth/rect.size.width, kScrollCellHeight/rect.size.height);
        rect.size.height = rect.size.height * scale;
        rect.size.width = rect.size.width * scale;
		imageView.frame = rect;
		imageView.tag = 2*i+1;	// tag our images for later use when we place them in serial fashion
		[_imageGridView addSubview:imageView];
        [_imageGridView addSubview:label];
		[imageView release];
	}
	
    [_imageGridView setDecelerationRate:UIScrollViewDecelerationRateNormal*.6];
	[self layoutScrollImages];	// now place the photos in serial layout within the scrollview
}

- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [_imageGridView subviews];
    
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curYLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]])
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(0, curYLoc);
			view.frame = frame;
			
			curYLoc += (frame.size.height);
		}
        else if ([view isKindOfClass:[UILabel class]]) {
            CGRect frame = view.frame;
            frame.origin = CGPointMake(0, curYLoc);
            view.frame = frame;
            
            curYLoc += (frame.size.height);
        }
	}
	
	// set the content size so it can be scrollable
	[_imageGridView setContentSize:CGSizeMake(kScrollCellWidth, curYLoc + 40)];
}

#pragma mark - Other Methods

- (NSString *)extractReferencesAndReturnRemainder:(NSString *)original {
    NSString *httpMatchString = @"http://\\w*(\\.\\w*)+(/\\w*)*(/\\.\\w*)?";
    NSString *fullMatchString = [NSString stringWithFormat:@"\\[%@ .*\\]", httpMatchString];
    //NSLog(@"full match string is %@", fullMatchString);
    NSRange matchedRange = [original rangeOfRegex:fullMatchString];
    while (matchedRange.location != NSNotFound) {
        //NSLog(@"matched range is %i, %i", matchedRange.location, matchedRange.length);
        NSString *match = [original substringWithRange:matchedRange];
        NSString *httpSubstring = [match stringByMatching:httpMatchString];
        NSString *withoutHttp = [match stringByReplacingOccurrencesOfString:httpSubstring withString:@""];
        NSString *content = [withoutHttp stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[] "]];
        [_referencesTableViewText addObject:content];
        [_referencesTableViewAddresses addObject:httpSubstring];
        original = [[[original substringToIndex:matchedRange.location] 
                    stringByAppendingString:content] 
                    stringByAppendingString:[original substringFromIndex:matchedRange.location+matchedRange.length]];
        matchedRange = [original rangeOfRegex:fullMatchString];
        //NSLog(@"found match: %@", match);
    }
    NSString *geneString = @"\\[\\[gene:\\w*\\]\\]";
    matchedRange = [original rangeOfRegex:geneString];
    NSMutableArray *genes = [[NSMutableArray alloc] init];
    while (matchedRange.location != NSNotFound) {
        NSString *match = [original substringWithRange:matchedRange];
        NSString *gene = [[match stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]] substringFromIndex:5];
        original = [[[original substringToIndex:matchedRange.location] 
                        stringByAppendingString:[NSString stringWithFormat:@"(gene: %@)", gene]] 
                        stringByAppendingString:[original substringFromIndex:matchedRange.location+matchedRange.length]];
        matchedRange = [original rangeOfRegex:geneString];
        if ([self.rootViewController.geneDictionary objectForKey:gene] != nil) {
            [genes addObject:gene];
        }
    }
    [_referencesTableViewText addObjectsFromArray:genes];
    [_referencesTableViewAddresses addObjectsFromArray:genes];
    [genes release];
    return original;
}

- (void) parseFileText:(NSString *)raw {
    NSArray *lines = [raw componentsSeparatedByString:@"\n"];
    for (int i = 0; i < lines.count; i++) {
        NSString *line = [[lines objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // NSLog(@"line: %@", line);
        if ([line isEqualToString:@"#SUMMARY"]) {
           // NSLog(@"summary");
            for (int j = i+1; j < lines.count; j++) {
                NSString *nline = [[lines objectAtIndex:j] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '#[a-zA-Z]*'"];
                if ([predicate evaluateWithObject:nline]) {
                    i = j-1;
                    // NSLog(@"breaking summary");
                    break;
                } else if ([nline isEqualToString:@"##TITLE"]) {
                    _titleLabel.text = [lines objectAtIndex:++j];
                } else if ([nline isEqualToString:@"##TEXT"]) {
                    j++;
                    NSPredicate *hashPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '#.*'"];
                    NSString *text = @"";
                    while (![hashPredicate evaluateWithObject:[lines objectAtIndex:j]]) {
                        text = [text stringByAppendingString:[lines objectAtIndex:j++]];
                    }
                    j--;
                    // NSLog(@"summary view text is %@", text);
                    _summaryTextView.text = [self extractReferencesAndReturnRemainder:text];
                }
            }
        } else if ([line isEqualToString:@"#IMAGE"]) {
            //NSLog(@"image");
            NSString *title = @"";
            NSString *file = @"";
            NSString *text = @"";
            for (int j = i+1; j < lines.count; j++) {
                NSString *nline = [[lines objectAtIndex:j] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '#[a-zA-Z]*'"];
                if ([predicate evaluateWithObject:nline]) {
                    //NSLog(@"breaking");
                    i = j-1;
                    break;
                } else if ([nline isEqualToString:@"##FILE"]) {
                    file = [[lines objectAtIndex:++j] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                } else if ([nline isEqualToString:@"##TITLE"]) {
                    title = [[lines objectAtIndex:++j] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                } else if ([nline isEqualToString:@"##TEXT"]) {
                    text = [[lines objectAtIndex:++j] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                }
            }
            //NSLog(@"name is %@, text %@", title, text);
            [_imageGridViewFiles addObject:[file copy]];
            [_imageGridViewTitles addObject:[title copy]];
            [_imageGridViewText addObject:[text copy]];
        }
        // NSLog(@"files %@, titles %@", _imageGridViewFiles, _imageGridViewTitles);
    }
}

- (void) loadAllForDisease:(NSString *)disease andGene:(NSString *)gene andSNP:(NSString *)snp andMutation:(NSString *)mutation {
    // NSLog(@"disease %@, gene %@, snp %@, mutation %@", disease, gene, snp, mutation);
    NSString *fileContents;
    NSString *fileName;
    NSError *error = nil;
    for (int i = 1; i < 100; i++) {
        [[_imageGridView viewWithTag:i] removeFromSuperview];
    }
    [_imageGridViewFiles removeAllObjects];
    [_imageGridViewTitles removeAllObjects];
    [_referencesTableViewAddresses removeAllObjects];
    [_referencesTableViewText removeAllObjects];
    [_summaryTextView setText:@""];
    // do titleLabel, summaryTextView, referencesTableView, imageGridView
    if ([gene isEqualToString:@""] && [snp isEqualToString:@""] && [mutation isEqualToString:@""]) {
        fileName = [[NSBundle mainBundle] pathForResource:[disease lowercaseString] ofType:@"txt"];
        fileContents = [NSString stringWithContentsOfFile:fileName
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error]; 
        _titleLabel.text = @"Summary";
        [self parseFileText:fileContents];
    } else if ([snp isEqualToString:@""]) {
        // NSLog(@"gene %@", [gene lowercaseString]);
        fileName = [[NSBundle mainBundle] pathForResource:[gene lowercaseString] ofType:@"txt"];
        // NSLog(@"filename %@", fileName);
        fileContents = [NSString stringWithContentsOfFile:fileName
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error]; 
        _titleLabel.text = gene;
        [self parseFileText:fileContents];
    } else {
        // NSLog(@"hi %@", [[gene lowercaseString] stringByAppendingFormat:@"_%@_%@", [disease lowercaseString], [mutation uppercaseString]]);
        fileName = [[NSBundle mainBundle] pathForResource:[[gene lowercaseString] stringByAppendingFormat:@"_%@_%@", [disease lowercaseString], [mutation uppercaseString]]
                                                   ofType:@"txt"];
        // NSLog(@"filename %@", fileName);
        fileContents = [NSString stringWithContentsOfFile:fileName
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error]; 
        _titleLabel.text = [NSString stringWithFormat:@"%@: %@, %@ (%@)", gene, snp, mutation, [[[self.rootViewController.snpDictionary objectForKey:snp] objectForKey:@"alleles"] objectAtIndex:0]];
        [self parseFileText:fileContents];
    }
    // NSLog(@"file %@\ncontents:%@", fileName, fileContents);
    NSLog(@"names %@, titles %@, summary %@", _imageGridViewFiles, _imageGridViewFiles, _summaryTextView.text);
    [self setupScrollView];
    if (self.referencesTableViewText.count > 0) [self.referencesTableView setUserInteractionEnabled:YES];
    else [self.referencesTableView setUserInteractionEnabled:NO];
    [_referencesTableView reloadData];
}

- (void)drillToGene:(NSString *)gene {
    // Just handles the button.
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeLastObject];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                      style:UIBarButtonItemStyleBordered 
                                                                     target:self 
                                                                     action:@selector(backToTopLevel)];
    [items addObject:barButtonItem];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.rootNavigationItem.title = gene;
}

- (void)backToTopLevel {
    // Handles the button in the toolbar and calls the root view controller.
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeLastObject];
    UIBarButtonItem *doneItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(doReturnFromSearch:)] autorelease];
    [items addObject:doneItem];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.rootNavigationItem.title = ksBiomarkers;
    [self.rootViewController backToTopLevel];
}
                                     
                                     
@end
