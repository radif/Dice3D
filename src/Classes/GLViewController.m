//
//  GLViewController.h
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/14/08.
//  Copyright Jeff LaMarche 2008. All rights reserved.
//

#import "GLViewController.h"
#import "GLView.h"

#define kMinEraseInterval				0.5
#define kEraseAccelerationThreshold		2.0
#define kAccelerometerFrequency			25 //Hz
#define kFilteringFactor				0.1

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)





@implementation GLViewController

- (void)drawView:(GLView*)view;

{

	glClear(GL_DEPTH_BUFFER_BIT);
	glLoadIdentity(); 
	
	bool diceAreStillChecker=NO;
	GLfloat centerX, centerY;
	GLfloat distanceX, distanceY;
	GLfloat distanceMinX, distanceMinY;
	GLfloat distanceMaxX, distanceMaxY;

	
	
	
	Vertex3D pos[numberOfDice];
	
	
	//centerX=0;
	//centerY=0;
	distanceMinX=50;
	distanceMinY=50;
	distanceMaxX=-50;
	distanceMaxY=-50;
	for (int i=0;i<numberOfDice;i++){
	
		pos[i] = die[i].currentPosition;
		
		if (isFalling[i]==YES) diceAreStillChecker=YES;
		//Counting center look
		
		//centerX=centerX+pos[i].x;
		//centerY=centerY+pos[i].y;
		//Counting Distance
		
			//Minimum
			if (pos[i].x<distanceMinX) distanceMinX=pos[i].x;
			if (pos[i].y<distanceMinY) distanceMinY=pos[i].y;
			
			//Maximum
			if (pos[i].x>distanceMaxX) distanceMaxX=pos[i].x;
			if (pos[i].y>distanceMaxY) distanceMaxY=pos[i].y;
		
		
		
	}
	
	//Counting center look
	//centerX=centerX/numberOfDice;
	//centerY=centerY/numberOfDice;
	//Counting Distance
	distanceX=distanceMaxX-distanceMinX;
	distanceY=distanceMaxY-distanceMinY;
	centerX=distanceMinX+distanceX/2;
	centerY=distanceMinY+distanceY/2;
	
	if (diceAreStillChecker==NO) diceAreStill=NO; else diceAreStill=YES;
	
	
	
	Rotation3D rot[numberOfDice];
	for (int i=0;i<numberOfDice;i++){
	rot[i]=die[i].currentRotation;
	
	}
	//Looking
	
	if (diceAreStill==YES){
	if  (cameraPosition.x>-40)  cameraPosition.x=cameraPosition.x-1.9;
		if  (cameraPosition.z<2)  cameraPosition.z=cameraPosition.z+1.5;
		if  (cameraPosition.z>2)  cameraPosition.z=cameraPosition.z-1.5;
	}
	else
	{
		if  (cameraPosition.x<distanceMinX-4) {cameraPosition.x=cameraPosition.x+.5;
			//NSLog(@"%f",distanceMinX );
		}
	
		//If distance x distance y
		//If Landscape mode:
		//NSLog(@"X: %f",distanceX);
		//NSLog(@"Y: %f",distanceY);
		
		distanceX=distanceX*2;
		// Getting the max distamce and assigning it to Y
		if (distanceY<distanceX)distanceY=distanceX;
		distanceY=distanceY/6-5+numberOfDice;

		if  (cameraPosition.z> distanceY)  cameraPosition.z=cameraPosition.z-.2; else if  (cameraPosition.z< distanceY)  cameraPosition.z=cameraPosition.z+.2;
		
	}
	
	gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z, centerX, centerY, pos[0].z,0.0, 0.1, 0.0);
	
	//Drawing
	glDisable(GL_BLEND);
	
	if (numberOfDice>1){
	//Sort the dice draw order
		
	for (int i=0;i<numberOfDice;i++){
		//Collision Detection
		if (i>0){
		for (int j=0;j<i;j++){
		//if previous die is the same as next die
			//checking X
			//Checking left X
			if ((pos[j].x-1 < pos[i].x+1)  & (pos[j].x+1 > pos[i].x-1) ){
			//X is interpolated
				
				//Checking Y
				if ((pos[j].y-1 < pos[i].y+1)  & (pos[j].y+1 > pos[i].y-1) ){
				//Change position, acceleration/2 -; play sound
				
					if(firstFly==NO){
					dieAcceleration[i].x=-dieAcceleration[i].x*.6;
				dieAcceleration[j].x=-dieAcceleration[j].x*.6;
					
					dieAcceleration[i].y=-dieAcceleration[i].y*.6;
					dieAcceleration[j].y=-dieAcceleration[j].y*.6;
					}
					
					if (pos[j].x-1 < pos[i].x+1) {
						
						pos[i].x=pos[i].x-.5;
						pos[j].x=pos[j].x+.5;
						
					}else{
						pos[i].x=pos[i].x+.5;
						pos[j].x=pos[j].x-.5;
					}
					
					if (pos[j].y-1 < pos[i].y+1) {
						
						pos[i].y=pos[i].y-.5;
						pos[j].y=pos[j].y+.5;
						
					}else{
						pos[i].y=pos[i].y+.5;
						pos[j].y=pos[j].y-.5;
					}
					
					//FIXME: play collision sound
					//[floorSound2 play];
				}
				
				
				

			}
			

			
			
			
			
			
			
				
		
		}//for (int j=0;j<numberOfDice;i++)
		
		}//if (i>0)
		
		
		
		
		[die[i] drawSelf];
	
	
	}
	}
	else{
		
		[die[0] drawSelf];
		
	}
	
	
		
		
	
	[stage drawSelf];	
	
	
			
	
		

		

        
	
	
	
		
		
		//Rotation
	for (int i=0;i<numberOfDice;i++){
	if(isFalling[i]==YES){
		//Rotation
	rot[i].x=rot[i].x+dieRotationStep[i].x;
	rot[i].y=rot[i].y+dieRotationStep[i].y;
	rot[i].z=rot[i].z+dieRotationStep[i].z;
	rot[i]=[self checkRotations:rot[i]];
		//Acceleration
		if (isMixing==NO){
			
		pos[i].x=pos[i].x+dieAcceleration[i].x;
		pos[i].y=pos[i].y+dieAcceleration[i].y;
			
		}
		if (pos[i].x>xTop){
			firstFly=NO;
			dieAcceleration[i].x=-dieAcceleration[i].x*0.7;
			//FIXME: Play Sounds According to the die number
			[floorSound2 play];
			if (pos[i].x>xTop) pos[i].x=xTop;
			

			//Randomize rotation
			dieRotationStep[i].y=dieRotationStep[i].z+(random() % 6)-3;
			dieRotationStep[i].z=dieRotationStep[i].z+(random() % 6)-3;

			

		}
		
		if (firstFly==NO){
			if (pos[i].x<xBottom) pos[i].x=xBottom;
			//dieAcceleration[i].x=-dieAcceleration[i].x*0.7;
			
		}
		
				
		if ((pos[i].y<yBottom) | (pos[i].y>yTop)){
			dieAcceleration[i].y=-dieAcceleration[i].y*0.7;
			
			if (pos[i].y>yTop) pos[i].y=yTop;
			if (pos[i].y<yBottom) pos[i].y=yBottom;
			//Randomize rotation
			dieRotationStep[i].y=dieRotationStep[i].z+(random() % 6)-3;
			dieRotationStep[i].z=dieRotationStep[i].z+(random() % 6)-3;
			//Possibly Decrease Acceleration here
			
			//FIXME: Play Sounds According to the die number
			[floorSound2 play];
			
		}
		
	
		
		
		
	}
	

		
	
	//Falling
		if (isMixing==YES)
		{
			
			//Falling flags
			isFalling[i]=YES;
			
			//FIXME::ismixing
			pos[i].z=pos[i].z+.7;
			if (pos[i].z>zTop) pos[i].z=zTop;
			
			pos[i].x=pos[i].x-1.9;
			if (pos[i].x<-20) pos[i].x=-20; 


		}
		
		else{
		
		//Die
			
			if(isFalling[i]==YES){
		
		if ((zGravStep[i]<0.01) & (zGravStep[i]>-0.01) )  zGravStep[i]=0.01;
		if (zGravStep[i]>0) {
			zGravStep[i]=zGravStep[i]/gForce; }
		else{
			zGravStep[i]=zGravStep[i]*gForce;
		}
		
			
		pos[i].z=pos[i].z-zGravStep[i];
				
		if (pos[i].z<zBottom){
			
			if(zGravStep[i]<0.025){
			//Last time hit the floor	
				isFalling[i]=NO;
				

				
				//dieFaceRotation.x=[self normalizeLastFallWithAngle:rot[i].x andRotationAcceleration:dieRotationStep[i].x];
				dieFaceRotation.y=[self normalizeLastFallWithAngle:rot[i].y andRotationAcceleration:dieRotationStep[i].y];
				dieFaceRotation.z=[self normalizeLastFallWithAngle:rot[i].z andRotationAcceleration:dieRotationStep[i].z];
				
				
				
				if (dieFaceRotation.y==0.) droppedFace[i]=1;
				
				if ((dieFaceRotation.y==90) & (dieFaceRotation.z==270)) droppedFace[i]=2;
				if ((dieFaceRotation.y==270) & (dieFaceRotation.z==90)) droppedFace[i]=2;
				
				if ((dieFaceRotation.y==270) & (dieFaceRotation.z==0)) droppedFace[i]=3;
				if ((dieFaceRotation.y==90) & (dieFaceRotation.z==180)) droppedFace[i]=3;
				
				if ((dieFaceRotation.y==90) & (dieFaceRotation.z==0)) droppedFace[i]=4;
				if ((dieFaceRotation.y==270) & (dieFaceRotation.z==180)) droppedFace[i]=4;
				
				if ((dieFaceRotation.y==270) & (dieFaceRotation.z==270)) droppedFace[i]=5;
				if ((dieFaceRotation.y==90) & (dieFaceRotation.z==90)) droppedFace[i]=5;
				
				if (dieFaceRotation.y==180) droppedFace[i]=6;
				
				NSLog(@"_________________________");
				NSLog(@"Dropped Face: %i",droppedFace[i]);
				//Checking the axes

				
				if((dieFaceRotation.y==0) | (dieFaceRotation.y==180)) {
				
					//NSLog(@"1");
					rot[i].x=dieFaceRotation.x;
					rot[i].y=dieFaceRotation.y;

				}else{
				if((dieFaceRotation.y==90) | (dieFaceRotation.y==270)) {
					//NSLog(@"2");
					
					//rot[i].x=rot[i].z;
					rot[i].z=dieFaceRotation.z;
					rot[i].y=dieFaceRotation.y;
						//rot[i].z=10;
				}}

	
			}
			
			
			//Randomize the Gravity Step
			zGravStep[i]=zGravStep[i]/100*((random() % 100));
			
			zGravStep[i]=-zGravStep[i]/3;
			pos[i].z=zBottom;
			

			gravityIndicator=zGravStep[i]/3;
			//Randomize rotation
			dieRotationStep[i].y=dieRotationStep[i].z+(random() % 6)-3+gravityIndicator;
			dieRotationStep[i].z=dieRotationStep[i].z+(random() % 6)-3+gravityIndicator;
			
			//Randomazi direction
			//gravityIndicator=-gravityIndicator;
			dieAcceleration[i].x=(dieAcceleration[i].x+(random() % 25)-12)/100+gravityIndicator;
			dieAcceleration[i].y=(dieAcceleration[i].y+(random() % 25)-12)/100+gravityIndicator;
			

			
			//FIXME: Play Sounds According to the die number
			firstFly=NO;
			[floorSound1 play];
		}
		
			}//isFalling
		
						
			}
			
		//
		
	die[i].currentPosition=pos[i];
	die[i].currentRotation=rot[i];
		


	}
		
	
		

}

