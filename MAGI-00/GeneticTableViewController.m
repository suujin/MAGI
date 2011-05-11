//
//  GeneticTableViewController.m
//  MAGI-00
//
//  Created by Dev on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeneticTableViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <MobileCoreServices/UTType.h>
#import "SelectionUtility.h"

@implementation GeneticTableViewController

@synthesize docs;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void) reloadDirectory {
    NSArray *files = [SelectionUtility filesDirectoryContents];
    @synchronized(docs) {
        if (docs.count != files.count) {
            self.docs = [[files mutableCopy] autorelease];
            [self.tableView reloadData];
        }
    }
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
    return docs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [docs objectAtIndex:indexPath.row];
    NSString *typestr = @"kUTTypeText";
    NSArray *array = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDocumentTypes"];
    for (NSDictionary *dict in array) {
        if ([typestr isEqualToString:[[dict objectForKey:@"LSItemContentTypes"] objectAtIndex:0]])
            cell.imageView.image = [UIImage imageNamed:[[dict objectForKey:@"CFBundleTypeIconFiles"] objectAtIndex:0]];
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.editing;
}

- (NSString *)documentAtPath:(NSIndexPath *)indexPath {
    NSString *name = [docs objectAtIndex:indexPath.row];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *contents = [NSString stringWithContentsOfFile:[documentsPath stringByAppendingPathComponent:name]
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
    // TODO: load the file contents correctly for large files
    if (error != nil) {
        NSLog(@"Error! Could not load file %@: %@", name, [error localizedDescription]);
    }
    return contents;
}

- (void)deleteDocument:(NSIndexPath *)indexPath {
    NSString *name = [docs objectAtIndex:indexPath.row];
    [docs removeObjectAtIndex:indexPath.row];
    NSFileManager *fileMgr = [[[NSFileManager alloc] init] autorelease];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    BOOL res = [fileMgr removeItemAtPath:[documentsPath stringByAppendingPathComponent:name] error:&error];
    if (error != nil || !res) {
        NSLog(@"Error! Could not remove file: %@", [error localizedDescription]);
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteDocument:indexPath];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Do nothing
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    int from = fromIndexPath.row;
    int to = toIndexPath.row;
    NSString *fromDoc = [docs objectAtIndex:from];
    [docs removeObjectAtIndex:from];
    [docs insertObject:fromDoc atIndex:to];
    [tableView reloadData];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.editing;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: nice custom cell that indicates selection
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
