//
//  DiseaseTableViewController.h
//  MAGI-00
//
//  Created by Dev on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DiseaseTableViewController : UITableViewController {
    NSArray *diseases;
    UIImageView *coverImage;
}

@property (nonatomic, retain) NSArray *diseases;
@property (nonatomic, retain) UIImageView *coverImage;

@end