-(void)setupView:(GLView*)view
{		
		srandom(time(NULL));
	
	//How Many Dice?
	numberOfDice=[[NSString stringWithFormat:@"%@", [[[UIApplication sharedApplication] delegate] getMyettingsforElementNumber:1]]intValue];
	if (numberOfDice>NumberOfMaxDice) numberOfDice=NumberOfMaxDice;
	
	//What Kind of Game?
	gameMode=[[NSString stringWithFormat:@"%@", [[[UIApplication sharedApplication] delegate] getMyettingsforElementNumber:0]] copy];
	if ([gameMode isEqual:@"Sexy"]){
		numberOfDice=2;
	}
	
	
	//Physics
	//Declaration:
	
	firstFly=NO;
	diceAreStill=YES;
	cameraPosition.x=-40;
	cameraPosition.y=0;
	cameraPosition.z=1;
	
	
	
	gForce=.78;
	zBottom=-22.0;
	zTop=-10.0;
	
	xTop= 9.5;
	xBottom=-6.5;
	
	yTop=11.5;
	yBottom=-11.5;
	
	
	for (int i=0;i<numberOfDice;i++){
		zGravStep[i]=0.1;
		//Falling Flag
		isFalling[i]=NO;
		
		dieAcceleration[i].x=0.0;
		dieAcceleration[i].y=0.0;
		dieAcceleration[i].z=0.0;
		
		dieRotationStep[i].x=0.0;
		dieRotationStep[i].y=0.0;
		dieRotationStep[i].z=0.0;
		
	}

	
	isMixing=NO;
	
	//Sounds
	NSLog(@"Loading Sounds");
	floorSound1 = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"floor1" ofType:@"wav"]];
	floorSound2 = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"floor2" ofType:@"wav"]];
	mixingSound = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mixing" ofType:@"wav"]];
	
	//Shaking
	
	//Configure and enable the accelerometer
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];

	

	//Graphics Declaration
	const GLfloat			lightAmbient[] = {0.6, 0.6, 0.6, 1.0};
	const GLfloat			lightDiffuse[] = {1.0, 1.0, 1.0, 1.0};
	
	const GLfloat			lightPosition[] = {-1.0, -1.0, 10.0, 0.0}; 
	const GLfloat			lightShininess = 0.0;
	const GLfloat			zNear = 0.01, zFar = 150.0, fieldOfView = 32.0; 

	GLfloat size; 
	
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION);
	
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
	glShadeModel(GL_SMOOTH); 
	
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
	glLightfv(GL_LIGHT0, GL_POSITION, lightPosition); 
	glLightfv(GL_LIGHT0, GL_SHININESS, &lightShininess);

	
	glLoadIdentity(); 
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f); 	
	
	
	//glGetError(); // Clear error codes
	
	
	NSString *path;
	
	//Game Mode Options
