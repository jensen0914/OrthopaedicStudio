//
//  ResultsManager.m
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
#import "ResultsManager.h"
#import <OsiriX/DCMObject.h>
#import <OsiriXAPI/dicomFile.h>


@implementation ResultsManager

- (void)initWithMainFilter:(OrthopaedicStudioFilter*) main_filter {

	mainFilter = main_filter;
	//last_opmode_saving = -1;
}


- (NSInteger) displayAlert : (NSString*) alertStr {
	
	NSAlert* alert = [ [ NSAlert alloc ] init ];
	[ alert addButtonWithTitle : @"OK" ];
	[ alert setMessageText : @"Orthopaedic Studio"];
	[ alert setInformativeText : alertStr ];
	[ alert setAlertStyle : NSAlertStyleInformational ];
	[ alert setShowsSuppressionButton : NO ];
	NSInteger choice = [ alert runModal ];
	[ alert release ];
	return choice;
}


- (void)readVisualScoreResults:(int) op_mode{
		
	switch (op_mode) {
		case AP:
			if ([mainFilter->popUp_AP_XRayView selectedTag] == 1) result_AP_XRayView = @"N/A";
			else result_AP_XRayView = [mainFilter->popUp_AP_XRayView titleOfSelectedItem];
			
			if ([mainFilter->popUp_AP_ShentonLeft selectedTag] == 1) result_AP_ShentonLeft = @"N/A";
			else result_AP_ShentonLeft = [mainFilter->popUp_AP_ShentonLeft titleOfSelectedItem];
			
			if ([mainFilter->popUp_AP_ShentonRight selectedTag] == 1) result_AP_ShentonRight = @"N/A";
			else result_AP_ShentonRight = [mainFilter->popUp_AP_ShentonRight titleOfSelectedItem];
			
			if ([mainFilter->popUp_AP_CrossOverLeft selectedTag] == 1) result_AP_CrossOverLeft = @"N/A";
			else result_AP_CrossOverLeft = [mainFilter->popUp_AP_CrossOverLeft titleOfSelectedItem];
			
			if ([mainFilter->popUp_AP_CrossOverRight selectedTag] == 1) result_AP_CrossOverRight = @"N/A";
			else result_AP_CrossOverRight = [mainFilter->popUp_AP_CrossOverRight titleOfSelectedItem];
			
			if ([mainFilter->popUp_AP_PosteriorWallLeft selectedTag] == 1) result_AP_PosteriorWallLeft = @"N/A";
			else result_AP_PosteriorWallLeft = [mainFilter->popUp_AP_PosteriorWallLeft titleOfSelectedItem];
			
			if ([mainFilter->popUp_AP_PosteriorWallRight selectedTag] == 1) result_AP_PosteriorWallRight = @"N/A";
			else result_AP_PosteriorWallRight = [mainFilter->popUp_AP_PosteriorWallRight titleOfSelectedItem];
			
			if ([mainFilter->popUp_AP_TonnisLeft selectedTag] == 1) result_AP_TonnisLeft = @"N/A";
			else result_AP_TonnisLeft = [mainFilter->popUp_AP_TonnisLeft titleOfSelectedItem];
			
			if ([mainFilter->popUp_AP_TonnisRight selectedTag] == 1) result_AP_TonnisRight = @"N/A";
			else result_AP_TonnisRight = [mainFilter->popUp_AP_TonnisRight titleOfSelectedItem];
			
			break;
			
		case VonRosen:
			// obs. tagnumreringen är lite inkonsekvent här
			if ([mainFilter->popUp_VR_JointConLeft selectedTag] == -1) result_VR_JointConLeft = @"N/A";
			else result_VR_JointConLeft = [NSString stringWithFormat:@"%ld", (long)[mainFilter->popUp_VR_JointConLeft selectedTag]];
			
			if ([mainFilter->popUp_VR_JointConRight selectedTag] == -1) result_VR_JointConRight = @"N/A";
			else result_VR_JointConRight = [NSString stringWithFormat:@"%ld", (long)[mainFilter->popUp_VR_JointConRight selectedTag]];
			
			break;
		default:
			break;
	}
	
	
	
}

