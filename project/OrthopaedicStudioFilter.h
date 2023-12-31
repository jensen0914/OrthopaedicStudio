//
//  OrthopaedicStudioFilter.h
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

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>
#import <Cocoa/Cocoa.h>

#define TEXT_REG_DISCLAIMER1				@"Copyright 2010-2017, Carl Siversson (carl.siversson@med.lu.se), Lund University, Sweden"
#define TEXT_REG_DISCLAIMER2				@"\n\nTHE SOFTWARE IS PROVIDED AS IS. USE THE SOFTWARE AT YOUR OWN RISK. NEITHER THE AUTHOR NOR THE DISTRIBUTOR MAKES ANY WARRANTIES AS TO PERFORMANCE OR FITNESS FOR A PARTICULAR PURPOSE, OR ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED. NO ORAL OR WRITTEN COMMUNICATION FROM OR INFORMATION PROVIDED BY THE AUTHOR OR THE DISTRIBUTOR SHALL CREATE A WARRANTY. UNDER NO CIRCUMSTANCES SHALL THE AUTHOR OR THE DISTRIBUTOR BE LIABLE FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES RESULTING FROM THE USE, MISUSE, OR INABILITY TO USE THE SOFTWARE, EVEN IF THE AUTHOR OR THE DISTRIBUTOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.\n\nTHIS SOFTWARE IS NOT CERTIFIED FOR PRIMARY DIAGNOSTIC IMAGING.\n\nAll calculations, measurements and images provided by this software are intended for non-diagnostic investigational use only. Any other use is entirely at the discretion and risk of the user. If you do use this software for scientific research please give appropriate credit in publications. \n\nThis software is distributed under the GNU GPL v3 licence."

#define TEXT_ORTHO_HELP_URL                 @"https://web.archive.org/web/20160303223908/http://orthostudio.spectronic.se/orthostudio/User_Manual.html"
#define TEXT_ORTHO_HELP_AP_VISUAL_URL              @"https://web.archive.org/web/20160303223908/http://orthostudio.spectronic.se/orthostudio/User_Manual.html#widget5"
#define TEXT_ORTHO_HELP_AP_QUANTITATIVE_URL        @"https://web.archive.org/web/20160303223908/http://orthostudio.spectronic.se/orthostudio/User_Manual.html#widget6"
#define TEXT_ORTHO_HELP_VON_ROSEN_VISUAL_URL       @"https://web.archive.org/web/20160303223908/http://orthostudio.spectronic.se/orthostudio/User_Manual.html#widget7"
#define TEXT_ORTHO_HELP_FP_QUANTITATIVE_URL        @"https://web.archive.org/web/20160303223908/http://orthostudio.spectronic.se/orthostudio/User_Manual.html#widget8"
#define TEXT_ORTHO_HELP_FROG_QUANTITATIVE_URL      @"https://web.archive.org/web/20160303223908/http://orthostudio.spectronic.se/orthostudio/User_Manual.html#widget9"


enum OpMode {
	NoInit = -1,
	AP = 0,
	VonRosen,
	FP,
	Frog,
	FrogScfe,
    Alpha
};


enum Windows {
	NoWindow = -1,
	AP_1 = 1,
	AP_2,
	AP_3,
	VonRosen_1,
	FP_1,
	FP_2,
	Frog_0,
	Frog_1,
	Frog_2,
	Alpha_1,
    Alpha_2
};

@interface OrthopaedicStudioFilter : PluginFilter {

	IBOutlet NSPanel *window1;
	IBOutlet NSPanel *window2;
	IBOutlet NSPanel *window3;
	
	IBOutlet NSPanel *vonRosenWindow;
	
	IBOutlet NSPanel *falseProfileWindow1;
	IBOutlet NSPanel *falseProfileWindow2;
	
	IBOutlet NSPanel *frogWindow0;	// the reason this window has number 0, is since it was implemeted aftewards.
	IBOutlet NSPanel *frogWindow1;
	IBOutlet NSPanel *frogWindow2;
	
    IBOutlet NSPanel *alphaWindow1;
	IBOutlet NSPanel *alphaWindow2;
    
	IBOutlet NSPanel *registrationWindow;
	

	id  Short_Key_Monitor;
	int Op_Mode;
	int Curr_Visible_Window;
	int curr_Visible_Image;
	BOOL Viewer_Changed_Notification_Received;
	NSString* Curr_Save_File;
	
	NSMenuItem *blankMenuItem;
	
	//flags
	BOOL setMenuIsCalledFlag;
	BOOL filterImageIsCalledFlag;
	
	BOOL callFilterImageWhenNibIsLoadedFlag;
	NSString  *callFilterImageWhenNibIsLoadedString;
	
	@public 
	
	//AP
	IBOutlet NSPopUpButton *popUp_AP_XRayView;
	IBOutlet NSPopUpButton *popUp_AP_ShentonLeft;
	IBOutlet NSPopUpButton *popUp_AP_ShentonRight;
	IBOutlet NSPopUpButton *popUp_AP_CrossOverLeft;
	IBOutlet NSPopUpButton *popUp_AP_CrossOverRight;
	IBOutlet NSPopUpButton *popUp_AP_PosteriorWallLeft;
	IBOutlet NSPopUpButton *popUp_AP_PosteriorWallRight;
	IBOutlet NSPopUpButton *popUp_AP_TonnisLeft;
	IBOutlet NSPopUpButton *popUp_AP_TonnisRight;
	
	//Von Rosen
	IBOutlet NSPopUpButton *popUp_VR_JointConLeft;
	IBOutlet NSPopUpButton *popUp_VR_JointConRight;
	
