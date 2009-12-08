//
//  ShowCourseViewController.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodleResultViewController.h"

@interface ShowCourseViewController : MoodleResultViewController {
  NSInteger courseId;
}

@property (assign) NSInteger courseId;

@end