- (void)readROIResults: (int) op_mode : (RoiManager*) roiManager : (BOOL) update_FP_side {
	
	if(op_mode == AP) {
		
		if (roiManager->result_LCE_right < -999) result_AP_LCE_right = @"N/A";
		else result_AP_LCE_right = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_LCE_right];
		
		if (roiManager->result_LCE_left < -999) result_AP_LCE_left = @"N/A";
		else result_AP_LCE_left = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_LCE_left];
		
		if (roiManager->result_Tonnis_right < -999) result_AP_Tonnis_right = @"N/A";
		else result_AP_Tonnis_right = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_Tonnis_right];
		
		if (roiManager->result_Tonnis_left < -999) result_AP_Tonnis_left = @"N/A";
		else result_AP_Tonnis_left = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_Tonnis_left];
		
		if (roiManager->result_JSW_right < 0) result_AP_JSW_right = @"N/A";
		else result_AP_JSW_right = [NSString stringWithFormat:@"%-3.1f mm", roiManager->result_JSW_right*10];
		
		if (roiManager->result_JSW_left < 0) result_AP_JSW_left = @"N/A";
		else result_AP_JSW_left = [NSString stringWithFormat:@"%-3.1f mm", roiManager->result_JSW_left*10];
		
		if (roiManager->result_PelvicTilt < 0) result_AP_PelvicTilt = @"N/A";
		else result_AP_PelvicTilt = [NSString stringWithFormat:@"%-4.1f cm", roiManager->result_PelvicTilt];
		
		if (roiManager->result_PelvicRot < 0) result_AP_PelvicRot = @"N/A";
		else result_AP_PelvicRot = [NSString stringWithFormat:@"%-4.1f mm", roiManager->result_PelvicRot*10];
        
        if (roiManager->result_Frog_Alpha_right < 0) result_Frog_Alpha_right = @"N/A";
		else result_Frog_Alpha_right = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_Frog_Alpha_right];
		
		if (roiManager->result_Frog_Alpha_left < 0) result_Frog_Alpha_left = @"N/A";
		else result_Frog_Alpha_left = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_Frog_Alpha_left];
		
	} else if(op_mode == FP) {
		
		// not the most beautiful solution... this stuff should not be here
		if(update_FP_side) {
			[mainFilter->popup_FP_Side selectItemAtIndex:roiManager->guessed_FP_ACE_side];
		}
		
		if (roiManager->result_FP_ACE < -999) result_FP_ACE = @"N/A";
		else {
			if ([mainFilter->popup_FP_Side indexOfSelectedItem] == FP_ACE_LEFT) {
				result_FP_ACE = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_FP_ACE];
			} else {
				result_FP_ACE = [NSString stringWithFormat:@"%-4.1fº", -roiManager->result_FP_ACE];
			}
		}	
		
	} else if(op_mode == Frog || op_mode == FrogScfe) {
		
		if (roiManager->result_Frog_Alpha_right < 0) result_Frog_Alpha_right = @"N/A";
		else result_Frog_Alpha_right = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_Frog_Alpha_right];
		
		if (roiManager->result_Frog_Alpha_left < 0) result_Frog_Alpha_left = @"N/A";
		else result_Frog_Alpha_left = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_Frog_Alpha_left];
		
		if (roiManager->result_Frog_HNOffset_right < -999) result_Frog_HNOffset_right = @"N/A";
		else result_Frog_HNOffset_right = [NSString stringWithFormat:@"%-3.2f", roiManager->result_Frog_HNOffset_right];
		
		if (roiManager->result_Frog_HNOffset_left < -999) result_Frog_HNOffset_left = @"N/A";
		else result_Frog_HNOffset_left = [NSString stringWithFormat:@"%-3.2f", roiManager->result_Frog_HNOffset_left];
		
		if (roiManager->result_FrogScfe_Southwick_right < -999) result_FrogScfe_Southwick_right = @"N/A";
		else result_FrogScfe_Southwick_right = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_FrogScfe_Southwick_right];
		
		if (roiManager->result_FrogScfe_Southwick_left < -999) result_FrogScfe_Southwick_left = @"N/A";
		else result_FrogScfe_Southwick_left = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_FrogScfe_Southwick_left];
		
		if (roiManager->result_FrogScfe_EMOffset_right < -999) result_FrogScfe_EMOffset_right = @"N/A";
		else result_FrogScfe_EMOffset_right = [NSString stringWithFormat:@"%-3.1f mm", roiManager->result_FrogScfe_EMOffset_right*10];
		
		if (roiManager->result_FrogScfe_EMOffset_left < -999) result_FrogScfe_EMOffset_left = @"N/A";
		else result_FrogScfe_EMOffset_left = [NSString stringWithFormat:@"%-3.1f mm", roiManager->result_FrogScfe_EMOffset_left*10];
        
	} else if(op_mode == Alpha) {
        
        if (roiManager->result_Frog_Alpha_right < 0) result_Frog_Alpha_right = @"N/A";
		else result_Frog_Alpha_right = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_Frog_Alpha_right];
		
		if (roiManager->result_Frog_Alpha_left < 0) result_Frog_Alpha_left = @"N/A";
		else result_Frog_Alpha_left = [NSString stringWithFormat:@"%-4.1fº", roiManager->result_Frog_Alpha_left];
		
	}
	
	
	}

