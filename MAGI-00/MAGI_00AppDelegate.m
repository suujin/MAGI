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

@implementation MAGI_00AppDelegate

@synthesize splitViewController = _splitViewController;
@synthesize rootViewController = _rootViewController;
@synthesize detailViewController = _detailViewController;
@synthesize window = _window;
@synthesize diseases = _diseases;
@synthesize rootNavigationItem = _rootNavigationItem;
@synthesize geneticViewController=_geneticViewController;
@synthesize chromosomeViewController=_chromosomeViewController;

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
    
    self.window.rootViewController = self.geneticViewController;
    [self.geneticViewController setSearchDelegate:self];
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
    [super dealloc];
}

#pragma mark - Genetic Selection Delegate

- (void)performSearchWithParameters:(NSDictionary *)settings {
    NSLog(@"Performing search with parameters: %@", settings);
    self.detailViewController.topLevelDelegate = self;
    self.detailViewController.rootNavigationItem = self.rootNavigationItem;
    self.detailViewController.rootViewController = _rootViewController;
    self.rootViewController.detailViewController = _detailViewController;
    self.window.rootViewController = self.splitViewController;
}

- (void)presentChromosomeBrowserWithSettings:(NSDictionary *)settings {
    NSLog(@"Presenting chromosome browser");
}

#pragma mark - Top Level Delegate

- (void)returnFromSearch {
    NSLog(@"Returning from search!");
    self.window.rootViewController = self.geneticViewController;
    [self.geneticViewController reloadAfterSearch];
}

@end
