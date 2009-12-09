//
//  MoodleResultViewController.m
//  WIRemoting
//
//  Created by Felix Huang on 09-12-08.
//  Copyright 2009 Webinit Consulting. All rights reserved.
//

#import "MoodleResultViewController.h"
#import "MoodleExampleAppDelegate.h"
#import "Moodle.h"

@implementation MoodleResultViewController

@synthesize description;

- (id) initWithTitle:(NSString*) aTitle andDescription:(NSString*) aDescription
{
  self = [super initWithStyle:UITableViewStylePlain];
  
  if (nil != self) {
    
    views = [[NSMutableArray alloc] init];
    
    // add sub views
    
    // create a custom navigiation bar button and set it to always back
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    barItem.title = @"Back";
    self.navigationItem.backBarButtonItem = barItem;
    [barItem release];
    
    // set the title of the main view
    self.title = aTitle;
    self.description = aDescription;
    
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // customize
  [self customize];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  moodle = [MoodleExampleAppDelegate instance].moodle;
  [self execute];

}

- (void) customize {}
- (void) execute {}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
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
  if (nil != [[views objectAtIndex:indexPath.row] valueForKey:@"controller"]) {
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  else {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell.textLabel.text = [[views objectAtIndex:indexPath.row] valueForKey:@"title"];
  cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
  cell.detailTextLabel.text = [[views objectAtIndex:indexPath.row] valueForKey:@"description"];
  cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
  
  return cell;
}


// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


- (void) failed:(RMResponse*) response error:(NSError*) error
{
  // create a UIAlertView
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:[error localizedFailureReason]
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];
}

- (void)dealloc {
  self.description = nil;
  [views release];
  [super dealloc];
}


@end