- (void)readROIResultsForFile: (int) op_mode : (RoiManager*) roiManager {
	
	if(op_mode == AP) {
		
		if (roiManager->result_LCE_right < -999) result_AP_LCE_right = @"N/A";
		else result_AP_LCE_right = [NSString stringWithFormat:@"%-4.1f", roiManager->result_LCE_right];
		
		if (roiManager->result_LCE_left < -999) result_AP_LCE_left = @"N/A";
		else result_AP_LCE_left = [NSString stringWithFormat:@"%-4.1f", roiManager->result_LCE_left];
		
		if (roiManager->result_Tonnis_right < -999) result_AP_Tonnis_right = @"N/A";
		else result_AP_Tonnis_right = [NSString stringWithFormat:@"%-4.1f", roiManager->result_Tonnis_right];
		
		if (roiManager->result_Tonnis_left < -999) result_AP_Tonnis_left = @"N/A";
		else result_AP_Tonnis_left = [NSString stringWithFormat:@"%-4.1f", roiManager->result_Tonnis_left];
		
		if (roiManager->result_JSW_right < 0) result_AP_JSW_right = @"N/A";
		else result_AP_JSW_right = [NSString stringWithFormat:@"%-3.1f", roiManager->result_JSW_right*10];
		
		if (roiManager->result_JSW_left < 0) result_AP_JSW_left = @"N/A";
		else result_AP_JSW_left = [NSString stringWithFormat:@"%-3.1f", roiManager->result_JSW_left*10];
		
		if (roiManager->result_PelvicTilt < 0) result_AP_PelvicTilt = @"N/A";
		else result_AP_PelvicTilt = [NSString stringWithFormat:@"%-4.1f", roiManager->result_PelvicTilt];
		
		if (roiManager->result_PelvicRot < 0) result_AP_PelvicRot = @"N/A";
		else result_AP_PelvicRot = [NSString stringWithFormat:@"%-4.1f", roiManager->result_PelvicRot*10];
        
        if (roiManager->result_Frog_Alpha_right < 0) result_Frog_Alpha_right = @"N/A";
		else result_Frog_Alpha_right = [NSString stringWithFormat:@"%-4.1f", roiManager->result_Frog_Alpha_right];
		
		if (roiManager->result_Frog_Alpha_left < 0) result_Frog_Alpha_left = @"N/A";
		else result_Frog_Alpha_left = [NSString stringWithFormat:@"%-4.1f", roiManager->result_Frog_Alpha_left];
		
	} else if(op_mode == FP) {
		
		if (roiManager->result_FP_ACE < -999) result_FP_ACE = @"N/A";
		else {		
			if ([mainFilter->popup_FP_Side indexOfSelectedItem] == FP_ACE_LEFT) {
				result_FP_ACE = [NSString stringWithFormat:@"%-4.1f", roiManager->result_FP_ACE];
			} else {
				result_FP_ACE = [NSString stringWithFormat:@"%-4.1f", -roiManager->result_FP_ACE];
			}
		}
		
	} else if(op_mode == Frog || op_mode == FrogScfe) {
		
		if (roiManager->result_Frog_Alpha_right < 0) result_Frog_Alpha_right = @"N/A";
		else result_Frog_Alpha_right = [NSString stringWithFormat:@"%-4.1f", roiManager->result_Frog_Alpha_right];
		
		if (roiManager->result_Frog_Alpha_left < 0) result_Frog_Alpha_left = @"N/A";
		else result_Frog_Alpha_left = [NSString stringWithFormat:@"%-4.1f", roiManager->result_Frog_Alpha_left];
		
		if (roiManager->result_Frog_HNOffset_right < -999) result_Frog_HNOffset_right = @"N/A";
		else result_Frog_HNOffset_right = [NSString stringWithFormat:@"%-3.2f", roiManager->result_Frog_HNOffset_right];
		
		if (roiManager->result_Frog_HNOffset_left < -999) result_Frog_HNOffset_left = @"N/A";
		else result_Frog_HNOffset_left = [NSString stringWithFormat:@"%-3.2f", roiManager->result_Frog_HNOffset_left];
		
		if (roiManager->result_FrogScfe_Southwick_right < -999) result_FrogScfe_Southwick_right = @"N/A";
		else result_FrogScfe_Southwick_right = [NSString stringWithFormat:@"%-4.1f", roiManager->result_FrogScfe_Southwick_right];
		
		if (roiManager->result_FrogScfe_Southwick_left < -999) result_FrogScfe_Southwick_left = @"N/A";
		else result_FrogScfe_Southwick_left = [NSString stringWithFormat:@"%-4.1f", roiManager->result_FrogScfe_Southwick_left];
		
		if (roiManager->result_FrogScfe_EMOffset_right < -999) result_FrogScfe_EMOffset_right = @"N/A";
		else result_FrogScfe_EMOffset_right = [NSString stringWithFormat:@"%-3.1f", roiManager->result_FrogScfe_EMOffset_right*10];
		
		if (roiManager->result_FrogScfe_EMOffset_left < -999) result_FrogScfe_EMOffset_left = @"N/A";
		else result_FrogScfe_EMOffset_left = [NSString stringWithFormat:@"%-3.1f", roiManager->result_FrogScfe_EMOffset_left*10];
        
	} else if(op_mode == Alpha) {
		
        if (roiManager->result_Frog_Alpha_right < 0) result_Frog_Alpha_right = @"N/A";
		else result_Frog_Alpha_right = [NSString stringWithFormat:@"%-4.1f", roiManager->result_Frog_Alpha_right];
		
		if (roiManager->result_Frog_Alpha_left < 0) result_Frog_Alpha_left = @"N/A";
		else result_Frog_Alpha_left = [NSString stringWithFormat:@"%-4.1f", roiManager->result_Frog_Alpha_left];
		
	}
		
}