//-----------------------------------------------------------------------	
	if ([gameMode isEqual:@"Sexy"]){
		
		NSLog(@"Loading Stage");
		
	path= [[NSBundle mainBundle] pathForResource:@"mydesk" ofType:@"obj"];
	stage = [[OpenGLWaveFrontObject alloc] initWithPath:path];
	Vertex3D position = Vertex3DMake(0.0, -0.5, zBottom-1);
	stage.currentPosition = position;
	

	
	
	
		
	
	NSLog(@"Loading Die1");
	
	
		
		path = [[NSBundle mainBundle] pathForResource:@"sexydie1" ofType:@"obj"];
		die[0] = [[OpenGLWaveFrontObject alloc] initWithPath:path];
		position = Vertex3DMake(0.0, -2.0, zBottom);
		die[0].currentPosition = position;
		
		
		NSLog(@"Loading Die1");
		
		
		
		path = [[NSBundle mainBundle] pathForResource:@"sexydie2" ofType:@"obj"];
		die[1] = [[OpenGLWaveFrontObject alloc] initWithPath:path];
		position = Vertex3DMake(0.0, 2.0, zBottom);
		die[1].currentPosition = position;
		
	
	}
	
	
	//-----------------------------------------------------------------------	
	if ([gameMode isEqual:@"Numbers"]){
		
		NSLog(@"Loading Stage");
		
		path= [[NSBundle mainBundle] pathForResource:@"mydesk" ofType:@"obj"];
		stage = [[OpenGLWaveFrontObject alloc] initWithPath:path];
		Vertex3D position = Vertex3DMake(0.0, -0.5, zBottom-1);
		stage.currentPosition = position;
		
		
		
		
		
		for(int i=0;i<numberOfDice;i++){
		
		NSLog(@"Loading Die: %i",i);
		
		
		
		path = [[NSBundle mainBundle] pathForResource:@"die" ofType:@"obj"];
		die[i] = [[OpenGLWaveFrontObject alloc] initWithPath:path];
		position = Vertex3DMake(0.0, -2.0, zBottom);
		die[i].currentPosition = position;
		
		}

		
		
	}
	
	
	
	
	
	[floorSound1 play];
	[floorSound2 play];
		
	


	
	
	//Place them nicely at the zBottom
	//[self resetAndMix];
		
	
	
}
- (void)didReceiveMemoryWarning 
{
	
    [super didReceiveMemoryWarning]; 
}

