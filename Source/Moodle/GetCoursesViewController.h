//
//  GetCoursesViewController.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodleResultViewController.h"

@interface GetCoursesViewController : MoodleResultViewController {
  BOOL mineOnly;
}

@property (assign) BOOL mineOnly;

@end
