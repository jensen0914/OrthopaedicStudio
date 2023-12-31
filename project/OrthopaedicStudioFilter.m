//
//  OrthopaedicStudioFilter.m
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

#import "AppControllerMenu.h"
#import "OrthopaedicStudioFilter.h"
#import <OsiriXAPI/Notifications.h>
#import "RoiManager.h"
#import "ResultsManager.h"


ResultsManager *resultsManager;
RoiManager *roiManager;


@implementation OrthopaedicStudioFilter

- (NSInteger) displayAlert : (NSString*) alertStr : (NSString*) choice1Str : (NSString*) choice2Str : (NSString*) choice3Str {

	NSAlert* alert = [ [ NSAlert alloc ] init ];
	[ alert addButtonWithTitle : choice1Str ];
	[ alert addButtonWithTitle : choice2Str ];
	if ( choice3Str != nil )
	{
		[ alert addButtonWithTitle : choice3Str ];
	}
	[ alert setMessageText : @"Orthopaedic Studio"];
	[ alert setInformativeText : alertStr ];
	[ alert setAlertStyle : NSAlertStyleInformational ];
	[ alert setShowsSuppressionButton : NO ];
	NSInteger choice = [ alert runModal ];
	[ alert release ];
	return choice;
}

- (long) filterImage:(NSString*) menuName {
	
	int newOpMode;
	int curr_step;
	int frog_mode;
	
	// wait for nib to be loaded if first time starting
	if (filterImageIsCalledFlag == NO) {
		filterImageIsCalledFlag = YES;
		
		callFilterImageWhenNibIsLoadedFlag = YES;
		callFilterImageWhenNibIsLoadedString = menuName;
		[callFilterImageWhenNibIsLoadedString retain];
		
		[NSBundle loadNibNamed:@"MainMenu" owner:self];	
				
		return 0;
	}
	
	if([menuName rangeOfString:@"Anteroposterior"].location != NSNotFound) {
		newOpMode = AP;
	} else if([menuName rangeOfString:@"Von Rosen"].location != NSNotFound) { 
		newOpMode = VonRosen;
	} else if([menuName rangeOfString:@"False Profile"].location != NSNotFound) {
		newOpMode = FP;
	} else if([menuName rangeOfString:@"Frog"].location != NSNotFound) {
		newOpMode = Frog;
    } else if([menuName rangeOfString:@"Alpha angle"].location != NSNotFound) {
		newOpMode = Alpha;
	} else {
		return 0;
	}

	
	if (Curr_Visible_Window != NoWindow && (newOpMode == Op_Mode || (newOpMode == Frog && Op_Mode == FrogScfe))) {
		// if same op mode as we are in, then do nothing. Exit function.
		// A fix is applied above to handle Frog SCFE mode.
		return 0;
	}
	
	// start by closing old windows
	if (Curr_Visible_Window != NoWindow) {
		
		switch (Curr_Visible_Window) {
			case AP_1:
				[window1 performClose:self];
				break;
			case AP_2:
				[window2 performClose:self];
				break;
			case AP_3:
				[window3 performClose:self];
				break;
			case VonRosen_1:
				[vonRosenWindow performClose:self];
				break;
			case FP_1:
				[falseProfileWindow1 performClose:self];
				break;
			case FP_2:
				[falseProfileWindow2 performClose:self];
				break;
			case Frog_0:
				[frogWindow0 performClose:self];	
				break;
			case Frog_1:
				[frogWindow1 performClose:self];
				break;
			case Frog_2:
				[frogWindow2 performClose:self];
				break;
            case Alpha_1:
				[alphaWindow1 performClose:self];
				break;
			case Alpha_2:
				[alphaWindow2 performClose:self];
				break;    
		}		
		
	} 
	
	// if first time starting then show disclaimer
	if(Op_Mode == NoInit) {
		NSInteger choice = [self displayAlert :
							[NSString stringWithFormat:@"%@%@", TEXT_REG_DISCLAIMER1, TEXT_REG_DISCLAIMER2] :
							@"Stop" :
							@"Continue" :
							nil];
		if (choice == NSAlertFirstButtonReturn) {
			[self closePlugin];
			return 0;
		}
	}	
	
	Op_Mode = newOpMode;	
	

	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiAdded:) name:OsirixAddROINotification object:NULL];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiChanged:) name:OsirixROIChangeNotification object:NULL];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewerChanged:) name:OsirixDCMViewIndexChangedNotification object:NULL];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUpdated:) name:OsirixDCMUpdateCurrentImageNotification object:NULL];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeViewer:) name:OsirixCloseViewerNotification object:NULL];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiWillBeDeleted:) name:OsirixRemoveROINotification object:NULL];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiIsDeleted:) name:OsirixROIRemovedFromArrayNotification object:NULL];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewerChanged:) name:OsirixViewerWillChangeNotification object:NULL];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification5:) name:OsirixUpdateViewNotification object:NULL];
	
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roiSelected:) name:OsirixROISelectedNotification object:NULL];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mouseClicked:) name:OsirixMouseDownNotification object:NULL];
	
	[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey: @"ROITEXTIFSELECTED"];
	[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey: @"ROITEXTNAMEONLY"];
	
	//[NSBundle loadNibNamed:@"MainMenu" owner:self];	
	//[NSApp beginSheet: window modalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:nil contextInfo:nil];
	
	// set roi type to point
	for (ViewerController* viewer in [ViewerController getDisplayed2DViewers]) @try {
		[viewer setROIToolTag:[[NSNumber numberWithLong:t2DPoint] longValue]];
	} @catch (NSException* e) { // a fix since version 3.7b8++ solves this exception, but we want to be retro-compatible
	}
		
	curr_Visible_Image = [[viewerController imageView] curImage];	
	Viewer_Changed_Notification_Received = NO;
	
	resultsManager = [ResultsManager alloc];
	[resultsManager initWithMainFilter:self];
	
	roiManager = [RoiManager alloc];
	[roiManager initClean];
	
	if(Curr_Save_File == NULL) [resultsManager displaySaveFile:@"(no file)":Op_Mode];
	else [resultsManager displaySaveFile:[Curr_Save_File lastPathComponent]:Op_Mode];
	
	switch (Op_Mode) {
		case AP:
						
			Curr_Visible_Window = AP_1;
			[window1 makeKeyAndOrderFront:self];
				
			curr_step = [roiManager loadFromExistingPoints:Op_Mode:viewerController];
			[roiManager setStep:curr_step: Op_Mode];
			//[roiManager displayROIInstructions:curr_step:Op_Mode:self];
					
			break;
			
		case VonRosen:
			Curr_Visible_Window = VonRosen_1;
			[vonRosenWindow makeKeyAndOrderFront:self];
					
			break;
			
		case FP:
			Curr_Visible_Window = FP_1;
						
			curr_step = [roiManager loadFromExistingPoints:Op_Mode:viewerController];
			//curr_step = 1;
			[roiManager setStep:curr_step: Op_Mode];
			[roiManager displayROIInstructions:curr_step:Op_Mode:self];
			
			[falseProfileWindow1 makeKeyAndOrderFront:self];
			break;
			
		case Frog:
			
			frog_mode = [roiManager checkOpModeFromExistingPoints:viewerController];
			if(frog_mode == FrogScfe) {
				curr_step = [roiManager loadFromExistingPoints:frog_mode:viewerController];	
			} else {
				curr_step = [roiManager loadFromExistingPoints:Op_Mode:viewerController];
				frog_mode = Op_Mode;
			}
			
			if(curr_step>1) {
				// if we are on step two or higher then jump directly to second frog window
				Op_Mode = frog_mode;
				[roiManager setStep:curr_step: Op_Mode];
				[roiManager displayROIInstructions:curr_step:Op_Mode:self];	

				Curr_Visible_Window = Frog_1;
				[frogWindow1 makeKeyAndOrderFront:self];				
				
			} else {
				// let user choose frog type
				Curr_Visible_Window = Frog_0;
				[frogWindow0 makeKeyAndOrderFront:self];
			}				
			break;
			
        case Alpha:
			Curr_Visible_Window = Alpha_1;
            
			curr_step = [roiManager loadFromExistingPoints:Op_Mode:viewerController];
			//curr_step = 1;
			[roiManager setStep:curr_step: Op_Mode];
			[roiManager displayROIInstructions:curr_step:Op_Mode:self];
			
			[alphaWindow1 makeKeyAndOrderFront:self];
			break;   
            
		default:
			break;
	}
	
	[viewerController needsDisplayUpdate];
	[roiManager updateCalculatedRois:viewerController];
		
	
	return 0;
}



