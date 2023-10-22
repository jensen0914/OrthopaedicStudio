//
//  RoiManager.m
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

#import <OsiriXAPI/Notifications.h>
#import <OsiriXAPI/PluginFilter.h>
#import "OrthopaedicStudioFilter.h"
#import "RoiManager.h"
#import <Foundation/Foundation.h>





@implementation RoiManager


-(void)initClean {
	
	//NSLog(@"initClean");
	
	curr_Step = 1;
	next_Step = 1;
	block_update_rois_flag = NO;
	waiting_for_alpha_adjust_right_flag = 0;
	waiting_for_alpha_adjust_left_flag = 0;

	pointFemoralHeadRight1 = NULL;
	pointFemoralHeadRight2 = NULL;
	pointFemoralHeadRight3 = NULL;
	
	pointLateralSourcilRight = NULL;
	pointMedialSourcilRight = NULL;
		
	pointFemoralHeadLeft1 = NULL;
	pointFemoralHeadLeft2 = NULL;
	pointFemoralHeadLeft3 = NULL;
	
	pointLateralSourcilLeft = NULL;
	pointMedialSourcilLeft = NULL;
	
	pointJSWRight = NULL;
	pointJSWLeft = NULL;
	
	pointSacrococcygealJoint = NULL;
	pointPublicSymphysis = NULL;

	//False Profile
	pointFPFemoralHead1 = NULL;
	pointFPFemoralHead2 = NULL;
	pointFPFemoralHead3 = NULL;
	pointFPAnteriorEdgeSourcil = NULL;
	
	//Frog
	pointFrogNarrowestFemoralNeckRight1 = NULL;
	pointFrogNarrowestFemoralNeckRight2 = NULL;
	
	pointFrogNarrowestFemoralNeckLeft1 = NULL;
	pointFrogNarrowestFemoralNeckLeft2 = NULL;
	
	pointFrogFemoralHeadExceedsCircleRight = NULL;
	pointFrogFemoralHeadExceedsCircleLeft = NULL;
	
	pointFrogAnteriorFemoralNeckRight = NULL;
	pointFrogAnteriorFemoralNeckLeft = NULL;
	
	// Frog SCFE	
	pointFrogScfeEpiphysisSuperiorRight = NULL;
	pointFrogScfeEpiphysisInferiorRight = NULL;
	
	pointFrogScfeEpiphysisSuperiorLeft = NULL;
	pointFrogScfeEpiphysisInferiorLeft = NULL;
	
	pointFrogScfeFemoralHeadRight = NULL;
	pointFrogScfeFemoralHeadLeft = NULL;
	
	pointFrogScfeAlphaAdjustRight = NULL;
	pointFrogScfeAlphaAdjustLeft = NULL;
	
	pointFrogScfeShaftSuperiorRight1 = NULL;
	pointFrogScfeShaftSuperiorRight2 = NULL;
	pointFrogScfeShaftInferiorRight1 = NULL;
	pointFrogScfeShaftInferiorRight2 = NULL;
	
	pointFrogScfeShaftSuperiorLeft1 = NULL;
	pointFrogScfeShaftSuperiorLeft2 = NULL;
	pointFrogScfeShaftInferiorLeft1 = NULL;
	pointFrogScfeShaftInferiorLeft2 = NULL;
	
	pointFrogScfeMetaphysisRight = NULL;
	pointFrogScfeMetaphysisLeft = NULL;
	
	// ----- Helper rois ------
	circleFemoralHeadRight = NULL;
	circleFemoralHeadLeft = NULL;
	lineBetweenFemoralHeads = NULL;
	
	angleTonnisRight = NULL;
	angleTonnisLeft = NULL;	
	angleLCERight = NULL;
	angleLCELeft = NULL;
	lineJSWRight = NULL;
	lineJSWLeft = NULL;
	lineSacToSymph = NULL;
	
	//False Profile
	circleFPFemoralHead = NULL;
	angleFPACE = NULL;
	
	//Frog
	lineFrogNarrowestFemoralNeckRight = NULL;
	lineFrogNarrowestFemoralNeckLeft = NULL;
	angleFrogAlphaRight = NULL;
	angleFrogAlphaLeft = NULL;
	lineFrogHNOffsetOuterRight = NULL;
	lineFrogHNOffsetInnerRight = NULL;
	lineFrogHNOffsetOuterLeft = NULL;
	lineFrogHNOffsetInnerLeft = NULL;
	
	// Frog SCFE
	lineFrogScfeCrossShaftUpperRight = NULL;
	lineFrogScfeCrossShaftLowerRight = NULL;	
	lineFrogScfeCrossShaftUpperLeft = NULL;
	lineFrogScfeCrossShaftLowerLeft = NULL;	
	lineFrogScfeEMOffsetOuterRight = NULL;
	lineFrogScfeEMOffsetInnerRight = NULL;	
	lineFrogScfeEMOffsetOuterLeft = NULL;
	lineFrogScfeEMOffsetInnerLeft = NULL;	
	angleFrogScfeSouthwickRight = NULL;
	angleFrogScfeSouthwickLeft = NULL;	
	lineFrogScfeAlphaCenterRight = NULL;
	lineFrogScfeAlphaCenterLeft = NULL;
	lineFrogScfeAlphaAdjustRight = NULL;
	lineFrogScfeAlphaAdjustLeft = NULL;
	
	lineFrogScfeSouthwickBaseRealRight  = NULL;
	lineFrogScfeSouthwickBaseRealLeft  = NULL;
	
	lineFrogScfeSouthwickBaseCloneRight  = NULL;
	lineFrogScfeSouthwickBaseCloneLeft  = NULL;
	
	pointPrefs = NULL;
	
	lastPrevAddedRoi = NULL;
	
	
	result_LCE_right = -1000.0;
	result_LCE_left = -1000.0;
	result_Tonnis_right = -1000.0;
	result_Tonnis_left = -1000.0;
	result_JSW_right = -1000.0;
	result_JSW_left = -1000.0;
	result_PelvicTilt = -1000.0;
	result_PelvicRot = -1000.0;
	
	result_FP_ACE = -1000.0;
	guessed_FP_ACE_side = 0;
	
	result_Frog_Alpha_right = -1000.0;
	result_Frog_Alpha_left = -1000.0;
	
	result_Frog_HNOffset_left = -1000.0;
	result_Frog_HNOffset_right = -1000.0;
	
	result_FrogScfe_Southwick_left = -1000.0;
	result_FrogScfe_Southwick_right = -1000.0;
	
	result_FrogScfe_EMOffset_left = -1000.0;
	result_FrogScfe_EMOffset_right = -1000.0;
	
	currDCMPix = NULL;
	currDCMView = NULL;
	
}

-(void)restart :( ViewerController*) viewerController : (BOOL) include_prefs {
	
	NSMutableArray  *roiSeriesList;
	NSMutableArray  *roiImageList;
	
	//if(include_prefs==YES) NSLog(@"restart: include_prefs = YES");
	//else NSLog(@"restart: include_prefs = NO");
	
	roiSeriesList = [viewerController roiList];
	roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
	
	if(pointFemoralHeadRight1 != NULL) [roiImageList removeObject:pointFemoralHeadRight1];
	if(pointFemoralHeadRight2 != NULL) [roiImageList removeObject:pointFemoralHeadRight2];
	if(pointFemoralHeadRight3 != NULL) [roiImageList removeObject:pointFemoralHeadRight3];
	
	if(pointLateralSourcilRight != NULL) [roiImageList removeObject:pointLateralSourcilRight];
	if(pointMedialSourcilRight != NULL) [roiImageList removeObject:pointMedialSourcilRight];
	
	if(pointFemoralHeadLeft1 != NULL) [roiImageList removeObject:pointFemoralHeadLeft1];
	if(pointFemoralHeadLeft2 != NULL) [roiImageList removeObject:pointFemoralHeadLeft2];
	if(pointFemoralHeadLeft3 != NULL) [roiImageList removeObject:pointFemoralHeadLeft3];
	
	if(pointLateralSourcilLeft != NULL) [roiImageList removeObject:pointLateralSourcilLeft];
	if(pointMedialSourcilLeft != NULL) [roiImageList removeObject:pointMedialSourcilLeft];
	
	if(pointJSWRight != NULL) [roiImageList removeObject:pointJSWRight];
	if(pointJSWLeft != NULL) [roiImageList removeObject:pointJSWLeft];
	
	if(pointSacrococcygealJoint != NULL) [roiImageList removeObject:pointSacrococcygealJoint];
	if(pointPublicSymphysis != NULL) [roiImageList removeObject:pointPublicSymphysis];
	
	//False Profile
	if(pointFPFemoralHead1 != NULL) [roiImageList removeObject:pointFPFemoralHead1];
	if(pointFPFemoralHead2 != NULL) [roiImageList removeObject:pointFPFemoralHead2];
	if(pointFPFemoralHead3 != NULL) [roiImageList removeObject:pointFPFemoralHead3];
	if(pointFPAnteriorEdgeSourcil != NULL) [roiImageList removeObject:pointFPAnteriorEdgeSourcil];
	
	//Frog
	if(pointFrogNarrowestFemoralNeckRight1 != NULL) [roiImageList removeObject:pointFrogNarrowestFemoralNeckRight1];
	if(pointFrogNarrowestFemoralNeckRight2 != NULL) [roiImageList removeObject:pointFrogNarrowestFemoralNeckRight2];
	
	if(pointFrogNarrowestFemoralNeckLeft1 != NULL) [roiImageList removeObject:pointFrogNarrowestFemoralNeckLeft1];
	if(pointFrogNarrowestFemoralNeckLeft2 != NULL) [roiImageList removeObject:pointFrogNarrowestFemoralNeckLeft2];
	
	if(pointFrogFemoralHeadExceedsCircleRight != NULL) [roiImageList removeObject:pointFrogFemoralHeadExceedsCircleRight];
	if(pointFrogFemoralHeadExceedsCircleLeft != NULL) [roiImageList removeObject:pointFrogFemoralHeadExceedsCircleLeft];
	
	if(pointFrogAnteriorFemoralNeckRight != NULL) [roiImageList removeObject:pointFrogAnteriorFemoralNeckRight];
	if(pointFrogAnteriorFemoralNeckLeft != NULL) [roiImageList removeObject:pointFrogAnteriorFemoralNeckLeft];
	
	// Frog SCFE	
	if(pointFrogScfeEpiphysisSuperiorRight != NULL) [roiImageList removeObject:pointFrogScfeEpiphysisSuperiorRight];
	if(pointFrogScfeEpiphysisInferiorRight != NULL) [roiImageList removeObject:pointFrogScfeEpiphysisInferiorRight];
	
	if(pointFrogScfeEpiphysisSuperiorLeft != NULL) [roiImageList removeObject:pointFrogScfeEpiphysisSuperiorLeft];
	if(pointFrogScfeEpiphysisInferiorLeft != NULL) [roiImageList removeObject:pointFrogScfeEpiphysisInferiorLeft];
	
	if(pointFrogScfeFemoralHeadRight != NULL) [roiImageList removeObject:pointFrogScfeFemoralHeadRight];
	if(pointFrogScfeFemoralHeadLeft != NULL) [roiImageList removeObject:pointFrogScfeFemoralHeadLeft];
	
	if(pointFrogScfeAlphaAdjustRight != NULL) [roiImageList removeObject:pointFrogScfeAlphaAdjustRight];
	if(pointFrogScfeAlphaAdjustLeft != NULL) [roiImageList removeObject:pointFrogScfeAlphaAdjustLeft];
	
	if(pointFrogScfeShaftSuperiorRight1 != NULL) [roiImageList removeObject:pointFrogScfeShaftSuperiorRight1];
	if(pointFrogScfeShaftSuperiorRight2 != NULL) [roiImageList removeObject:pointFrogScfeShaftSuperiorRight2];
	if(pointFrogScfeShaftInferiorRight1 != NULL) [roiImageList removeObject:pointFrogScfeShaftInferiorRight1];
	if(pointFrogScfeShaftInferiorRight2 != NULL) [roiImageList removeObject:pointFrogScfeShaftInferiorRight2];
	
	if(pointFrogScfeShaftSuperiorLeft1 != NULL) [roiImageList removeObject:pointFrogScfeShaftSuperiorLeft1];
	if(pointFrogScfeShaftSuperiorLeft2 != NULL) [roiImageList removeObject:pointFrogScfeShaftSuperiorLeft2];
	if(pointFrogScfeShaftInferiorLeft1 != NULL) [roiImageList removeObject:pointFrogScfeShaftInferiorLeft1];
	if(pointFrogScfeShaftInferiorLeft2 != NULL) [roiImageList removeObject:pointFrogScfeShaftInferiorLeft2];
	
	if(pointFrogScfeMetaphysisRight != NULL) [roiImageList removeObject:pointFrogScfeMetaphysisRight];
	if(pointFrogScfeMetaphysisLeft != NULL) [roiImageList removeObject:pointFrogScfeMetaphysisLeft];
	
	// ----- Helper rois -----
	if(circleFemoralHeadRight != NULL) [roiImageList removeObject:circleFemoralHeadRight];
	if(circleFemoralHeadLeft != NULL) [roiImageList removeObject:circleFemoralHeadLeft];
	if(lineBetweenFemoralHeads != NULL) [roiImageList removeObject:lineBetweenFemoralHeads];
	
	if(angleTonnisRight != NULL) [roiImageList removeObject:angleTonnisRight];
	if(angleTonnisLeft != NULL) [roiImageList removeObject:angleTonnisLeft];
	if(angleLCERight != NULL) [roiImageList removeObject:angleLCERight];	
	if(angleLCELeft != NULL) [roiImageList removeObject:angleLCELeft];
	
	if(lineJSWRight != NULL) [roiImageList removeObject:lineJSWRight];
	if(lineJSWLeft != NULL) [roiImageList removeObject:lineJSWLeft];	
	if(lineSacToSymph != NULL) [roiImageList removeObject:lineSacToSymph];
	
	//False Profile
	if(circleFPFemoralHead != NULL) [roiImageList removeObject:circleFPFemoralHead];
	if(angleFPACE != NULL) [roiImageList removeObject:angleFPACE];
	
	//Frog
	if(lineFrogNarrowestFemoralNeckRight != NULL) [roiImageList removeObject:lineFrogNarrowestFemoralNeckRight];
	if(lineFrogNarrowestFemoralNeckLeft != NULL) [roiImageList removeObject:lineFrogNarrowestFemoralNeckLeft];
	if(angleFrogAlphaRight != NULL) [roiImageList removeObject:angleFrogAlphaRight];
	if(angleFrogAlphaLeft != NULL) [roiImageList removeObject:angleFrogAlphaLeft];
	
	if(lineFrogHNOffsetOuterRight != NULL) [roiImageList removeObject:lineFrogHNOffsetOuterRight];
	if(lineFrogHNOffsetInnerRight != NULL) [roiImageList removeObject:lineFrogHNOffsetInnerRight];
	if(lineFrogHNOffsetOuterLeft != NULL) [roiImageList removeObject:lineFrogHNOffsetOuterLeft];
	if(lineFrogHNOffsetInnerLeft != NULL) [roiImageList removeObject:lineFrogHNOffsetInnerLeft];
	
	// Frog SCFE
	if(lineFrogScfeCrossShaftUpperRight != NULL) [roiImageList removeObject:lineFrogScfeCrossShaftUpperRight];
	if(lineFrogScfeCrossShaftLowerRight != NULL) [roiImageList removeObject:lineFrogScfeCrossShaftLowerRight];
	if(lineFrogScfeCrossShaftUpperLeft != NULL) [roiImageList removeObject:lineFrogScfeCrossShaftUpperLeft];
	if(lineFrogScfeCrossShaftLowerLeft != NULL) [roiImageList removeObject:lineFrogScfeCrossShaftLowerLeft];
	if(lineFrogScfeEMOffsetOuterRight != NULL) [roiImageList removeObject:lineFrogScfeEMOffsetOuterRight];
	if(lineFrogScfeEMOffsetInnerRight != NULL) [roiImageList removeObject:lineFrogScfeEMOffsetInnerRight];	
	if(lineFrogScfeEMOffsetOuterLeft != NULL) [roiImageList removeObject:lineFrogScfeEMOffsetOuterLeft];
	if(lineFrogScfeEMOffsetInnerLeft != NULL) [roiImageList removeObject:lineFrogScfeEMOffsetInnerLeft];	
	if(angleFrogScfeSouthwickRight != NULL) [roiImageList removeObject:angleFrogScfeSouthwickRight];
	if(angleFrogScfeSouthwickLeft != NULL) [roiImageList removeObject:angleFrogScfeSouthwickLeft];	
	if(lineFrogScfeAlphaCenterRight != NULL) [roiImageList removeObject:lineFrogScfeAlphaCenterRight];
	if(lineFrogScfeAlphaCenterLeft != NULL) [roiImageList removeObject:lineFrogScfeAlphaCenterLeft];
	if(lineFrogScfeAlphaAdjustRight != NULL) [roiImageList removeObject:lineFrogScfeAlphaAdjustRight];
	if(lineFrogScfeAlphaAdjustLeft != NULL) [roiImageList removeObject:lineFrogScfeAlphaAdjustLeft];
	if(lineFrogScfeSouthwickBaseRealRight != NULL) [roiImageList removeObject:lineFrogScfeSouthwickBaseRealRight];
	if(lineFrogScfeSouthwickBaseRealLeft != NULL) [roiImageList removeObject:lineFrogScfeSouthwickBaseRealLeft];
	if(lineFrogScfeSouthwickBaseCloneRight != NULL) [roiImageList removeObject:lineFrogScfeSouthwickBaseCloneRight];
	if(lineFrogScfeSouthwickBaseCloneLeft != NULL) [roiImageList removeObject:lineFrogScfeSouthwickBaseCloneLeft];
	
	if(include_prefs == YES){
		if(pointPrefs != NULL) [roiImageList removeObject:pointPrefs];
	}
	
	[viewerController needsDisplayUpdate];
	
}


-(int)getStep {
	return curr_Step;
}

-(int)getNextStep {
	return next_Step;
}


-(void)setStep: (int)step : (int)op_mode{
	
	switch (op_mode) {
		case AP:
			if(step <= NBR_OF_STEPS) {
				curr_Step = step;	 
			} else curr_Step = NBR_OF_STEPS;
			break;
			
		case FP:
			if(step <= NBR_OF_STEPS_FP) {
				curr_Step = step;	 
			} else curr_Step = NBR_OF_STEPS_FP;
			break;
			
		case Frog:
			if(step <= NBR_OF_STEPS_FROG) {
				curr_Step = step;	 
			} else curr_Step = NBR_OF_STEPS_FROG;
			break;
			
		case FrogScfe:
			if(step <= NBR_OF_STEPS_FROG_SCFE) {
				curr_Step = step;	 
			} else curr_Step = NBR_OF_STEPS_FROG_SCFE;
			break;
            
        case Alpha:
			if(step <= NBR_OF_STEPS_ALPHA) {
				curr_Step = step;	 
			} else curr_Step = NBR_OF_STEPS_ALPHA;
			break;    
			
		default:
			curr_Step = 1;
			break;
	}
		
	
	if(pointPrefs != NULL) {
		[pointPrefs setComments:[NSString stringWithFormat:@"op:%d cs:%d ", op_mode, curr_Step]];
	}
	
} 

