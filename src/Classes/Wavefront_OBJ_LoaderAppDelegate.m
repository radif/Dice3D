//
//  Wavefront_OBJ_LoaderAppDelegate.m
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/14/08.
//  Copyright Jeff LaMarche 2008. All rights reserved.
//

#import "Wavefront_OBJ_LoaderAppDelegate.h"
#import "GLViewController.h"
#import "GLView.h"


@implementation Wavefront_OBJ_LoaderAppDelegate
@synthesize window;
@synthesize controller;

- (void)applicationDidFinishLaunching:(UIApplication*)application
{
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	[self getSettingsFromFile];
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	viewController=[[MainMenuViewController alloc]init];
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
	
//	NSString *extensionString = [NSString stringWithUTF8String:(char *)glGetString(GL_EXTENSIONS)];
//	NSArray *extensions = [extensionString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//	for (NSString *oneExtension in extensions)
//		NSLog(oneExtension);

}
-(void) loadGame{
	GLViewController *theController = [[GLViewController alloc] init];
	self.controller = theController;
	[theController release];
	
	GLView *glView = [[GLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	
	glView.controller = controller;
	glView.animationInterval = 1.0 / kRenderingFrequency;
	[glView startAnimation];
	[viewController.view removeFromSuperview];
	[window addSubview:glView];
	[glView release];
}
- (void)dealloc
{
	[viewController release];
	[window release];
	[controller release];
	[settingsArray release];
	[super dealloc];
}


#pragma mark Settings

-(void)getSettingsFromFile{//This mehod can only be used once througout the life of the program!!!
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	
	
	
	NSString *newPath =[NSString stringWithFormat: @"%@/Settings.plist",[filePaths objectAtIndex: 0]];
	if ([[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
		settingsArray=[[NSMutableArray alloc] initWithContentsOfFile:newPath];
		
	}else{
		
		settingsArray=[[NSMutableArray alloc]initWithObjects:@"Numbers",@"2",@"2",nil];
		//Numbers; Sexy (only 2); Letters (up to 7); Words (up to 7)
	}
	
}
-(void)saveSettingsToFile{
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	
	
	
	NSString *newPath =[NSString stringWithFormat: @"%@/Settings.plist",[filePaths objectAtIndex: 0]];
	[settingsArray writeToFile:newPath atomically:YES];
}


-(void)setMyettings:(NSString *) mySettings forElementNumber:(int) indexObject{
	[settingsArray replaceObjectAtIndex:indexObject withObject:mySettings];
	
}
-(NSString *)getMyettingsforElementNumber:(int) indexObject{
	return [settingsArray objectAtIndex:indexObject];
}

@end