- (void)awakeFromNib
{
	//NSLog(@"ortho awakeFromNib");

	if(callFilterImageWhenNibIsLoadedFlag == YES) {
		//NSLog(@"ortho callFilterImageWhenNibIsLoadedFlag == YES");
		callFilterImageWhenNibIsLoadedFlag = NO;
		[callFilterImageWhenNibIsLoadedString autorelease];
		[self filterImage:callFilterImageWhenNibIsLoadedString];		
	}
}



- (void) initPlugin {

	Curr_Visible_Window = NoWindow;
	Curr_Save_File = NULL;
	Op_Mode = NoInit;
	
	blankMenuItem = NULL;
	
	setMenuIsCalledFlag = NO;
	filterImageIsCalledFlag = NO;
	callFilterImageWhenNibIsLoadedFlag = NO;
}


- (void) closePlugin{

	// if new op mode, then start by closing old windows
	if (Curr_Visible_Window != NoWindow) {
		
		switch (Curr_Visible_Window) {
			case AP_1:
				[window1 performClose:self];
				break;
			case AP_2:
				[window2 performClose:self];
				break;
			case AP_3:
				[window3 performClose:self];
				break;
			case VonRosen_1:
				[vonRosenWindow performClose:self];
				break;
			case FP_1:
				[falseProfileWindow1 performClose:self];
				break;
			case FP_2:
				[falseProfileWindow2 performClose:self];
				break;
			case Frog_0:
				[frogWindow0 performClose:self];	
			case Frog_1:
				[frogWindow1 performClose:self];
				break;
			case Frog_2:
				[frogWindow2 performClose:self];
				break;
            case Alpha_1:
				[alphaWindow1 performClose:self];
				break;
			case Alpha_2:
				[alphaWindow2 performClose:self];
				break;    
		}
	} 
	
	Op_Mode = NoInit;
}