-(int)roiAdded: (NSNotification*)notification : (int) op_mode : (ViewerController*) viewerController {
	
	NSMutableArray  *roiSeriesList;
	NSMutableArray  *roiImageList;

	int retval = 0;
	ROI* roi = [[notification userInfo] objectForKey:@"ROI"];
	ROI* temp_roi;
	int nbrOfSteps = 1;
		
	if(op_mode==AP) nbrOfSteps = NBR_OF_STEPS;
	if(op_mode==FP) nbrOfSteps = NBR_OF_STEPS_FP;
	if(op_mode==Frog) nbrOfSteps = NBR_OF_STEPS_FROG;
	if(op_mode==FrogScfe) nbrOfSteps = NBR_OF_STEPS_FROG_SCFE;
    if(op_mode==Alpha) nbrOfSteps = NBR_OF_STEPS_ALPHA;
	
	//NSLog(@"roi added");
	
	//NSRunInformationalAlertPanel(@"roi added", @" " , @"OK", 0L, 0L);
	
	if ([roi type] == [[NSNumber numberWithLong:t2DPoint] longValue] && curr_Step > 0 && curr_Step < nbrOfSteps)
	{ 		
		
		DCMView* view = [roi curView];
		ViewerController* viewerController = [[view window] windowController];
	
		//NSRunInformationalAlertPanel(@"curr image", [NSString stringWithFormat:@"%d", [[viewerController imageView] curImage]] , @"OK", 0L, 0L);		
		[roi setTextBoxOffset:NSMakePoint ([[[viewerController imageView] curDCM] pwidth]/40, -[[[viewerController imageView] curDCM] pheight]/10)];		
		[roi setThickness:1.0 globally: NO];
		[roi setSelectable:TRUE];
		//[roi setROIMode:ROI_sleep];
		[roi setDisplayTextualData:FALSE];
		
		//not nessecary, since it will be done by roi_changed function
		//if(lastPrevAddedRoi!=NULL) {
		//	[lastPrevAddedRoi setDisplayTextualData:TRUE];
		//}
		
		if(op_mode == AP) {
		
			switch (curr_Step) {
				case 1:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_RIGHT];
					pointFemoralHeadRight1 = roi;	
					break;				
				case 2:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_RIGHT];
					pointFemoralHeadRight2 = roi;
					break;					
				case 3:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_RIGHT];
					pointFemoralHeadRight3 = roi;
					break;
                case 4:					
					[roi setNSColor:[NSColor cyanColor] globally:NO];
					[roi setName:NAME_FROG_NARROWEST_FEMORAL_RIGHT];				
					pointFrogNarrowestFemoralNeckRight1 = roi;
					break;				
				case 5:					
					[roi setNSColor:[NSColor cyanColor] globally:NO];
					[roi setName:NAME_FROG_NARROWEST_FEMORAL_RIGHT];				
					pointFrogNarrowestFemoralNeckRight2 = roi;
					break;				
				case 6:					
					[roi setNSColor:[NSColor redColor] globally:NO];
					[roi setName:NAME_FROG_EXCEEDS_CIRCLE_RIGHT];				
					pointFrogFemoralHeadExceedsCircleRight = roi;
					break;
				case 7:					
					[roi setNSColor:[NSColor purpleColor] globally:NO];
					[roi setName:NAME_LATERAL_SOURCIL_RIGHT];				
					pointLateralSourcilRight = roi;
					break;				
				case 8:					
					[roi setNSColor:[NSColor purpleColor] globally:NO];
					[roi setName:NAME_MEDIAL_SOURCIL_RIGHT];				
					pointMedialSourcilRight = roi;
					break;				
				case 9:					
					[roi setNSColor:[NSColor magentaColor] globally:NO];
					[roi setName:NAME_JSW_RIGHT];				
					pointJSWRight = roi;
					break;								
				case 10:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_LEFT];
					pointFemoralHeadLeft1 = roi;	
					break;				
				case 11:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_LEFT];
					pointFemoralHeadLeft2 = roi;	
					break;				
				case 12:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_LEFT];
					pointFemoralHeadLeft3 = roi;	
					break;
				case 13:					
					[roi setNSColor:[NSColor cyanColor] globally:NO];
					[roi setName:NAME_FROG_NARROWEST_FEMORAL_LEFT];				
					pointFrogNarrowestFemoralNeckLeft1 = roi;
					break;				
				case 14:					
					[roi setNSColor:[NSColor cyanColor] globally:NO];
					[roi setName:NAME_FROG_NARROWEST_FEMORAL_LEFT];				
					pointFrogNarrowestFemoralNeckLeft2 = roi;
					break;				
				case 15:					
					[roi setNSColor:[NSColor redColor] globally:NO];
					[roi setName:NAME_FROG_EXCEEDS_CIRCLE_LEFT];				
					pointFrogFemoralHeadExceedsCircleLeft = roi;
					break;	
				case 16:					
					[roi setNSColor:[NSColor purpleColor] globally:NO];
					[roi setName:NAME_LATERAL_SOURCIL_LEFT];				
					pointLateralSourcilLeft = roi;
					break;				
				case 17:					
					[roi setNSColor:[NSColor purpleColor] globally:NO];
					[roi setName:NAME_MEDIAL_SOURCIL_LEFT];				
					pointMedialSourcilLeft = roi;
					break;				
				case 18:					
					[roi setNSColor:[NSColor magentaColor] globally:NO];
					[roi setName:NAME_JSW_LEFT];				
					pointJSWLeft = roi;
					break;				
				case 19:					
					[roi setNSColor:[NSColor cyanColor] globally:NO];
					[roi setName:NAME_SAC_JOINT];				
					pointSacrococcygealJoint = roi;
					break;				
				case 20:					
					[roi setNSColor:[NSColor cyanColor] globally:NO];
					[roi setName:NAME_PUB_SYMPH];
					pointPublicSymphysis = roi;
					break;	
					
				default:
					retval = -1;
					curr_Step--;
					break;
			} 
		
		} else if(op_mode == FP) {
			
			switch (curr_Step) {
				case 1:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FP_FEMORAL_HEAD];
					pointFPFemoralHead1 = roi;	
					break;				
				case 2:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FP_FEMORAL_HEAD];
					pointFPFemoralHead2 = roi;
					break;					
				case 3:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FP_FEMORAL_HEAD];
					pointFPFemoralHead3 = roi;
					break;						
				case 4:					
					[roi setNSColor:[NSColor redColor] globally:NO];
					[roi setName:NAME_FP_ANTERIOR_SOURCIL];				
					pointFPAnteriorEdgeSourcil = roi;
					break;				
												
				default:
					retval = -1;
					curr_Step--;
					break;
			} 
						
		} else if(op_mode == Frog) {
			
			switch (curr_Step) {
				case 1:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_RIGHT];
					pointFemoralHeadRight1 = roi;	
					break;				
				case 2:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_RIGHT];
					pointFemoralHeadRight2 = roi;
					break;					
				case 3:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_RIGHT];
					pointFemoralHeadRight3 = roi;
					break;						
				case 4:					
					[roi setNSColor:[NSColor cyanColor] globally:NO];
					[roi setName:NAME_FROG_NARROWEST_FEMORAL_RIGHT];				
					pointFrogNarrowestFemoralNeckRight1 = roi;
					break;				
				case 5:					
					[roi setNSColor:[NSColor cyanColor] globally:NO];
					[roi setName:NAME_FROG_NARROWEST_FEMORAL_RIGHT];				
					pointFrogNarrowestFemoralNeckRight2 = roi;
					break;				
				case 6:					
					[roi setNSColor:[NSColor redColor] globally:NO];
					[roi setName:NAME_FROG_EXCEEDS_CIRCLE_RIGHT];				
					pointFrogFemoralHeadExceedsCircleRight = roi;
					break;	
				case 7:					
					[roi setNSColor:[NSColor yellowColor] globally:NO];
					[roi setName:NAME_FROG_ANTERIOR_FEMORAL_NECK_RIGHT];				
					pointFrogAnteriorFemoralNeckRight = roi;
					break;					
				case 8: 				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_LEFT];
					pointFemoralHeadLeft1 = roi;	
					break;				
				case 9:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_LEFT];
					pointFemoralHeadLeft2 = roi;	
					break;				
				case 10:				
					[roi setNSColor:[NSColor blueColor] globally:NO];
					[roi setName:NAME_FEMORAL_HEAD_LEFT];
					pointFemoralHeadLeft3 = roi;	
					break;					
				case 11:					
					[roi setNSColor:[NSColor cyanColor] globally:NO];
					[roi setName:NAME_FROG_NARROWEST_FEMORAL_LEFT];				
					pointFrogNarrowestFemoralNeckLeft1 = roi;
					break;				
				case 12:					
					[roi setNSColor:[NSColor cyanColor] globally:NO];
					[roi setName:NAME_FROG_NARROWEST_FEMORAL_LEFT];				
					pointFrogNarrowestFemoralNeckLeft2 = roi;
					break;				
				case 13:					
					[roi setNSColor:[NSColor redColor] globally:NO];
					[roi setName:NAME_FROG_EXCEEDS_CIRCLE_LEFT];				
					pointFrogFemoralHeadExceedsCircleLeft = roi;
					break;	
				case 14:					
					[roi setNSColor:[NSColor yellowColor] globally:NO];
					[roi setName:NAME_FROG_ANTERIOR_FEMORAL_NECK_LEFT];				
					pointFrogAnteriorFemoralNeckLeft = roi;
					break;	
					
				default:
					retval = -1;
					curr_Step--;
					break;
				}
			} else if(op_mode == FrogScfe) {
				
				switch (curr_Step) {
					case 1:				
						[roi setNSColor:[NSColor yellowColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_EPIPHYSIS_SUPERIOR_RIGHT];
						pointFrogScfeEpiphysisSuperiorRight = roi;	
						break;				
					case 2:				
						[roi setNSColor:[NSColor yellowColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_EPIPHYSIS_INFERIOR_RIGHT];
						pointFrogScfeEpiphysisInferiorRight = roi;
						break;					
					case 3:				
						[roi setNSColor:[NSColor blueColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_FEMORAL_HEAD_RIGHT];
						pointFrogScfeFemoralHeadRight = roi;
						break;						
					case 4:					
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_NARROWEST_FEMORAL_RIGHT];				
						pointFrogNarrowestFemoralNeckRight1 = roi;
						break;				
					case 5:					
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_NARROWEST_FEMORAL_RIGHT];				
						pointFrogNarrowestFemoralNeckRight2 = roi;
						break;				
					case 6:					
						[roi setNSColor:[NSColor redColor] globally:NO];
						[roi setName:NAME_FROG_EXCEEDS_CIRCLE_RIGHT];				
						pointFrogFemoralHeadExceedsCircleRight = roi;
						break;	
					case 7:					
						[roi setNSColor:[NSColor redColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_ALPHA_ADJUST_RIGHT];
						if (pointFrogScfeAlphaAdjustRight != NULL) {							
							waiting_for_alpha_adjust_right_flag = 0;
							temp_roi = pointFrogScfeAlphaAdjustRight;
							pointFrogScfeAlphaAdjustRight = roi;
							roiSeriesList = [viewerController roiList];
							roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];							
							[roiImageList removeObject:temp_roi];
						} else {
							pointFrogScfeAlphaAdjustRight = roi;
						}
						break;					
					case 8: 				
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_SHAFT_SUPERIOR_RIGHT];
						pointFrogScfeShaftSuperiorRight1 = roi;	
						break;				
					case 9:				
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_SHAFT_SUPERIOR_RIGHT];
						pointFrogScfeShaftSuperiorRight2 = roi;	
						break;				
					case 10:				
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_SHAFT_INFERIOR_RIGHT];
						pointFrogScfeShaftInferiorRight1 = roi;	
						break;					
					case 11:					
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_SHAFT_INFERIOR_RIGHT];				
						pointFrogScfeShaftInferiorRight2 = roi;
						break;				
					case 12:					
						[roi setNSColor:[NSColor yellowColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_METAPHYSIS_RIGHT];				
						pointFrogScfeMetaphysisRight = roi;
						break;				
					case 13:				
						[roi setNSColor:[NSColor yellowColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_EPIPHYSIS_SUPERIOR_LEFT];
						pointFrogScfeEpiphysisSuperiorLeft = roi;	
						break;				
					case 14:				
						[roi setNSColor:[NSColor yellowColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_EPIPHYSIS_INFERIOR_LEFT];
						pointFrogScfeEpiphysisInferiorLeft = roi;
						break;					
					case 15:				
						[roi setNSColor:[NSColor blueColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_FEMORAL_HEAD_LEFT];
						pointFrogScfeFemoralHeadLeft = roi;
						break;						
					case 16:					
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_NARROWEST_FEMORAL_LEFT];				
						pointFrogNarrowestFemoralNeckLeft1 = roi;
						break;				
					case 17:					
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_NARROWEST_FEMORAL_LEFT];				
						pointFrogNarrowestFemoralNeckLeft2 = roi;
						break;				
					case 18:					
						[roi setNSColor:[NSColor redColor] globally:NO];
						[roi setName:NAME_FROG_EXCEEDS_CIRCLE_LEFT];				
						pointFrogFemoralHeadExceedsCircleLeft = roi;
						break;	
					case 19:					
						[roi setNSColor:[NSColor redColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_ALPHA_ADJUST_LEFT];	
						if (pointFrogScfeAlphaAdjustLeft != NULL) {							
							waiting_for_alpha_adjust_left_flag = 0;
							temp_roi = pointFrogScfeAlphaAdjustLeft;
							pointFrogScfeAlphaAdjustLeft = roi;
							roiSeriesList = [viewerController roiList];
							roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];							
							[roiImageList removeObject:temp_roi];
						} else {
							pointFrogScfeAlphaAdjustLeft = roi;
						}
						break;					
					case 20: 				
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_SHAFT_SUPERIOR_LEFT];
						pointFrogScfeShaftSuperiorLeft1 = roi;	
						break;				
					case 21:				
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_SHAFT_SUPERIOR_LEFT];
						pointFrogScfeShaftSuperiorLeft2 = roi;	
						break;				
					case 22:				
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_SHAFT_INFERIOR_LEFT];
						pointFrogScfeShaftInferiorLeft1 = roi;	
						break;					
					case 23:					
						[roi setNSColor:[NSColor cyanColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_SHAFT_INFERIOR_LEFT];				
						pointFrogScfeShaftInferiorLeft2 = roi;
						break;				
					case 24:					
						[roi setNSColor:[NSColor yellowColor] globally:NO];
						[roi setName:NAME_FROG_SCFE_METAPHYSIS_LEFT];				
						pointFrogScfeMetaphysisLeft = roi;
						break;
						
					default:
						retval = -1;
						curr_Step--;
						break;
				}
			
            } else if(op_mode == Alpha) {
                
                switch (curr_Step) {
                    case 1:				
                        [roi setNSColor:[NSColor blueColor] globally:NO];
                        [roi setName:NAME_FEMORAL_HEAD_RIGHT];
                        pointFemoralHeadRight1 = roi;	
                        break;				
                    case 2:				
                        [roi setNSColor:[NSColor blueColor] globally:NO];
                        [roi setName:NAME_FEMORAL_HEAD_RIGHT];
                        pointFemoralHeadRight2 = roi;
                        break;					
                    case 3:				
                        [roi setNSColor:[NSColor blueColor] globally:NO];
                        [roi setName:NAME_FEMORAL_HEAD_RIGHT];
                        pointFemoralHeadRight3 = roi;
                        break;
                    case 4:					
                        [roi setNSColor:[NSColor cyanColor] globally:NO];
                        [roi setName:NAME_FROG_NARROWEST_FEMORAL_RIGHT];				
                        pointFrogNarrowestFemoralNeckRight1 = roi;
                        break;				
                    case 5:					
                        [roi setNSColor:[NSColor cyanColor] globally:NO];
                        [roi setName:NAME_FROG_NARROWEST_FEMORAL_RIGHT];				
                        pointFrogNarrowestFemoralNeckRight2 = roi;
                        break;				
                    case 6:					
                        [roi setNSColor:[NSColor redColor] globally:NO];
                        [roi setName:NAME_FROG_EXCEEDS_CIRCLE_RIGHT];				
                        pointFrogFemoralHeadExceedsCircleRight = roi;
                        break;
                    case 7:				
                        [roi setNSColor:[NSColor blueColor] globally:NO];
                        [roi setName:NAME_FEMORAL_HEAD_LEFT];
                        pointFemoralHeadLeft1 = roi;	
                        break;				
                    case 8:				
                        [roi setNSColor:[NSColor blueColor] globally:NO];
                        [roi setName:NAME_FEMORAL_HEAD_LEFT];
                        pointFemoralHeadLeft2 = roi;	
                        break;				
                    case 9:				
                        [roi setNSColor:[NSColor blueColor] globally:NO];
                        [roi setName:NAME_FEMORAL_HEAD_LEFT];
                        pointFemoralHeadLeft3 = roi;	
                        break;
                    case 10:					
                        [roi setNSColor:[NSColor cyanColor] globally:NO];
                        [roi setName:NAME_FROG_NARROWEST_FEMORAL_LEFT];				
                        pointFrogNarrowestFemoralNeckLeft1 = roi;
                        break;				
                    case 11:					
                        [roi setNSColor:[NSColor cyanColor] globally:NO];
                        [roi setName:NAME_FROG_NARROWEST_FEMORAL_LEFT];				
                        pointFrogNarrowestFemoralNeckLeft2 = roi;
                        break;				
                    case 12:					
                        [roi setNSColor:[NSColor redColor] globally:NO];
                        [roi setName:NAME_FROG_EXCEEDS_CIRCLE_LEFT];				
                        pointFrogFemoralHeadExceedsCircleLeft = roi;
                        break;	
                        
                    default:
                        retval = -1;
                        curr_Step--;
                        break;
                } 
                
            } else {
			retval = -1;
			curr_Step--;
		}
				
		curr_Step++;
	
		if(pointPrefs == NULL) {
			
			pointPrefs = [viewerController newROI: t2DPoint];
			[pointPrefs setNSColor:[[NSColor yellowColor] colorWithAlphaComponent:0.0] globally:NO];
			[pointPrefs setDisplayTextualData:NO];
			[pointPrefs setThickness:1.0 globally: NO];
			[pointPrefs setSelectable:NO];
			[pointPrefs setName:NAME_PREFS];	
			
			NSMutableArray* roiSeriesList = [viewerController roiList];
			NSMutableArray* roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: pointPrefs];	
		}	
		
		[pointPrefs setComments:[NSString stringWithFormat:@"op:%d cs:%d ", op_mode, curr_Step]];
			
		
		
		// this must be here, after the prefs roi is created. Otherwise
		// the roiChanged function will trig the TextualData to be shown
		// imediately for the first point, due to the creation of the 
		// prefs roi
		lastPrevAddedRoi = roi;
				
		retval = curr_Step;
		
	} 
	
	return(retval);
	
}


-(void)makeLastAddedRoiTextualInfoVisible {
	if(lastPrevAddedRoi!=NULL) {
		[lastPrevAddedRoi setDisplayTextualData:TRUE];
		[lastPrevAddedRoi setROIMode:ROI_sleep];
		lastPrevAddedRoi = NULL;
	}
}

-(void)roiSelected: (NSNotification*)notification : (ViewerController*) viewerController {
	//ROI* roi = [notification object];
	
	//if(currentlySelectedRoi != NULL) {
	//	[currentlySelectedRoi setDisplayTextualData:FALSE];
	//}
	
	//currentlySelectedRoi = roi;
	//[currentlySelectedRoi setDisplayTextualData:TRUE];
	
}

-(void)mouseClicked: (NSNotification*)notification : (ViewerController*) viewerController {

	//if(currentlySelectedRoi != NULL) {
	//	if([currentlySelectedRoi ROImode] == 0) {
	//		[currentlySelectedRoi setDisplayTextualData:FALSE];
	//		currentlySelectedRoi = NULL;
	//	}
	//
}



