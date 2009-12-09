//
//  RootViewController.m
//  Untitled
//
//  Created by Felix Huang on 09-12-08.
//  Copyright Webinit Consulting 2009. All rights reserved.
//

#import "RootViewController.h"
#import "WIRemoting.h"
#import "MoodleResultViewController.h"
#import "GetCoursesViewController.h"
#import "LoginViewController.h"
#import "LogoutViewController.h"

@implementation RootViewController

@synthesize views;

- (void) awakeFromNib
{
  MoodleResultViewController *controller;
  
  views = [[NSMutableArray alloc] init];
  
  // add sub views
  // get courses
  controller = [[GetCoursesViewController alloc] initWithTitle:@"All Courses"
                                                andDescription:@"Get all courses from Moodle"];
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"All Courses", @"title",
                    @"Retrieve all courses from the connected Moodle system.", @"description",
                    controller, @"controller",
                    nil]];
  [controller release];

  // get my courses
  GetCoursesViewController *gcvc = [[GetCoursesViewController alloc] initWithTitle:@"My Courses"
                                                andDescription:@"Get my courses from Moodle"];
  gcvc.mineOnly = YES;
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"My Courses", @"title",
                    @"Retrieve my courses.", @"description",
                    gcvc, @"controller",
                    nil]];
  [gcvc release];
  
  // log in as admin
  LoginViewController *lvc = [[LoginViewController alloc] initWithTitle:@"Log In as Admin"
                                            andDescription:@"Log In as the admin user"];
  lvc.username = @"admin";
  lvc.password = @"1234";
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Admin", @"title",
                    @"Log In as Admin User", @"description",
                    lvc, @"controller",
                    nil]];
  [lvc release];
  
  // log in as teacher
  lvc = [[LoginViewController alloc] initWithTitle:@"Log In as Teacher"
                                    andDescription:@"Log In as the teacher user"];
  lvc.username = @"teacher";
  lvc.password = @"teacher";
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Teacher", @"title",
                    @"Log In as Teacher User", @"description",
                    lvc, @"controller",
                    nil]];
  [lvc release];
  
  // log out
  controller = [[LogoutViewController alloc] initWithTitle:@"Log Out"
                                            andDescription:@"Log out from Moodle"];
  [views addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Log Out", @"title",
                    @"Log Out the System", @"description",
                    controller, @"controller",
                    nil]];
  [controller release];
  
  // create a custom navigiation bar button and set it to always back
  UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
  barItem.title = @"Back";
  self.navigationItem.backBarButtonItem = barItem;
  [barItem release];
  
  // set the title of the main view
  self.title = @"Example Functions";
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [views count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc]
             initWithStyle:UITableViewCellStyleSubtitle
             reuseIdentifier:CellIdentifier]
            autorelease];
  }
    
	// Configure the cell.
  cell.selectionStyle = UITableViewCellSelectionStyleGray;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.textLabel.text = [[views objectAtIndex:indexPath.row] valueForKey:@"title"];
  cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
  cell.detailTextLabel.text = [[views objectAtIndex:indexPath.row] valueForKey:@"description"];
  cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];

  return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here -- for example, create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController animated:YES];
	// [anotherViewController release];
  MoodleResultViewController *controller = [[views objectAtIndex:indexPath.row]
                                            objectForKey:@"controller"];
  if (nil != controller) {
    [self.navigationController pushViewController:controller
                                         animated:YES];
  }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
  [views release];
  [super dealloc];
}


@end

