//
//  RootViewController.m
//  MAGI-00
//
//  Created by Dev on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "Constants.h"
#import "MAGI_00AppDelegate.h"

@implementation RootViewController
		
@synthesize detailViewController;
@synthesize entries=_entries;
@synthesize rsidToGene=_rsidToGene;
@synthesize rsidAlleleToMutation=_rsidAlleleToMutation;
@synthesize snpDictionary=_snpDictionary;
@synthesize diseaseCode=_diseaseCode;
@synthesize snps=_snps;
@synthesize mutations=_mutations;
@synthesize genes=_genes;
@synthesize geneDictionary=_geneDictionary;
@synthesize topLevelEntries=_topLevelEntries;
@synthesize topLevelSnps=_topLevelSnps;
@synthesize topLevelGenes=_topLevelGenes;
@synthesize topLevelMutations=_topLevelMutations;
@synthesize currentGeneString=_currentGeneString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    self.currentGeneString = nil;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

		
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _entries.count;
}

		
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    cell.textLabel.text = [_entries objectAtIndex:indexPath.row];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *gene = [_genes objectAtIndex:indexPath.row];
    NSString *snp = [_snps objectAtIndex:indexPath.row];
    NSString *mutation = [_mutations objectAtIndex:indexPath.row];
    NSLog(@"selected at row: %i", indexPath.row);
    NSLog(@"gene %@, mutation %@", gene, mutation);
    if (gene != nil && mutation != nil && ![gene isEqualToString:@""] && [mutation isEqualToString:@""] && 
        (_currentGeneString == nil || ![_currentGeneString isEqualToString:gene])) {
        NSLog(@"accepted gene %@, mutation %@", gene, mutation);
        self.currentGeneString = gene;
        [self drillToGene:[_genes objectAtIndex:indexPath.row]];
    } else {
        [detailViewController loadAllForDisease:_diseaseCode
                                        andGene:gene
                                         andSNP:snp 
                                    andMutation:mutation];
    }
    if ([self.tableView indexPathForSelectedRow] == nil) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    self.detailViewController = nil;
    self.entries = nil;
    self.rsidAlleleToMutation = nil;
    self.rsidToGene = nil;
    self.snpDictionary = nil;
    self.snps = nil;
    self.mutations = nil;
    self.diseaseCode = nil;
    self.genes = nil;
    self.geneDictionary = nil;
    self.topLevelGenes = nil;
    self.topLevelEntries = nil;
    self.topLevelMutations = nil;
    self.topLevelSnps = nil;
    self.currentGeneString = nil;
}

- (void)dealloc
{
    [detailViewController release];
    [_entries release];
    [_rsidToGene release];
    [_rsidAlleleToMutation release];
    [_snpDictionary release];
    [_snps release];
    [_mutations release];
    [_diseaseCode release];
    [_genes release];
    [_geneDictionary release];
    [_topLevelEntries release];
    [_topLevelGenes release];
    [_topLevelMutations release];
    [_topLevelSnps release];
    [_currentGeneString release];
    [super dealloc];
}

#pragma mark - Other Functions

- (void)updateEntries:(int)type {
   /* switch (type) {
        case kBiomarkers:
            self.entries = [NSArray arrayWithObjects:@"SNP1", @"SNP2", nil];
            break;
        case kRisksPrognoses: case kTreatments:
            self.entries = [NSArray arrayWithArray:
                            [[((MAGI_00AppDelegate *)[UIApplication sharedApplication].delegate).diseases allKeys] 
                             sortedArrayUsingSelector:@selector(compare:)]];
            break;
        case kSummary:
            self.entries = [NSArray arrayWithObjects:@"Risks", @"Treatments", @"By Biomarker", nil];
            break;
        default:
            break;
    }*/
    [self.tableView reloadData];
    if ([self.tableView indexPathForSelectedRow] == nil) 
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
}