-(void)dealloc {
	
	[blankMenuItem release];
	
	[roiManager release];
	[resultsManager release];
	
	if(Curr_Save_File != NULL) {
		[Curr_Save_File release];
	}
	
	[super dealloc];
}


- (void) setMenus
{
	AppController *appController = 0L;
	NSMenuItem *orthoStudioMenu = 0L;
	
	NSMenuItem *apMenuItem = 0L;
	NSMenuItem *vonRosenMenuItem = 0L;
	NSMenuItem *falseProfileMenuItem = 0L;
	NSMenuItem *frogMenuItem = 0L;
    NSMenuItem *alphaMenuItem = 0L;
    
    NSMenuItem *comboMeasTitleMenuItem = 0L;
    NSMenuItem *singleMeasTitleMenuItem = 0L;
	
	if(setMenuIsCalledFlag == NO) {
		setMenuIsCalledFlag = YES;
		appController = [AppController sharedAppController];
		
		// alternative way to access menus
		//[[[[[[[[NSApplication sharedApplication] mainMenu] itemWithTitle:@"File"] submenu] itemWithTitle:@"Export"] submenu] itemWithTitle:@"Export to Quicktime"] setKeyEquivalent:@""];
		
		orthoStudioMenu = [[appController roisMenu] itemWithTitle:@"Orthopaedic Studio"];
		if (orthoStudioMenu && [orthoStudioMenu hasSubmenu])
		{
			NSMenu *orthoStudioSubMenu = 0L;
			orthoStudioSubMenu = [orthoStudioMenu submenu];
            
            // adding header for combination measurments
            comboMeasTitleMenuItem = [[NSMenuItem alloc] init];
          //  [multiMeasTitleMenuItem setAttributedTitle:multiMeasTitleString];
            [comboMeasTitleMenuItem setTitle:@"Image specific measurements"];
            [comboMeasTitleMenuItem setEnabled:NO];
            [orthoStudioSubMenu insertItem: comboMeasTitleMenuItem atIndex:0];
                   
            // adding divider
            [orthoStudioSubMenu insertItem:[NSMenuItem separatorItem] atIndex:5];
            
            // adding header for single measurments
            singleMeasTitleMenuItem = [[NSMenuItem alloc] init];
            //  [multiMeasTitleMenuItem setAttributedTitle:multiMeasTitleString];
            [singleMeasTitleMenuItem setTitle:@"General measurements"];
            [singleMeasTitleMenuItem setEnabled:NO];
            [orthoStudioSubMenu insertItem: singleMeasTitleMenuItem atIndex:6];
            
            
			apMenuItem = [orthoStudioSubMenu itemWithTitle:@"Anteroposterior"];
			vonRosenMenuItem = [orthoStudioSubMenu itemWithTitle:@"Von Rosen"];
			falseProfileMenuItem = [orthoStudioSubMenu itemWithTitle:@"False Profile"];
			frogMenuItem = [orthoStudioSubMenu itemWithTitle:@"Frog"];
			alphaMenuItem = [orthoStudioSubMenu itemWithTitle:@"Alpha angle"];
            
			//blankMenuItem = [orthoStudioSubMenu itemWithTitle:@" "];
            blankMenuItem = [NSMenuItem separatorItem];
            [orthoStudioSubMenu insertItem:blankMenuItem atIndex:8];
			
			[blankMenuItem retain];
			
            // increase indentation for items
            [apMenuItem setIndentationLevel:1];
            [vonRosenMenuItem setIndentationLevel:1];
            [falseProfileMenuItem setIndentationLevel:1];
            [frogMenuItem setIndentationLevel:1];
            [alphaMenuItem setIndentationLevel:1];
            
			
          //  [multiMeasTitleMenuItem setEnabled:NO];
            
			[apMenuItem setKeyEquivalent:@"a"];
			[apMenuItem setKeyEquivalentModifierMask:NSEventModifierFlagShift | NSEventModifierFlagControl];
			
			[vonRosenMenuItem setKeyEquivalent:@"v"];
			[vonRosenMenuItem setKeyEquivalentModifierMask:NSEventModifierFlagShift | NSEventModifierFlagControl];
			
			[falseProfileMenuItem setKeyEquivalent:@"p"];
			[falseProfileMenuItem setKeyEquivalentModifierMask:NSEventModifierFlagShift | NSEventModifierFlagControl];
			
			[frogMenuItem setKeyEquivalent:@"f"];
			[frogMenuItem setKeyEquivalentModifierMask:NSEventModifierFlagShift | NSEventModifierFlagControl];
            
            [alphaMenuItem setKeyEquivalent:@"l"];
			[alphaMenuItem setKeyEquivalentModifierMask:NSEventModifierFlagShift | NSEventModifierFlagControl];
			
			// remove register menu if already registered
			[blankMenuItem setHidden:YES];
		}
	}
}