-(void)roiChanged: (NSNotification*)notification : (ViewerController*) viewerController : (OrthopaedicStudioFilter*) mainFilter {
	
	ROI* roi = [notification object];
	//NSLog(@"roiChanged: %@", [roi name]);
	
	if ([roi type] == [[NSNumber numberWithLong:t2DPoint] longValue] && roi != pointPrefs )
	{
	    
		
		// visa texual data för senst tillagda roien, om en annan roi nu väljs
		if(lastPrevAddedRoi != NULL && lastPrevAddedRoi != roi) {
			[lastPrevAddedRoi setDisplayTextualData:TRUE];
			lastPrevAddedRoi = NULL;
		}
		
		if(block_update_rois_flag == NO) {
			
			// väldigt osnygg hantering av alpha adjust for SCFE
			if(waiting_for_alpha_adjust_right_flag > 0 && roi == pointFrogScfeAlphaAdjustRight) {
				waiting_for_alpha_adjust_right_flag--;
				if(waiting_for_alpha_adjust_right_flag == 0){					
					curr_Step ++;
					[self displayROIInstructions:curr_Step:FrogScfe:mainFilter];
				}
			}
			   
			if(waiting_for_alpha_adjust_left_flag > 0 && roi == pointFrogScfeAlphaAdjustLeft) {
				waiting_for_alpha_adjust_left_flag--;
				if(waiting_for_alpha_adjust_left_flag == 0){					
					curr_Step ++;
					[self displayROIInstructions:curr_Step:FrogScfe:mainFilter];
				}
			}
			   
			
			[self updateCalculatedRois:viewerController];
		}
	}
}


