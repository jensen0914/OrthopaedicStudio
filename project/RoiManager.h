//
//  RoiManager.h
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

#define NAME_FEMORAL_HEAD_RIGHT		@"Femoral head (right)"
#define NAME_FEMORAL_HEAD_LEFT		@"Femoral head (left)"
//AP
#define NAME_LATERAL_SOURCIL_RIGHT	@"Lateral edge of sourcil (right)"
#define NAME_MEDIAL_SOURCIL_RIGHT	@"Medial edge of sourcil (right)"
#define NAME_JSW_RIGHT				@"Joint space width (right)"
#define NAME_LATERAL_SOURCIL_LEFT	@"Lateral edge of sourcil (left)"
#define NAME_MEDIAL_SOURCIL_LEFT	@"Medial edge of sourcil (left)"
#define NAME_JSW_LEFT				@"Joint space width (left)"
#define NAME_SAC_JOINT				@"Sacrococcygeal joint"
#define NAME_PUB_SYMPH				@"Pubic Symphysis"
//False Profile
#define NAME_FP_FEMORAL_HEAD		@"Femoral head"
#define NAME_FP_ANTERIOR_SOURCIL	@"Anterior edge of sourcil" 
//Frog
#define NAME_FROG_NARROWEST_FEMORAL_RIGHT	@"Narrowest region across femoral neck (right)"
#define NAME_FROG_NARROWEST_FEMORAL_LEFT	@"Narrowest region across femoral neck (left)"

#define NAME_FROG_EXCEEDS_CIRCLE_RIGHT		@"Fermoral head first exceeds circle (right)"
#define NAME_FROG_EXCEEDS_CIRCLE_LEFT		@"Fermoral head first exceeds circle (left)"

#define NAME_FROG_ANTERIOR_FEMORAL_NECK_RIGHT		@"Anterormost point of femoral neck (right)"
#define NAME_FROG_ANTERIOR_FEMORAL_NECK_LEFT		@"Anterormost point of femoral neck (left)"

// Frog SCFE
#define NAME_FROG_SCFE_EPIPHYSIS_SUPERIOR_RIGHT		@"Superior edge of epiphysis (right)"
#define NAME_FROG_SCFE_EPIPHYSIS_INFERIOR_RIGHT		@"Inferior edge of epiphysis (right)"
#define NAME_FROG_SCFE_EPIPHYSIS_SUPERIOR_LEFT		@"Superior edge of epiphysis (left)"
#define NAME_FROG_SCFE_EPIPHYSIS_INFERIOR_LEFT		@"Inferior edge of epiphysis (left)"
#define NAME_FROG_SCFE_FEMORAL_HEAD_RIGHT			@"Femoral head curvature (right)"
#define NAME_FROG_SCFE_FEMORAL_HEAD_LEFT			@"Femoral head curvature (left)"
#define NAME_FROG_SCFE_ALPHA_ADJUST_RIGHT			@"Adjust line to follow center of femoral neck (right)"
#define NAME_FROG_SCFE_ALPHA_ADJUST_LEFT			@"Adjust line to follow center of femoral neck (left)"
#define NAME_FROG_SCFE_SHAFT_SUPERIOR_RIGHT			@"Superior edge of shaft (right)"
#define NAME_FROG_SCFE_SHAFT_INFERIOR_RIGHT			@"Inferior edge of shaft (right)"
#define NAME_FROG_SCFE_SHAFT_SUPERIOR_LEFT			@"Superior edge of shaft (left)"
#define NAME_FROG_SCFE_SHAFT_INFERIOR_LEFT			@"Inferior edge of shaft (left)"
#define NAME_FROG_SCFE_METAPHYSIS_RIGHT				@"Superior edge of metaphysis (right)"
#define NAME_FROG_SCFE_METAPHYSIS_LEFT				@"Superior edge of metaphysis (left)"



#define NAME_HELPER					@"OS helper roi"
#define NAME_PREFS					@"OS preferences roi"


