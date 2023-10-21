//
//  LicenceManager.h
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
#import <OrthopaedicStudioFilter.h>


#define CLIENT_PASS				@"f1309z4r4cx98nyvt498ynm8cd"
#define KEY_SALT				@"mcf903498756skd9875vnvcmq"

//#define EVAL_URL				@"http://www.spectronic.se/orthostudio/check_evaluation.php"
//#define LICENSE_URL				@"http://www.spectronic.se/orthostudio/check_license.php"
//#define TRANSFER_URL			@"http://www.spectronic.se/orthostudio/transfer_license.php"

#define EVAL_URL				@"http://orthostudio.spectronic.se/check_evaluation.php"
#define LICENSE_URL				@"http://orthostudio.spectronic.se/check_license.php"
#define TRANSFER_URL			@"http://orthostudio.spectronic.se/transfer_license.php"

#define MAX_EVALUATION_DAYS		30
#define APP_FOLDER				@"OrthoStudio"
#define EVAL_FILE				@".orthoconf"
#define KEY_FILE				@".orthoprefs"
#define USER_INFO_FILE			@".orthouser"
#define DUMMY_FILE				@"config.dat"
#define DUMMY_FILE_DATA			@"orthostudio-128778f7fa8e883ba2f89e23ca937fea0912a43b998f98237c9a8427efe4baff24398dfa8e883ba2f89e23ca937fea0912"


enum LicenseVerfication {
	VerifyLocal,
	VerifyRemote,
	CheckingLicenseKey,
	CheckingEvalLicense,
	CheckingNotActive,
	LicenseKeyOk,
	LicenseKeyRemoteNotExist,
	LicenseKeyInUse,
	LicenseKeyBanned,
	LicenseKeyBad,
	LicenseKeyLocalNotExist,
	LicenseEvalOk,
	LicenseEvalExpired,
};


@interface LicenceManager : NSObject {

	OrthopaedicStudioFilter *mainFilter;
	NSString* MacAddress;
	NSString* AppDataPath;
	NSMutableData* recievedData;
	int RemoteCheckingMode;
}

- (id)initWithFilterClass:(OrthopaedicStudioFilter*) main_filter;
-(void) dealloc;
-(int) checkLicense:(int) verification_mode : (int*)days_left : (NSString**) license_info;
-(int) readEvaluationFile:(int) max_days_left;
-(int)readAndVerifyLicenseKey:(NSString**) key_ptr;
- (BOOL)saveAndVerifyLicenseKey:(NSString*) key : (int) key_status;
- (BOOL)deleteLicenseKeyFile;
- (BOOL)verifyLicenseKey:(NSString*) key;
- (NSString*)extractBodyText:(NSString*) htmltext;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