-(void)updateCalculatedRois:(ViewerController*) viewerController {

	double x1;
	double y1;
	
	double x2;
	double y2;
	
	double x3;
	double y3;
	
	double x4;
	double y4;
	
	double x5;
	double y5;
	
	double x6;
	double y6;
	
	double x7;
	double y7;
	
	double s;
	double sUnder;
	
	double xc;
	double yc;
	double r;
		
	double xd;
	double yd;
		
	double k;
	double k2;

	double xr;		
	double yr;
	
	NSMutableArray  *roiSeriesList;
	NSMutableArray  *roiImageList;
	
	result_LCE_right = -1000.0;
	result_LCE_left = -1000.0;
	result_Tonnis_right = -1000.0;
	result_Tonnis_left = -1000.0;
	result_JSW_right = -1000.0;
	result_JSW_left = -1000.0;
	result_PelvicTilt = -1000.0;
	result_PelvicRot = -1000.0;
	
	result_FP_ACE = -1000.0;
	guessed_FP_ACE_side = 0;
	
	result_Frog_Alpha_right = -1000.0;
	result_Frog_Alpha_left = -1000.0;
	
	result_Frog_HNOffset_left = -1000.0;
	result_Frog_HNOffset_right = -1000.0;
	
	result_FrogScfe_Southwick_left = -1000.0;
	result_FrogScfe_Southwick_right = -1000.0;
	
	result_FrogScfe_EMOffset_left = -1000.0;
	result_FrogScfe_EMOffset_right = -1000.0;

	
	
	
	// Handle circle around right femoral head
	if ((pointFemoralHeadRight1 != NULL && pointFemoralHeadRight2 != NULL && pointFemoralHeadRight3 != NULL) ||
		(pointFrogScfeEpiphysisSuperiorRight != NULL && pointFrogScfeEpiphysisInferiorRight != NULL && pointFrogScfeFemoralHeadRight != NULL)) {
		
	
		if(circleFemoralHeadRight == NULL){
			circleFemoralHeadRight = [viewerController newROI: tOval];
			
			[circleFemoralHeadRight setNSColor:[NSColor blueColor] globally:NO];
			[circleFemoralHeadRight setDisplayTextualData:FALSE];
			[circleFemoralHeadRight setThickness:1.0 globally: NO];
			[circleFemoralHeadRight setSelectable:FALSE];
			[circleFemoralHeadRight setName:NAME_HELPER];	
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: circleFemoralHeadRight];

		}
					
		// are we doing regular circles or frog scfe circles?
		if(pointFemoralHeadRight1 != NULL && pointFemoralHeadRight2 != NULL && pointFemoralHeadRight3 != NULL) {

			x1 = [[[pointFemoralHeadRight1 points] objectAtIndex:0] x];
			y1 = [[[pointFemoralHeadRight1 points] objectAtIndex:0] y];
			
			x2 = [[[pointFemoralHeadRight2 points] objectAtIndex:0] x];
			y2 = [[[pointFemoralHeadRight2 points] objectAtIndex:0] y];
			
			x3 = [[[pointFemoralHeadRight3 points] objectAtIndex:0] x];
			y3 = [[[pointFemoralHeadRight3 points] objectAtIndex:0] y];
			
		} else {	
			x1 = [[[pointFrogScfeEpiphysisSuperiorRight points] objectAtIndex:0] x];
			y1 = [[[pointFrogScfeEpiphysisSuperiorRight points] objectAtIndex:0] y];
			
			x2 = [[[pointFrogScfeEpiphysisInferiorRight points] objectAtIndex:0] x];
			y2 = [[[pointFrogScfeEpiphysisInferiorRight points] objectAtIndex:0] y];
			
			x3 = [[[pointFrogScfeFemoralHeadRight points] objectAtIndex:0] x];
			y3 = [[[pointFrogScfeFemoralHeadRight points] objectAtIndex:0] y];
		}
		
		r = COORD_MAX; // initialize to value that will be ignored
		s = 0.5*((x2 - x3)*(x1 - x3) - (y2 - y3)*(y3 - y1));
		sUnder = (x1 - x2)*(y3 - y1) - (y2 - y1)*(x1 - x3);
		
		if(sUnder != 0)
		{
			s = s / sUnder;
			xc = 0.5*(x1 + x2) + s*(y2 - y1); // center x coordinate
			yc = 0.5*(y1 + y2) + s*(x1 - x2); // center y coordinate
			r = sqrt(pow((x1-xc), 2) + pow((y1-yc), 2));
		}
		//NSLog(@"xc: %f yc: %f r: %f", xc, yc, r);
		
		if(r<COORD_MAX) {
			NSRect outerrect = NSMakeRect(xc, yc, r, r);
			[circleFemoralHeadRight setROIRect:outerrect];
			[viewerController needsDisplayUpdate];
		}
	} else if(circleFemoralHeadRight != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: circleFemoralHeadRight];
		circleFemoralHeadRight = NULL;
	}
	
	
	
	// Handle circle around left femoral head
	if (pointFemoralHeadLeft1 != NULL && pointFemoralHeadLeft2 != NULL && pointFemoralHeadLeft3 != NULL ||
		(pointFrogScfeEpiphysisSuperiorLeft != NULL && pointFrogScfeEpiphysisInferiorLeft != NULL && pointFrogScfeFemoralHeadLeft != NULL)) {
		
		if(circleFemoralHeadLeft == NULL){
			circleFemoralHeadLeft = [viewerController newROI: tOval];
			
			[circleFemoralHeadLeft setNSColor:[NSColor blueColor] globally:NO];
			[circleFemoralHeadLeft setDisplayTextualData:FALSE];
			[circleFemoralHeadLeft setThickness:1.0 globally: NO];
			[circleFemoralHeadLeft setSelectable:FALSE];
			[circleFemoralHeadLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: circleFemoralHeadLeft];
			
		}
			
		// are we doing regular circles or frog scfe circles?
		if(pointFemoralHeadLeft1 != NULL && pointFemoralHeadLeft2 != NULL && pointFemoralHeadLeft3 != NULL) {
			x1 = [[[pointFemoralHeadLeft1 points] objectAtIndex:0] x];
			y1 = [[[pointFemoralHeadLeft1 points] objectAtIndex:0] y];
			
			x2 = [[[pointFemoralHeadLeft2 points] objectAtIndex:0] x];
			y2 = [[[pointFemoralHeadLeft2 points] objectAtIndex:0] y];
			
			x3 = [[[pointFemoralHeadLeft3 points] objectAtIndex:0] x];
			y3 = [[[pointFemoralHeadLeft3 points] objectAtIndex:0] y];
			
		} else {	
			
			x1 = [[[pointFrogScfeEpiphysisSuperiorLeft points] objectAtIndex:0] x];
			y1 = [[[pointFrogScfeEpiphysisSuperiorLeft points] objectAtIndex:0] y];
			
			x2 = [[[pointFrogScfeEpiphysisInferiorLeft points] objectAtIndex:0] x];
			y2 = [[[pointFrogScfeEpiphysisInferiorLeft points] objectAtIndex:0] y];
			
			x3 = [[[pointFrogScfeFemoralHeadLeft points] objectAtIndex:0] x];
			y3 = [[[pointFrogScfeFemoralHeadLeft points] objectAtIndex:0] y];
		}
		
		s = 0.5*((x2 - x3)*(x1 - x3) - (y2 - y3)*(y3 - y1));
		sUnder = (x1 - x2)*(y3 - y1) - (y2 - y1)*(x1 - x3);
		
		if(sUnder != 0)
		{
			s = s / sUnder;
			xc = 0.5*(x1 + x2) + s*(y2 - y1); // center x coordinate
			yc = 0.5*(y1 + y2) + s*(x1 - x2); // center y coordinate
			r = sqrt(pow((x1-xc), 2) + pow((y1-yc), 2));
		}
		
		if(r<COORD_MAX) {
			NSRect outerrect = NSMakeRect(xc, yc, r, r);
			[circleFemoralHeadLeft setROIRect:outerrect];
			[viewerController needsDisplayUpdate];
		}
	} else if(circleFemoralHeadLeft != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: circleFemoralHeadLeft];
		circleFemoralHeadLeft = NULL;
	}
	
	/* // Handle line between femoral heads
		if (circleFemoralHeadRight != NULL && circleFemoralHeadLeft != NULL) {
		
			if(lineBetweenFemoralHeads == NULL){
				lineBetweenFemoralHeads = [viewerController newROI: tMesure];
				
				[lineBetweenFemoralHeads setNSColor:[NSColor redColor] globally:NO];
				[lineBetweenFemoralHeads setDisplayTextualData:FALSE];
				[lineBetweenFemoralHeads setThickness:1.0 globally: NO];
				[lineBetweenFemoralHeads setSelectable:FALSE];
				[lineBetweenFemoralHeads setName:NAME_HELPER];
				
				roiSeriesList = [viewerController roiList];
				roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
				
				[roiImageList addObject: lineBetweenFemoralHeads];
			}
			
			
			NSMutableArray  *points = [lineBetweenFemoralHeads points];
			[points removeAllObjects];
			
			x1 = [circleFemoralHeadRight rect].origin.x;
			y1 = [circleFemoralHeadRight rect].origin.y;
			
			x2 = [circleFemoralHeadLeft rect].origin.x;
			y2 = [circleFemoralHeadLeft rect].origin.y;
			
			[points addObject: [viewerController newPoint: x1 : y1]]; 
			[points addObject: [viewerController newPoint: x2 : y2]];
		
			//[lineBetweenFemoralHeads points] = points;
			
			[viewerController needsDisplayUpdate];
		
	 }  else if(lineBetweenFemoralHeads != NULL) {
	 roiSeriesList = [viewerController roiList];
	 roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
	 
	 [roiImageList removeObject: lineBetweenFemoralHeads];
	 lineBetweenFemoralHeads = NULL;
	 }*/
	
	

	// Tönnis angle right
	if (circleFemoralHeadRight != NULL && circleFemoralHeadLeft != NULL && 
		pointLateralSourcilRight != NULL && pointMedialSourcilRight != NULL) {
	
		if(angleTonnisRight == NULL){
			angleTonnisRight = [viewerController newROI: tAngle];
			
			[angleTonnisRight setNSColor:[NSColor purpleColor] globally:NO];
			[angleTonnisRight setDisplayTextualData:FALSE];
			[angleTonnisRight setThickness:1.0 globally: NO];
			[angleTonnisRight setSelectable:FALSE];
			[angleTonnisRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: angleTonnisRight];
		}
		
		NSMutableArray  *points = [angleTonnisRight points];
		[points removeAllObjects];

		x1 = [[[pointLateralSourcilRight points] objectAtIndex:0] x];
		y1 = [[[pointLateralSourcilRight points] objectAtIndex:0] y];		
		
		x2 = [[[pointMedialSourcilRight points] objectAtIndex:0] x];
		y2 = [[[pointMedialSourcilRight points] objectAtIndex:0] y];
			
		x3 = [circleFemoralHeadRight rect].origin.x;
		y3 = y2 - (([circleFemoralHeadLeft rect].origin.y - [circleFemoralHeadRight rect].origin.y)* (x2-[circleFemoralHeadRight rect].origin.x) / ([circleFemoralHeadLeft rect].origin.x - [circleFemoralHeadRight rect].origin.x));
	
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		[points addObject: [viewerController newPoint: x3 : y3]];
				
		[viewerController needsDisplayUpdate];		
		result_Tonnis_right = [angleTonnisRight Angle: [[points objectAtIndex:0] point] :[[points objectAtIndex:1] point] :[[points objectAtIndex:2] point]];
	
		if (y3 < ( y1 + (y2-y1)*(x3-x1)/(x2-x1) )) {
			result_Tonnis_right = -result_Tonnis_right;
		}
		
	} else if(angleTonnisRight != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: angleTonnisRight];
		angleTonnisRight = NULL;
	}
	
	
	// Tönnis angle left
	if (circleFemoralHeadRight != NULL && circleFemoralHeadLeft != NULL && 
		pointLateralSourcilLeft != NULL && pointMedialSourcilLeft != NULL) {
		
		if(angleTonnisLeft == NULL){
			angleTonnisLeft = [viewerController newROI: tAngle];
			
			[angleTonnisLeft setNSColor:[NSColor purpleColor] globally:NO];
			[angleTonnisLeft setDisplayTextualData:FALSE];
			[angleTonnisLeft setThickness:1.0 globally: NO];
			[angleTonnisLeft setSelectable:FALSE];
			[angleTonnisLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: angleTonnisLeft];
		}
		
		NSMutableArray  *points = [angleTonnisLeft points];
		[points removeAllObjects];
		
		x1 = [[[pointLateralSourcilLeft points] objectAtIndex:0] x];
		y1 = [[[pointLateralSourcilLeft points] objectAtIndex:0] y];		
		
		x2 = [[[pointMedialSourcilLeft points] objectAtIndex:0] x];
		y2 = [[[pointMedialSourcilLeft points] objectAtIndex:0] y];
		
		x3 = [circleFemoralHeadLeft rect].origin.x;
		y3 = y2 - (([circleFemoralHeadLeft rect].origin.y - [circleFemoralHeadRight rect].origin.y)* (x2-[circleFemoralHeadLeft rect].origin.x) / ([circleFemoralHeadLeft rect].origin.x - [circleFemoralHeadRight rect].origin.x));
		
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		[points addObject: [viewerController newPoint: x3 : y3]];
		
		[viewerController needsDisplayUpdate];
		result_Tonnis_left = [angleTonnisLeft Angle: [[points objectAtIndex:0] point] :[[points objectAtIndex:1] point] :[[points objectAtIndex:2] point]];
	
		if (y3 < ( y1 + (y2-y1)*(x3-x1)/(x2-x1) )) {
			result_Tonnis_left = -result_Tonnis_left;
		}
		
	} else if(angleTonnisLeft != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: angleTonnisLeft];
		angleTonnisLeft = NULL;
	}
	
	
	// LCE angle right
	if (circleFemoralHeadRight != NULL && circleFemoralHeadLeft != NULL && pointLateralSourcilRight != NULL) {
		
		if(angleLCERight == NULL){
			angleLCERight = [viewerController newROI: tAngle];
			
			[angleLCERight setNSColor:[NSColor purpleColor] globally:NO];
			[angleLCERight setDisplayTextualData:FALSE];
			[angleLCERight setThickness:1.0 globally: NO];
			[angleLCERight setSelectable:FALSE];
			[angleLCERight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: angleLCERight];
		}
		
		NSMutableArray  *points = [angleLCERight points];
		[points removeAllObjects];
		
		x1 = [[[pointLateralSourcilRight points] objectAtIndex:0] x];
		y1 = [[[pointLateralSourcilRight points] objectAtIndex:0] y];		
		
		x2 = [circleFemoralHeadRight rect].origin.x;
		y2 = [circleFemoralHeadRight rect].origin.y;
		
		x3 = [circleFemoralHeadLeft rect].origin.x;
		y3 = [circleFemoralHeadLeft rect].origin.y;
	
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		[points addObject: [viewerController newPoint: x3 : y3]];
		
		[viewerController needsDisplayUpdate];
		result_LCE_right = [angleLCERight Angle: [[points objectAtIndex:0] point] :[[points objectAtIndex:1] point] :[[points objectAtIndex:2] point]] -90;
	
	} else if(angleLCERight != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: angleLCERight];
		angleLCERight = NULL;
	}
	
	
	// LCE angle left
	if (circleFemoralHeadRight != NULL && circleFemoralHeadLeft != NULL && pointLateralSourcilLeft != NULL) {
		
		if(angleLCELeft == NULL){
			angleLCELeft = [viewerController newROI: tAngle];
			
			[angleLCELeft setNSColor:[NSColor purpleColor] globally:NO];
			[angleLCELeft setDisplayTextualData:FALSE];
			[angleLCELeft setThickness:1.0 globally: NO];
			[angleLCELeft setSelectable:FALSE];
			[angleLCELeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: angleLCELeft];
		}
		
		NSMutableArray  *points = [angleLCELeft points];
		[points removeAllObjects];
		
		x1 = [circleFemoralHeadRight rect].origin.x;
		y1 = [circleFemoralHeadRight rect].origin.y;
		
		x2 = [circleFemoralHeadLeft rect].origin.x;
		y2 = [circleFemoralHeadLeft rect].origin.y;
		
		x3 = [[[pointLateralSourcilLeft points] objectAtIndex:0] x];
		y3 = [[[pointLateralSourcilLeft points] objectAtIndex:0] y];
		
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		[points addObject: [viewerController newPoint: x3 : y3]];
		
		[viewerController needsDisplayUpdate];
		result_LCE_left = [angleLCELeft Angle: [[points objectAtIndex:0] point] :[[points objectAtIndex:1] point] :[[points objectAtIndex:2] point]] -90;
	
	} else if(angleLCELeft != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: angleLCELeft];
		angleLCELeft = NULL;
	}
	
	
	// Handle JSW right
	if (circleFemoralHeadRight != NULL && pointJSWRight != NULL) {
		
		if(lineJSWRight == NULL){
			lineJSWRight = [viewerController newROI: tMesure];
			
			[lineJSWRight setNSColor:[NSColor magentaColor] globally:NO];
			[lineJSWRight setDisplayTextualData:FALSE];
			[lineJSWRight setThickness:1.0 globally: NO];
			[lineJSWRight setSelectable:FALSE];
			[lineJSWRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineJSWRight];
		}
		
		NSMutableArray  *points = [lineJSWRight points];
		[points removeAllObjects];
		
		x1 = [[[pointJSWRight points] objectAtIndex:0] x];
		y1 = [[[pointJSWRight points] objectAtIndex:0] y];
		
		x2 = [circleFemoralHeadRight rect].origin.x;
		y2 = [circleFemoralHeadRight rect].origin.y;
		
		xd = x1-x2;
		yd = y1-y2;
		
		r = [circleFemoralHeadRight rect].size.height;
		//l = sqrt(xd*xd + yd*yd);
			
		k = yd/xd;
		//yd = xd*k;		
		//r*r = xr*xr + k*k*xr*xr;
		//r*r = (k*k +1) * xr*xr;		
		//r = sqrt(k*k+1) *xr;
		
		xr = r / sqrt(k*k+1);		
		if(xd<0) xr = -xr;
		
		yr = xr*k;
		
		x3 = xr + x2;
		y3 = yr + y2;
		
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x3 : y3]];
				
		[viewerController needsDisplayUpdate];
		result_JSW_right = [lineJSWRight Length:[[points objectAtIndex:0] point] :[[points objectAtIndex:1] point]];  
		
	} else if(lineJSWRight != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: lineJSWRight];
		lineJSWRight = NULL;
	}
	
	// Handle JSW left
	if (circleFemoralHeadLeft != NULL && pointJSWLeft != NULL) {
		
		if(lineJSWLeft == NULL){
			lineJSWLeft = [viewerController newROI: tMesure];
			
			[lineJSWLeft setNSColor:[NSColor magentaColor] globally:NO];
			[lineJSWLeft setDisplayTextualData:FALSE];
			[lineJSWLeft setThickness:1.0 globally: NO];
			[lineJSWLeft setSelectable:FALSE];
			[lineJSWLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineJSWLeft];
		}
		
		NSMutableArray  *points = [lineJSWLeft points];
		[points removeAllObjects];
		
		x1 = [[[pointJSWLeft points] objectAtIndex:0] x];
		y1 = [[[pointJSWLeft points] objectAtIndex:0] y];
		
		x2 = [circleFemoralHeadLeft rect].origin.x;
		y2 = [circleFemoralHeadLeft rect].origin.y;
		
		xd = x1-x2;
		yd = y1-y2;
		
		r = [circleFemoralHeadLeft rect].size.height;
		k = yd/xd;	
		
		xr = r / sqrt(k*k+1);				
		if(xd<0) xr = -xr;
		
		yr = xr*k;
		
		x3 = xr + x2;
		y3 = yr + y2;
		
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x3 : y3]];
		
		[viewerController needsDisplayUpdate];
		result_JSW_left = [lineJSWLeft Length:[[points objectAtIndex:0] point] :[[points objectAtIndex:1] point]];
	
	}  else if(lineJSWLeft != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: lineJSWLeft];
		lineJSWLeft = NULL;
	}
	
	
	// Handle line between Sacrococcygeal Joint and Public Symphysis
	if (pointSacrococcygealJoint != NULL && pointPublicSymphysis != NULL) {
		
		if(lineSacToSymph == NULL){
			lineSacToSymph = [viewerController newROI: tMesure];
			
			[lineSacToSymph setNSColor:[NSColor cyanColor] globally:NO];
			[lineSacToSymph setDisplayTextualData:FALSE];
			[lineSacToSymph setThickness:1.0 globally: NO];
			[lineSacToSymph setSelectable:FALSE];
			[lineSacToSymph setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineSacToSymph];
		}
		
		
		NSMutableArray  *points = [lineSacToSymph points];
		[points removeAllObjects];
			
		x1 = [[[pointSacrococcygealJoint points] objectAtIndex:0] x];
		y1 = [[[pointSacrococcygealJoint points] objectAtIndex:0] y];
		
		x2 = [[[pointPublicSymphysis points] objectAtIndex:0] x];
		y2 = [[[pointPublicSymphysis points] objectAtIndex:0] y];
		
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		
		[viewerController needsDisplayUpdate];
		result_PelvicTilt = [lineSacToSymph Length:[[points objectAtIndex:0] point] :[[viewerController newPoint: x1 : y2] point]];
		result_PelvicRot = [lineSacToSymph Length:[[points objectAtIndex:0] point] :[[viewerController newPoint: x2 : y1] point]];
	
	}   else if(lineSacToSymph != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: lineSacToSymph];
		lineSacToSymph = NULL;
	}
	
	
	// Handle circle around femoral head for FP
	if (pointFPFemoralHead1 != NULL && pointFPFemoralHead2 != NULL && pointFPFemoralHead3 != NULL) {
		
		if(circleFPFemoralHead == NULL){
			circleFPFemoralHead = [viewerController newROI: tOval];
			
			[circleFPFemoralHead setNSColor:[NSColor blueColor] globally:NO];
			[circleFPFemoralHead setDisplayTextualData:FALSE];
			[circleFPFemoralHead setThickness:1.0 globally: NO];
			[circleFPFemoralHead setSelectable:FALSE];
			[circleFPFemoralHead setName:NAME_HELPER];	
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: circleFPFemoralHead];
			
		}
		
		x1 = [[[pointFPFemoralHead1 points] objectAtIndex:0] x];
		y1 = [[[pointFPFemoralHead1 points] objectAtIndex:0] y];
		
		x2 = [[[pointFPFemoralHead2 points] objectAtIndex:0] x];
		y2 = [[[pointFPFemoralHead2 points] objectAtIndex:0] y];
		
		x3 = [[[pointFPFemoralHead3 points] objectAtIndex:0] x];
		y3 = [[[pointFPFemoralHead3 points] objectAtIndex:0] y];
		
		s = 0.5*((x2 - x3)*(x1 - x3) - (y2 - y3)*(y3 - y1));
		sUnder = (x1 - x2)*(y3 - y1) - (y2 - y1)*(x1 - x3);
		
		if(sUnder != 0)
		{
			s = s / sUnder;
			xc = 0.5*(x1 + x2) + s*(y2 - y1); // center x coordinate
			yc = 0.5*(y1 + y2) + s*(x1 - x2); // center y coordinate
			r = sqrt(pow((x1-xc), 2) + pow((y1-yc), 2));
		}
		
		if(r<COORD_MAX) {
			NSRect outerrect = NSMakeRect(xc, yc, r, r);
			[circleFPFemoralHead setROIRect:outerrect];
			[viewerController needsDisplayUpdate];
		}
	} else if(circleFPFemoralHead != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: circleFPFemoralHead];
		circleFPFemoralHead = NULL;
	}
	
	// ACE angle
	if (circleFPFemoralHead != NULL && pointFPAnteriorEdgeSourcil != NULL) {
		
		if(angleFPACE == NULL){
			angleFPACE = [viewerController newROI: tAngle];
			
			[angleFPACE setNSColor:[NSColor redColor] globally:NO];
			[angleFPACE setDisplayTextualData:FALSE];
			[angleFPACE setThickness:1.0 globally: NO];
			[angleFPACE setSelectable:FALSE];
			[angleFPACE setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: angleFPACE];
		}
		
		NSMutableArray  *points = [angleFPACE points];
		[points removeAllObjects];
		
		x1 = [[[pointFPAnteriorEdgeSourcil points] objectAtIndex:0] x];
		y1 = [[[pointFPAnteriorEdgeSourcil points] objectAtIndex:0] y];		
		
		x2 = [circleFPFemoralHead rect].origin.x;
		y2 = [circleFPFemoralHead rect].origin.y;
				
		x3 = x2;
		y3 = y2/2;
		
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		[points addObject: [viewerController newPoint: x3 : y3]];
			
		[viewerController needsDisplayUpdate];
		
		if(x1>x2){
			// left side (doublecheck this)
			guessed_FP_ACE_side = FP_ACE_LEFT;
			result_FP_ACE = [angleFPACE Angle: [[points objectAtIndex:0] point] :[[points objectAtIndex:1] point] :[[points objectAtIndex:2] point]];
		} else {
			// right side
			guessed_FP_ACE_side = FP_ACE_RIGHT;
			result_FP_ACE = -[angleFPACE Angle: [[points objectAtIndex:0] point] :[[points objectAtIndex:1] point] :[[points objectAtIndex:2] point]];
		}
		
	} else if(angleFPACE != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: angleFPACE];
		angleFPACE = NULL;
	}
	
	
	
	// Handle line between narrowest part of femoral neck right
	if (pointFrogNarrowestFemoralNeckRight1 != NULL && pointFrogNarrowestFemoralNeckRight2 != NULL) {
		
		if(lineFrogNarrowestFemoralNeckRight == NULL){
			lineFrogNarrowestFemoralNeckRight = [viewerController newROI: tMesure];
			
			[lineFrogNarrowestFemoralNeckRight setNSColor:[NSColor cyanColor] globally:NO];
			[lineFrogNarrowestFemoralNeckRight setDisplayTextualData:FALSE];
			[lineFrogNarrowestFemoralNeckRight setThickness:1.0 globally: NO];
			[lineFrogNarrowestFemoralNeckRight setSelectable:FALSE];
			[lineFrogNarrowestFemoralNeckRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogNarrowestFemoralNeckRight];
		}
		
		
		NSMutableArray  *points = [lineFrogNarrowestFemoralNeckRight points];
		[points removeAllObjects];
		
		x1 = [[[pointFrogNarrowestFemoralNeckRight1 points] objectAtIndex:0] x];
		y1 = [[[pointFrogNarrowestFemoralNeckRight1 points] objectAtIndex:0] y];
		
		x2 = [[[pointFrogNarrowestFemoralNeckRight2 points] objectAtIndex:0] x];
		y2 = [[[pointFrogNarrowestFemoralNeckRight2 points] objectAtIndex:0] y];
		
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		
		[viewerController needsDisplayUpdate];
		
	}   else if(lineFrogNarrowestFemoralNeckRight != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: lineFrogNarrowestFemoralNeckRight];
		lineFrogNarrowestFemoralNeckRight = NULL;
	}
	
	
	// Handle line between narrowest part of femoral neck left
	if (pointFrogNarrowestFemoralNeckLeft1 != NULL && pointFrogNarrowestFemoralNeckLeft2 != NULL) {
		
		if(lineFrogNarrowestFemoralNeckLeft == NULL){
			lineFrogNarrowestFemoralNeckLeft = [viewerController newROI: tMesure];
			
			[lineFrogNarrowestFemoralNeckLeft setNSColor:[NSColor cyanColor] globally:NO];
			[lineFrogNarrowestFemoralNeckLeft setDisplayTextualData:FALSE];
			[lineFrogNarrowestFemoralNeckLeft setThickness:1.0 globally: NO];
			[lineFrogNarrowestFemoralNeckLeft setSelectable:FALSE];
			[lineFrogNarrowestFemoralNeckLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogNarrowestFemoralNeckLeft];
		}
		
		
		NSMutableArray  *points = [lineFrogNarrowestFemoralNeckLeft points];
		[points removeAllObjects];
		
		x1 = [[[pointFrogNarrowestFemoralNeckLeft1 points] objectAtIndex:0] x];
		y1 = [[[pointFrogNarrowestFemoralNeckLeft1 points] objectAtIndex:0] y];
		
		x2 = [[[pointFrogNarrowestFemoralNeckLeft2 points] objectAtIndex:0] x];
		y2 = [[[pointFrogNarrowestFemoralNeckLeft2 points] objectAtIndex:0] y];
		
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		
		[viewerController needsDisplayUpdate];
		
	}   else if(lineFrogNarrowestFemoralNeckLeft != NULL) {
		roiSeriesList = [viewerController roiList];
		roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
		[roiImageList removeObject: lineFrogNarrowestFemoralNeckLeft];
		lineFrogNarrowestFemoralNeckLeft = NULL;
	}
	
	
	// Alpha angle right
	if (circleFemoralHeadRight != NULL && lineFrogNarrowestFemoralNeckRight != NULL && pointFrogFemoralHeadExceedsCircleRight != NULL) {
		
		if(angleFrogAlphaRight == NULL){
            
            angleFrogAlphaRight = [viewerController newROI: tAngle];
			
			[angleFrogAlphaRight setNSColor:[NSColor redColor] globally:NO];
			[angleFrogAlphaRight setDisplayTextualData:FALSE];
			[angleFrogAlphaRight setThickness:1.0 globally: NO];
			[angleFrogAlphaRight setSelectable:FALSE];
			[angleFrogAlphaRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: angleFrogAlphaRight];
		}

		NSMutableArray  *points2;
		NSMutableArray  *points = [angleFrogAlphaRight points];
		[points removeAllObjects];
		
		x1 = [[[pointFrogFemoralHeadExceedsCircleRight points] objectAtIndex:0] x];
		y1 = [[[pointFrogFemoralHeadExceedsCircleRight points] objectAtIndex:0] y];		
		
		x2 = [circleFemoralHeadRight rect].origin.x;
		y2 = [circleFemoralHeadRight rect].origin.y;
		
		x3 = ([[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:0] x] + [[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:1] x]) / 2;
		y3 = ([[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:0] y] + [[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:1] y]) / 2;
		
	
		// are we in scfe mode?
		if(pointFrogScfeEpiphysisSuperiorRight != NULL) {

			// is the alpha adjustment point placed?
			if(pointFrogScfeAlphaAdjustRight == NULL) {
				block_update_rois_flag = YES;
				x4 = (x2+x3)/2;
				y4 = (y2+y3)/2;

				pointFrogScfeAlphaAdjustRight = [viewerController newROI: t2DPoint];
				[pointFrogScfeAlphaAdjustRight setNSColor:[NSColor redColor] globally:NO];
				[pointFrogScfeAlphaAdjustRight setDisplayTextualData:TRUE];
				[pointFrogScfeAlphaAdjustRight setTextBoxOffset:NSMakePoint ([[[viewerController imageView] curDCM] pwidth]/40, -[[[viewerController imageView] curDCM] pheight]/10)];		
				[pointFrogScfeAlphaAdjustRight setThickness:1.0 globally: NO];
				[pointFrogScfeAlphaAdjustRight setSelectable:TRUE];
				[pointFrogScfeAlphaAdjustRight setName:NAME_FROG_SCFE_ALPHA_ADJUST_RIGHT];
				
				MyPoint *pnt = [viewerController newPoint: x4 : y4];
				[pointFrogScfeAlphaAdjustRight mouseRoiDown:[pnt point] :1.0];
				[pointFrogScfeAlphaAdjustRight mouseRoiUp:[pnt point] ];
				[pointFrogScfeAlphaAdjustRight setROIMode:ROI_sleep ];
				[pointFrogFemoralHeadExceedsCircleRight setROIMode:ROI_sleep ];
				
				roiSeriesList = [viewerController roiList];
				roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
				
				waiting_for_alpha_adjust_right_flag = 2;
				block_update_rois_flag = NO;
				[roiImageList addObject: pointFrogScfeAlphaAdjustRight];
								
			} else {

				x4 = [[[pointFrogScfeAlphaAdjustRight points] objectAtIndex:0] x];
				y4 = [[[pointFrogScfeAlphaAdjustRight points] objectAtIndex:0] y];
			}

			k =  (y4-y3) / (x4-x3);
			k2 = (y2-y1) / (x2-x1);
			
			x5 = (y3 - y1 -x3*k + x1*k2) / (k2-k);
			//x5 = (y3 - y1) / ((y2-y1)/(x2-x1) - (y4-y3)/(x4-x3));
			y5 = y1 + (x5-x1)*(y2-y1)/(x2-x1);
			
			if(x5>-COORD_MAX && x5<COORD_MAX && y5>-COORD_MAX && 5<COORD_MAX) {			
				// make the line point out a little
				x3 = x3 - (x5-x3)/3;
				y3 = y3 - (y5-y3)/3;
			
				[points addObject: [viewerController newPoint: x1 : y1]]; 
				[points addObject: [viewerController newPoint: x5 : y5]];
				[points addObject: [viewerController newPoint: x3 : y3]];
			
				if(x2 > x5+1 || x2 < x5-1 || y2 > y5+1 || y2 < y5-1) {
					
					if(lineFrogScfeAlphaCenterRight == NULL){
						lineFrogScfeAlphaCenterRight = [viewerController newROI: tMesure];
						[lineFrogScfeAlphaCenterRight setNSColor:[NSColor redColor] globally:NO];
						[lineFrogScfeAlphaCenterRight setDisplayTextualData:FALSE];
						[lineFrogScfeAlphaCenterRight setThickness:1.0 globally: NO];
						[lineFrogScfeAlphaCenterRight setSelectable:FALSE];
						[lineFrogScfeAlphaCenterRight setName:NAME_HELPER];
						
						roiSeriesList = [viewerController roiList];
						roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
						
						[roiImageList addObject: lineFrogScfeAlphaCenterRight];		
					}
										
					 points2 = [lineFrogScfeAlphaCenterRight points];
					[points2 removeAllObjects];
			
					[points2 addObject: [viewerController newPoint: x2 : y2]]; 
					[points2 addObject: [viewerController newPoint: x5 : y5]];
				}
			}
		} else {
		
			[points addObject: [viewerController newPoint: x1 : y1]]; 
			[points addObject: [viewerController newPoint: x2 : y2]];
			[points addObject: [viewerController newPoint: x3 : y3]];
		}
		
		[viewerController needsDisplayUpdate];		
		result_Frog_Alpha_right = [angleFrogAlphaRight Angle: [[points objectAtIndex:0] point] :[[points objectAtIndex:1] point] :[[points objectAtIndex:2] point]];
		
	} else { 
		if(angleFrogAlphaRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
			[roiImageList removeObject: angleFrogAlphaRight];
			angleFrogAlphaRight = NULL;
		}
		
		if(lineFrogScfeAlphaCenterRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeAlphaCenterRight];
			lineFrogScfeAlphaCenterRight = NULL;
		}
	}
	
	
	// Alpha angle left
	if (circleFemoralHeadLeft != NULL && lineFrogNarrowestFemoralNeckLeft != NULL && pointFrogFemoralHeadExceedsCircleLeft != NULL) {
		
		if(angleFrogAlphaLeft == NULL){
			angleFrogAlphaLeft = [viewerController newROI: tAngle];
			
			[angleFrogAlphaLeft setNSColor:[NSColor redColor] globally:NO];
			[angleFrogAlphaLeft setDisplayTextualData:FALSE];
			[angleFrogAlphaLeft setThickness:1.0 globally: NO];
			[angleFrogAlphaLeft setSelectable:FALSE];
			[angleFrogAlphaLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: angleFrogAlphaLeft];
		}
		
		
		
		NSMutableArray  *points2;
		NSMutableArray  *points = [angleFrogAlphaLeft points];
		[points removeAllObjects];
		
		x1 = [[[pointFrogFemoralHeadExceedsCircleLeft points] objectAtIndex:0] x];
		y1 = [[[pointFrogFemoralHeadExceedsCircleLeft points] objectAtIndex:0] y];		
		
		x2 = [circleFemoralHeadLeft rect].origin.x;
		y2 = [circleFemoralHeadLeft rect].origin.y;
		
		x3 = ([[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:0] x] + [[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:1] x]) / 2;
		y3 = ([[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:0] y] + [[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:1] y]) / 2;
		
		
		// are we in scfe mode?
		if(pointFrogScfeEpiphysisSuperiorLeft != NULL) {
			
			
			// is the alpha adjustment point placed?
			if(pointFrogScfeAlphaAdjustLeft == NULL) {
				block_update_rois_flag = YES;
				x4 = (x2+x3)/2;
				y4 = (y2+y3)/2;
					
				pointFrogScfeAlphaAdjustLeft = [viewerController newROI: t2DPoint];
				[pointFrogScfeAlphaAdjustLeft setNSColor:[NSColor redColor] globally:NO];
				[pointFrogScfeAlphaAdjustLeft setDisplayTextualData:TRUE];
				[pointFrogScfeAlphaAdjustLeft setTextBoxOffset:NSMakePoint ([[[viewerController imageView] curDCM] pwidth]/40, -[[[viewerController imageView] curDCM] pheight]/10)];		
				[pointFrogScfeAlphaAdjustLeft setThickness:1.0 globally: NO];
				[pointFrogScfeAlphaAdjustLeft setSelectable:TRUE];
				[pointFrogScfeAlphaAdjustLeft setName:NAME_FROG_SCFE_ALPHA_ADJUST_RIGHT];
					
				MyPoint *pnt = [viewerController newPoint: x4 : y4];
				[pointFrogScfeAlphaAdjustLeft mouseRoiDown:[pnt point] :1.0];
				[pointFrogScfeAlphaAdjustLeft mouseRoiUp:[pnt point] ];
				[pointFrogScfeAlphaAdjustLeft setROIMode:ROI_sleep ];
				[pointFrogFemoralHeadExceedsCircleLeft setROIMode:ROI_sleep ];
					
				roiSeriesList = [viewerController roiList];
				roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
					
				waiting_for_alpha_adjust_left_flag = 2;
				block_update_rois_flag = NO;
				[roiImageList addObject: pointFrogScfeAlphaAdjustLeft];
					
			} else {
	
				x4 = [[[pointFrogScfeAlphaAdjustLeft points] objectAtIndex:0] x];
				y4 = [[[pointFrogScfeAlphaAdjustLeft points] objectAtIndex:0] y]; 
			}

			k =  (y4-y3) / (x4-x3);
			k2 = (y2-y1) / (x2-x1);
			
			x5 = (y3 - y1 -x3*k + x1*k2) / (k2-k);
			//x5 = (y3 - y1) / ((y2-y1)/(x2-x1) - (y4-y3)/(x4-x3));
			y5 = y1 + (x5-x1)*(y2-y1)/(x2-x1);
			
			if(x5>-COORD_MAX && x5<COORD_MAX && y5>-COORD_MAX && 5<COORD_MAX) {			
				// make the line point out a little
				x3 = x3 - (x5-x3)/3;
				y3 = y3 - (y5-y3)/3;
				
				[points addObject: [viewerController newPoint: x1 : y1]]; 
				[points addObject: [viewerController newPoint: x5 : y5]];
				[points addObject: [viewerController newPoint: x3 : y3]];
						
				if(x2 > x5+1 || x2 < x5-1 || y2 > y5+1 || y2 < y5-1) {
					
					if(lineFrogScfeAlphaCenterLeft == NULL){
						lineFrogScfeAlphaCenterLeft = [viewerController newROI: tMesure];
						
						[lineFrogScfeAlphaCenterLeft setNSColor:[NSColor redColor] globally:NO];
						[lineFrogScfeAlphaCenterLeft setDisplayTextualData:FALSE];
						[lineFrogScfeAlphaCenterLeft setThickness:1.0 globally: NO];
						[lineFrogScfeAlphaCenterLeft setSelectable:FALSE];
						[lineFrogScfeAlphaCenterLeft setName:NAME_HELPER];
						
						roiSeriesList = [viewerController roiList];
						roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
						
						[roiImageList addObject: lineFrogScfeAlphaCenterLeft];
					}
					
					points2 = [lineFrogScfeAlphaCenterLeft points];
					[points2 removeAllObjects];
					
					[points2 addObject: [viewerController newPoint: x2 : y2]]; 
					[points2 addObject: [viewerController newPoint: x5 : y5]];
				} 
			}
		} else {
			
			[points addObject: [viewerController newPoint: x1 : y1]]; 
			[points addObject: [viewerController newPoint: x2 : y2]];
			[points addObject: [viewerController newPoint: x3 : y3]];
		}
		
		[viewerController needsDisplayUpdate];		
		result_Frog_Alpha_left = [angleFrogAlphaLeft Angle: [[points objectAtIndex:0] point] :[[points objectAtIndex:1] point] :[[points objectAtIndex:2] point]];
		
	} else {
		if(angleFrogAlphaLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
			[roiImageList removeObject: angleFrogAlphaLeft];
			angleFrogAlphaLeft = NULL;
		}
		
		if(lineFrogScfeAlphaCenterLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeAlphaCenterLeft];
			lineFrogScfeAlphaCenterLeft = NULL;
		}
	}
	
	
	

	
	// Head-neck offset right
	if (pointFrogAnteriorFemoralNeckRight != NULL && angleFrogAlphaRight != NULL) {
		
		if(lineFrogHNOffsetOuterRight == NULL){
			lineFrogHNOffsetOuterRight = [viewerController newROI: tMesure];
			
			[lineFrogHNOffsetOuterRight setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogHNOffsetOuterRight setDisplayTextualData:FALSE];
			[lineFrogHNOffsetOuterRight setThickness:1.0 globally: NO];
			[lineFrogHNOffsetOuterRight setSelectable:FALSE];
			[lineFrogHNOffsetOuterRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogHNOffsetOuterRight];
		}
		
		if(lineFrogHNOffsetInnerRight == NULL){
			lineFrogHNOffsetInnerRight = [viewerController newROI: tMesure];
			
			[lineFrogHNOffsetInnerRight setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogHNOffsetInnerRight setDisplayTextualData:FALSE];
			[lineFrogHNOffsetInnerRight setThickness:1.0 globally: NO];
			[lineFrogHNOffsetInnerRight setSelectable:FALSE];
			[lineFrogHNOffsetInnerRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogHNOffsetInnerRight];
		}
		
		
		NSMutableArray  *points = [lineFrogHNOffsetOuterRight points];
		[points removeAllObjects];
		
		NSMutableArray  *points2 = [lineFrogHNOffsetInnerRight points];
		[points2 removeAllObjects];
		
		//xd = [[[angleFrogAlphaRight points] objectAtIndex:2] x] - [[[angleFrogAlphaRight points] objectAtIndex:1] x];
		//yd = [[[angleFrogAlphaRight points] objectAtIndex:2] y] - [[[angleFrogAlphaRight points] objectAtIndex:1] y];
				
		xd = ([[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:0] x] + [[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:1] x]) / 2 - [circleFemoralHeadRight rect].origin.x;
		yd = ([[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:0] y] + [[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:1] y]) / 2 - [circleFemoralHeadRight rect].origin.y;
		
		k = yd/xd;
		
		r = [circleFemoralHeadRight rect].size.height;		
	
		xr = r / sqrt(1/(k*k)+1);						
		yr = -xr/k;
		
		if(yd>0){
			yr = -yr;
			xr = -xr;
		}
		
		x1 = [circleFemoralHeadRight rect].origin.x + xr;
		y1 = [circleFemoralHeadRight rect].origin.y + yr;
		
		x2 = [[[pointFrogAnteriorFemoralNeckRight points] objectAtIndex:0] x];
		y2 = [[[pointFrogAnteriorFemoralNeckRight points] objectAtIndex:0] y];
		
		x3 = (x2 + k*y2 - k*y1 + k*k*x1) / (1 + k*k);
		y3 = y1 + k*(x3 -x1);
		
		x4 = x1 + (x2-x3);
		y4 = y1 + (y2-y3);
		
		[points addObject: [viewerController newPoint: x4 : y4]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		
		[points2 addObject: [viewerController newPoint: x1 : y1]]; 
		[points2 addObject: [viewerController newPoint: x3 : y3]];
		
		[viewerController needsDisplayUpdate];
		result_Frog_HNOffset_right = [lineFrogHNOffsetOuterRight Length:[[points2 objectAtIndex:0] point] :[[points objectAtIndex:0] point]] / 
									 ([lineFrogHNOffsetOuterRight Length:[[points2 objectAtIndex:0] point] :[circleFemoralHeadRight rect].origin] *2) ;
	
		// support negative values
		x4 = x4 - [circleFemoralHeadRight rect].origin.x;
		y4 = y4 - [circleFemoralHeadRight rect].origin.y;
		if((x4*x4 + y4*y4) > r*r) {
			result_Frog_HNOffset_right = -result_Frog_HNOffset_right;
		}
		
	}   else {
		
		if(lineFrogHNOffsetOuterRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
			[roiImageList removeObject: lineFrogHNOffsetOuterRight];
			lineFrogHNOffsetOuterRight = NULL;
		}
		
		if(lineFrogHNOffsetInnerRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogHNOffsetInnerRight];
			lineFrogHNOffsetInnerRight = NULL;
		}
		
	}
	
	
	// Head-neck offset left
	if (pointFrogAnteriorFemoralNeckLeft != NULL && angleFrogAlphaLeft != NULL) {
		
		if(lineFrogHNOffsetOuterLeft == NULL){
			lineFrogHNOffsetOuterLeft = [viewerController newROI: tMesure];
			
			[lineFrogHNOffsetOuterLeft setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogHNOffsetOuterLeft setDisplayTextualData:FALSE];
			[lineFrogHNOffsetOuterLeft setThickness:1.0 globally: NO];
			[lineFrogHNOffsetOuterLeft setSelectable:FALSE];
			[lineFrogHNOffsetOuterLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogHNOffsetOuterLeft];
		}
		
		if(lineFrogHNOffsetInnerLeft == NULL){
			lineFrogHNOffsetInnerLeft = [viewerController newROI: tMesure];
			
			[lineFrogHNOffsetInnerLeft setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogHNOffsetInnerLeft setDisplayTextualData:FALSE];
			[lineFrogHNOffsetInnerLeft setThickness:1.0 globally: NO];
			[lineFrogHNOffsetInnerLeft setSelectable:FALSE];
			[lineFrogHNOffsetInnerLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogHNOffsetInnerLeft];
		}
		
		
		NSMutableArray  *points = [lineFrogHNOffsetOuterLeft points];
		[points removeAllObjects];
		
		NSMutableArray  *points2 = [lineFrogHNOffsetInnerLeft points];
		[points2 removeAllObjects];
		
		//xd = [[[angleFrogAlphaRight points] objectAtIndex:2] x] - [[[angleFrogAlphaRight points] objectAtIndex:1] x];
		//yd = [[[angleFrogAlphaRight points] objectAtIndex:2] y] - [[[angleFrogAlphaRight points] objectAtIndex:1] y];
		
		xd = ([[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:0] x] + [[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:1] x]) / 2 - [circleFemoralHeadLeft rect].origin.x;
		yd = ([[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:0] y] + [[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:1] y]) / 2 - [circleFemoralHeadLeft rect].origin.y;
		
		k = yd/xd;
		
		r = [circleFemoralHeadLeft rect].size.height;		
		
		xr = r / sqrt(1/(k*k)+1);						
		yr = -xr/k;
		
		if(yd<0){
			yr = -yr;
			xr = -xr;
		}
		
		x1 = [circleFemoralHeadLeft rect].origin.x + xr;
		y1 = [circleFemoralHeadLeft rect].origin.y + yr;
		
		x2 = [[[pointFrogAnteriorFemoralNeckLeft points] objectAtIndex:0] x];
		y2 = [[[pointFrogAnteriorFemoralNeckLeft points] objectAtIndex:0] y];
		
		x3 = (x2 + k*y2 - k*y1 + k*k*x1) / (1 + k*k);
		y3 = y1 + k*(x3 -x1);
		
		x4 = x1 + (x2-x3);
		y4 = y1 + (y2-y3);
		
		[points addObject: [viewerController newPoint: x4 : y4]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		
		[points2 addObject: [viewerController newPoint: x1 : y1]]; 
		[points2 addObject: [viewerController newPoint: x3 : y3]];
		
		[viewerController needsDisplayUpdate];
		result_Frog_HNOffset_left = [lineFrogHNOffsetOuterLeft Length:[[points2 objectAtIndex:0] point] :[[points objectAtIndex:0] point]] / 
									([lineFrogHNOffsetOuterLeft Length:[[points2 objectAtIndex:0] point] :[circleFemoralHeadLeft rect].origin] *2) ;
	
		// support negative values
		x4 = x4 - [circleFemoralHeadLeft rect].origin.x;
		y4 = y4 - [circleFemoralHeadLeft rect].origin.y;
		if((x4*x4 + y4*y4) > r*r) {
			result_Frog_HNOffset_left = -result_Frog_HNOffset_left;
		}
	
	}   else {
		
		if(lineFrogHNOffsetOuterLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogHNOffsetOuterLeft];
			lineFrogHNOffsetOuterLeft = NULL;
		}
		
		if(lineFrogHNOffsetInnerLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogHNOffsetInnerLeft];
			lineFrogHNOffsetInnerLeft = NULL;
		}
		
	}
	
	
	// Handle right southwick measurement
	if (pointFrogScfeShaftSuperiorRight1 != NULL && pointFrogScfeShaftSuperiorRight2 != NULL &&
		pointFrogScfeShaftInferiorRight1 != NULL && pointFrogScfeShaftInferiorRight2 != NULL &&
		circleFemoralHeadRight != NULL) {
		//NSLog(@"Handle southwick measurement");
		
		if(lineFrogScfeCrossShaftUpperRight == NULL){
			lineFrogScfeCrossShaftUpperRight = [viewerController newROI: tMesure];
			
			[lineFrogScfeCrossShaftUpperRight setNSColor:[NSColor cyanColor] globally:NO];
			[lineFrogScfeCrossShaftUpperRight setDisplayTextualData:FALSE];
			[lineFrogScfeCrossShaftUpperRight setThickness:1.0 globally: NO];
			[lineFrogScfeCrossShaftUpperRight setSelectable:FALSE];
			[lineFrogScfeCrossShaftUpperRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeCrossShaftUpperRight];
		}
		
		
		if(lineFrogScfeCrossShaftLowerRight == NULL){
			lineFrogScfeCrossShaftLowerRight = [viewerController newROI: tMesure];
			
			[lineFrogScfeCrossShaftLowerRight setNSColor:[NSColor cyanColor] globally:NO];
			[lineFrogScfeCrossShaftLowerRight setDisplayTextualData:FALSE];
			[lineFrogScfeCrossShaftLowerRight setThickness:1.0 globally: NO];
			[lineFrogScfeCrossShaftLowerRight setSelectable:FALSE];
			[lineFrogScfeCrossShaftLowerRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeCrossShaftLowerRight];
		}
		
		if(lineFrogScfeSouthwickBaseRealRight == NULL){
			lineFrogScfeSouthwickBaseRealRight = [viewerController newROI: tMesure];
			
			[lineFrogScfeSouthwickBaseRealRight setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogScfeSouthwickBaseRealRight setDisplayTextualData:FALSE];
			[lineFrogScfeSouthwickBaseRealRight setThickness:1.0 globally: NO];
			[lineFrogScfeSouthwickBaseRealRight setSelectable:FALSE];
			[lineFrogScfeSouthwickBaseRealRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeSouthwickBaseRealRight];
		}
		
		if(lineFrogScfeSouthwickBaseCloneRight == NULL){
			lineFrogScfeSouthwickBaseCloneRight = [viewerController newROI: tMesure];
			
			[lineFrogScfeSouthwickBaseCloneRight setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogScfeSouthwickBaseCloneRight setDisplayTextualData:FALSE];
			[lineFrogScfeSouthwickBaseCloneRight setThickness:1.0 globally: NO];
			[lineFrogScfeSouthwickBaseCloneRight setSelectable:FALSE];
			[lineFrogScfeSouthwickBaseCloneRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeSouthwickBaseCloneRight];
		}
		
		if(angleFrogScfeSouthwickRight == NULL){
			angleFrogScfeSouthwickRight = [viewerController newROI: tAngle];
			
			[angleFrogScfeSouthwickRight setNSColor:[NSColor redColor] globally:NO];
			[angleFrogScfeSouthwickRight setDisplayTextualData:FALSE];
			[angleFrogScfeSouthwickRight setThickness:1.0 globally: NO];
			[angleFrogScfeSouthwickRight setSelectable:FALSE];
			[angleFrogScfeSouthwickRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: angleFrogScfeSouthwickRight];
		}
		
		NSMutableArray  *points;
		
		// two cross shaft lines
		x1 = [[[pointFrogScfeShaftSuperiorRight1 points] objectAtIndex:0] x];
		y1 = [[[pointFrogScfeShaftSuperiorRight1 points] objectAtIndex:0] y];
		
		x2 = [[[pointFrogScfeShaftSuperiorRight2 points] objectAtIndex:0] x];
		y2 = [[[pointFrogScfeShaftSuperiorRight2 points] objectAtIndex:0] y];
		
		if(y2 > y1) {
			x5 = x1;
			y5 = y1;
			x1 = x2;
			y1 = y2;
			x2 = x5;
			y2 = y5;
		}	
				
		x3 = [[[pointFrogScfeShaftInferiorRight1 points] objectAtIndex:0] x];
		y3 = [[[pointFrogScfeShaftInferiorRight1 points] objectAtIndex:0] y];
		
		x4 = [[[pointFrogScfeShaftInferiorRight2 points] objectAtIndex:0] x];
		y4 = [[[pointFrogScfeShaftInferiorRight2 points] objectAtIndex:0] y];
		
		if(y4 > y3) {
			x5 = x3;
			y5 = y3;
			x3 = x4;
			y3 = y4;
			x4 = x5;
			y4 = y5;
		}
		
		
		// draw cross shaft lines
		points = [lineFrogScfeCrossShaftUpperRight points];
		[points removeAllObjects];
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x3 : y3]];
		
		points = [lineFrogScfeCrossShaftLowerRight points];
		[points removeAllObjects];	
		[points addObject: [viewerController newPoint: x2 : y2]]; 
		[points addObject: [viewerController newPoint: x4 : y4]];
				
		
		// calc midpoints of cross shaft lines
		x1 = (x1+x3) /2;
		y1 = (y1+y3) /2;
		x2 = (x2+x4) /2;
		y2 = (y2+y4) /2;
		
		// two of the southwick endpoints (the shaft midline)
		x3 = x1 + (x2-x1)*1.5;
		y3 = y1 + (y2-y1)*1.5;
		
		x4 = x1 - (x2-x1);
		y4 = y1 - (y2-y1);
		
		// points of southwick base		
		x1 = [[[pointFrogScfeEpiphysisSuperiorRight points] objectAtIndex:0] x];
		y1 = [[[pointFrogScfeEpiphysisSuperiorRight points] objectAtIndex:0] y];
		
		x2 = [[[pointFrogScfeEpiphysisInferiorRight points] objectAtIndex:0] x];
		y2 = [[[pointFrogScfeEpiphysisInferiorRight points] objectAtIndex:0] y];
		
		points = [lineFrogScfeSouthwickBaseRealRight points];
		[points removeAllObjects];
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		
		// points of cloned southwick base
		x5 = x3 - (x2-x1)/2;
		y5 = y3 - (y2-y1)/2;
		
		x6 = x3 + (x2-x1)/2;
		y6 = y3 + (y2-y1)/2;
		
		points = [lineFrogScfeSouthwickBaseCloneRight points];
		[points removeAllObjects];
		[points addObject: [viewerController newPoint: x5 : y5]]; 
		[points addObject: [viewerController newPoint: x6 : y6]];
		
		// last point in southwick angle (90 deg reference)
		x7 = x3 - (y2-y1)/2;
		y7 = y3 + (x2-x1)/2;
		
		points = [angleFrogScfeSouthwickRight points];
		[points removeAllObjects];
		[points addObject: [viewerController newPoint: x4 : y4]]; 
		[points addObject: [viewerController newPoint: x3 : y3]];
		[points addObject: [viewerController newPoint: x7 : y7]];
		
		[viewerController needsDisplayUpdate];
		result_FrogScfe_Southwick_right = [angleFrogScfeSouthwickRight Angle: [[points objectAtIndex:0] point] :[[points objectAtIndex:1] point] :[[points objectAtIndex:2] point]];

		if(((x5-x4)*(x5-x4) + (y5-y4)*(y5-y4)) < (x6-x4)*(x6-x4) + (y6-y4)*(y6-y4)) {
			result_FrogScfe_Southwick_right = -result_FrogScfe_Southwick_right;
		}
		
	}   else {
		
		if(lineFrogScfeCrossShaftUpperRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
		
			[roiImageList removeObject: lineFrogScfeCrossShaftUpperRight];
			lineFrogScfeCrossShaftUpperRight = NULL;
		}
		
		if(lineFrogScfeCrossShaftLowerRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeCrossShaftLowerRight];
			lineFrogScfeCrossShaftLowerRight = NULL;
		}
		
		if(lineFrogScfeSouthwickBaseRealRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeSouthwickBaseRealRight];
			lineFrogScfeSouthwickBaseRealRight = NULL;
		}
		
		if(lineFrogScfeSouthwickBaseCloneRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeSouthwickBaseCloneRight];
			lineFrogScfeSouthwickBaseCloneRight = NULL;
		}
		
		if(angleFrogScfeSouthwickRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: angleFrogScfeSouthwickRight];
			angleFrogScfeSouthwickRight = NULL;
		}
	}
	
	
	// Handle left southwick measurement
	if (pointFrogScfeShaftSuperiorLeft1 != NULL && pointFrogScfeShaftSuperiorLeft2 != NULL &&
		pointFrogScfeShaftInferiorLeft1 != NULL && pointFrogScfeShaftInferiorLeft2 != NULL &&
		circleFemoralHeadLeft != NULL) {
		//NSLog(@"Handle southwick measurement");
		
		if(lineFrogScfeCrossShaftUpperLeft == NULL){
			lineFrogScfeCrossShaftUpperLeft = [viewerController newROI: tMesure];
			
			[lineFrogScfeCrossShaftUpperLeft setNSColor:[NSColor cyanColor] globally:NO];
			[lineFrogScfeCrossShaftUpperLeft setDisplayTextualData:FALSE];
			[lineFrogScfeCrossShaftUpperLeft setThickness:1.0 globally: NO];
			[lineFrogScfeCrossShaftUpperLeft setSelectable:FALSE];
			[lineFrogScfeCrossShaftUpperLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeCrossShaftUpperLeft];
		}
		
		
		if(lineFrogScfeCrossShaftLowerLeft == NULL){
			lineFrogScfeCrossShaftLowerLeft = [viewerController newROI: tMesure];
			
			[lineFrogScfeCrossShaftLowerLeft setNSColor:[NSColor cyanColor] globally:NO];
			[lineFrogScfeCrossShaftLowerLeft setDisplayTextualData:FALSE];
			[lineFrogScfeCrossShaftLowerLeft setThickness:1.0 globally: NO];
			[lineFrogScfeCrossShaftLowerLeft setSelectable:FALSE];
			[lineFrogScfeCrossShaftLowerLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeCrossShaftLowerLeft];
		}
		
		if(lineFrogScfeSouthwickBaseRealLeft == NULL){
			lineFrogScfeSouthwickBaseRealLeft = [viewerController newROI: tMesure];
			
			[lineFrogScfeSouthwickBaseRealLeft setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogScfeSouthwickBaseRealLeft setDisplayTextualData:FALSE];
			[lineFrogScfeSouthwickBaseRealLeft setThickness:1.0 globally: NO];
			[lineFrogScfeSouthwickBaseRealLeft setSelectable:FALSE];
			[lineFrogScfeSouthwickBaseRealLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeSouthwickBaseRealLeft];
		}
		
		if(lineFrogScfeSouthwickBaseCloneLeft == NULL){
			lineFrogScfeSouthwickBaseCloneLeft = [viewerController newROI: tMesure];
			
			[lineFrogScfeSouthwickBaseCloneLeft setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogScfeSouthwickBaseCloneLeft setDisplayTextualData:FALSE];
			[lineFrogScfeSouthwickBaseCloneLeft setThickness:1.0 globally: NO];
			[lineFrogScfeSouthwickBaseCloneLeft setSelectable:FALSE];
			[lineFrogScfeSouthwickBaseCloneLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeSouthwickBaseCloneLeft];
		}
		
		if(angleFrogScfeSouthwickLeft == NULL){
			angleFrogScfeSouthwickLeft = [viewerController newROI: tAngle];
			
			[angleFrogScfeSouthwickLeft setNSColor:[NSColor redColor] globally:NO];
			[angleFrogScfeSouthwickLeft setDisplayTextualData:FALSE];
			[angleFrogScfeSouthwickLeft setThickness:1.0 globally: NO];
			[angleFrogScfeSouthwickLeft setSelectable:FALSE];
			[angleFrogScfeSouthwickLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: angleFrogScfeSouthwickLeft];
		}
		
		NSMutableArray  *points;
		
		// two cross shaft lines
		x1 = [[[pointFrogScfeShaftSuperiorLeft1 points] objectAtIndex:0] x];
		y1 = [[[pointFrogScfeShaftSuperiorLeft1 points] objectAtIndex:0] y];
		
		x2 = [[[pointFrogScfeShaftSuperiorLeft2 points] objectAtIndex:0] x];
		y2 = [[[pointFrogScfeShaftSuperiorLeft2 points] objectAtIndex:0] y];
		
		if(y2 > y1) {
			x5 = x1;
			y5 = y1;
			x1 = x2;
			y1 = y2;
			x2 = x5;
			y2 = y5;
		}	
		
		x3 = [[[pointFrogScfeShaftInferiorLeft1 points] objectAtIndex:0] x];
		y3 = [[[pointFrogScfeShaftInferiorLeft1 points] objectAtIndex:0] y];
		
		x4 = [[[pointFrogScfeShaftInferiorLeft2 points] objectAtIndex:0] x];
		y4 = [[[pointFrogScfeShaftInferiorLeft2 points] objectAtIndex:0] y];
		
		if(y4 > y3) {
			x5 = x3;
			y5 = y3;
			x3 = x4;
			y3 = y4;
			x4 = x5;
			y4 = y5;
		}
		
		
		// draw cross shaft lines
		points = [lineFrogScfeCrossShaftUpperLeft points];
		[points removeAllObjects];
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x3 : y3]];
		
		points = [lineFrogScfeCrossShaftLowerLeft points];
		[points removeAllObjects];	
		[points addObject: [viewerController newPoint: x2 : y2]]; 
		[points addObject: [viewerController newPoint: x4 : y4]];
		
		
		// calc midpoints of cross shaft lines
		x1 = (x1+x3) /2;
		y1 = (y1+y3) /2;
		x2 = (x2+x4) /2;
		y2 = (y2+y4) /2;
		
		// two of the southwick endpoints (the shaft midline)
		x3 = x1 + (x2-x1)*1.5;
		y3 = y1 + (y2-y1)*1.5;
		
		x4 = x1 - (x2-x1);
		y4 = y1 - (y2-y1);
		
		// points of southwick base		
		x1 = [[[pointFrogScfeEpiphysisSuperiorLeft points] objectAtIndex:0] x];
		y1 = [[[pointFrogScfeEpiphysisSuperiorLeft points] objectAtIndex:0] y];
		
		x2 = [[[pointFrogScfeEpiphysisInferiorLeft points] objectAtIndex:0] x];
		y2 = [[[pointFrogScfeEpiphysisInferiorLeft points] objectAtIndex:0] y];
		
		points = [lineFrogScfeSouthwickBaseRealLeft points];
		[points removeAllObjects];
		[points addObject: [viewerController newPoint: x1 : y1]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		
		// points of cloned southwick base
		x5 = x3 - (x2-x1)/2;
		y5 = y3 - (y2-y1)/2;
		
		x6 = x3 + (x2-x1)/2;
		y6 = y3 + (y2-y1)/2;
		
		points = [lineFrogScfeSouthwickBaseCloneLeft points];
		[points removeAllObjects];
		[points addObject: [viewerController newPoint: x5 : y5]]; 
		[points addObject: [viewerController newPoint: x6 : y6]];
		
		// last point in southwick angle (90 deg reference)
		x7 = x3 + (y2-y1)/2;
		y7 = y3 - (x2-x1)/2;
		
		points = [angleFrogScfeSouthwickLeft points];
		[points removeAllObjects];
		[points addObject: [viewerController newPoint: x4 : y4]]; 
		[points addObject: [viewerController newPoint: x3 : y3]];
		[points addObject: [viewerController newPoint: x7 : y7]];
		
		[viewerController needsDisplayUpdate];
		result_FrogScfe_Southwick_left = [angleFrogScfeSouthwickLeft Angle: [[points objectAtIndex:0] point] :[[points objectAtIndex:1] point] :[[points objectAtIndex:2] point]];
		
		if(((x5-x4)*(x5-x4) + (y5-y4)*(y5-y4)) < (x6-x4)*(x6-x4) + (y6-y4)*(y6-y4)) {
			result_FrogScfe_Southwick_left = -result_FrogScfe_Southwick_left;
		}
		
	}   else {
		
		if(lineFrogScfeCrossShaftUpperLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeCrossShaftUpperLeft];
			lineFrogScfeCrossShaftUpperLeft = NULL;
		}
		
		if(lineFrogScfeCrossShaftLowerLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeCrossShaftLowerLeft];
			lineFrogScfeCrossShaftLowerLeft = NULL;
		}
		
		if(lineFrogScfeSouthwickBaseRealLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeSouthwickBaseRealLeft];
			lineFrogScfeSouthwickBaseRealLeft = NULL;
		}
		
		if(lineFrogScfeSouthwickBaseCloneLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeSouthwickBaseCloneLeft];
			lineFrogScfeSouthwickBaseCloneLeft = NULL;
		}
		
		if(angleFrogScfeSouthwickLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: angleFrogScfeSouthwickLeft];
			angleFrogScfeSouthwickLeft = NULL;
		}
	}
	
	
	
	// Epiphysis-metaphyseal offset right
	if (pointFrogScfeMetaphysisRight != NULL && angleFrogAlphaRight != NULL) {
		
		if(lineFrogScfeEMOffsetOuterRight == NULL){
			lineFrogScfeEMOffsetOuterRight = [viewerController newROI: tMesure];
			
			[lineFrogScfeEMOffsetOuterRight setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogScfeEMOffsetOuterRight setDisplayTextualData:FALSE];
			[lineFrogScfeEMOffsetOuterRight setThickness:1.0 globally: NO];
			[lineFrogScfeEMOffsetOuterRight setSelectable:FALSE];
			[lineFrogScfeEMOffsetOuterRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeEMOffsetOuterRight];
		}
		
		if(lineFrogScfeEMOffsetInnerRight == NULL){
			lineFrogScfeEMOffsetInnerRight = [viewerController newROI: tMesure];
			
			[lineFrogScfeEMOffsetInnerRight setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogScfeEMOffsetInnerRight setDisplayTextualData:FALSE];
			[lineFrogScfeEMOffsetInnerRight setThickness:1.0 globally: NO];
			[lineFrogScfeEMOffsetInnerRight setSelectable:FALSE];
			[lineFrogScfeEMOffsetInnerRight setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeEMOffsetInnerRight];
		}
		
		
		NSMutableArray  *points = [lineFrogScfeEMOffsetOuterRight points];
		[points removeAllObjects];
		
		NSMutableArray  *points2 = [lineFrogScfeEMOffsetInnerRight points];
		[points2 removeAllObjects];
		
		//xd = [[[angleFrogAlphaRight points] objectAtIndex:2] x] - [[[angleFrogAlphaRight points] objectAtIndex:1] x];
		//yd = [[[angleFrogAlphaRight points] objectAtIndex:2] y] - [[[angleFrogAlphaRight points] objectAtIndex:1] y];
		
		
		xd = ([[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:0] x] + [[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:1] x]) / 2 - [[[angleFrogAlphaRight points] objectAtIndex:1] x];
		yd = ([[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:0] y] + [[[lineFrogNarrowestFemoralNeckRight points] objectAtIndex:1] y]) / 2 - [[[angleFrogAlphaRight points] objectAtIndex:1] y];
		
		k = yd/xd;
		
		r = [circleFemoralHeadRight rect].size.height;		
		
		//x1 = [circleFemoralHeadRight rect].origin.x + xr;
		//y1 = [circleFemoralHeadRight rect].origin.y + yr;
		x1 = [[[pointFrogScfeEpiphysisSuperiorRight points] objectAtIndex:0] x];
		y1 = [[[pointFrogScfeEpiphysisSuperiorRight points] objectAtIndex:0] y];
		
		x2 = [[[pointFrogScfeMetaphysisRight points] objectAtIndex:0] x];
		y2 = [[[pointFrogScfeMetaphysisRight points] objectAtIndex:0] y];
		
		x3 = (x2 + k*y2 - k*y1 + k*k*x1) / (1 + k*k);
		y3 = y1 + k*(x3 -x1);
		
		x4 = x1 + (x2-x3);
		y4 = y1 + (y2-y3);
		
		[points addObject: [viewerController newPoint: x4 : y4]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		
		[points2 addObject: [viewerController newPoint: x1 : y1]]; 
		[points2 addObject: [viewerController newPoint: x3 : y3]];
		
		[viewerController needsDisplayUpdate];
		result_FrogScfe_EMOffset_right = [lineFrogScfeEMOffsetOuterRight Length:[[points2 objectAtIndex:0] point] :[[points objectAtIndex:0] point]];
		
		// support negative values
		x4 = x4 - [circleFemoralHeadRight rect].origin.x;
		y4 = y4 - [circleFemoralHeadRight rect].origin.y;
		if((x4*x4 + y4*y4) < r*r) {
			result_FrogScfe_EMOffset_right = -result_FrogScfe_EMOffset_right;
		}
		
	}   else {
		
		if(lineFrogScfeEMOffsetOuterRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeEMOffsetOuterRight];
			lineFrogScfeEMOffsetOuterRight = NULL;
		}
		
		if(lineFrogScfeEMOffsetInnerRight != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeEMOffsetInnerRight];
			lineFrogScfeEMOffsetInnerRight = NULL;
		}
		
	}
	
	
	
	// Epiphysis-metaphyseal offset left
	if (pointFrogScfeMetaphysisLeft != NULL && angleFrogAlphaLeft != NULL) {
		
		if(lineFrogScfeEMOffsetOuterLeft == NULL){
			lineFrogScfeEMOffsetOuterLeft = [viewerController newROI: tMesure];
			
			[lineFrogScfeEMOffsetOuterLeft setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogScfeEMOffsetOuterLeft setDisplayTextualData:FALSE];
			[lineFrogScfeEMOffsetOuterLeft setThickness:1.0 globally: NO];
			[lineFrogScfeEMOffsetOuterLeft setSelectable:FALSE];
			[lineFrogScfeEMOffsetOuterLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeEMOffsetOuterLeft];
		}
		
		if(lineFrogScfeEMOffsetInnerLeft == NULL){
			lineFrogScfeEMOffsetInnerLeft = [viewerController newROI: tMesure];
			
			[lineFrogScfeEMOffsetInnerLeft setNSColor:[NSColor yellowColor] globally:NO];
			[lineFrogScfeEMOffsetInnerLeft setDisplayTextualData:FALSE];
			[lineFrogScfeEMOffsetInnerLeft setThickness:1.0 globally: NO];
			[lineFrogScfeEMOffsetInnerLeft setSelectable:FALSE];
			[lineFrogScfeEMOffsetInnerLeft setName:NAME_HELPER];
			
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList addObject: lineFrogScfeEMOffsetInnerLeft];
		}
		
		
		NSMutableArray  *points = [lineFrogScfeEMOffsetOuterLeft points];
		[points removeAllObjects];
		
		NSMutableArray  *points2 = [lineFrogScfeEMOffsetInnerLeft points];
		[points2 removeAllObjects];
		
		xd = ([[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:0] x] + [[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:1] x]) / 2 - [[[angleFrogAlphaLeft points] objectAtIndex:1] x];
		yd = ([[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:0] y] + [[[lineFrogNarrowestFemoralNeckLeft points] objectAtIndex:1] y]) / 2 - [[[angleFrogAlphaLeft points] objectAtIndex:1] y];
				
		k = yd/xd;
		
		r = [circleFemoralHeadLeft rect].size.height;		
		
		x1 = [[[pointFrogScfeEpiphysisSuperiorLeft points] objectAtIndex:0] x];
		y1 = [[[pointFrogScfeEpiphysisSuperiorLeft points] objectAtIndex:0] y];
		
		x2 = [[[pointFrogScfeMetaphysisLeft points] objectAtIndex:0] x];
		y2 = [[[pointFrogScfeMetaphysisLeft points] objectAtIndex:0] y];
		
		
		x3 = (x2 + k*y2 - k*y1 + k*k*x1) / (1 + k*k);
		y3 = y1 + k*(x3 -x1);
		
		x4 = x1 + (x2-x3);
		y4 = y1 + (y2-y3);
		
		[points addObject: [viewerController newPoint: x4 : y4]]; 
		[points addObject: [viewerController newPoint: x2 : y2]];
		
		[points2 addObject: [viewerController newPoint: x1 : y1]]; 
		[points2 addObject: [viewerController newPoint: x3 : y3]];
		
		[viewerController needsDisplayUpdate];
		result_FrogScfe_EMOffset_left = [lineFrogScfeEMOffsetOuterLeft Length:[[points2 objectAtIndex:0] point] :[[points objectAtIndex:0] point]];
		
		// support negative values
		x4 = x4 - [circleFemoralHeadLeft rect].origin.x;
		y4 = y4 - [circleFemoralHeadLeft rect].origin.y;
		if((x4*x4 + y4*y4) < r*r) {
			result_FrogScfe_EMOffset_left = -result_FrogScfe_EMOffset_left;
		}
		
	}   else {
		
		if(lineFrogScfeEMOffsetOuterLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeEMOffsetOuterLeft];
			lineFrogScfeEMOffsetOuterLeft = NULL;
		}
		
		if(lineFrogScfeEMOffsetInnerLeft != NULL) {
			roiSeriesList = [viewerController roiList];
			roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
			
			[roiImageList removeObject: lineFrogScfeEMOffsetInnerLeft];
			lineFrogScfeEMOffsetInnerLeft = NULL;
		}
		
	}
}


