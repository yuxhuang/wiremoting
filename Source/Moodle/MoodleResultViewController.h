//
//  MoodleResultViewController.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Moodle;

@interface MoodleResultViewController : UITableViewController {
  NSString *description;
  NSMutableArray *views;
  Moodle *moodle;
}

@property (nonatomic, copy) NSString *description;

- (id) initWithTitle:(NSString*) title andDescription:(NSString*) description;
- (void) customize;
- (void) execute;

@end
