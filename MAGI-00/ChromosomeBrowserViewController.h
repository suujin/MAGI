//
//  ChromosomeBrowserViewController.h
//  MAGI-00
//
//  Created by Dev on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface ChromosomeBrowserViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    
    UINavigationBar *navigationBar;
    AQGridView *gridView;
}
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet AQGridView *gridView;

@end
