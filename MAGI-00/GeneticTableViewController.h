//
//  GeneticTableViewController.h
//  MAGI-00
//
//  Created by Dev on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GeneticTableViewController : UITableViewController {
    NSMutableArray *docs;
}

@property (nonatomic, retain) NSArray *docs;

- (void) reloadDirectory;
- (NSArray *)linesOfDocumentAtPath:(NSIndexPath *)indexPath;

@end