- (void)dealloc 
{
	
	[stage release];
	[die[NumberOfMaxDice] release];
	[gameMode release];
	[floorSound1 release];
	[floorSound2 release];
	[mixingSound release];

    [super dealloc];
}
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	
	
	NSSet *touch1 = [event allTouches];
	int nb = [touch1 count];
	UITouch *touch = [[event allTouches] anyObject];
	
	
	
	startLocation = [[touches anyObject] locationInView:self.view];
	
	
	//Simulator shake
	if ( (startLocation.x<80) & (startLocation.y>400)) [self resetAndMix];
	
	/*
	startLocation = [[touches anyObject] locationInView:self.view];
	
	isMixing=YES;
	for (int i=0;i<numberOfDice;i++){
		dieRotationStep[i].x=0.0;
		dieRotationStep[i].y=0.0;
		dieRotationStep[i].z=0.0;
	}
*/

}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	/*
	CGPoint pt = [[touches anyObject] locationInView:self.view];
	
	for (int i=0;i<numberOfDice;i++){
	//	dieRotationStep[i].x=(pt.y-startLocation.y)/17;
	dieRotationStep[i].y=(pt.x-startLocation.x)/21;
	
	dieRotationStep[i].z=(pt.y-startLocation.y)/23;
		
	
}*/

}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	/*
	isMixing=NO;
	for (int i=0;i<numberOfDice;i++){
	zGravStep[i]=0.1;
	}
	 */

	

}
#pragma mark Custom