- (void)performSearchAndDisplayResults {
    // for each SNP and allele, see if it has results in rsidToGene and rsidAlleleToMutation
    // put results in entries
    NSMutableArray *ent = [[NSMutableArray alloc] init];
    NSMutableArray *gen = [[NSMutableArray alloc] init];
    NSMutableArray *snp = [[NSMutableArray alloc] init];
    NSMutableArray *mut = [[NSMutableArray alloc] init];
    NSMutableDictionary *gendict = [[NSMutableDictionary alloc] init];
    [ent addObject:@"Summary"];
    [gen addObject:@""];
    [snp addObject:@""];
    [mut addObject:@""];
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"intValue" ascending:YES];
    for (NSString *snpString in [[_snpDictionary allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]]) {
        //NSDictionary *entry = [_snpDictionary objectForKey:snpString];
        NSArray *genes = [_rsidToGene objectForKey:snpString];
        if (genes == nil) continue;
        for (NSString *gene in genes) {
            if ([gendict objectForKey:gene] == nil) {
                [ent addObject:gene];
                [gen addObject:gene];
                [snp addObject:@""];
                [mut addObject:@""];
                [gendict addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[[[NSMutableArray alloc] initWithObjects:snpString, nil] autorelease] forKey:gene]];
            } else {
                NSMutableArray *arr = [gendict objectForKey:gene];
                [arr addObject:snpString];
            }
            /*NSString *alleleString = [(NSArray *)[entry objectForKey:@"alleles"] objectAtIndex:0];
            NSMutableArray *alleles = [[alleleString componentsSeparatedByString:@"/"] mutableCopy];
            if ([[alleles objectAtIndex:0] isEqualToString:[alleles objectAtIndex:1]]) {
                [alleles removeLastObject];
            }
            for (NSString *allele in alleles) {
                NSString *combined = [snpString stringByAppendingString:allele];
                NSArray *res = [_rsidAlleleToMutation objectForKey:combined];
                if (res == nil) continue;
                for (NSString *mutation in res) {
                    [ent addObject:[gene stringByAppendingFormat:@": %@, %@ (%@)", snpString, mutation, alleleString]];
                    [gen addObject:gene];
                    [snp addObject:snpString];
                    [mut addObject:mutation];
                }
            }
            [alleles release];*/
        }
    }
    [sorter release];
    NSLog(@"entries %@\ngenes %@\nsnp %@\nmut %@", ent, gen, snp, mut);
    self.entries = ent;
    self.topLevelEntries = [[ent mutableCopy] autorelease];
    self.genes = gen;
    self.topLevelGenes = [[gen mutableCopy] autorelease];
    self.snps = snp;
    self.topLevelSnps = [[gen mutableCopy] autorelease];
    self.mutations = mut;
    self.topLevelMutations = [[mut mutableCopy] autorelease];
    self.geneDictionary = gendict;
    [ent release];
    [gen release];
    [snp release];
    [mut release];
    [gendict release];
    [self updateEntries:0];
}

- (void)backToTopLevel {
    self.entries = [[_topLevelEntries mutableCopy] autorelease];
    self.genes = [[_topLevelGenes mutableCopy] autorelease];
    self.snps = [[_topLevelSnps mutableCopy] autorelease];
    self.mutations = [[_topLevelMutations mutableCopy] autorelease];
    self.currentGeneString = nil;
    if ([self.tableView indexPathForSelectedRow].row < _entries.count) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.tableView reloadData];
    [self tableView:self.tableView didSelectRowAtIndexPath:path];
}

- (void)drillToGene:(NSString *)gene {
    NSMutableArray *ent = [[NSMutableArray alloc] init];
    NSMutableArray *gen = [[NSMutableArray alloc] init];
    NSMutableArray *snp = [[NSMutableArray alloc] init];
    NSMutableArray *mut = [[NSMutableArray alloc] init];
    NSArray *snpStrings = [_geneDictionary objectForKey:gene];
    [ent addObject:gene];
    [gen addObject:gene];
    [snp addObject:@""];
    [mut addObject:@""];
    for (NSString *snpString in snpStrings) {
        NSDictionary *entry = [_snpDictionary objectForKey:snpString];
        NSArray *genes = [_rsidToGene objectForKey:snpString];
        if (genes == nil) continue;
        for (NSString *gene in genes) {
            NSString *alleleString = [(NSArray *)[entry objectForKey:@"alleles"] objectAtIndex:0];
            NSMutableArray *alleles = [[alleleString componentsSeparatedByString:@"/"] mutableCopy];
            if ([[alleles objectAtIndex:0] isEqualToString:[alleles objectAtIndex:1]]) {
                [alleles removeLastObject];
            }
            for (NSString *allele in alleles) {
                NSString *combined = [snpString stringByAppendingString:allele];
                NSArray *res = [_rsidAlleleToMutation objectForKey:combined];
                if (res == nil) continue;
                for (NSString *mutation in res) {
                    [ent addObject:[gene stringByAppendingFormat:@": %@, %@ (%@)", snpString, mutation, alleleString]];
                    [gen addObject:gene];
                    [snp addObject:snpString];
                    [mut addObject:mutation];
                }
            }
            [alleles release];
        }
    }
    self.entries = ent;
    self.genes = gen;
    self.snps = snp;
    self.mutations = mut;
    [ent release];
    [gen release];
    [snp release];
    [mut release];
    if ([self.tableView indexPathForSelectedRow].row < _entries.count) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.tableView reloadData];
    [self.detailViewController drillToGene:gene];
    [self tableView:self.tableView didSelectRowAtIndexPath:path];
}

@end