-(void)displayROIInstructions:(int)stepNbr : (int)op_mode : (OrthopaedicStudioFilter*) mainFilter {
	
	NSBundle* pluginBundle = [NSBundle bundleForClass:[mainFilter class]];	
	NSString* imageName = NULL;
	
	//NSLog(@"displayROIInstructions: step %d opmode %d", stepNbr, op_mode);
	
	next_Step = stepNbr +1;
	
	if(op_mode == AP) {
		
		[mainFilter->button_SkipThis setTransparent:NO];
		[mainFilter->button_SkipThis setEnabled:YES];
		
		switch (stepNbr) {
			case 1:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Pan and zoom to RIGHT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"AP_right_femur" ofType:@"png"];
				next_Step = 4;
				break;			
			case 2:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Pan and zoom to RIGHT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"AP_right_femur" ofType:@"png"];
				next_Step = 4;
				break;			
			case 3:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Pan and zoom to RIGHT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"AP_right_femur" ofType:@"png"];
				next_Step = 4;
				break;
            case 4:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 2 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select two points across the right femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"pointAPNarrowestFemoralNeckRight" ofType:@"png"];
				next_Step = 6;
				break;
			case 5:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 2 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select two points across the right femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"pointAPNarrowestFemoralNeckRight" ofType:@"png"];
				next_Step = 6;
				break;
			case 6:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 3 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select the point where the right femoral head or neck first exceeds the circle anteriorally"];
				imageName = [pluginBundle pathForResource:@"pointAPFemoralHeadExceedsCircleRight" ofType:@"png"];
				break;    
			case 7:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 4 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select the LATERAL edge of the right sourcil."];
				imageName = [pluginBundle pathForResource:@"AP_right_lateral" ofType:@"png"];
				break;
			case 8:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 5 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select the MEDIAL edge of the right sourcil."];
				imageName = [pluginBundle pathForResource:@"AP_right_medial" ofType:@"png"];
				break;
			case 9:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 6 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select one point of the right sourcil which is at the narrowest region of joint (radial to femoral head)"];
				imageName = [pluginBundle pathForResource:@"AP_right_JSW" ofType:@"png"];
				break;	
			case 10:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 7 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Pan and zoom to LEFT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"AP_left_femur" ofType:@"png"];
				next_Step = 13;
				break;
			case 11:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 7 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Pan and zoom to LEFT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"AP_left_femur" ofType:@"png"];
				next_Step = 13;
				break;
			case 12:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 7 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Pan and zoom to LEFT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"AP_left_femur" ofType:@"png"];
				next_Step = 13;
				break;	
            case 13:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 8 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select two points across the left femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"pointAPNarrowestFemoralNeckLeft" ofType:@"png"];
				next_Step = 15;
				break;
			case 14:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 8 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select two points across the left femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"pointAPNarrowestFemoralNeckLeft" ofType:@"png"];
				next_Step = 15;
				break;
			case 15:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 9 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select the point where the left femoral head or neck first exceeds the circle anteriorally"];
				imageName = [pluginBundle pathForResource:@"pointAPFemoralHeadExceedsCircleLeft" ofType:@"png"];
				break;    
			case 16:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 10 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select the LATERAL edge of the left sourcil."];
				imageName = [pluginBundle pathForResource:@"AP_left_lateral" ofType:@"png"];
				break;
			case 17:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 11 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select the MEDIAL edge of the left sourcil."];
				imageName = [pluginBundle pathForResource:@"AP_left_medial" ofType:@"png"];
				break;
			case 18:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 12 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select one point of the left sourcil which is at the narrowest region of joint (radial to femoral head)"];
				imageName = [pluginBundle pathForResource:@"AP_left_JSW" ofType:@"png"];
				break;
			case 19:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 13 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Pan and zoom to coccyx and symphysis. Then select the middle of the sacrococcygeal joint"];
				imageName = [pluginBundle pathForResource:@"AP_saccocc" ofType:@"png"];
				break;
			case 20:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 14 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"Select the top of the pubic symphysis"];	
				imageName = [pluginBundle pathForResource:@"AP_pubsymph" ofType:@"png"];
				break;			
			case 21:
				[mainFilter->text_AP_RoiInstructionsStep setStringValue:@"Instructions (step 15 of 15)"];
				[mainFilter->text_AP_RoiInstructions setStringValue:@"All markers are now positioned. Note that the markers can still be moved.\n\nClick forward to review the results."];				
				imageName = @"";
				
				[mainFilter->button_SkipThis setTransparent:YES];
				[mainFilter->button_SkipThis setEnabled:NO];
				break;	
			default:
				break;
		}
		
		if (imageName != NULL) {
			[mainFilter->image_AP_RoiInstructions setImage:[[NSImage alloc] initWithContentsOfFile:imageName]];
		} 
		
	} else if(op_mode == FP) {
		
		[mainFilter->button_FP_SkipThis setTransparent:NO];
		[mainFilter->button_FP_SkipThis setEnabled:YES];
		
		switch (stepNbr) {
			case 1:
				[mainFilter->text_FP_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 3)"];
				[mainFilter->text_FP_RoiInstructions setStringValue:@"Select three points along the spherical curvature of either the right or the left femoral head."];
				imageName = [pluginBundle pathForResource:@"FP_femur" ofType:@"png"];
				next_Step = 4;
				break;			
			case 2:
				[mainFilter->text_FP_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 3)"];
				[mainFilter->text_FP_RoiInstructions setStringValue:@"Select three points along the spherical curvature of either the right or the left femoral head."];
				imageName = [pluginBundle pathForResource:@"FP_femur" ofType:@"png"];
				next_Step = 4;
				break;			
			case 3:
				[mainFilter->text_FP_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 3)"];
				[mainFilter->text_FP_RoiInstructions setStringValue:@"Select three points along the spherical curvature of either the right or the left femoral head."];
				imageName = [pluginBundle pathForResource:@"FP_femur" ofType:@"png"];
				next_Step = 4;
				break;	
			case 4:
				[mainFilter->text_FP_RoiInstructionsStep setStringValue:@"Instructions (step 2 of 3)"];
				[mainFilter->text_FP_RoiInstructions setStringValue:@"Select the ANTERIOR edge of the sourcil."];
				imageName = [pluginBundle pathForResource:@"FP_anterior" ofType:@"png"];
				break;	
			case 5:
				[mainFilter->text_FP_RoiInstructionsStep setStringValue:@"Instructions (step 3 of 3)"];
				[mainFilter->text_FP_RoiInstructions setStringValue:@"All markers are now positioned. Note that the markers can still be moved.\n\nClick forward to review the results."];				
				imageName = @"";
				
				[mainFilter->button_FP_SkipThis setTransparent:YES];
				[mainFilter->button_FP_SkipThis setEnabled:NO];
				break;	
			default:
				break;
		}
		
		if (imageName != NULL) {
			[mainFilter->image_FP_RoiInstructions setImage:[[NSImage alloc] initWithContentsOfFile:imageName]];
		}
		
	} else if(op_mode == Frog) {
		
		[mainFilter->button_Frog_SkipThis setTransparent:NO];
		[mainFilter->button_Frog_SkipThis setEnabled:YES];
		
		switch (stepNbr) {
			case 1:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Pan and zoom to RIGHT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"Frog_right_femur" ofType:@"png"];				
				next_Step = 4;
				break;			
			case 2:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Pan and zoom to RIGHT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"Frog_right_femur" ofType:@"png"];				
				next_Step = 4;
				break;			
			case 3:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Pan and zoom to RIGHT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"Frog_right_femur" ofType:@"png"];				
				next_Step = 4;
				break;	
			case 4:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 2 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points across the right femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"Frog_right_narrowest" ofType:@"png"];
				next_Step = 6;
				break;
			case 5:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 2 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points across the right femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"Frog_right_narrowest" ofType:@"png"];
				next_Step = 6;
				break;
			case 6:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 3 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select the point where the right femoral head or neck first exceeds the circle anteriorally"];
				imageName = [pluginBundle pathForResource:@"Frog_right_circle" ofType:@"png"];
				break;
			case 7:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 4 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select a point at the anteriormost aspect of the right femoral neck"];
				imageName = [pluginBundle pathForResource:@"pointFrogAnteriorFemoralNeckRight" ofType:@"png"];
				break;				
			case 8:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 5 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Pan and zoom to LEFT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"Frog_left_femur" ofType:@"png"];
				next_Step = 11;
				break;
			case 9:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 5 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Pan and zoom to LEFT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"Frog_left_femur" ofType:@"png"];
				next_Step = 11;
				break;
			case 10:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 5 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Pan and zoom to LEFT joint. Then select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"Frog_left_femur" ofType:@"png"];
				next_Step = 11;
				break;	
			case 11:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 6 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points across the left femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"Frog_left_narrowest" ofType:@"png"];
				next_Step = 13;
				break;
			case 12:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 6 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points across the left femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"Frog_left_narrowest" ofType:@"png"];
				next_Step = 13;
				break;
			case 13:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 7 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select the point where the left femoral head or neck first exceeds the circle anteriorally"];
				imageName = [pluginBundle pathForResource:@"Frog_left_circle" ofType:@"png"];
				break;
			case 14:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 8 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select a point at the anteriormost aspect of the left femoral neck"];
				imageName = [pluginBundle pathForResource:@"pointFrogAnteriorFemoralNeckLeft" ofType:@"png"];; //CS fix!
				break;
			case 15:
				[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 9 of 9)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"All markers are now positioned. Note that the markers can still be moved.\n\nClick forward to review the results."];				
				imageName = @"";
				
				[mainFilter->button_Frog_SkipThis setTransparent:YES];
				[mainFilter->button_Frog_SkipThis setEnabled:NO];
				break;	
			default:
				break;
		}
		
		if (imageName != NULL) {
			[mainFilter->image_Frog_RoiInstructions setImage:[[NSImage alloc] initWithContentsOfFile:imageName]];
		}
		
	}else if(op_mode == FrogScfe) {
			
			[mainFilter->button_Frog_SkipThis setTransparent:NO];
			[mainFilter->button_Frog_SkipThis setEnabled:YES];
			
			switch (stepNbr) {
				case 1:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Pan and zoom to RIGHT joint. Then select the point marking the superior edge of the epiphysis"];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeEpiphysisSuperiorRight" ofType:@"png"];
					break;			
				case 2:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 2 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select the point marking the inferior edge of the epiphysis"];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeEpiphysisInferiorRight" ofType:@"png"];
					break;			
				case 3:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 3 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select a point along the spherical curvature of the femoral head."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeFemoralHeadRight" ofType:@"png"];
					break;	
				case 4:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 4 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points across the right femoral neck at the narrowest region."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeNarrowestFemoralNeckRight" ofType:@"png"];
					next_Step = 6;
					break;
				case 5:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 4 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points across the right femoral neck at the narrowest region."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeNarrowestFemoralNeckRight" ofType:@"png"];
					next_Step = 6;
					break;
				case 6:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 5 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select the point where the right femoral head or neck first exceeds the circle anteriorally"];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeFemoralHeadExceedsCircleRight" ofType:@"png"];
					break;
				case 7:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 6 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"A point has been automatically placed. Adjust this point so that the associated line follows the center of the femoral neck"];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeAlphaAdjustRight" ofType:@"png"];
					break;				
				case 8:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 7 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points along the superior edge of the shaft."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeShaftSuperiorRight" ofType:@"png"];
					waiting_for_alpha_adjust_right_flag = 0;
					next_Step = 10;
					break;
				case 9:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 7 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points along the superior edge of the shaft."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeShaftSuperiorRight" ofType:@"png"];
					next_Step = 10;
					break;
				case 10:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 8 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points along the inferior edge of the shaft."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeShaftInferiorRight" ofType:@"png"];
					next_Step = 12;
					break;	
				case 11:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 8 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points along the inferior edge of the shaft."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeShaftInferiorRight" ofType:@"png"];
					next_Step = 12;
					break;
				case 12:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 9 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select the point marking the superior edge of the metaphysis."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeMetaphysisRight" ofType:@"png"];
					break;
				
				case 13:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 10 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Pan and zoom to LEFT joint. Then select the point marking the superior edge of the epiphysis"];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeEpiphysisSuperiorLeft" ofType:@"png"];
					break;			
				case 14:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 11 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select the point marking the inferior edge of the epiphysis"];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeEpiphysisInferiorLeft" ofType:@"png"];
					break;			
				case 15:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 12 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select a point along the spherical curvature of the femoral head."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeFemoralHeadLeft" ofType:@"png"];
					break;	
				case 16:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 13 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points across the left femoral neck at the narrowest region."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeNarrowestFemoralNeckLeft" ofType:@"png"];
					next_Step = 18;
					break;
				case 17:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 13 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points across the left femoral neck at the narrowest region."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeNarrowestFemoralNeckLeft" ofType:@"png"];
					next_Step = 18;
					break;
				case 18:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 14 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select the point where the left femoral head or neck first exceeds the circle anteriorally"];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeFemoralHeadExceedsCircleLeft" ofType:@"png"];
					break;
				case 19:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 15 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"A point has been automatically placed. Adjust this point so that the associated line follows the center of the femoral neck"];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeAlphaAdjustLeft" ofType:@"png"];
					break;				
				case 20:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 16 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points along the superior edge of the shaft."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeShaftSuperiorLeft" ofType:@"png"];
					waiting_for_alpha_adjust_left_flag = 0;
					next_Step = 22;
					break;
				case 21:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 16 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points along the superior edge of the shaft."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeShaftSuperiorLeft" ofType:@"png"];
					next_Step = 22;
					break;
				case 22:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 17 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points along the inferior edge of the shaft."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeShaftInferiorLeft" ofType:@"png"];
					next_Step = 24;
					break;	
				case 23:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 17 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points along the inferior edge of the shaft."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeShaftInferiorLeft" ofType:@"png"];
					next_Step = 24;
					break;
				case 24:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 18 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select the point marking the superior edge of the metaphysis."];
					imageName = [pluginBundle pathForResource:@"pointFrogScfeMetaphysisLeft" ofType:@"png"];
					break;	
					
				case 25:
					[mainFilter->text_Frog_RoiInstructionsStep setStringValue:@"Instructions (step 19 of 19)"];
					[mainFilter->text_Frog_RoiInstructions setStringValue:@"All markers are now positioned. Note that the markers can still be moved.\n\nClick forward to review the results."];				
					imageName = @"";
					
					[mainFilter->button_Frog_SkipThis setTransparent:YES];
					[mainFilter->button_Frog_SkipThis setEnabled:NO];
					break;	
				default:
					break;
			}
			
		
		if (imageName != NULL) {
			[mainFilter->image_Frog_RoiInstructions setImage:[[NSImage alloc] initWithContentsOfFile:imageName]];
			[mainFilter->image_Frog_RoiInstructions setImageScaling:NSImageScaleNone];
		}
        
	} else if(op_mode == Alpha) {
		
		[mainFilter->button_Alpha_SkipThis setTransparent:NO];
		[mainFilter->button_Alpha_SkipThis setEnabled:YES];
		
		switch (stepNbr) {
			case 1:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"Frog_right_femur" ofType:@"png"];
				next_Step = 4;
				break;			
			case 2:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"Frog_right_femur" ofType:@"png"];
				next_Step = 4;
				break;			
			case 3:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 1 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select three points along the spherical curvature of the femoral head."];
				imageName = [pluginBundle pathForResource:@"Frog_right_femur" ofType:@"png"];
				next_Step = 4;
				break;
            case 4:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 2 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select two points across the femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"Frog_right_narrowest" ofType:@"png"];
				next_Step = 6;
				break;
			case 5:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 2 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select two points across the femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"Frog_right_narrowest" ofType:@"png"];
				next_Step = 6;
				break;
			case 6:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 3 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select the point where the femoral head or neck first exceeds the circle anteriorally"];
				imageName = [pluginBundle pathForResource:@"Frog_right_circle" ofType:@"png"];
				break;    
			case 7:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 4 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select three points along the spherical curvature of the opposite femoral head. Or click the results button to skip the opposite side."];
				imageName = [pluginBundle pathForResource:@"Frog_left_femur" ofType:@"png"];
				next_Step = 10;
				break;
			case 8:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 4 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select three points along the spherical curvature of the opposite femoral head. Or click the results button to skip the opposite side."];
				imageName = [pluginBundle pathForResource:@"Frog_left_femur" ofType:@"png"];
				next_Step = 10;
				break;
			case 9:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 4 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select three points along the spherical curvature of the opposite femoral head. Or click the results button to skip the opposite side."];
				imageName = [pluginBundle pathForResource:@"Frog_left_femur" ofType:@"png"];
				next_Step = 10;
				break;	
            case 10:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 5 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select two points across the femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"Frog_left_narrowest" ofType:@"png"];
				next_Step = 12;
				break;
			case 11:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 5 of 7)"];
				[mainFilter->text_Frog_RoiInstructions setStringValue:@"Select two points across the femoral neck at the narrowest region."];
				imageName = [pluginBundle pathForResource:@"Frog_left_narrowest" ofType:@"png"];
				next_Step = 12;
				break;
			case 12:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 6 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"Select the point where the femoral head or neck first exceeds the circle anteriorally"];
				imageName = [pluginBundle pathForResource:@"Frog_left_circle" ofType:@"png"];
				break;  
            case 13:
				[mainFilter->text_Alpha_RoiInstructionsStep setStringValue:@"Instructions (step 7 of 7)"];
				[mainFilter->text_Alpha_RoiInstructions setStringValue:@"All markers are now positioned. Note that the markers can still be moved.\n\nClick forward to review the results."];				
				imageName = @"";
				
				[mainFilter->button_Alpha_SkipThis setTransparent:YES];
				[mainFilter->button_Alpha_SkipThis setEnabled:NO];    
			default:
				break;
		}
		
		if (imageName != NULL) {
			[mainFilter->image_Alpha_RoiInstructions setImage:[[NSImage alloc] initWithContentsOfFile:imageName]];
		} 
		
	}
	
	
	
}


