//
//  GLViewController.h
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/14/08.
//  Copyright Jeff LaMarche 2008. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "OpenGLWaveFrontObject.h"
#import "SoundEffect.h"
#import "gluLookAt.h"

#define NumberOfMaxDice				7


@class GLView;

@interface GLViewController : UIViewController <UIAccelerometerDelegate> {

	int numberOfDice;
	NSString *gameMode;
	
	OpenGLWaveFrontObject *die[NumberOfMaxDice];
	OpenGLWaveFrontObject *stage;
	
	//animation variables:
	
	 GLfloat zGravStep[NumberOfMaxDice];
	 GLfloat gForce;
	
	//Falling flag
	bool isFalling[NumberOfMaxDice];
	
	Vertex3D dieAcceleration[NumberOfMaxDice];
	
	Vertex3D dieRotationStep[NumberOfMaxDice];

	
	
	bool isMixing;
	bool firstFly;
	bool diceAreStill;
	//Stage Boundaries
	 GLfloat zBottom;
	 GLfloat zTop;
	GLfloat xTop;
	GLfloat xBottom;
	GLfloat yTop;
	GLfloat yBottom;
	 
	

	
	Vertex3D cameraPosition;
	//Vertex3D CenterLook[NumberOfMaxDice];
	//Temporary needed;
	Rotation3D dieFaceRotation;
	 
	
	//
	
	//Sound
	
	SoundEffect *floorSound1;
	SoundEffect *floorSound2;
	SoundEffect *mixingSound;

	//Shake
	
	CFTimeInterval		lastTime;
	UIAccelerationValue	myAccelerometer[3];
	
	//MixWithFingerMovements
	
	CGPoint startLocation;
//Temporary values:
	float gravityIndicator;
	
	//Game Strategy
	int droppedFace[NumberOfMaxDice];
}


//GLView
- (void)drawView:(GLView*)view;
- (void)setupView:(GLView*)view;
//Custom
-(Rotation3D )checkRotations:(Rotation3D ) therotation;
-(void) resetAndMix;
-(float) normalizeLastFallWithAngle:(float )angle andRotationAcceleration:(float)rotAccel;


@end