#define NBR_OF_STEPS				21
#define NBR_OF_STEPS_FP				5
#define NBR_OF_STEPS_FROG			15 
#define NBR_OF_STEPS_FROG_SCFE	    25
#define NBR_OF_STEPS_ALPHA			13

#define COORD_MAX					100000		// this is an abitrary max, that should be higher than any wanted pixel position
												// since the roi functions stop working if they are fed with positions too high.

enum FP_ACESide {
	FP_ACE_RIGHT = 0,
	FP_ACE_LEFT
};



@interface RoiManager : NSObject {	
	
	ROI				*pointFemoralHeadRight1;
	ROI				*pointFemoralHeadRight2;
	ROI				*pointFemoralHeadRight3;
	
	ROI				*pointFemoralHeadLeft1;
	ROI				*pointFemoralHeadLeft2;
	ROI				*pointFemoralHeadLeft3;
	
	//AP
	ROI				*pointLateralSourcilRight;
	ROI				*pointMedialSourcilRight;
	
	ROI				*pointLateralSourcilLeft;
	ROI				*pointMedialSourcilLeft;
	
	ROI				*pointJSWRight;
	ROI				*pointJSWLeft;
	
	ROI				*pointSacrococcygealJoint;
	ROI				*pointPublicSymphysis;
	
	//False Profile
	ROI				*pointFPFemoralHead1;
	ROI				*pointFPFemoralHead2;
	ROI				*pointFPFemoralHead3;
	ROI				*pointFPAnteriorEdgeSourcil;
	
	//Frog
	ROI				*pointFrogNarrowestFemoralNeckRight1;
	ROI				*pointFrogNarrowestFemoralNeckRight2;
	
	ROI				*pointFrogNarrowestFemoralNeckLeft1;
	ROI				*pointFrogNarrowestFemoralNeckLeft2;
	
	ROI				*pointFrogFemoralHeadExceedsCircleRight;
	ROI				*pointFrogFemoralHeadExceedsCircleLeft;
	
	ROI				*pointFrogAnteriorFemoralNeckRight;
	ROI				*pointFrogAnteriorFemoralNeckLeft;
	
	// Frog SCFE
	
	ROI				*pointFrogScfeEpiphysisSuperiorRight;
	ROI				*pointFrogScfeEpiphysisInferiorRight;
	
	ROI				*pointFrogScfeEpiphysisSuperiorLeft;
	ROI				*pointFrogScfeEpiphysisInferiorLeft;
	
	ROI				*pointFrogScfeFemoralHeadRight;
	ROI				*pointFrogScfeFemoralHeadLeft;
	
	ROI				*pointFrogScfeAlphaAdjustRight;
	ROI				*pointFrogScfeAlphaAdjustLeft;
	
	ROI				*pointFrogScfeShaftSuperiorRight1;
	ROI				*pointFrogScfeShaftSuperiorRight2;
	ROI				*pointFrogScfeShaftInferiorRight1;
	ROI				*pointFrogScfeShaftInferiorRight2;
	
	ROI				*pointFrogScfeShaftSuperiorLeft1;
	ROI				*pointFrogScfeShaftSuperiorLeft2;
	ROI				*pointFrogScfeShaftInferiorLeft1;
	ROI				*pointFrogScfeShaftInferiorLeft2;
	
	ROI				*pointFrogScfeMetaphysisRight;
	ROI				*pointFrogScfeMetaphysisLeft;
	
	//--Helper rois
	ROI				*circleFemoralHeadRight;
	ROI				*circleFemoralHeadLeft;	
	
	//AP
	ROI				*lineBetweenFemoralHeads;
	ROI				*angleTonnisRight;
	ROI				*angleTonnisLeft;
	ROI				*angleLCERight;
	ROI				*angleLCELeft;
	ROI				*lineJSWRight;
	ROI				*lineJSWLeft;
	ROI				*lineSacToSymph;
	
	//False Profile
	ROI				*circleFPFemoralHead;
	ROI				*angleFPACE;
	
	//Frog
	ROI				*lineFrogNarrowestFemoralNeckRight;
	ROI				*lineFrogNarrowestFemoralNeckLeft;
	ROI				*angleFrogAlphaRight;
	ROI				*angleFrogAlphaLeft;
	