- (void)displayVisualScoreResults:(int) op_mode{
	

	switch (op_mode) {
		case AP:
			[mainFilter->text_AP_XRayView setStringValue:result_AP_XRayView];
			[mainFilter->text_AP_ShentonLeft setStringValue:result_AP_ShentonLeft];
			[mainFilter->text_AP_ShentonRight setStringValue:result_AP_ShentonRight];
			[mainFilter->text_AP_CrossOverLeft setStringValue:result_AP_CrossOverLeft];
			[mainFilter->text_AP_CrossOverRight setStringValue:result_AP_CrossOverRight];
			[mainFilter->text_AP_PosteriorWallLeft setStringValue:result_AP_PosteriorWallLeft];
			[mainFilter->text_AP_PosteriorWallRight setStringValue:result_AP_PosteriorWallRight];
			[mainFilter->text_AP_TonnisLeft setStringValue:result_AP_TonnisLeft];
			[mainFilter->text_AP_TonnisRight setStringValue:result_AP_TonnisRight];
			break;

		default:
			break;
	}
}

- (void)displayROIResults:(int) op_mode {
	
	
	switch (op_mode) {
		case AP:
			[mainFilter->text_AP_LCERight setStringValue:result_AP_LCE_right];
			[mainFilter->text_AP_LCELeft setStringValue:result_AP_LCE_left];
			
			[mainFilter->text_AP_TonnisAngleRight setStringValue:result_AP_Tonnis_right];
			[mainFilter->text_AP_TonnisAngleLeft setStringValue:result_AP_Tonnis_left];
			
			[mainFilter->text_AP_JSWRight setStringValue:result_AP_JSW_right];
			[mainFilter->text_AP_JSWLeft setStringValue:result_AP_JSW_left];
			
			[mainFilter->text_AP_PelvicTilt setStringValue:result_AP_PelvicTilt];
			[mainFilter->text_AP_PelvicRot setStringValue:result_AP_PelvicRot];
            
            [mainFilter->text_AP_AlphaRight setStringValue:result_Frog_Alpha_right];
			[mainFilter->text_AP_AlphaLeft setStringValue:result_Frog_Alpha_left];
			break;			
		case FP:			
			[mainFilter->text_FP_ACE setStringValue:result_FP_ACE];
			break;
		case Frog:
		case FrogScfe:
			[mainFilter->text_Frog_AlphaRight setStringValue:result_Frog_Alpha_right];
			[mainFilter->text_Frog_AlphaLeft setStringValue:result_Frog_Alpha_left];
			
			[mainFilter->text_Frog_HNOffsetRight setStringValue:result_Frog_HNOffset_right];
			[mainFilter->text_Frog_HNOffsetLeft setStringValue:result_Frog_HNOffset_left];
			
			[mainFilter->text_FrogScfe_SouthwickRight setStringValue:result_FrogScfe_Southwick_right];
			[mainFilter->text_FrogSfce_SouthwickLeft setStringValue:result_FrogScfe_Southwick_left];
			
			[mainFilter->text_FrogScfe_EMOffsetRight setStringValue:result_FrogScfe_EMOffset_right];
			[mainFilter->text_FrogScfe_EMOffsetLeft setStringValue:result_FrogScfe_EMOffset_left];
			break;
        case Alpha:
			[mainFilter->text_Alpha_AlphaRight setStringValue:result_Frog_Alpha_right];
			[mainFilter->text_Alpha_AlphaLeft setStringValue:result_Frog_Alpha_left];
			break;   
		default:
			break;
	}
	

}


