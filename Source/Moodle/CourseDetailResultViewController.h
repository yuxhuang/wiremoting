//
//  CourseDetailResultViewController.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodleResultViewController.h"
#import "WIRemoting.h"

@interface CourseDetailResultViewController : MoodleResultViewController {
  NSInteger courseId;
  SEL selector;
  NSString *arrayType;
  NSString *titleField;
  NSString *descriptionField;
}

@property (assign) NSInteger courseId;
@property (nonatomic, copy) NSString *arrayType;
@property (nonatomic, copy) NSString *titleField;
@property (nonatomic, copy) NSString *descriptionField;
@property (assign) SEL selector;

@end