-(int)checkOpModeFromExistingPoints:(ViewerController*) viewerController {

	int				retval = -1;
	NSRange			pos;
	NSMutableArray  *roiSeriesList;
	NSMutableArray  *roiImageList;
	
	roiSeriesList = [viewerController roiList];
	roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
	
	for(ROI *roi in roiImageList) {
		
		if([[roi name] isEqualToString:NAME_PREFS] ) {
			
			NSString *rc = [pointPrefs comments];
			
			pos = [rc rangeOfString:@"op:"];
			if(pos.location != NSNotFound && [rc length] >= pos.location+5) {
				retval = [[rc substringWithRange:NSMakeRange(pos.location+3, 2)] intValue];
			}
			break;
		}
	}
	return retval;
}


-(int)loadFromExistingPoints:(int) op_mode :(ViewerController*) viewerController {
	
	NSMutableArray  *roiSeriesList;
	NSMutableArray  *roiImageList;
	NSMutableArray  *roisToDelete = [NSMutableArray arrayWithCapacity:1];
	BOOL anything_found = NO;
	BOOL prefs_found = NO;
	BOOL points_found = NO;
	int loadedCurrStep = 1;
	int nbrOfSteps = 1;
	int loadedCurrOpMode = 1;
	NSRange pos;
	
	if(op_mode==AP) nbrOfSteps = NBR_OF_STEPS;
	if(op_mode==FP) nbrOfSteps = NBR_OF_STEPS_FP;
	if(op_mode==Frog) nbrOfSteps = NBR_OF_STEPS_FROG;
	if(op_mode==FrogScfe) nbrOfSteps = NBR_OF_STEPS_FROG_SCFE;
    if(op_mode==Alpha) nbrOfSteps = NBR_OF_STEPS_ALPHA;
	
	
	roiSeriesList = [viewerController roiList];
	roiImageList = [roiSeriesList objectAtIndex: [[viewerController imageView] curImage]];
	
	for(ROI *roi in roiImageList) {
		
		points_found = NO;
		//NSRunInformationalAlertPanel(@"ROI", [roi name], @"OK", 0L, 0L);
		
		if([[roi name] isEqualToString:NAME_HELPER] ) {
			[roisToDelete addObject:roi];
			
		} else if([[roi name] isEqualToString:NAME_PREFS] ) {
			//NSLog(@"prefs found");
			prefs_found = YES;
			pointPrefs = roi;
			
			NSString *rc = [pointPrefs comments];
			
			//NSLog(rc);
			pos = [rc rangeOfString:@"cs:"];
			if(pos.location != NSNotFound && [rc length] >= pos.location+5) loadedCurrStep = [[rc substringWithRange:NSMakeRange(pos.location+3, 2)] intValue];
			else loadedCurrStep = nbrOfSteps;
			
			pos = [rc rangeOfString:@"op:"];
			if(pos.location != NSNotFound && [rc length] >= pos.location+5) loadedCurrOpMode = [[rc substringWithRange:NSMakeRange(pos.location+3, 2)] intValue];
			else loadedCurrOpMode = -1;
			
			if(loadedCurrOpMode != op_mode) {
				loadedCurrStep = nbrOfSteps;
				//NSLog(@"wrong opmode");
			}
			
		} else if([[roi name] isEqualToString:NAME_FEMORAL_HEAD_RIGHT] ) {
			points_found = YES;
			
			if(pointFemoralHeadRight1 == NULL) pointFemoralHeadRight1 = roi;
			else if(pointFemoralHeadRight2 == NULL) pointFemoralHeadRight2 = roi;
			else if(pointFemoralHeadRight3 == NULL) pointFemoralHeadRight3 = roi;
			
		} else if([[roi name] isEqualToString:NAME_LATERAL_SOURCIL_RIGHT] ) {
			points_found = YES;
			pointLateralSourcilRight = roi;
			
		} else if([[roi name] isEqualToString:NAME_MEDIAL_SOURCIL_RIGHT] ) {
			points_found = YES;
			pointMedialSourcilRight = roi;
			
		} else if([[roi name] isEqualToString:NAME_JSW_RIGHT] ) {
			points_found = YES;
			pointJSWRight = roi;	
			
		} else if([[roi name] isEqualToString:NAME_FEMORAL_HEAD_LEFT] ) {
			points_found = YES;
			
			if(pointFemoralHeadLeft1 == NULL) pointFemoralHeadLeft1 = roi;
			else if(pointFemoralHeadLeft2 == NULL) pointFemoralHeadLeft2 = roi;
			else if(pointFemoralHeadLeft3 == NULL) pointFemoralHeadLeft3 = roi;
			
		} else if([[roi name] isEqualToString:NAME_LATERAL_SOURCIL_LEFT] ) {
			points_found = YES;
			pointLateralSourcilLeft = roi;	
			
		} else if([[roi name] isEqualToString:NAME_MEDIAL_SOURCIL_LEFT] ) {
			points_found = YES;
			pointMedialSourcilLeft = roi;
			
		} else if([[roi name] isEqualToString:NAME_JSW_LEFT] ) {
			points_found = YES;
			pointJSWLeft = roi;	
			
		} else if([[roi name] isEqualToString:NAME_SAC_JOINT] ) {
			points_found = YES;
			pointSacrococcygealJoint = roi;	
			
		} else if([[roi name] isEqualToString:NAME_PUB_SYMPH] ) {
			points_found = YES;
			pointPublicSymphysis = roi;
		
		} else if([[roi name] isEqualToString:NAME_FP_FEMORAL_HEAD] ) {
			points_found = YES;
			
			if(pointFPFemoralHead1 == NULL) pointFPFemoralHead1 = roi;
			else if(pointFPFemoralHead2 == NULL) pointFPFemoralHead2 = roi;
			else if(pointFPFemoralHead3 == NULL) pointFPFemoralHead3 = roi;
			
		} else if([[roi name] isEqualToString:NAME_FP_ANTERIOR_SOURCIL] ) {
			points_found = YES;
			pointFPAnteriorEdgeSourcil = roi;
		
		}else if([[roi name] isEqualToString:NAME_FROG_NARROWEST_FEMORAL_RIGHT] ) {
			points_found = YES;
			if(pointFrogNarrowestFemoralNeckRight1 == NULL) pointFrogNarrowestFemoralNeckRight1 = roi;
			else if(pointFrogNarrowestFemoralNeckRight2 == NULL) pointFrogNarrowestFemoralNeckRight2 = roi;
		
		}else if([[roi name] isEqualToString:NAME_FROG_NARROWEST_FEMORAL_LEFT] ) {
			points_found = YES;
			if(pointFrogNarrowestFemoralNeckLeft1 == NULL) pointFrogNarrowestFemoralNeckLeft1 = roi;
			else if(pointFrogNarrowestFemoralNeckLeft2 == NULL) pointFrogNarrowestFemoralNeckLeft2 = roi;
	
		}else if([[roi name] isEqualToString:NAME_FROG_EXCEEDS_CIRCLE_RIGHT] ) {
			points_found = YES;
			pointFrogFemoralHeadExceedsCircleRight = roi;
		
		}else if([[roi name] isEqualToString:NAME_FROG_EXCEEDS_CIRCLE_LEFT] ) {
			points_found = YES;
			pointFrogFemoralHeadExceedsCircleLeft = roi;
		}else if([[roi name] isEqualToString:NAME_FROG_ANTERIOR_FEMORAL_NECK_RIGHT] ) {
			points_found = YES;
			pointFrogAnteriorFemoralNeckRight = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_ANTERIOR_FEMORAL_NECK_LEFT] ) {
			points_found = YES;
			pointFrogAnteriorFemoralNeckLeft = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_EPIPHYSIS_SUPERIOR_RIGHT] ) {
			points_found = YES;
			pointFrogScfeEpiphysisSuperiorRight = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_EPIPHYSIS_INFERIOR_RIGHT] ) {
			points_found = YES;
			pointFrogScfeEpiphysisInferiorRight = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_EPIPHYSIS_SUPERIOR_LEFT] ) {
			points_found = YES;
			pointFrogScfeEpiphysisSuperiorLeft = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_EPIPHYSIS_INFERIOR_LEFT] ) {
			points_found = YES;
			pointFrogScfeEpiphysisInferiorLeft = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_FEMORAL_HEAD_RIGHT] ) {
			points_found = YES;
			pointFrogScfeFemoralHeadRight = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_FEMORAL_HEAD_LEFT] ) {
			points_found = YES;
			pointFrogScfeFemoralHeadLeft = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_ALPHA_ADJUST_RIGHT] ) {
			points_found = YES;
			pointFrogScfeAlphaAdjustRight = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_ALPHA_ADJUST_LEFT] ) {
			points_found = YES;
			pointFrogScfeAlphaAdjustLeft = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_SHAFT_SUPERIOR_RIGHT] ) {
			points_found = YES;
			if(pointFrogScfeShaftSuperiorRight1 == NULL) pointFrogScfeShaftSuperiorRight1 = roi;
			else if(pointFrogScfeShaftSuperiorRight2 == NULL) pointFrogScfeShaftSuperiorRight2 = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_SHAFT_INFERIOR_RIGHT] ) {
			points_found = YES;
			if(pointFrogScfeShaftInferiorRight1 == NULL) pointFrogScfeShaftInferiorRight1 = roi;
			else if(pointFrogScfeShaftInferiorRight2 == NULL) pointFrogScfeShaftInferiorRight2 = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_SHAFT_SUPERIOR_LEFT] ) {
			points_found = YES;
			if(pointFrogScfeShaftSuperiorLeft1 == NULL) pointFrogScfeShaftSuperiorLeft1 = roi;
			else if(pointFrogScfeShaftSuperiorLeft2 == NULL) pointFrogScfeShaftSuperiorLeft2 = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_SHAFT_INFERIOR_LEFT] ) {
			points_found = YES;
			if(pointFrogScfeShaftInferiorLeft1 == NULL) pointFrogScfeShaftInferiorLeft1 = roi;
			else if(pointFrogScfeShaftInferiorLeft2 == NULL) pointFrogScfeShaftInferiorLeft2 = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_METAPHYSIS_RIGHT] ) {
			points_found = YES;
			pointFrogScfeMetaphysisRight = roi;
			
		}else if([[roi name] isEqualToString:NAME_FROG_SCFE_METAPHYSIS_LEFT] ) {
			points_found = YES;
			pointFrogScfeMetaphysisLeft = roi;
			
		}
		
		//if(points_found) NSLog(@"Point found:");
		//else NSLog(@"Point NOT found:");
		//NSLog([roi name]);
		//NSLog(@"");
		
		// Textual Data might be hidden from since the roi was previously shown.
		// This can happen when the plugin is interrupted before all points are placed.
		// Thus make sure all rois have their textual data shown.
		if(points_found) {
			[roi setDisplayTextualData:TRUE];
			anything_found = YES;
		}
	}
	
	if(prefs_found) {
		anything_found = YES;
	}
	
	[roiImageList removeObjectsInArray:roisToDelete];
	
	if(anything_found == YES && loadedCurrStep == 1) loadedCurrStep = nbrOfSteps;
	
	//NSLog(@"loadFromExistingPoints: loadedCurrStep %d", loadedCurrStep);
    
    
	return(loadedCurrStep);
}


