//
//  MainMenuViewController.m
//  dice3d
//
//  Created by Radif Sharafullin on 6/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"


@implementation MainMenuViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	self.view.backgroundColor=[UIColor blackColor];
	mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(20,00,150,320) style:UITableViewStyleGrouped];
	mainTableView.delegate = self;
	mainTableView.dataSource = self;
	mainTableView.bounces=NO;
	mainTableView.alpha=.9f;
	mainTableView.backgroundColor=[UIColor clearColor];
	
	mainTableView.scrollEnabled = YES;
	
	[self.view addSubview:mainTableView];
	
	
	
	
	playControlButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	playControlButton.frame = CGRectMake(240, 150, 100, 40);
	playControlButton.backgroundColor = [UIColor whiteColor];
	playControlButton.showsTouchWhenHighlighted=YES;
	[playControlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[playControlButton setTitle:@"Roll" forState:UIControlStateNormal];
	[playControlButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:playControlButton];
	
	infoButton = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
	infoButton.frame = CGRectMake(435, 275, 20, 20);
	//infoButton.backgroundColor = [UIColor whiteColor];
	infoButton.showsTouchWhenHighlighted=YES;
	//[infoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[infoButton setTitle:@"Roll" forState:UIControlStateNormal];
	[infoButton addTarget:self action:@selector(displayInfo) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:infoButton];
	
	
}

-(void)displayInfo{


}

-(void)startGame{

	[[[UIApplication sharedApplication]delegate] loadGame];

}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[playControlButton release];
	[infoButton release];
	[mainTableView release];
    [super dealloc];
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section==0) return 3;
	if (section==1) return 1;
	
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	//cell.selectionStyle=UITableViewCellSelectionStyleGray;

	
	//How Many Dice?
	//numberOfDice=[[NSString stringWithFormat:@"%@", [[[UIApplication sharedApplication] delegate] getMyettingsforElementNumber:1]]intValue];
		
	
	
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	if(indexPath.section==0){
	switch (indexPath.row) {
		case 0:
			if ([[NSString stringWithFormat:@"%@", [[[UIApplication sharedApplication] delegate] getMyettingsforElementNumber:0]] isEqual:@"Numbers"]){
			
				cell.accessoryType=UITableViewCellAccessoryCheckmark;
			}
			else
			{
				cell.accessoryType=UITableViewCellAccessoryNone;
			}
			cell.text=@"Numbers";
			
			break;
		case 1:
			if ([[NSString stringWithFormat:@"%@", [[[UIApplication sharedApplication] delegate] getMyettingsforElementNumber:0]] isEqual:@"Letters"]){
				
				cell.accessoryType=UITableViewCellAccessoryCheckmark;
			}
			else
			{
				cell.accessoryType=UITableViewCellAccessoryNone;
			}
			cell.text=@"Letters";
			break;
		case 2:
			if ([[NSString stringWithFormat:@"%@", [[[UIApplication sharedApplication] delegate] getMyettingsforElementNumber:0]] isEqual:@"Sexy"]){
				
				cell.accessoryType=UITableViewCellAccessoryCheckmark;
			}
			else
			{
				cell.accessoryType=UITableViewCellAccessoryNone;
			}
			cell.text=@"Sexy";
			break;
		
	}
	
	}
	
	if(indexPath.section==1){
		switch (indexPath.row) {
			case 0:
				cell.text=[NSString stringWithFormat:@"%@", [[[UIApplication sharedApplication] delegate] getMyettingsforElementNumber:1]];
				
				cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
				break;
			
		}
		
		
	}
	
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(indexPath.section==0){
		switch (indexPath.row) {
			case 0:
				
				[[[UIApplication sharedApplication] delegate] setMyettings:@"Numbers" forElementNumber:0 ];
				[[[UIApplication sharedApplication] delegate] setMyettings:[[[UIApplication sharedApplication] delegate] getMyettingsforElementNumber:2] forElementNumber:1 ];
				break;
			case 1:
				[[[UIApplication sharedApplication] delegate] setMyettings:@"Letters" forElementNumber:0 ];
				[[[UIApplication sharedApplication] delegate] setMyettings:@"7" forElementNumber:1 ];
				
				break;
			case 2:
				[[[UIApplication sharedApplication] delegate] setMyettings:@"Sexy" forElementNumber:0 ];
				[[[UIApplication sharedApplication] delegate] setMyettings:@"2" forElementNumber:1 ];
			
				break;
		
		
	}
	}
	if(indexPath.section==1){
		
		
	}
	
	[mainTableView reloadData];
	[[[UIApplication sharedApplication] delegate] saveSettingsToFile ];
	
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section==0) return @"Dice Type";
	if (section==1) return @"Number of Dice";
	return @"" ;
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



@end
