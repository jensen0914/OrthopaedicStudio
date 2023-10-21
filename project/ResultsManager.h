//
//  ResultsManager.h
//  OrthoStudio
//
//  Copyright Carl Siversson, 2010-2014. All rights reserved.
//  Distributed under GNU - GPL v3
//
// =========================================================================
//  This software is distributed WITHOUT ANY WARRANTY; without even
//  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
//  PURPOSE.
// =========================================================================

#import <Cocoa/Cocoa.h>


enum SaveFields {
	EvaluationTime = 0,
	PatID,
	Date,
	Type,
	APView,
	ShentonR,
	ShentonL,
	CrossOverR,
	CrossOverL,
	PostWallR,
	PostWallL,
	TonnisGradeR,
	TonnisGradeL,
	LCER,
	LCEL,
	TonnisR,
	TonnisL,
	JSWR,
	JSWL,
	PelvTilt,
	PelvRot,
	CongruityR,
	CongruityL,
	FPSide,
	ACE,
	AlphaR,
	AlphaL,
	HNoffsetR,
	HNoffsetL,
	SouthwickR,
	SouthwickL,
	EMoffsetR,
	EMoffsetL,
	NbrOfSavedFields
	
};

@interface ResultsManager : NSObject {
	
	OrthopaedicStudioFilter *mainFilter;
	//int		last_opmode_saving;
	
	//AP
	NSString *result_AP_XRayView;
	NSString *result_AP_ShentonLeft;
	NSString *result_AP_ShentonRight;
	NSString *result_AP_CrossOverLeft;
	NSString *result_AP_CrossOverRight;
	NSString *result_AP_PosteriorWallLeft;
	NSString *result_AP_PosteriorWallRight;
	NSString *result_AP_TonnisLeft;
	NSString *result_AP_TonnisRight;
	
	NSString *result_AP_LCE_right;
	NSString *result_AP_LCE_left;
	NSString *result_AP_Tonnis_right;
	NSString *result_AP_Tonnis_left;
	NSString *result_AP_JSW_right;
	NSString *result_AP_JSW_left;
	NSString *result_AP_PelvicTilt;
	NSString *result_AP_PelvicRot;
	
	//Von Rosen
	NSString *result_VR_JointConLeft;
	NSString *result_VR_JointConRight;
	
	//False Profile
	NSString *result_FP_ACE;
	//int		  guessed_FP_ACE_side;
	
	//Frog
	NSString *result_Frog_Alpha_left;
	NSString *result_Frog_Alpha_right;
	
	NSString *result_Frog_HNOffset_left;
	NSString *result_Frog_HNOffset_right;
	
	NSString *result_FrogScfe_Southwick_left;
	NSString *result_FrogScfe_Southwick_right;
	
	NSString *result_FrogScfe_EMOffset_left;
	NSString *result_FrogScfe_EMOffset_right;
	
}

- (void)initWithMainFilter:(OrthopaedicStudioFilter*) main_filter;
- (void)readVisualScoreResults:(int) op_mode;
- (void)readROIResults: (int) op_mode : (RoiManager*) roiManager : (BOOL) update_FP_side;
- (void)readROIResultsForFile: (int) op_mode : (RoiManager*) roiManager;
- (void)displayVisualScoreResults:(int) op_mode;
- (void)displayROIResults:(int) op_mode;
- (void)displaySaveFile: (NSString*) filename : (int) op_mode;
- (BOOL)saveResults: (NSString*) filename : (NSString*) separator : (NSString*) decimalSep : (int) opMode : (ViewerController*) viewerController : (RoiManager*) roiManager;


@end