- (void)displaySaveFile: (NSString*) filename : (int) op_mode {
	
	switch (op_mode) {
		case AP:
			[mainFilter->text_AP_SaveFile setStringValue:filename];
			break;
		case VonRosen:
			[mainFilter->text_VR_SaveFile setStringValue:filename];
			break;
		case FP:
			[mainFilter->text_FP_SaveFile setStringValue:filename];
			break;
		case Frog:
		case FrogScfe:	
			[mainFilter->text_Frog_SaveFile setStringValue:filename];
			break;
        case Alpha:
			[mainFilter->text_Alpha_SaveFile setStringValue:filename];
			break;    
		default:
			break;
	}
	
}


- (BOOL)saveResults: (NSString*) filename : (NSString*) separator : (NSString*) decimalSep : (int) opMode : (ViewerController*) viewerController : (RoiManager*) roiManager {

	@try {
		
	
	NSString			*dcm_file;
	DCMObject			*dcmObj=nil;
	NSString			*pat_id;
	NSString			*pat_date;
	
	dcm_file = [[[[viewerController imageView] dcmPixList] objectAtIndex: [[viewerController imageView] curImage]] sourceFile];
	
	if( dcm_file && [DicomFile isDICOMFile:dcm_file])
	{
		dcmObj = [[DCMObject alloc] initWithContentsOfFile:dcm_file decodingPixelData:NO];
		pat_id = [[dcmObj attributeArrayWithName:@"PatientID"] componentsJoinedByString:@""];
		pat_date = [[dcmObj attributeArrayWithName:@"StudyDate"] componentsJoinedByString:@""];
		[dcmObj release];
	}
	else
	{
		pat_id = @"unknown";
		pat_date = @"unknown";
	}
	
		
	// get a string representing the current time
	NSDate* nowTime = [[NSDate alloc] init];
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSString* eval_time = [dateFormatter stringFromDate:nowTime];	
	
	//NSRunInformationalAlertPanel(eval_time, @"" , @"OK", 0L, 0L);
	
	int i;
	
	NSMutableString *file;
	NSMutableString *prev_last_line_string;
	NSMutableString *new_last_line_string;
	
	NSMutableArray *file_array;
	NSMutableArray *prev_last_line_array = NULL;
	NSMutableArray *new_last_line_array;	
	//NSMutableArray *comp_array = NULL;
	//NSMutableString	*comp_array_string;
	//NSMutableArray *prev_save_array = NULL;
	BOOL	isAlreadySaved = NO;
	
	NSError *file_error;
	NSStringEncoding file_enc;
	NSRange range;
	
	//int opModeDate[4] = {APDate, VonRosenDate, FPDate, FrogDate};
	
	NSArray *title_array = [NSArray arrayWithObjects:@"Evaluation date", @"Patient ID", @"Study date", @"Type", @"AP view",
							@"Break in Shenton R", @"Break in Shenton L", @"Cross-over R",
							@"Cross-over L", @"Posterior wall R", @"Posterior wall L",
							@"Tonnis grade R", @"Tonnis grade L", @"LCE R",
							@"LCE L", @"Tonnis R", @"Tonnis L",
							@"JSW R (mm)", @"JSW L (mm)", @"Pelvic Tilt (cm)",
							@"Pelvic Rotation (mm)", @"Congruity R (0=excellent 1=good 2=fair 3=poor)",
							@"Congruity L", @"FP side", @"ACE", 
							@"Alpha angle R", @"Alpha angle L", 
							@"Head-Neck offset ratio R", @"Head-Neck offset ratio L", 
							@"Southwick angle R", @"Southwick angle L",
							@"Epiphysis-metaphyseal offset R (mm)", @"Epiphysis-metaphyseal offset L (mm)", nil];
							

	//NSRunInformationalAlertPanel(@"1", @"" , @"OK", 0L, 0L);
    //read from the file
	if((file = [NSMutableString stringWithContentsOfFile:filename usedEncoding:&file_enc error:&file_error]) == nil) {

		if([file_error code] == NSFileReadNoSuchFileError || [file_error code] == NSFileNoSuchFileError) {
			// ok, create new file
			file_array = [NSMutableArray arrayWithCapacity:1];
			[file_array addObject:[title_array componentsJoinedByString:separator]];
			
		} else {
			// error opening file
			[self displayAlert : @"An error occured with the file! Close all other programs currently accessing the datafile and try again. Or try saving with another filename."];
			return(NO);
		}
    } else {
		// file is opened and everything is fine
		
		// if file has been modified by other programs its newlinecharachters might have been changed. Is so, change it back.
		[file replaceOccurrencesOfString:@"\r" withString:@"\n" options:NSLiteralSearch range: NSMakeRange(0, [file length])];
		[file replaceOccurrencesOfString:@"\n\n" withString:@"\n" options:NSLiteralSearch range: NSMakeRange(0, [file length])];
		
		file_array = (NSMutableArray*)[file componentsSeparatedByString:@"\n"];
	}
	
	//NSRunInformationalAlertPanel(@"2", @"" , @"OK", 0L, 0L);
	
	if((prev_last_line_string = (NSMutableString*)[file_array lastObject]) != nil) {
	
		prev_last_line_array = (NSMutableArray*)[prev_last_line_string componentsSeparatedByString:separator];

		//NSLog(@"count: %d, saved fields: %d", [prev_last_line_array count], NbrOfSavedFields);
		
		if([prev_last_line_array count] != NbrOfSavedFields) {
			prev_last_line_array = NULL;
		}	

	} else prev_last_line_array = NULL;
		
	if (prev_last_line_array == NULL) {
		// wrong format
		[self displayAlert: @"The file you have choosen is not formatted as Orthopaedic Studio is expecting it to be. Try saving to another file."];
		return(NO);
	}	
		
	new_last_line_array = [[NSMutableArray alloc] initWithCapacity:NbrOfSavedFields];
	[new_last_line_array autorelease];

	for(i = 0; i<NbrOfSavedFields; i++) {
		[new_last_line_array addObject:@""];
	}
	
	[self readVisualScoreResults:opMode];
	[self readROIResultsForFile:opMode: roiManager];
		
	switch (opMode) {
		case AP:
			
			[new_last_line_array replaceObjectAtIndex:EvaluationTime withObject:eval_time];
			[new_last_line_array replaceObjectAtIndex:PatID withObject:pat_id];
			[new_last_line_array replaceObjectAtIndex:Date withObject:pat_date];
			[new_last_line_array replaceObjectAtIndex:Type withObject:@"AP"];
			
			[new_last_line_array replaceObjectAtIndex:APView withObject:result_AP_XRayView];
			[new_last_line_array replaceObjectAtIndex:ShentonR withObject:result_AP_ShentonRight];
			[new_last_line_array replaceObjectAtIndex:ShentonL withObject:result_AP_ShentonLeft];
			[new_last_line_array replaceObjectAtIndex:CrossOverR withObject:result_AP_CrossOverRight];
			[new_last_line_array replaceObjectAtIndex:CrossOverL withObject:result_AP_CrossOverLeft];
			[new_last_line_array replaceObjectAtIndex:PostWallR withObject:result_AP_PosteriorWallRight];
			[new_last_line_array replaceObjectAtIndex:PostWallL withObject:result_AP_PosteriorWallLeft];
			[new_last_line_array replaceObjectAtIndex:TonnisGradeR withObject:result_AP_TonnisRight];
			[new_last_line_array replaceObjectAtIndex:TonnisGradeL withObject:result_AP_TonnisLeft];
			
			[new_last_line_array replaceObjectAtIndex:LCER withObject:result_AP_LCE_right];
			[new_last_line_array replaceObjectAtIndex:LCEL withObject:result_AP_LCE_left];
			[new_last_line_array replaceObjectAtIndex:TonnisR withObject:result_AP_Tonnis_right];
			[new_last_line_array replaceObjectAtIndex:TonnisL withObject:result_AP_Tonnis_left];
			[new_last_line_array replaceObjectAtIndex:JSWR withObject:result_AP_JSW_right];
			[new_last_line_array replaceObjectAtIndex:JSWL withObject:result_AP_JSW_left];
			[new_last_line_array replaceObjectAtIndex:PelvTilt withObject:result_AP_PelvicTilt];
			[new_last_line_array replaceObjectAtIndex:PelvRot withObject:result_AP_PelvicRot];

            [new_last_line_array replaceObjectAtIndex:AlphaR withObject:result_Frog_Alpha_right];
			[new_last_line_array replaceObjectAtIndex:AlphaL withObject:result_Frog_Alpha_left];
            
			break;
			
		case VonRosen:
			
			[new_last_line_array replaceObjectAtIndex:EvaluationTime withObject:eval_time];
			[new_last_line_array replaceObjectAtIndex:PatID withObject:pat_id];
			[new_last_line_array replaceObjectAtIndex:Date withObject:pat_date];
			[new_last_line_array replaceObjectAtIndex:Type withObject:@"Von Rosen"];
			
			[new_last_line_array replaceObjectAtIndex:CongruityR withObject:result_VR_JointConRight];
			[new_last_line_array replaceObjectAtIndex:CongruityL withObject:result_VR_JointConLeft];
			
			break;
			
		case FP:
			
			[new_last_line_array replaceObjectAtIndex:EvaluationTime withObject:eval_time];
			[new_last_line_array replaceObjectAtIndex:PatID withObject:pat_id];
			[new_last_line_array replaceObjectAtIndex:Date withObject:pat_date];
			[new_last_line_array replaceObjectAtIndex:Type withObject:@"False Profile"];
			
			// a complicated way to extract the words "left" or "right"
			[new_last_line_array replaceObjectAtIndex:FPSide withObject:[[[mainFilter->popup_FP_Side titleOfSelectedItem] componentsSeparatedByString:@" "] objectAtIndex:0]];
			[new_last_line_array replaceObjectAtIndex:ACE withObject:result_FP_ACE];
						
			break;
		
		case Frog:
			
			[new_last_line_array replaceObjectAtIndex:EvaluationTime withObject:eval_time];
			[new_last_line_array replaceObjectAtIndex:PatID withObject:pat_id];
			[new_last_line_array replaceObjectAtIndex:Date withObject:pat_date];
			[new_last_line_array replaceObjectAtIndex:Type withObject:@"Frog"];
			
			[new_last_line_array replaceObjectAtIndex:AlphaR withObject:result_Frog_Alpha_right];
			[new_last_line_array replaceObjectAtIndex:AlphaL withObject:result_Frog_Alpha_left];
			
			[new_last_line_array replaceObjectAtIndex:HNoffsetR withObject:result_Frog_HNOffset_right];
			[new_last_line_array replaceObjectAtIndex:HNoffsetL withObject:result_Frog_HNOffset_left];

			break;
			
		case FrogScfe:
			
			[new_last_line_array replaceObjectAtIndex:EvaluationTime withObject:eval_time];
			[new_last_line_array replaceObjectAtIndex:PatID withObject:pat_id];
			[new_last_line_array replaceObjectAtIndex:Date withObject:pat_date];
			[new_last_line_array replaceObjectAtIndex:Type withObject:@"Frog SCFE"];
			
			[new_last_line_array replaceObjectAtIndex:AlphaR withObject:result_Frog_Alpha_right];
			[new_last_line_array replaceObjectAtIndex:AlphaL withObject:result_Frog_Alpha_left];
			
			[new_last_line_array replaceObjectAtIndex:SouthwickR withObject:result_FrogScfe_Southwick_right];
			[new_last_line_array replaceObjectAtIndex:SouthwickL withObject:result_FrogScfe_Southwick_left];
			
			[new_last_line_array replaceObjectAtIndex:EMoffsetR withObject:result_FrogScfe_EMOffset_right];
			[new_last_line_array replaceObjectAtIndex:EMoffsetL withObject:result_FrogScfe_EMOffset_left];
			
			break;
            
		case Alpha:
			
			[new_last_line_array replaceObjectAtIndex:EvaluationTime withObject:eval_time];
			[new_last_line_array replaceObjectAtIndex:PatID withObject:pat_id];
			[new_last_line_array replaceObjectAtIndex:Date withObject:pat_date];
			[new_last_line_array replaceObjectAtIndex:Type withObject:@"Alpha angle"];
			
            [new_last_line_array replaceObjectAtIndex:AlphaR withObject:result_Frog_Alpha_right];
			[new_last_line_array replaceObjectAtIndex:AlphaL withObject:result_Frog_Alpha_left];	
            
		default:
			break;
			
	}
	
	// create string without evaluation date	
	range.location = PatID;
	range.length = NbrOfSavedFields -1;	
	new_last_line_string = (NSMutableString*)[[new_last_line_array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]] componentsJoinedByString:separator];
		
	// change to localized decimal separator if required
	if([decimalSep isEqualToString:@"."] == NO) {
		[new_last_line_string replaceOccurrencesOfString:@"." withString:decimalSep options:NSLiteralSearch range: NSMakeRange(0, [new_last_line_string length])];
	}	
		
	// strings are checked without the evluation time, since that will always be different for two successive click on the save button	
	isAlreadySaved = [new_last_line_string isEqualToString:[[prev_last_line_array objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]] componentsJoinedByString:separator]];

	
	if(isAlreadySaved == YES) {
		[self displayAlert: @"Data has already been saved."];
	} else {

		// append evaluation time to the string. Note that dots have not been changed to commas in evaluation time strings.
		range.location = EvaluationTime;
		range.length = 1;
		new_last_line_string =  (NSMutableString*)[[(NSString*)[new_last_line_array objectAtIndex:EvaluationTime] stringByAppendingString:separator] stringByAppendingString:new_last_line_string];
		
		[file_array addObject:new_last_line_string];
		file = (NSMutableString*)[file_array componentsJoinedByString:@"\n"];

		//write to file
		if([file writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:&file_error] == NO) {
			[self displayAlert : @"An error occured while saving the data! Close all other programs currently accessing the datafile and try again. Or try saving with another filename."];
			return(NO);
		}		
		//last_opmode_saving = opMode;
	}

		
	} @catch (NSException* e) { 
		NSLog(@"Orthopaedic Studio exception caught: %@", [e reason]);
		[self displayAlert : @"There was an exeption error and the data has probably not been saved. Close all other programs accessing the file, then try again."];
		return(NO);
	}
	
	return(YES);
}


@end