	ROI				*lineFrogHNOffsetOuterRight;
	ROI				*lineFrogHNOffsetInnerRight;
	
	ROI				*lineFrogHNOffsetOuterLeft;
	ROI				*lineFrogHNOffsetInnerLeft;
	
	// Frog SCFE
	ROI				*lineFrogScfeCrossShaftUpperRight;
	ROI				*lineFrogScfeCrossShaftLowerRight;
	
	ROI				*lineFrogScfeCrossShaftUpperLeft;
	ROI				*lineFrogScfeCrossShaftLowerLeft;
	
	ROI				*lineFrogScfeEMOffsetOuterRight;
	ROI				*lineFrogScfeEMOffsetInnerRight;
	
	ROI				*lineFrogScfeEMOffsetOuterLeft;
	ROI				*lineFrogScfeEMOffsetInnerLeft;
	
	ROI				*angleFrogScfeSouthwickRight;
	ROI				*angleFrogScfeSouthwickLeft;
	
	ROI				*lineFrogScfeAlphaCenterRight;
	ROI				*lineFrogScfeAlphaCenterLeft;
	
	ROI				*lineFrogScfeAlphaAdjustRight;
	ROI				*lineFrogScfeAlphaAdjustLeft;
	
	ROI				*lineFrogScfeSouthwickBaseRealRight;
	ROI				*lineFrogScfeSouthwickBaseRealLeft;
	
	ROI				*lineFrogScfeSouthwickBaseCloneRight;
	ROI				*lineFrogScfeSouthwickBaseCloneLeft;
	
	ROI				*pointPrefs;
	
	int curr_Step;
	int next_Step;
	
	BOOL block_update_rois_flag;
	int waiting_for_alpha_adjust_right_flag;
	int waiting_for_alpha_adjust_left_flag;
	
	ROI				*lastPrevAddedRoi;
		
	DCMPix			*currDCMPix;
	DCMView			*currDCMView;
	
	@public
	float result_LCE_right;
	float result_LCE_left;
	float result_Tonnis_right;
	float result_Tonnis_left;
	float result_JSW_right;
	float result_JSW_left;
	float result_PelvicTilt;
	float result_PelvicRot;
	
	float result_FP_ACE;
	int	  guessed_FP_ACE_side;
	
	float result_Frog_Alpha_right;
	float result_Frog_Alpha_left;
	
	float result_Frog_HNOffset_left;
	float result_Frog_HNOffset_right;
	
	float result_FrogScfe_Southwick_left;
	float result_FrogScfe_Southwick_right;
	
	float result_FrogScfe_EMOffset_left;
	float result_FrogScfe_EMOffset_right;
	
}

-(void)initClean;
-(void)restart: (ViewerController*) viewerController : (BOOL) include_prefs;
-(int)getStep;
-(int)getNextStep;
-(void)setStep: (int)step : (int)op_mode;
-(void)roiSelected: (NSNotification*)notification : (ViewerController*) viewerController;
-(void)mouseClicked: (NSNotification*)notification : (ViewerController*) viewerController;
-(void)roiChanged: (NSNotification*)notification : (ViewerController*) viewerController : (OrthopaedicStudioFilter*) mainFilter;
-(int)roiAdded: (NSNotification*)notification : (int) op_mode : (ViewerController*) viewerController;
-(void)makeLastAddedRoiTextualInfoVisible;
-(void)updateCalculatedRois:(ViewerController*) viewerController;
-(void)displayROIInstructions: (int)stepNbr : (int)op_mode : (OrthopaedicStudioFilter*) mainFilter;
-(int)checkOpModeFromExistingPoints:(ViewerController*) viewerController;
-(int)loadFromExistingPoints: (int) op_mode : (ViewerController*) viewerController;
-(BOOL)isThisThePrefsRoi:(ROI*) roi;
-(BOOL)isRoiOneOfOurs: (ROI*) roi : (BOOL) nullify;

@end