- (BOOL)windowShouldClose:(NSWindow *)sender {
	//this function is connected though delegates to each window, which are made using interface builder.
	//NSRunInformationalAlertPanel(@"windowShouldClose", @" " , @"OK", 0L, 0L);
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OsirixAddROINotification object:NULL];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OsirixROIChangeNotification object:NULL];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OsirixDCMUpdateCurrentImageNotification object:NULL];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OsirixCloseViewerNotification object:NULL];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OsirixRemoveROINotification object:NULL];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OsirixViewerWillChangeNotification object:NULL];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OsirixROIRemovedFromArrayNotification object:NULL];
	
	
	[roiManager release];
	[resultsManager release];
	
	Curr_Visible_Window = NoWindow;
	
	return YES;
	
}


-(void)closeViewer:(NSNotification*)notification {
	
	ViewerController	*v = [notification object];
	
	if(Viewer_Changed_Notification_Received == YES) {
		Viewer_Changed_Notification_Received = NO;
	
	} else if (v == viewerController) {
		//NSRunInformationalAlertPanel(@"OsirixCloseViewerNotification", @" " , @"OK", 0L, 0L);
		
		[roiManager initClean];
		[roiManager displayROIInstructions:1:Op_Mode:self];		
	
		[resultsManager readROIResults:Op_Mode:roiManager:NO];
		[resultsManager displayROIResults:Op_Mode];
		
		viewerController = NULL;
	}
}

-(void)roiIsDeleted:(NSNotification*)notification {
	
	//NSLog(@"roiIsDeleted:");
		
	[roiManager updateCalculatedRois:viewerController];
	[resultsManager readROIResults:Op_Mode:roiManager:NO];
	[resultsManager displayROIResults:Op_Mode];
	
}

-(void)roiWillBeDeleted:(NSNotification*)notification {

	// This notofication is strange, since there seem to be a bug in OsiriX that sometimes causes all ROIs to be "imaginary" removed
	// every time a roi is clicked. That is, this function is called but no rois are actually removed and the pointer that is passed 
	// this function does not refer to an actual roi
	
	//NSLog(@"roiWillBeDeleted: %@", [[notification object] name]);
	
	NSRect frame;
	
	if([roiManager isThisThePrefsRoi:[notification object]] == YES) {
		//NSLog(@"isThisThePrefsRoi = YES");
			//CS kan denna vara bortkommenterad?
			//[roiManager restart: viewerController:NO];
			[roiManager initClean];
			[roiManager displayROIInstructions:1:Op_Mode:self];
	
			// if frog, display first window
			if((Op_Mode == Frog || Op_Mode == FrogScfe) && Curr_Visible_Window == Frog_1) {
		
				frame = [frogWindow1 frame];
				frame.origin.y = frame.origin.y+frame.size.height;
		
				[frogWindow0 setFrameTopLeftPoint:frame.origin];
				[frogWindow0 makeKeyAndOrderFront:self];
		
				[frogWindow1 orderOut:self];
				Curr_Visible_Window = Frog_0;			
			}
	} else { 
		[roiManager isRoiOneOfOurs:[notification object]:YES];				
	}
}



-(void)viewerChanged:(NSNotification*)notification {
	ViewerController	*v = [notification object];	
	Viewer_Changed_Notification_Received = YES;
	
	if (viewerController != v) {
		// set to point roi type. Should check the other windows, but I cant figure out how to do that
		@try {	
			[v setROIToolTag:[[NSNumber numberWithLong:t2DPoint] longValue]];
		} @catch (NSException* e) { // a fix since version 3.7b8++ solves this exception, but we want to be retro-compatible
		}
	}
}