-(Rotation3D )checkRotations:(Rotation3D ) therotation{

	if (therotation.x>360)therotation.x=therotation.x-360;
	if (therotation.x<0)therotation.x=therotation.x+360;
	
	if (therotation.y>360)therotation.y=therotation.y-360;
	if (therotation.y<0)therotation.y=therotation.y+360;
	
	if (therotation.z>360)therotation.z=therotation.z-360;
	if (therotation.z<0)therotation.z=therotation.z+360;
	
	return therotation;
}

#pragma mark Reset and Mix;

-(void) resetAndMix{
	[mixingSound play];
	
	//FIXME: remove Demo Later
	//Demo
	//numberOfDice=numberOfDice+1;
	//if (numberOfDice>NumberOfMaxDice) numberOfDice=1;
	//End Demo
	
	firstFly=YES;
	diceAreStill=NO;
	isMixing=YES;
	for (int i=0;i<numberOfDice;i++){
	//dieRotationStep[i].x=(random() % 500)/10-25;
	dieRotationStep[i].y=(random() % 500)/10-25;
	dieRotationStep[i].z=(random() % 500)/10-25;
	}
	

	
	[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(voidReset) userInfo:nil repeats:NO];
	
}

-(void)voidReset{
	isMixing=NO;
	for(int i=0;i<numberOfDice;i++){
		dieAcceleration[i].x=1.5;
	
	}
}
- (void) accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	UIAccelerationValue				length,
	x,
	y,
	z;
	
	//Use a basic high-pass filter to remove the influence of the gravity
	myAccelerometer[0] = acceleration.x * kFilteringFactor + myAccelerometer[0] * (1.0 - kFilteringFactor);
	myAccelerometer[1] = acceleration.y * kFilteringFactor + myAccelerometer[1] * (1.0 - kFilteringFactor);
	myAccelerometer[2] = acceleration.z * kFilteringFactor + myAccelerometer[2] * (1.0 - kFilteringFactor);
	// Compute values for the three axes of the acceleromater
	x = acceleration.x - myAccelerometer[0];
	y = acceleration.y - myAccelerometer[0];
	z = acceleration.z - myAccelerometer[0];
	
	//Compute the intensity of the current acceleration 
	length = sqrt(x * x + y * y + z * z);
	// If above a given threshold, play the erase sounds and erase the drawing view
	if((length >= kEraseAccelerationThreshold) && (CFAbsoluteTimeGetCurrent() > lastTime + kMinEraseInterval)) {
		
		[self resetAndMix];
		lastTime = CFAbsoluteTimeGetCurrent();
	}
	
	/*else{
	//Here starts look at
		tempVector.x=x;
		tempVector.y=y;
		tempVector.z=z;
		//NSLog(@"x: %f; y: %f; z: %f,", x,y,z);
	}
	 */
}
#pragma mark Sounds
/*
-(void)playRandomFloorSound{
	int i=(random() % 4);
	switch (i) {
		case 1:
			[floorSound1 play];
			break;
		case 2:
			[floorSound2 play];
			break;
		case 3:
			[floorSound3 play];
			break;
		case 4:
			[floorSound4 play];
			break;
		
	}
 }
 */

#pragma mark Floor Angle -Rotation  accel Normalization
-(float) normalizeLastFallWithAngle:(float )angle andRotationAcceleration:(float)rotAccel{

	
	// Just put it on flat
	if ((angle>0) & (angle<45)) angle=0;
	if ((angle>44) & (angle<135)) angle=90;
	if ((angle>134) & (angle<225)) angle=180;
	if ((angle>224) & (angle<315)) angle=270;
	if ((angle>314) & (angle<361)) angle=0;
		


	return angle;
}

@end
