//
//  LicenceManager.m
//
//  Copyright Carl Siversson, 2010-2014. All rights reserved.
//  Distributed under GNU - GPL v3
//
// =========================================================================
//  This software is distributed WITHOUT ANY WARRANTY; without even
//  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
//  PURPOSE.
// =========================================================================

#import "LicenceManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "MACAddressManager.h"

@implementation LicenceManager

//*************************************
//
//	initWithMainFilter
//
//*************************************
- (id)initWithFilterClass:(OrthopaedicStudioFilter*) main_filter {
		
	MACAddressManager* mac_address_manager;
	NSFileManager* fileman;
	BOOL exists;
	BOOL isDirectory;
	NSError *error = nil;
	NSArray* paths;
	
	self = [super init];	
	mainFilter = main_filter;
	recievedData = nil;
	
	if(self) {
		// find users application support folder
		fileman = [[NSFileManager alloc] init];
	
		AppDataPath = NULL;
		paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,NSUserDomainMask,YES);
		if ([paths count] != 0) {		
			AppDataPath = [paths objectAtIndex:0];
			AppDataPath = [AppDataPath stringByAppendingPathComponent:APP_FOLDER];
			exists = [fileman fileExistsAtPath:AppDataPath isDirectory:&isDirectory];
		
			if (exists==FALSE) {
				if (![fileman createDirectoryAtPath:AppDataPath withIntermediateDirectories:YES attributes:nil error:&error])	{		
					AppDataPath = NULL;	
				}
			} else if(isDirectory==FALSE) {
				AppDataPath = NULL;
			}
		}
		[fileman release];
	
		if(	AppDataPath != NULL) {
			// find mac address (or make one up if one for some reason can't be found);
			mac_address_manager = [MACAddressManager alloc];	
			MacAddress = [mac_address_manager getBestMACAddress:AppDataPath];
			[mac_address_manager release];
		
			// create a dummy file in the app data directory. Just to decieve anyone tampering with the license files.
			[DUMMY_FILE_DATA writeToFile:[AppDataPath stringByAppendingPathComponent:DUMMY_FILE] atomically:YES encoding:NSUnicodeStringEncoding error:&error];
		}
	
		if (AppDataPath==NULL || MacAddress==NULL) {
			// licensemanager failed
			NSLog(@"licensemanager failed");
			[self autorelease];
			return(nil);
		} else {
			[AppDataPath retain];
			[MacAddress retain];
			//NSLog(@"\nApp data path is: %@\nMAC address is: %@", AppDataPath, MacAddress);
			return(self);
		}
	} else {
		return(nil);
	}
}


//*************************************
//
//	dealloc
//
//*************************************
-(void) dealloc  {

	if(AppDataPath!=NULL){
		[AppDataPath release];
	}
						  
	if(MacAddress!=NULL) {
		[MacAddress release];
	}
	
	[super dealloc];
}
	




