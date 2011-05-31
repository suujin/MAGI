//
//  RootViewController.h
//  MAGI-00
//
//  Created by Dev on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
}

		
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSArray *topLevelEntries;
@property (nonatomic, retain) NSArray *entries;
@property (nonatomic, retain) NSString *diseaseCode;
@property (nonatomic, retain) NSDictionary *geneDictionary;
@property (nonatomic, retain) NSArray *genes;
@property (nonatomic, retain) NSArray *topLevelGenes;
@property (nonatomic, retain) NSArray *snps;
@property (nonatomic, retain) NSArray *topLevelSnps;
@property (nonatomic, retain) NSArray *mutations;
@property (nonatomic, retain) NSArray *topLevelMutations;
@property (nonatomic, retain) NSDictionary *rsidToGene;
@property (nonatomic, retain) NSDictionary *rsidAlleleToMutation;
@property (nonatomic, retain) NSDictionary *snpDictionary;
@property (nonatomic, retain) NSString *currentGeneString;

- (void)performSearchAndDisplayResults;
- (void)updateEntries:(int)type;
- (void)backToTopLevel;
- (void)drillToGene:(NSString *)gene;

@end