- (IBAction)buttonNextWindow:(id)sender {
	
	NSRect frame;
	
	switch (Curr_Visible_Window) {
		case AP_1:	
			frame = [window1 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
						
			[roiManager displayROIInstructions:[roiManager getStep]:Op_Mode:self];
			
			[window2 setFrameTopLeftPoint:frame.origin];
			[window2 makeKeyAndOrderFront:self];
			
			[window1 orderOut:self];
			//[window3 orderOut:self];
			
			// set roi type to point
			for (ViewerController* viewer in [ViewerController getDisplayed2DViewers]) @try {
				[viewer setROIToolTag:[[NSNumber numberWithLong:t2DPoint] longValue]];
			} @catch (NSException* e) { // a fix since version 3.7b8++ solves this exception, but we want to be retro-compatible
			}
									
			Curr_Visible_Window = AP_2; 			
			
			break;
			
		case AP_2:
			
			[roiManager makeLastAddedRoiTextualInfoVisible];
			
			[resultsManager readVisualScoreResults:Op_Mode];
			[resultsManager displayVisualScoreResults:Op_Mode];
			
			[resultsManager readROIResults:Op_Mode:roiManager:NO];
			[resultsManager displayROIResults:Op_Mode];
			
			frame = [window2 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
			[window3 setFrameTopLeftPoint:frame.origin];
			[window3 makeKeyAndOrderFront:self];
			
			//[window1 orderOut:self];
			[window2 orderOut:self];
			Curr_Visible_Window = AP_3; 
			
			break;
				
		case FP_1:	
			[roiManager makeLastAddedRoiTextualInfoVisible];
			
			[resultsManager readROIResults:Op_Mode:roiManager:YES];
			[resultsManager displayROIResults:Op_Mode];
			
			frame = [falseProfileWindow1 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
					
			[falseProfileWindow2 setFrameTopLeftPoint:frame.origin];
			[falseProfileWindow2 makeKeyAndOrderFront:self];
			
			[falseProfileWindow1 orderOut:self];
			
			Curr_Visible_Window = FP_2; 			
			
			break;
			
		case Frog_1:	
			[roiManager makeLastAddedRoiTextualInfoVisible];
			
			[resultsManager readROIResults:Op_Mode:roiManager:NO];
			[resultsManager displayROIResults:Op_Mode];
			
			frame = [frogWindow1 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
			
			[frogWindow2 setFrameTopLeftPoint:frame.origin];
			[frogWindow2 makeKeyAndOrderFront:self];
			
			[frogWindow1 orderOut:self];
			
			Curr_Visible_Window = Frog_2; 			
			
			break;
            
        case Alpha_1:	
			[roiManager makeLastAddedRoiTextualInfoVisible];
			
			[resultsManager readROIResults:Op_Mode:roiManager:YES];
			[resultsManager displayROIResults:Op_Mode];
			
			frame = [alphaWindow1 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
            
			[alphaWindow2 setFrameTopLeftPoint:frame.origin];
			[alphaWindow2 makeKeyAndOrderFront:self];
			
			[alphaWindow1 orderOut:self];
			
			Curr_Visible_Window = Alpha_2; 			
			
			break;    
			
		default:
			break;
	}
}

- (IBAction)buttonPrevWindow:(id)sender {
	
	NSRect frame;
	int curr_step;
	
	switch (Curr_Visible_Window) {
		case AP_3:	
			[roiManager displayROIInstructions:[roiManager getStep]:Op_Mode:self];
			
			frame = [window3 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
						
			[window2 setFrameTopLeftPoint:frame.origin];
			[window2 makeKeyAndOrderFront:self];
			
			[window1 orderOut:self];
			[window3 orderOut:self];
			
			// set roi type to point
			for (ViewerController* viewer in [ViewerController getDisplayed2DViewers]) @try {
				[viewer setROIToolTag:[[NSNumber numberWithLong:t2DPoint] longValue]];
			} @catch (NSException* e) { // a fix since version 3.7b8++ solves this exception, but we want to be retro-compatible
			}
			
			Curr_Visible_Window = 2; 
			
			
			break;
			
		case AP_2:
			
			frame = [window2 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
			[window1 setFrameTopLeftPoint:frame.origin];
			[window1 makeKeyAndOrderFront:self];
			
			[window3 orderOut:self];
			[window2 orderOut:self];
			Curr_Visible_Window = 1; 
			
			break;
			
			
		case FP_2:	
			[roiManager displayROIInstructions:[roiManager getStep]:Op_Mode:self];
			
			frame = [falseProfileWindow2 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
			
			[falseProfileWindow1 setFrameTopLeftPoint:frame.origin];
			[falseProfileWindow1 makeKeyAndOrderFront:self];
			
			[falseProfileWindow2 orderOut:self];
			
			// set roi type to point
			for (ViewerController* viewer in [ViewerController getDisplayed2DViewers]) @try {
				[viewer setROIToolTag:[[NSNumber numberWithLong:t2DPoint] longValue]];
			} @catch (NSException* e) { // a fix since version 3.7b8++ solves this exception, but we want to be retro-compatible
			}
			
			Curr_Visible_Window = FP_1; 
			
			break;
			
		case Frog_2:	
			
			frame = [frogWindow2 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
			[frogWindow2 orderOut:self];
						
			curr_step = [roiManager getStep];
			
			if(curr_step > 1) {
				[roiManager displayROIInstructions:curr_step:Op_Mode:self];
				[frogWindow1 setFrameTopLeftPoint:frame.origin];
				[frogWindow1 makeKeyAndOrderFront:self];
				Curr_Visible_Window = Frog_1;
				// set roi type to point
				for (ViewerController* viewer in [ViewerController getDisplayed2DViewers]) @try {
					[viewer setROIToolTag:[[NSNumber numberWithLong:t2DPoint] longValue]];
				} @catch (NSException* e) { // a fix since version 3.7b8++ solves this exception, but we want to be retro-compatible
				}
			} else {				
				[frogWindow0 setFrameTopLeftPoint:frame.origin];
				[frogWindow0 makeKeyAndOrderFront:self];
				Curr_Visible_Window = Frog_0;		
			}
	 
			
			break;	
			
        case Alpha_2:	
			[roiManager displayROIInstructions:[roiManager getStep]:Op_Mode:self];
			
			frame = [alphaWindow2 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
			
			[alphaWindow1 setFrameTopLeftPoint:frame.origin];
			[alphaWindow1 makeKeyAndOrderFront:self];
			
			[alphaWindow2 orderOut:self];
			
			// set roi type to point
			for (ViewerController* viewer in [ViewerController getDisplayed2DViewers]) @try {
				[viewer setROIToolTag:[[NSNumber numberWithLong:t2DPoint] longValue]];
			} @catch (NSException* e) { // a fix since version 3.7b8++ solves this exception, but we want to be retro-compatible
			}
			
			Curr_Visible_Window = Alpha_1; 
			
			break; 
            
		default:
			break;
	}
}
 

- (IBAction)buttonRestart:(id)sender {
	NSRect frame;
	
	NSInteger choice = [self displayAlert :
						@"This will remove all currently existing markers. Do you want to continue?" :
						@"OK" :
						@"Continue" :
						nil];
	if (choice == NSAlertFirstButtonReturn) {
		
		[roiManager restart: viewerController:YES];
		
		// The part below is also taken care of by the roisWillBeDeleted funtion when the prefs roi is deleted.
		// However, if there is no prefs roi the part below must still be executed. That is why this is also here.
		// This usually results in additional work and the below stuff being called twice. Redesign if this 
		// causes trouble.
		
		[roiManager initClean];
		[roiManager displayROIInstructions:1:Op_Mode:self];
		
		// if frog, display first window
		if((Op_Mode == Frog || Op_Mode == FrogScfe) && Curr_Visible_Window == Frog_1) {
			
			frame = [frogWindow1 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
			
			[frogWindow0 setFrameTopLeftPoint:frame.origin];
			[frogWindow0 makeKeyAndOrderFront:self];
			
			[frogWindow1 orderOut:self];
			Curr_Visible_Window = Frog_0;			
		}
	} 
}


- (IBAction)buttonSkipThis:(id)sender {
	[roiManager setStep:[roiManager getNextStep]:Op_Mode];
	[roiManager displayROIInstructions:[roiManager getStep]:Op_Mode:self];
}


- (IBAction)buttonSaveToPreviousFile:(id)sender { 
	
	if(Curr_Save_File != NULL) {
		
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setLocalizesFormat:YES];
		NSString *decimalSeparator = [numberFormatter decimalSeparator];
		NSString *csvSeparator;
		
		[numberFormatter release];
		
		if([decimalSeparator isEqualToString:@","] == YES) csvSeparator = @";";	
		else csvSeparator = @",";
		
		[resultsManager saveResults:Curr_Save_File :csvSeparator:decimalSeparator: Op_Mode: viewerController: roiManager];
	} else {
		[self buttonSaveToNewFile:sender];
	}

}

- (IBAction)buttonSaveToNewFile:(id)sender{ 
	
	NSString *path;
	
	CustomSavePanel *savePanel = (CustomSavePanel*)[CustomSavePanel savePanel];
	
	[savePanel setPrompt:NSLocalizedString(@"Save To",nil)];
	[savePanel setCanCreateDirectories:YES];
	[savePanel setRequiredFileType:@"csv"];
	[savePanel setCanSelectHiddenExtension:NO];
	[savePanel setExtensionHidden:NO];
	[savePanel setMessage:@"Select either a new or an existing file. Data will be appended to existing files."];	
	[savePanel setNameFieldLabel:@"Save to:"];
	[savePanel setTitle:@"Save data"];
	
	if(Curr_Save_File == NULL) {
		path = NSHomeDirectory();
		[savePanel setDirectory:[path stringByExpandingTildeInPath]];
        
        @try
        {
            // this function was first avaliable in 10.6. Was this the problem that stopped saving from working on 10.5?
            [savePanel setNameFieldStringValue:@"datafile.csv"];
        }
        @catch(NSException* ex)
        { }
		
	} else {
		
		[savePanel setDirectory:[Curr_Save_File stringByDeletingLastPathComponent]];
		[savePanel setNameFieldStringValue:[Curr_Save_File lastPathComponent]];
	}
		
	
	if ([savePanel runModal] == NSOKButton)
    {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setLocalizesFormat:YES];
		NSString *decimalSeparator = [numberFormatter decimalSeparator];
		NSString *csvSeparator;
		
		[numberFormatter release];
		
		if([decimalSeparator isEqualToString:@","] == YES) csvSeparator = @";";	
		else csvSeparator = @",";
		
			
		if(Curr_Save_File != NULL) {
			[Curr_Save_File release];
		}
		
        Curr_Save_File = [savePanel filename];
		[Curr_Save_File retain];
		
		[resultsManager displaySaveFile:[Curr_Save_File lastPathComponent]:Op_Mode];
		
		// NSRunInformationalAlertPanel(@"system filename", Curr_Save_File , @"OK", 0L, 0L);
		[resultsManager saveResults:Curr_Save_File :csvSeparator:decimalSeparator: Op_Mode: viewerController: roiManager];
    }
}


- (IBAction)buttonRegSubmit:(id)sender{
	[registrationWindow performClose:self];
}

- (IBAction)buttonRegCancel:(id)sender{
	[registrationWindow performClose:self];
}


- (IBAction)buttonFrogScfeYes:(id)sender {
	NSRect frame;
	
	Op_Mode = FrogScfe;
	
	[roiManager restart: viewerController:YES];
	
	// the below code will usually be called from roisWillBeDeteleted function as well. Se comment on buttonRestart above.
	[roiManager initClean];
	[roiManager displayROIInstructions:1:Op_Mode:self];
	
	frame = [frogWindow0 frame];
	frame.origin.y = frame.origin.y+frame.size.height;
	
	[frogWindow1 setFrameTopLeftPoint:frame.origin];
	[frogWindow1 makeKeyAndOrderFront:self];
	
	[frogWindow0 orderOut:self];
	
	// set roi type to point
	for (ViewerController* viewer in [ViewerController getDisplayed2DViewers]) @try {
		[viewer setROIToolTag:[[NSNumber numberWithLong:t2DPoint] longValue]];
	} @catch (NSException* e) { // a fix since version 3.7b8++ solves this exception, but we want to be retro-compatible
	}
	
	Curr_Visible_Window = Frog_1;		
}
		

- (IBAction)buttonFrogScfeNo:(id)sender{
	
	NSRect frame;

	Op_Mode = Frog;
	
	[roiManager restart: viewerController:YES];
	
	// the below code will usually be called from roisWillBeDeteleted function as well. Se comment on buttonRestart above.
	[roiManager initClean];
	[roiManager displayROIInstructions:1:Op_Mode:self];
	
	frame = [frogWindow0 frame];
	frame.origin.y = frame.origin.y+frame.size.height;
	
	[frogWindow1 setFrameTopLeftPoint:frame.origin];
	[frogWindow1 makeKeyAndOrderFront:self];
	
	[frogWindow0 orderOut:self];
	
	// set roi type to point
	for (ViewerController* viewer in [ViewerController getDisplayed2DViewers]) @try {
		[viewer setROIToolTag:[[NSNumber numberWithLong:t2DPoint] longValue]];
	} @catch (NSException* e) { // a fix since version 3.7b8++ solves this exception, but we want to be retro-compatible
	}
	
	Curr_Visible_Window = Frog_1;
}


- (IBAction)buttonHelp:(id)sender {
    
    //NSRunInformationalAlertPanel(@"Help clicked", @" " , @"OK", 0L, 0L);
    
    switch (Curr_Visible_Window) {
        case AP_1:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_AP_VISUAL_URL]];
            break;
        case AP_2:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_AP_QUANTITATIVE_URL]];
            break;
        case AP_3:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_AP_VISUAL_URL]];
            break;
        case VonRosen_1:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_VON_ROSEN_VISUAL_URL]];
            break;
        case FP_1:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_FP_QUANTITATIVE_URL]];
            break;
        case FP_2:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_FP_QUANTITATIVE_URL]];
            break;
        case Frog_0:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_FROG_QUANTITATIVE_URL]];
        case Frog_1:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_FROG_QUANTITATIVE_URL]];
            break;
        case Frog_2:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_FROG_QUANTITATIVE_URL]];
            break;
        case Alpha_1:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_URL]];
            break;
        case Alpha_2:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_URL]];
            break;
        default:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:TEXT_ORTHO_HELP_URL]];
            break;
    }
}
		
