//
//  SelectionUtility.m
//  MAGI-00
//
//  Created by Dev on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectionUtility.h"


@implementation SelectionUtility

+ (NSArray *)filesDirectoryContents {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSArray *files = [manager contentsOfDirectoryAtPath:documentsPath error:nil];
    [manager release];
    return files;
}

@end
