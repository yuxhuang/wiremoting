//
//  LoginViewController.h
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodleResultViewController.h"

@interface LoginViewController : MoodleResultViewController {
  NSString *username;
  NSString *password;
}

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end