- (IBAction)popupMenuFPSide:(id)sender {
	[resultsManager readROIResults:Op_Mode:roiManager:NO];
	[resultsManager displayROIResults:Op_Mode];
}


-(void)roiAdded:(NSNotification*)notification {
	int newStep;
	
	if(Curr_Visible_Window == AP_2 || Curr_Visible_Window == FP_1 || Curr_Visible_Window == Frog_1 || Curr_Visible_Window == Alpha_1) {
		newStep = [roiManager roiAdded:notification:Op_Mode:viewerController];
		
		if(newStep > 0) {
			[roiManager displayROIInstructions:newStep:Op_Mode:self];
		}
	}
	
}


-(void)roiChanged:(NSNotification*)notification {
	//NSRunInformationalAlertPanel(@"roi changed", @" " , @"OK", 0L, 0L);
	[roiManager roiChanged:notification:viewerController:self];
	
	if(Curr_Visible_Window == AP_3 || Curr_Visible_Window == FP_2 || Curr_Visible_Window == Frog_2 || Curr_Visible_Window == Alpha_2) {
		[resultsManager readROIResults:Op_Mode:roiManager:NO];
		[resultsManager displayROIResults:Op_Mode];
	}
}


-(void)roiSelected:(NSNotification*)notification {
	[roiManager roiSelected:notification:viewerController];	
}