//*************************************
//
//	checkLicense
//
//*************************************
-(int) checkLicense:(int) verification_mode: (int*)days_left: (NSString**) license_info{

	NSString *license_key;
	int eval_days_left;
	int license_key_status;
	int retval;
	NSString *load_file;
	
	NSURL *postURL;
	NSMutableURLRequest *urlRequest;
	NSString *submission;
	NSURLConnection *connection;
	RemoteCheckingMode = CheckingNotActive;
	
	license_key_status = [self readAndVerifyLicenseKey: &license_key];
	[license_key retain];
	
	if(verification_mode == VerifyLocal) {
		
		if(license_key_status == LicenseKeyOk) {
			//NSLog(@"local: ok, user has a valid license key");
			retval = LicenseKeyOk;
			
			if(license_info != NULL) {
				load_file = [AppDataPath stringByAppendingPathComponent: USER_INFO_FILE];
				*license_info = [NSString stringWithContentsOfFile:load_file encoding:NSUnicodeStringEncoding error:nil];
			}
		} else if(license_key_status == LicenseKeyLocalNotExist){
			//NSLog(@"local: user has no paid license, check for evaluation license");
			if((eval_days_left = [self readEvaluationFile:MAX_EVALUATION_DAYS]) > 0) {
				if(days_left != NULL) {
					*days_left = eval_days_left;
				}
				//NSLog(@"local: ok, eval license is active");
				retval = LicenseEvalOk;
			} else {
				//NSLog(@"local: failed, eval license has expired");
				retval = LicenseEvalExpired;
			}
			
		} else {
			//NSLog(@"local: This license key is BAD!");
			retval = license_key_status;
			
			if(days_left != NULL) {
				*days_left = [self readEvaluationFile:MAX_EVALUATION_DAYS];
			}
		}

	}
	
	
	if(verification_mode == VerifyRemote) {
		
		if(license_key_status == LicenseKeyOk) {
			//NSLog(@"remote: ok, user has a valid license key locally. Check if this key is ok on server");
			RemoteCheckingMode = CheckingLicenseKey;
			retval = LicenseKeyOk;
			
			if(license_info != NULL) {
				load_file = [AppDataPath stringByAppendingPathComponent: USER_INFO_FILE];
				*license_info = [NSString stringWithContentsOfFile:load_file encoding:NSUnicodeStringEncoding error:nil];
				//NSLog(*license_info);
			}
					
			
			postURL = [NSURL URLWithString:LICENSE_URL];
			urlRequest = [NSMutableURLRequest requestWithURL:postURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
			[urlRequest setHTTPMethod:@"POST"];
			submission = [NSString stringWithFormat:@"indata1=%@&indata2=%@&indata3=%@", CLIENT_PASS,license_key, MacAddress];
			[urlRequest setHTTPBody:[submission dataUsingEncoding:NSUTF8StringEncoding]];
			connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
			
			
		} else if(license_key_status == LicenseKeyLocalNotExist){
			// user has no paid license, check for evaluation license
			if((eval_days_left = [self readEvaluationFile:MAX_EVALUATION_DAYS]) > 0) {
				//NSLog(@"remote: ok, eval license is active locally, check if this evaluation license is ok on server");
				RemoteCheckingMode = CheckingEvalLicense;
				retval = LicenseEvalOk;
				
				if(days_left != NULL) {
					*days_left = eval_days_left;
				}
				
				postURL = [NSURL URLWithString:EVAL_URL];
				urlRequest = [NSMutableURLRequest requestWithURL:postURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
				[urlRequest setHTTPMethod:@"POST"];
				submission = [NSString stringWithFormat:@"indata1=%@&indata2=%@&indata3=%d", CLIENT_PASS, MacAddress, eval_days_left];
				[urlRequest setHTTPBody:[submission dataUsingEncoding:NSUTF8StringEncoding]];
				connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
			} else {
				//NSLog(@"remote: failed, eval license has expired (locally)");
				retval = LicenseEvalExpired;
			}
		} else {
			//NSLog(@"remote: This license key is BAD (locally)!");	
			retval = license_key_status;
			
			if(days_left != NULL) {
				*days_left = [self readEvaluationFile:MAX_EVALUATION_DAYS];
			}
		}
	}
		   
	[license_key release];
	return retval;
}



//*************************************
//
//	readEvaluationFile
//
//*************************************
-(int) readEvaluationFile:(int) max_days_left {
	
	NSString* save_file;
	NSFileManager* fileman;
	BOOL exists;
	BOOL isDirectory;
	NSError *error = nil;
	NSString *filedata;
	
	NSString* todaystring;
	NSDate* todaydate;
	NSRange timerange;
	NSDate* enddate;
	int saved_days_left;
	int days_left;
	
	NSTimeInterval secondsPerDay = 24 * 60 * 60;
	
	fileman = [[NSFileManager alloc] init];

	save_file = [AppDataPath stringByAppendingPathComponent: EVAL_FILE];
	exists = [fileman fileExistsAtPath: save_file isDirectory:&isDirectory];
	todaystring = [[NSDate date] description];
	timerange = NSMakeRange(11,8);
	todaystring = [todaystring stringByReplacingCharactersInRange:timerange withString:@"00:00:00"];		
	todaydate = [NSDate dateWithString:todaystring];
	
	if (exists==NO) {
		// create file
		error = nil;
		enddate = [todaydate dateByAddingTimeInterval: (secondsPerDay*max_days_left)];
		filedata = [NSString stringWithFormat:@"%f",[enddate timeIntervalSince1970]];
		[filedata writeToFile:save_file atomically:YES encoding:NSUnicodeStringEncoding error:&error];
		
		if(error == nil){
			days_left = max_days_left;
		} else {
			days_left = 0;
		}
		
	} else if (isDirectory==NO) {
		// load file
		filedata = [NSString stringWithContentsOfFile:save_file encoding:NSUnicodeStringEncoding error:&error];
		
		if (([filedata doubleValue]-[[NSDate date] timeIntervalSince1970])>0) {	
			
			saved_days_left = ((int)(([filedata doubleValue]-[[NSDate date] timeIntervalSince1970])/secondsPerDay))+1;
			
			// check if file has been tampered with
			if(saved_days_left>max_days_left) {
				
				// if so, write back the correct value into file
				error = nil;
				enddate = [todaydate dateByAddingTimeInterval: (secondsPerDay*max_days_left)];						   
				filedata = [NSString stringWithFormat:@"%f",[enddate timeIntervalSince1970]];
				[filedata writeToFile:save_file atomically:YES encoding:NSUnicodeStringEncoding error:&error];
				
				if(error == nil){
					days_left = max_days_left;
				} else {
					days_left = 0;
				}
				
			} else {
				days_left = saved_days_left;
			}
			
		} else {
			days_left = 0;
		}
		
	} else {
		// something is wrong
		days_left = 0;
	}
	
	[fileman release];
	return(days_left);
}


//*************************************
//
//	readAndVerifyLicenseKey
//
//*************************************
-(int)readAndVerifyLicenseKey:(NSString**) key_ptr  {
	
	NSString* load_file;
	NSString* filedata;
	NSArray* file_items;
	int retval;
	NSError *error = nil;
	*key_ptr = @"";
	load_file = [AppDataPath stringByAppendingPathComponent: KEY_FILE];
	filedata = [NSString stringWithContentsOfFile:load_file encoding:NSUnicodeStringEncoding error:&error];
	
	if(error == nil){
		file_items = [filedata componentsSeparatedByString:@"\n"];
		if([file_items count] == 2 && [self verifyLicenseKey:((NSString*)[file_items objectAtIndex:0])]) {
			// return key if pointer is not null
			if(key_ptr != NULL) {
				*key_ptr = ((NSString*)[file_items objectAtIndex:0]);
			}
			// return key status from file
			retval = [((NSString*)[file_items objectAtIndex:1]) intValue];
		}else {
			retval = LicenseKeyBad;
		}
	} else {
		retval = LicenseKeyLocalNotExist;
	}
	return retval;
}


//*************************************
//
//	saveAndVerifyLicenseKey
//
//*************************************
- (BOOL)saveAndVerifyLicenseKey:(NSString*) key: (int) key_status {
	
	BOOL retval;
	NSString* save_file;
	NSError *error = nil;

	if ([self verifyLicenseKey:key]) {
		key = [[key lowercaseString] stringByAppendingString:[NSString stringWithFormat:@"\n%d", key_status]];
		save_file = [AppDataPath stringByAppendingPathComponent: KEY_FILE];
		[key writeToFile:save_file atomically:YES encoding:NSUnicodeStringEncoding error:&error];
		
		if(error == nil){
			retval = YES;
		} else {
			retval = NO;
		}
	} else {
		retval = NO;
	}
	return(retval);
}



//*************************************
//
//	deleteLicenseKeyFile
//
//*************************************
- (BOOL)deleteLicenseKeyFile {
	
	BOOL retval;
	NSString* file;
	NSError *error = nil;
	NSFileManager* fileman;
	
	fileman = [[NSFileManager alloc] init];
		
	file = [AppDataPath stringByAppendingPathComponent: KEY_FILE];

	[fileman removeItemAtPath:file error:&error];
		
	if(error == nil){
		retval = YES;
	} else {
		retval = NO;
	}
	
	[fileman release];
	return(retval);
}




//*************************************
//
//	verifyLicenseKey
//
//*************************************
- (BOOL)verifyLicenseKey:(NSString*) key {
	
	unsigned char md5result[16];
	char *cStr;

	if ([key length] == 16) {
		cStr = [[[[key lowercaseString] substringToIndex:8] stringByAppendingString:KEY_SALT] UTF8String];
		CC_MD5( cStr, strlen(cStr), md5result );
		
		if ([[[key lowercaseString] substringFromIndex:8] isEqualToString:	[NSString stringWithFormat: @"%02x%02x%02x%02x", 
														md5result[0], md5result[1], md5result[2], md5result[3]]]) {
			return(YES);
		} else {
			return(NO);
		}
	
	} else {
		return(NO);
	}	
}




//*************************************
//
//	extractBodyText
//
//*************************************
- (NSString*)extractBodyText:(NSString*) htmltext {
	
	NSRange range;
	
	NSMutableString *textdata = [NSMutableString stringWithString:htmltext];
		
	// remove everything before the first body tag
	range = [textdata rangeOfString:@"<body>" options: NSCaseInsensitiveSearch];
	
	if(range.location != NSNotFound) {
	
		range.length = range.length + range.location;
		range.location = 0;
		[textdata deleteCharactersInRange:range];
	
		// remove everything after the last body tag
		range = [textdata rangeOfString:@"</body>" options: NSCaseInsensitiveSearch];

		if(range.location != NSNotFound) {

			range.length = [textdata length] - range.location;	
			[textdata deleteCharactersInRange:range];
	
			[textdata replaceOccurrencesOfString:@"\n" withString:@"" options: NSLiteralSearch range: NSMakeRange(0, [textdata length])];
			[textdata replaceOccurrencesOfString:@"\r" withString:@"" options: NSLiteralSearch range: NSMakeRange(0, [textdata length])];
			[textdata replaceOccurrencesOfString:@"<br>" withString:@"\n" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [textdata length])];
		} else {
			textdata = NULL;
		}		
	} else {
		textdata = NULL;
	}	
	
	return textdata;
}



//********************************************
//
//	delegate methods for NSURLConnection
//
//********************************************
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//NSLog(@"NSURLConnection - Received HTTP response...\n");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData {
	if (recievedData == nil) {
		recievedData = [[NSMutableData data] retain];
	 }
		
	[recievedData appendData:newData];	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
	NSLog(@"NSURLConnection - Failed with error: %@\n", [error localizedDescription]);
	
	if (recievedData != nil) {
		[recievedData release];
		recievedData = nil;
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSString* received_string;
	NSString* license_key;
	NSString* userinfo_string = NULL;
	NSArray* received_items;
	int eval_days_left;
	int received_days_left;
	int license_key_status;
	char nullbyte = 0;
	
    [connection release];
		
	[recievedData appendBytes:&nullbyte length:1];
	received_string = [self extractBodyText:[NSString stringWithUTF8String:[recievedData bytes]]];
	
	eval_days_left = [self readEvaluationFile:MAX_EVALUATION_DAYS];
	//NSLog(@"NSURLConnection - Finished connection:\n%@\n", received_string);
	
	if(received_string != NULL) {

		// if a licence key is being checked
		if(RemoteCheckingMode == CheckingLicenseKey) {
			
			license_key_status = [self readAndVerifyLicenseKey:&license_key];
			[license_key retain]; 
			
			received_items = [received_string componentsSeparatedByString:@"\n"];
			
			if([((NSString*)[received_items objectAtIndex:0]) rangeOfString:@"ok" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
				
				// check for user info
				if([received_items count] > 1) {
					userinfo_string = [[received_items subarrayWithRange:NSMakeRange(1, [received_items count]-1)] componentsJoinedByString:@"\n"];	
					
					// write user info to file
					[userinfo_string writeToFile:[AppDataPath stringByAppendingPathComponent: USER_INFO_FILE] atomically:YES encoding:NSUnicodeStringEncoding error:nil];
				}	 
				//NSLog(@"remote: key ok, user info is:\n%@\n", userinfo_string);
				NSLog(@"remote: key ok");
				
				if(license_key_status != LicenseKeyOk) {
					[self saveAndVerifyLicenseKey:license_key: LicenseKeyOk];
				}
							
			} else if([((NSString*)[received_items objectAtIndex:0]) rangeOfString:@"fail" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
				//NSLog(@"remote: key does not exist\n");
				if(license_key_status != LicenseKeyRemoteNotExist) {
					[self saveAndVerifyLicenseKey:license_key: LicenseKeyRemoteNotExist];
				}
				[mainFilter performLicenseAction: LicenseKeyRemoteNotExist: VerifyRemote: eval_days_left: @""];
				
			} else if([((NSString*)[received_items objectAtIndex:0]) rangeOfString:@"in use" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
				//NSLog(@"remote: key in use\n");
				if(license_key_status != LicenseKeyInUse) {
					[self saveAndVerifyLicenseKey:license_key: LicenseKeyInUse];
				}
				[mainFilter performLicenseAction: LicenseKeyInUse: VerifyRemote: eval_days_left: @""];
				
			} else if([((NSString*)[received_items objectAtIndex:0]) rangeOfString:@"banned" options: NSCaseInsensitiveSearch].location != NSNotFound ) {
				//NSLog(@"remote: key banned\n");
				if(license_key_status != LicenseKeyBanned) {
					[self saveAndVerifyLicenseKey:license_key: LicenseKeyBanned];
				}
				[mainFilter performLicenseAction: LicenseKeyBanned: VerifyRemote: eval_days_left: @""];
				
			} else {
				//NSLog(@"remote: returned something else\n");
				
			}
			
			[license_key release];
		}
		
		// if an evaluation licence is being checked
		if(RemoteCheckingMode == CheckingEvalLicense) {

			received_days_left = [received_string intValue];
			
			if (received_days_left < eval_days_left) {
				//NSLog(@"remote: local evaluation file has been tampered with\n");
				eval_days_left = received_days_left;
				[self readEvaluationFile:received_days_left];
			}
			
			if (eval_days_left <= 0) {
				//NSLog(@"remote: evaluation license has expired\n");
				[mainFilter performLicenseAction: LicenseEvalExpired: VerifyRemote: eval_days_left: @""];
			} else {
				// do nothing
				//NSLog(@"remote: evaluation license has %d (%d) days left\n", eval_days_left, received_days_left);
			}

		}
	}
	RemoteCheckingMode == CheckingNotActive;
	[recievedData release];
	recievedData = nil;
}

@end