	//False Profile
	
	
	// AP
	IBOutlet NSTextField *text_AP_XRayView;
	IBOutlet NSTextField *text_AP_ShentonLeft;
	IBOutlet NSTextField *text_AP_ShentonRight;
	IBOutlet NSTextField *text_AP_CrossOverLeft;
	IBOutlet NSTextField *text_AP_CrossOverRight;
	IBOutlet NSTextField *text_AP_PosteriorWallLeft;
	IBOutlet NSTextField *text_AP_PosteriorWallRight;
	IBOutlet NSTextField *text_AP_TonnisLeft;
	IBOutlet NSTextField *text_AP_TonnisRight;
	
	IBOutlet NSTextField *text_AP_LCERight;
	IBOutlet NSTextField *text_AP_LCELeft;
	IBOutlet NSTextField *text_AP_TonnisAngleRight;
	IBOutlet NSTextField *text_AP_TonnisAngleLeft;
	IBOutlet NSTextField *text_AP_JSWRight;
	IBOutlet NSTextField *text_AP_JSWLeft;
	IBOutlet NSTextField *text_AP_PelvicTilt;
	IBOutlet NSTextField *text_AP_PelvicRot;
    IBOutlet NSTextField *text_AP_AlphaRight;
	IBOutlet NSTextField *text_AP_AlphaLeft;
	
	IBOutlet NSTextField *text_AP_SaveFile;
	
	IBOutlet NSTextField *text_AP_RoiInstructions;
	IBOutlet NSTextField *text_AP_RoiInstructionsStep;
	
	IBOutlet NSImageView *image_AP_RoiInstructions;
	IBOutlet NSButton	 *button_SkipThis;
	
	//Von Rosen
	IBOutlet NSTextField *text_VR_SaveFile;	
	
	//False Profile
	IBOutlet NSTextField *text_FP_ACE;
	
	IBOutlet NSTextField *text_FP_SaveFile;
	
	IBOutlet NSTextField *text_FP_RoiInstructions;
	IBOutlet NSTextField *text_FP_RoiInstructionsStep;
	
	IBOutlet NSImageView *image_FP_RoiInstructions;
	IBOutlet NSButton	 *button_FP_SkipThis;
	
	IBOutlet NSPopUpButton	 *popup_FP_Side;
	
	//Frog
	IBOutlet NSTextField *text_Frog_AlphaRight;
	IBOutlet NSTextField *text_Frog_AlphaLeft;
	
	IBOutlet NSTextField *text_Frog_SaveFile;
	
	IBOutlet NSTextField *text_Frog_RoiInstructions;
	IBOutlet NSTextField *text_Frog_RoiInstructionsStep;
	
	IBOutlet NSImageView *image_Frog_RoiInstructions;
	IBOutlet NSButton	 *button_Frog_SkipThis;
	
	IBOutlet NSTextField *text_Frog_HNOffsetLeft;
	IBOutlet NSTextField *text_Frog_HNOffsetRight;
	
	//Frog Scfe
	IBOutlet NSTextField *text_FrogSfce_SouthwickLeft;
	IBOutlet NSTextField *text_FrogScfe_SouthwickRight;
	
	IBOutlet NSTextField *text_FrogScfe_EMOffsetLeft;
	IBOutlet NSTextField *text_FrogScfe_EMOffsetRight;
	
    // Alpha angle
    IBOutlet NSTextField *text_Alpha_AlphaRight;
	IBOutlet NSTextField *text_Alpha_AlphaLeft;
	
	IBOutlet NSTextField *text_Alpha_SaveFile;
	
	IBOutlet NSTextField *text_Alpha_RoiInstructions;
	IBOutlet NSTextField *text_Alpha_RoiInstructionsStep;
	
	IBOutlet NSImageView *image_Alpha_RoiInstructions;
	IBOutlet NSButton	 *button_Alpha_SkipThis;
    
    
	//Registration
	IBOutlet NSTextField *textFieldInput_Reg_LicenseKey;
	IBOutlet NSTextView  *textView_Reg_HyperLink;
    
}

- (long) filterImage:(NSString*) menuName;
- (void) initPlugin;
- (void) setMenus;
- (void) closePlugin;
- (IBAction)buttonNextWindow:(id)sender;
- (IBAction)buttonPrevWindow:(id)sender;
- (void)roiAdded:(NSNotification*)notification;
- (void)roiChanged:(NSNotification*)notification;
- (void)imageUpdated:(NSNotification*)notification;
- (IBAction)buttonRestart:(id)sender;
- (IBAction)buttonSkipThis:(id)sender;
- (IBAction)buttonSaveToPreviousFile:(id)sender;
- (IBAction)buttonSaveToNewFile:(id)sender;
- (IBAction)buttonRegSubmit:(id)sender;
- (IBAction)buttonRegCancel:(id)sender;
- (IBAction)buttonFrogScfeYes:(id)sender;
- (IBAction)buttonFrogScfeNo:(id)sender;
- (BOOL)windowShouldClose:(NSWindow *)sender;
- (IBAction)popupMenuFPSide:(id)sender;
- (IBAction)buttonHelp:(id)sender;

- (NSInteger) displayAlert : (NSString*) alertStr : (NSString*) choice1Str : (NSString*) choice2Str : (NSString*) choice3Str;

-(void)closeViewer:(NSNotification*)notification;
-(void)roiWillBeDeleted:(NSNotification*)notification;
//-(void)roiIsDeleted:(NSNotification*)notification;
-(void)viewerChanged:(NSNotification*)notification;





@end




@interface CustomSavePanel : NSSavePanel
{

}
- (BOOL)_overwriteExistingFileCheck:(NSString *)filename;

@end