-(void)mouseClicked:(NSNotification*)notification {
	[roiManager mouseClicked:notification:viewerController];
}

-(void)imageUpdated:(NSNotification*)notification {
		
	NSRect frame;
	ViewerController* viewer = [[NSApp makeWindowsPerform:@selector(frontmostViewerControllerFinder) inOrder:YES] windowController];
	[[viewer window] makeKeyAndOrderFront:self];
	
	if(viewer != viewerController || curr_Visible_Image != [[viewerController imageView] curImage]) {
		// the active image has been changed, the user has either selected a new viewer och changed to another image in
		// the old viewer. We need to reload.
		
		viewerController = viewer;
		curr_Visible_Image = [[viewerController imageView] curImage];
					
		[roiManager initClean];
		
		int newCurrStep = [roiManager loadFromExistingPoints:Op_Mode:viewerController];
		
		//NSLog(@"new curr step: %d", newCurrStep);
		
		//NSRunInformationalAlertPanel([NSString stringWithFormat:@"new curr step: %d", newCurrStep]);
		
		[roiManager setStep:newCurrStep:Op_Mode];
					
		if(newCurrStep > 1) {
			
			[viewerController needsDisplayUpdate];
			[roiManager updateCalculatedRois:viewerController];
			//NSRunInformationalAlertPanel(@"ROIs loaded", @" " , @"OK", 0L, 0L);
		}
		
		if(Curr_Visible_Window == Frog_0 && newCurrStep > 1) {
		
			frame = [frogWindow0 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
			
			[frogWindow1 setFrameTopLeftPoint:frame.origin];
			[frogWindow1 makeKeyAndOrderFront:self];
			
			[frogWindow0 orderOut:self];
			Curr_Visible_Window = Frog_1;		
		}
		
		if(Curr_Visible_Window == Frog_1 && newCurrStep <= 1) {
			
			frame = [frogWindow1 frame];
			frame.origin.y = frame.origin.y+frame.size.height;
			
			[frogWindow0 setFrameTopLeftPoint:frame.origin];
			[frogWindow0 makeKeyAndOrderFront:self];
			
			[frogWindow1 orderOut:self];
			Curr_Visible_Window = Frog_0;		
		}
		
		
		if(Curr_Visible_Window == AP_2 || Curr_Visible_Window == FP_1 || Curr_Visible_Window == Frog_1 || Curr_Visible_Window == Alpha_1) {
			[roiManager displayROIInstructions:newCurrStep:Op_Mode:self];		
		}
		
		if(Curr_Visible_Window == AP_3 || Curr_Visible_Window == FP_2 || Curr_Visible_Window == Frog_2 || Curr_Visible_Window == Alpha_2) {
			[resultsManager readROIResults:Op_Mode:roiManager:NO];
			[resultsManager displayROIResults:Op_Mode];
		}
	}
	
}



@end



@implementation NSWindow (OrthoStudio)

// used by selectOrOpenViewerForRoiWithId along with [NSApp makeWindowsPerform] to find the frontmost ViewerController
-(id)frontmostViewerControllerFinder {
	return [[self windowController] isKindOfClass:[ViewerController class]] ? self : NULL;
}

@end



@implementation CustomSavePanel


- (BOOL)_overwriteExistingFileCheck:(NSString *)filename {
	return(YES);
}		 


@end