-(BOOL)isThisThePrefsRoi:(ROI*) roi {
	
	if(pointPrefs == roi) return YES;
	else return NO;
}


-(BOOL)isRoiOneOfOurs:(ROI*) roi : (BOOL) nullify {

	
	
	BOOL retval = NO;
	
	if (pointFemoralHeadRight1		== roi) {
		if(nullify == YES) pointFemoralHeadRight1 = NULL;
		retval = YES;
	}	
	else if(pointFemoralHeadRight2		== roi) {
		if(nullify == YES) pointFemoralHeadRight2 = NULL;
		retval = YES;
	}	
	else if(pointFemoralHeadRight3		== roi) {
		if(nullify == YES) pointFemoralHeadRight3 = NULL;
		retval = YES;
	}	
	else if(pointLateralSourcilRight	== roi) {
		if(nullify == YES) pointLateralSourcilRight = NULL;
		retval = YES;
	}	
	else if(pointMedialSourcilRight		== roi) {
		if(nullify == YES) pointMedialSourcilRight = NULL;
		retval = YES;
	}	
	else if(pointFemoralHeadLeft1		== roi) {
		if(nullify == YES) pointFemoralHeadLeft1 = NULL;
		retval = YES;
	}	
	else if(pointFemoralHeadLeft2		== roi) {
		if(nullify == YES) pointFemoralHeadLeft2 = NULL;
		retval = YES;
	}	
	else if(pointFemoralHeadLeft3		== roi) {
		if(nullify == YES) pointFemoralHeadLeft3 = NULL;
		retval = YES;
	}	
	else if(pointLateralSourcilLeft		== roi) {
		if(nullify == YES) pointLateralSourcilLeft = NULL;
		retval = YES;
	}	
	else if(pointMedialSourcilLeft		== roi) {
		if(nullify == YES) pointMedialSourcilLeft = NULL;
		retval = YES;
	}	
	else if(pointJSWRight				== roi) {
		if(nullify == YES) pointJSWRight = NULL;
		retval = YES;
	}	
	else if(pointJSWLeft				== roi) {
		if(nullify == YES) pointJSWLeft = NULL;
		retval = YES;
	}	
	else if(pointSacrococcygealJoint	== roi) {
		if(nullify == YES) pointSacrococcygealJoint = NULL;
		retval = YES;
	}	
	else if(pointPublicSymphysis		== roi) {
		if(nullify == YES) pointPublicSymphysis = NULL;
		retval = YES;
	}	
	else if(circleFemoralHeadRight		== roi) {
		if(nullify == YES) circleFemoralHeadRight = NULL;
		retval = YES;
	}	
	else if(circleFemoralHeadLeft		== roi) {
		if(nullify == YES) circleFemoralHeadLeft = NULL;
		retval = YES;
	}	
	else if(lineBetweenFemoralHeads		== roi) {
		if(nullify == YES) lineBetweenFemoralHeads = NULL;
		retval = YES;
	}	
	else if(angleTonnisRight			== roi) {
		if(nullify == YES) angleTonnisRight = NULL;
		retval = YES;
	}	
	else if(angleTonnisLeft				== roi) {
		if(nullify == YES) angleTonnisLeft = NULL;
		retval = YES;
	}	
	else if(angleLCERight				== roi) {
		if(nullify == YES) angleLCERight = NULL;
		retval = YES;
	}	
	else if(angleLCELeft				== roi) {
		if(nullify == YES) angleLCELeft = NULL;
		retval = YES;
	}	
	else if(lineJSWRight				== roi) {
		if(nullify == YES) lineJSWRight = NULL;
		retval = YES;
	}	
	else if(lineJSWLeft					== roi) {
		if(nullify == YES) lineJSWLeft = NULL;
		retval = YES;
	}	
	else if(lineSacToSymph				== roi) {
		if(nullify == YES) lineSacToSymph = NULL;
		retval = YES;
	}	
	else if(pointPrefs					== roi) {
			if(nullify == YES) pointPrefs = NULL;
			retval = YES;
	}
	else if (pointFPFemoralHead1		== roi) {
		if(nullify == YES) pointFPFemoralHead1 = NULL;			//False Profile
		retval = YES;
	}	
	else if(pointFPFemoralHead2		== roi) {
		if(nullify == YES) pointFPFemoralHead2 = NULL;
		retval = YES;
	}	
	else if(pointFPFemoralHead3		== roi) {
		if(nullify == YES) pointFPFemoralHead3 = NULL;
		retval = YES;
	}	
	else if(pointFPAnteriorEdgeSourcil					== roi) {
		if(nullify == YES) pointFPAnteriorEdgeSourcil = NULL;		
		retval = YES;
	}	
	else if(pointFrogNarrowestFemoralNeckRight1					== roi) {
		if(nullify == YES) pointFrogNarrowestFemoralNeckRight1 = NULL;		//Frog
		retval = YES;
	}	
	else if(pointFrogNarrowestFemoralNeckRight2					 == roi) {
		if(nullify == YES) pointFrogNarrowestFemoralNeckRight2 = NULL;
		retval = YES;
	}	
	else if(pointFrogNarrowestFemoralNeckLeft1					== roi) {
		if(nullify == YES) pointFrogNarrowestFemoralNeckLeft1 = NULL;
		retval = YES;
	}	
	else if(pointFrogNarrowestFemoralNeckLeft2					== roi) {
		if(nullify == YES) pointFrogNarrowestFemoralNeckLeft2 = NULL;
		retval = YES;	
	}	
	else if(pointFrogFemoralHeadExceedsCircleRight					== roi) {
		if(nullify == YES) pointFrogFemoralHeadExceedsCircleRight = NULL;
		retval = YES;
	}	
	else if(pointFrogFemoralHeadExceedsCircleLeft					== roi) {
		if(nullify == YES) pointFrogFemoralHeadExceedsCircleLeft = NULL;
		retval = YES;
	}	
	else if(circleFPFemoralHead		== roi) {
		if(nullify == YES) circleFPFemoralHead = NULL;		//False Profile
		retval = YES;
	}
	else if(angleFPACE					== roi) {
		if(nullify == YES) angleFPACE = NULL;	
		retval = YES;
	}		
	else if(lineFrogNarrowestFemoralNeckRight					== roi) {
		if(nullify == YES) lineFrogNarrowestFemoralNeckRight = NULL;  //Frog
		retval = YES;
	}	
	else if(lineFrogNarrowestFemoralNeckLeft					== roi) {
		if(nullify == YES) lineFrogNarrowestFemoralNeckLeft = NULL;
		retval = YES;
	}	
	else if(angleFrogAlphaRight					== roi) {
		if(nullify == YES) angleFrogAlphaRight = NULL;
		retval = YES;
	}	
	else if(angleFrogAlphaLeft					== roi) {
		if(nullify == YES) angleFrogAlphaLeft = NULL;
		retval = YES;	
	} 
	else if(pointFrogAnteriorFemoralNeckRight == roi) {
		if(nullify == YES) pointFrogAnteriorFemoralNeckRight = NULL;
		retval = YES;
	}	
	else if(pointFrogAnteriorFemoralNeckLeft == roi) {
		if(nullify == YES) pointFrogAnteriorFemoralNeckLeft = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeEpiphysisSuperiorRight == roi) {
		if(nullify == YES) pointFrogScfeEpiphysisSuperiorRight = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeEpiphysisInferiorRight == roi) {
		if(nullify == YES) pointFrogScfeEpiphysisInferiorRight = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeEpiphysisSuperiorLeft == roi) {
		if(nullify == YES) pointFrogScfeEpiphysisSuperiorLeft = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeEpiphysisInferiorLeft == roi) {
		if(nullify == YES) pointFrogScfeEpiphysisInferiorLeft = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeFemoralHeadRight == roi) {
		if(nullify == YES) pointFrogScfeFemoralHeadRight = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeFemoralHeadLeft == roi) {
		if(nullify == YES) pointFrogScfeFemoralHeadLeft = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeAlphaAdjustRight == roi) {
		if(nullify == YES) pointFrogScfeAlphaAdjustRight = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeAlphaAdjustLeft == roi) {
		if(nullify == YES) pointFrogScfeAlphaAdjustLeft = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeShaftSuperiorRight1 == roi) {
		if(nullify == YES) pointFrogScfeShaftSuperiorRight1 = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeShaftSuperiorRight2 == roi) {
		if(nullify == YES) pointFrogScfeShaftSuperiorRight2 = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeShaftInferiorRight1 == roi) {
		if(nullify == YES) pointFrogScfeShaftInferiorRight1 = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeShaftInferiorRight2 == roi) {
		if(nullify == YES) pointFrogScfeShaftInferiorRight2 = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeShaftSuperiorLeft1 == roi) {
		if(nullify == YES) pointFrogScfeShaftSuperiorLeft1 = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeShaftSuperiorLeft2 == roi) {
		if(nullify == YES) pointFrogScfeShaftSuperiorLeft2 = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeShaftInferiorLeft1 == roi) {
		if(nullify == YES) pointFrogScfeShaftInferiorLeft1 = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeShaftInferiorLeft2 == roi) {
		if(nullify == YES) pointFrogScfeShaftInferiorLeft2 = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeMetaphysisRight == roi) {
		if(nullify == YES) pointFrogScfeMetaphysisRight = NULL;
		retval = YES;
	}	
	else if(pointFrogScfeMetaphysisLeft == roi) {
		if(nullify == YES) pointFrogScfeMetaphysisLeft = NULL;
		retval = YES;
	}	
	else if(lineFrogHNOffsetOuterRight == roi) {
		if(nullify == YES) lineFrogHNOffsetOuterRight = NULL;
		retval = YES;
	}	
	else if(lineFrogHNOffsetInnerRight == roi) {
		if(nullify == YES) lineFrogHNOffsetInnerRight = NULL;
		retval = YES;
	}	
	else if(lineFrogHNOffsetOuterLeft == roi) {
		if(nullify == YES) lineFrogHNOffsetOuterLeft = NULL;
		retval = YES;
	}	
	else if(lineFrogHNOffsetInnerLeft == roi) {
		if(nullify == YES) lineFrogHNOffsetInnerLeft = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeCrossShaftUpperRight == roi) {
		if(nullify == YES) lineFrogScfeCrossShaftUpperRight = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeCrossShaftLowerRight == roi) {
		if(nullify == YES) lineFrogScfeCrossShaftLowerRight = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeCrossShaftUpperLeft == roi) {
		if(nullify == YES) lineFrogScfeCrossShaftUpperLeft = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeCrossShaftLowerLeft == roi) {
		if(nullify == YES) lineFrogScfeCrossShaftLowerLeft = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeEMOffsetOuterRight == roi) {
		if(nullify == YES) lineFrogScfeEMOffsetOuterRight = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeEMOffsetInnerRight == roi) {
		if(nullify == YES) lineFrogScfeEMOffsetInnerRight = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeEMOffsetOuterLeft == roi) {
		if(nullify == YES) lineFrogScfeEMOffsetOuterLeft = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeEMOffsetInnerLeft == roi) {
		if(nullify == YES) lineFrogScfeEMOffsetInnerLeft = NULL;
		retval = YES;
	}	
	else if(angleFrogScfeSouthwickRight == roi) {
		if(nullify == YES) angleFrogScfeSouthwickRight = NULL;
		retval = YES;
	}	
	else if(angleFrogScfeSouthwickLeft == roi) {
		if(nullify == YES) angleFrogScfeSouthwickLeft = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeAlphaCenterRight == roi) {
		if(nullify == YES) lineFrogScfeAlphaCenterRight = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeAlphaCenterLeft == roi) {
		if(nullify == YES) lineFrogScfeAlphaCenterLeft = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeAlphaAdjustRight == roi) {
		if(nullify == YES) lineFrogScfeAlphaAdjustRight = NULL;
		retval = YES;
	}	
	else if(lineFrogScfeAlphaAdjustLeft == roi) {
		if(nullify == YES) lineFrogScfeAlphaAdjustLeft = NULL;
		retval = YES;
	}
	else if(lineFrogScfeSouthwickBaseRealRight == roi) {
		if(nullify == YES) lineFrogScfeSouthwickBaseRealRight = NULL;
		retval = YES;
	}
	else if(lineFrogScfeSouthwickBaseRealLeft == roi) {
		if(nullify == YES) lineFrogScfeSouthwickBaseRealLeft = NULL;
		retval = YES;
	}
	else if(lineFrogScfeSouthwickBaseCloneRight == roi) {
		if(nullify == YES) lineFrogScfeSouthwickBaseCloneRight = NULL;
		retval = YES;
	}
	else if(lineFrogScfeSouthwickBaseCloneLeft == roi) {
		if(nullify == YES) lineFrogScfeSouthwickBaseCloneLeft = NULL;
		retval = YES;
	}
	else {
		retval = NO;
	}
	
	//if(retval==YES) {
	//	if(nullify) NSLog(@"isRoiOneOfOurs: %@, NULLIFY = YES", [roi name]);
	//	else NSLog(@"isRoiOneOfOurs: %@ = YES", [roi name]);
	//} else {
	//	if(nullify) NSLog(@"isRoiOneOfOurs: %@, NULLIFY = NO", [roi name]);
	//	else NSLog(@"isRoiOneOfOurs: %@ = NO", [roi name]);
	//}
	return(retval);
}



@end
