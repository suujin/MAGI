//
//  MAGI_00AppDelegate.m
//  MAGI-00
//
//  Created by Dev on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MAGI_00AppDelegate.h"

#import "RootViewController.h"
#import "ChromosomeBrowserViewController.h"
#import "GeneticSelectionViewController.h"
#import "GeneticTableViewController.h"
#import "DetailViewController.h"

#define kGeneticSelectionController @"GeneticSelectionController"
#define kChromosomeBrowserController @"ChromosomeBrowserController"

@implementation MAGI_00AppDelegate

@synthesize splitViewController = _splitViewController;
@synthesize rootViewController = _rootViewController;
@synthesize detailViewController = _detailViewController;
@synthesize window = _window;
@synthesize diseases = _diseases;
@synthesize rootNavigationItem = _rootNavigationItem;
@synthesize geneticViewController=_geneticViewController;
@synthesize chromosomeViewController=_chromosomeViewController;
@synthesize rsidToGene = _rsidToGene;
@synthesize rsidAlleleToMutation = _rsidAlleleToMutation;


- (void)loadRsidAlleleToMutation {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    @synchronized(_rsidAlleleToMutation) {
        NSString *mutationPath = [[NSBundle mainBundle] pathForResource:@"rsidAlleleToMutation" ofType:nil];
        NSError *error = nil;
        NSString *contents = [NSString stringWithContentsOfFile:mutationPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
        if (error != nil) {
            NSLog(@"Error! Could not rsID/allele to mutation file %@: %@", mutationPath, [error localizedDescription]);
        }
        NSArray *lines = [contents componentsSeparatedByString:@"\n"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (NSString *line in lines) {
            NSArray *comps = [line componentsSeparatedByString:@","];
            [dict setObject:[comps objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, comps.count-2)]]
                     forKey:[(NSString *)[comps objectAtIndex:0] stringByAppendingString:[comps objectAtIndex:1]]];
        }
        _rsidAlleleToMutation = [[NSDictionary alloc] initWithDictionary:dict];
        [dict release];
    }
    NSLog(@"rsID allele to mutation: %@", _rsidAlleleToMutation);
    [pool release];
}

- (void)loadRsidToGene {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    @synchronized(_rsidToGene) {
        NSString *genePath = [[NSBundle mainBundle] pathForResource:@"rsidToGene" ofType:nil];
        NSError *error = nil;
        NSString *contents = [NSString stringWithContentsOfFile:genePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
        if (error != nil) {
            NSLog(@"Error! Could not rsID to gene file %@: %@", genePath, [error localizedDescription]);
        }
        NSArray *lines = [contents componentsSeparatedByString:@"\n"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        for (NSString *line in lines) {
            NSArray *comps = [line componentsSeparatedByString:@","];
            [dict setObject:[comps objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, comps.count-1)]]
                     forKey:[comps objectAtIndex:0]];
        }
        _rsidToGene = [[NSDictionary alloc] initWithDictionary:dict];
        [dict release];
    }

    NSLog(@"rsidtogene %@", _rsidToGene);
    [pool release];
}

- (void)loadDiseases {
    NSString *diseasesPath = [[NSBundle mainBundle] pathForResource:@"diseases" ofType:nil];
    NSError *error = nil;
    NSString *contents = [NSString stringWithContentsOfFile:diseasesPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
    if (error != nil) {
        NSLog(@"Error! Could not diseases file %@: %@", diseasesPath, [error localizedDescription]);
    }
    NSArray *lines = [contents componentsSeparatedByString:@"\n"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSString *line in lines) {
        NSArray *comps = [line componentsSeparatedByString:@","];
        NSMutableDictionary *compDict = [[NSMutableDictionary alloc] init];
        NSString *title = [comps objectAtIndex:0];
        for (NSString *comp in comps) {
            NSArray *parts = [comp componentsSeparatedByString:@":"];
            if (parts.count > 1) [compDict setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]]; 
        }
        [dict setObject:compDict forKey:title];
        [compDict release];
    }
    _diseases = [[NSDictionary alloc] initWithDictionary:dict];
    [dict release];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the split view controller's view to the window and display.
    if (self.geneticViewController == nil) {
        self.geneticViewController = [[[GeneticSelectionViewController alloc] initWithNibName:@"GeneticSelectionViewController" 
                                                                                       bundle:[NSBundle mainBundle]] autorelease];
    }
    
    if (self.chromosomeViewController == nil) {
        self.chromosomeViewController = [[[ChromosomeBrowserViewController alloc] initWithNibName:@"ChromosomeBrowserViewController" 
                                                                                           bundle:[NSBundle mainBundle]] autorelease];
    }
    
    [self loadDiseases];
    
    NSThread *rsidToGeneThread = [[NSThread alloc] initWithTarget:self selector:@selector(loadRsidToGene) object:nil];
    NSThread *rsidAlleleToMutationThread = [[NSThread alloc] initWithTarget:self selector:@selector(loadRsidAlleleToMutation) object:nil];
    [rsidToGeneThread start];
    [rsidAlleleToMutationThread start];
    
    self.window.rootViewController = self.geneticViewController;
    [self.geneticViewController setSearchDelegate:self];
    [self.chromosomeViewController setSearchDelegate:self];
    currentSelectionController = kGeneticSelectionController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_geneticViewController release];
    [_splitViewController release];
    [_rootViewController release];
    [_detailViewController release];
    [_diseases release];
    [_rootNavigationItem release];
    [_rsidToGene release];
    [_rsidAlleleToMutation release];
    [super dealloc];
}

#pragma mark - Genetic Selection Delegate

- (void)performSearchWithDisease:(NSString *)disease withSNPs:(NSDictionary *)snps {
    NSLog(@"Performing search");
    self.detailViewController.topLevelDelegate = self;
    self.detailViewController.rootNavigationItem = self.rootNavigationItem;
    self.detailViewController.rootViewController = _rootViewController;
    self.rootViewController.detailViewController = _detailViewController;
    self.window.rootViewController = self.splitViewController;
    @synchronized(_rsidToGene) {
        @synchronized(_rsidAlleleToMutation) {
            self.rootViewController.rsidToGene = _rsidToGene;
            self.rootViewController.rsidAlleleToMutation = _rsidAlleleToMutation;
            self.rootViewController.snpDictionary = snps;
            self.rootViewController.diseaseCode = [(NSDictionary *)[_diseases objectForKey:disease] objectForKey:@"code"];
            NSLog(@"starting search");
        }
    }
    [self.rootViewController performSearchAndDisplayResults];
}

- (void)presentChromosomeBrowserWithSettings:(NSDictionary *)settings {
    NSLog(@"Presenting chromosome browser");
    currentSelectionController = kChromosomeBrowserController;
    self.window.rootViewController = self.chromosomeViewController;
    self.chromosomeViewController.settings = settings;
}

- (void)returnFromChromosomeBrowser {
    currentSelectionController = kGeneticSelectionController;
    self.window.rootViewController = self.geneticViewController;
    [self.geneticViewController reloadAfterSearch];
}

#pragma mark - Top Level Delegate

- (void)returnFromSearch {
    NSLog(@"Returning from search!");
    if (currentSelectionController == kGeneticSelectionController) {
        self.window.rootViewController = self.geneticViewController;
        [self.geneticViewController reloadAfterSearch];
    } else if (currentSelectionController == kChromosomeBrowserController) {
        self.window.rootViewController = self.chromosomeViewController;
        [self.chromosomeViewController reloadAfterSearch];
    }
}

@end
