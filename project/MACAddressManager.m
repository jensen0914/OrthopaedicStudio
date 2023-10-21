//
//  MACAddress.m
//
//  Copyright Carl Siversson, 2010-2014. All rights reserved.
//  Distributed under GNU - GPL v3
//
// =========================================================================
//  This software is distributed WITHOUT ANY WARRANTY; without even
//  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
//  PURPOSE.
// =========================================================================

#import "MACAddressManager.h"

#include <stdio.h>

#include <CoreFoundation/CoreFoundation.h>

#include <IOKit/IOKitLib.h>
#include <IOKit/network/IOEthernetInterface.h>
#include <IOKit/network/IONetworkInterface.h>
#include <IOKit/network/IOEthernetController.h>


static kern_return_t FindEthernetInterfaces(io_iterator_t *matchingServices);
static kern_return_t GetMACAddress(io_iterator_t intfIterator, UInt8 *MACAddress, UInt8 bufferSize);


// Returns an iterator containing the primary (built-in) Ethernet interface. The caller is responsible for
// releasing the iterator after the caller is done with it.
static kern_return_t FindEthernetInterfaces(io_iterator_t *matchingServices)
{
    kern_return_t		kernResult; 
    CFMutableDictionaryRef	matchingDict;
    CFMutableDictionaryRef	propertyMatchDict;
    
    // Ethernet interfaces are instances of class kIOEthernetInterfaceClass. 
    // IOServiceMatching is a convenience function to create a dictionary with the key kIOProviderClassKey and 
    // the specified value.
    matchingDict = IOServiceMatching(kIOEthernetInterfaceClass);
	
    // Note that another option here would be:
    // matchingDict = IOBSDMatching("en0");
	
    if (NULL == matchingDict) {
        //printf("IOServiceMatching returned a NULL dictionary.\n");
    }
    else {
        // Each IONetworkInterface object has a Boolean property with the key kIOPrimaryInterface. Only the
        // primary (built-in) interface has this property set to TRUE.
        
        // IOServiceGetMatchingServices uses the default matching criteria defined by IOService. This considers
        // only the following properties plus any family-specific matching in this order of precedence 
        // (see IOService::passiveMatch):
        //
        // kIOProviderClassKey (IOServiceMatching)
        // kIONameMatchKey (IOServiceNameMatching)
        // kIOPropertyMatchKey
        // kIOPathMatchKey
        // kIOMatchedServiceCountKey
        // family-specific matching
        // kIOBSDNameKey (IOBSDNameMatching)
        // kIOLocationMatchKey
        
        // The IONetworkingFamily does not define any family-specific matching. This means that in            
        // order to have IOServiceGetMatchingServices consider the kIOPrimaryInterface property, we must
        // add that property to a separate dictionary and then add that to our matching dictionary
        // specifying kIOPropertyMatchKey.
		
        propertyMatchDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0,
													  &kCFTypeDictionaryKeyCallBacks,
													  &kCFTypeDictionaryValueCallBacks);
		
        if (NULL == propertyMatchDict) {
            //printf("CFDictionaryCreateMutable returned a NULL dictionary.\n");
        }
        else {
            // Set the value in the dictionary of the property with the given key, or add the key 
            // to the dictionary if it doesn't exist. This call retains the value object passed in.
            CFDictionarySetValue(propertyMatchDict, CFSTR(kIOPrimaryInterface), kCFBooleanTrue); 
            
            // Now add the dictionary containing the matching value for kIOPrimaryInterface to our main
            // matching dictionary. This call will retain propertyMatchDict, so we can release our reference 
            // on propertyMatchDict after adding it to matchingDict.
            CFDictionarySetValue(matchingDict, CFSTR(kIOPropertyMatchKey), propertyMatchDict);
            CFRelease(propertyMatchDict);
        }
    }
    
    // IOServiceGetMatchingServices retains the returned iterator, so release the iterator when we're done with it.
    // IOServiceGetMatchingServices also consumes a reference on the matching dictionary so we don't need to release
    // the dictionary explicitly.
    kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, matchingServices);    
    if (KERN_SUCCESS != kernResult) {
        //printf("IOServiceGetMatchingServices returned 0x%08x\n", kernResult);
    }
	
    return kernResult;
}

// Given an iterator across a set of Ethernet interfaces, return the MAC address of the last one.
// If no interfaces are found the MAC address is set to an empty string.
// In this sample the iterator should contain just the primary interface.
static kern_return_t GetMACAddress(io_iterator_t intfIterator, UInt8 *MACAddress, UInt8 bufferSize)
{
    io_object_t		intfService;
    io_object_t		controllerService;
    kern_return_t	kernResult = KERN_FAILURE;
    
    // Make sure the caller provided enough buffer space. Protect against buffer overflow problems.
	if (bufferSize < kIOEthernetAddressSize) {
		return kernResult;
	}
	
	// Initialize the returned address
    bzero(MACAddress, bufferSize);
    
    // IOIteratorNext retains the returned object, so release it when we're done with it.
    while (intfService = IOIteratorNext(intfIterator))
    {
        CFTypeRef	MACAddressAsCFData;        
		
        // IONetworkControllers can't be found directly by the IOServiceGetMatchingServices call, 
        // since they are hardware nubs and do not participate in driver matching. In other words,
        // registerService() is never called on them. So we've found the IONetworkInterface and will 
        // get its parent controller by asking for it specifically.
        
        // IORegistryEntryGetParentEntry retains the returned object, so release it when we're done with it.
        kernResult = IORegistryEntryGetParentEntry(intfService,
												   kIOServicePlane,
												   &controllerService);
		
        if (KERN_SUCCESS != kernResult) {
            //NSLog(@"IORegistryEntryGetParentEntry returned 0x%08x\n", kernResult);
        }
        else {
            // Retrieve the MAC address property from the I/O Registry in the form of a CFData
            MACAddressAsCFData = IORegistryEntryCreateCFProperty(controllerService,
																 CFSTR(kIOMACAddress),
																 kCFAllocatorDefault,
																 0);
            if (MACAddressAsCFData) {
                CFShow(MACAddressAsCFData); // for display purposes only; output goes to stderr
                
                // Get the raw bytes of the MAC address from the CFData
                CFDataGetBytes(MACAddressAsCFData, CFRangeMake(0, kIOEthernetAddressSize), MACAddress);
                CFRelease(MACAddressAsCFData);
            }
			
            // Done with the parent Ethernet controller object so we release it.
            (void) IOObjectRelease(controllerService);
        }
        
        // Done with the Ethernet interface object so we release it.
        (void) IOObjectRelease(intfService);
    }
	
    return kernResult;
}



int getPrimaryMACAddressCFunction(UInt8 *MACAddress)
{
    kern_return_t	kernResult = KERN_SUCCESS; // on PowerPC this is an int (4 bytes)
	/*
	 *	error number layout as follows (see mach/error.h and IOKit/IOReturn.h):
	 *
	 *	hi		 		       lo
	 *	| system(6) | subsystem(12) | code(14) |
	 */

    io_iterator_t	intfIterator;
    //UInt8			MACAddress[kIOEthernetAddressSize];
	
    kernResult = FindEthernetInterfaces(&intfIterator);
    
    if (KERN_SUCCESS != kernResult) {
        //NSLog(@"FindEthernetInterfaces returned 0x%08x\n", kernResult);
    }
    else {
        //kernResult = GetMACAddress(intfIterator, MACAddress, sizeof(MACAddress));
		kernResult = GetMACAddress(intfIterator, MACAddress, 6);
        
        if (KERN_SUCCESS != kernResult) {
            //NSLog(@"GetMACAddress returned 0x%08x\n", kernResult);
        }
		else {
			//NSLog(@"This system's built-in MAC address is %02x:%02x:%02x:%02x:%02x:%02x.\n",
			//	   MACAddress[0], MACAddress[1], MACAddress[2], MACAddress[3], MACAddress[4], MACAddress[5]);
		}
    }
    
    (void) IOObjectRelease(intfIterator);	// Release the iterator.

    return kernResult;
}


//================================================
//
//		Obj-C wrapper and utility functions
//
//================================================
@implementation MACAddressManager

- (int)getPrimaryMACAddress:(UInt8 *) mac_address
{
	return getPrimaryMACAddressCFunction(mac_address);
}

- (NSString*)getBestMACAddress:(NSString *) save_path
{
	UInt8 mac_adress[6];
	NSString* mac_address_string;
	NSString* save_file;
	
	NSFileManager* fileman;
	BOOL exists;
	BOOL isDirectory;
	NSError *error;
	BOOL create_file = NO;
	
	
	// get mac adress
	if([self getPrimaryMACAddress:mac_adress]==KERN_SUCCESS) {
		mac_address_string = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",mac_adress[0], mac_adress[1], mac_adress[2], mac_adress[3], mac_adress[4], mac_adress[5]];

	} else {
		// load from file
		
		// check if file already exists
		save_file = [save_path stringByAppendingPathComponent:MAC_FILE];
		fileman = [[NSFileManager alloc] init];
		[fileman autorelease];
		exists = [fileman fileExistsAtPath: save_file isDirectory:&isDirectory];
		
		
		if (exists==NO) {		
			// create file
			create_file = YES;
			
		} else if (isDirectory==NO) {
			// load file
			mac_address_string = [NSString stringWithContentsOfFile:save_file encoding:NSUnicodeStringEncoding error:&error];
			
			if([mac_address_string length] == 12) {
				create_file = NO;
			} else {
				create_file = YES;
			}
		} else {
			// something is wrong
			create_file = NO;
			mac_address_string = NULL;
		}
		
		
		if(create_file == YES) {
			// make a mac address up 
			srandom((unsigned int)time(NULL));
			mac_address_string = [NSString stringWithFormat:@"xx%02lx%02lx%02lx%02lx",random()%256, random()%256, random()%256, random()%256];
			
			//save to file
			error = nil;
			[mac_address_string writeToFile:save_file atomically:YES encoding:NSUnicodeStringEncoding error:&error];
			if(error != nil){
				mac_address_string = NULL;
			}
		}
	}
	
	return mac_address_string;
}




// this version of getBestMACAddress always loads the mac address from a file. Even though this
// makes the licence checking less error prone, it reduces the security, since the user could simply
// copy the application data folder from a computer with a valid license to any other computer to
// cheat the license check.

/*
- (NSString*)getBestMACAddress:(NSString *) save_path
{
	UInt8 mac_adress[6];
	NSString* mac_address_string;
	NSString* save_file;
	
	NSFileManager* fileman;
	BOOL exists;
	BOOL isDirectory;
	NSError *error;
	BOOL create_file = NO;
	
	// check if file already exists
	save_file = [save_path stringByAppendingPathComponent:MAC_FILE];
	fileman = [[NSFileManager alloc] init];
	[fileman autorelease];
	exists = [fileman fileExistsAtPath: save_file isDirectory:&isDirectory];
	
	
	if (exists==NO) {		
		// create file
		create_file = YES;
				
	} else if (isDirectory==NO) {
		// load file
		mac_address_string = [NSString stringWithContentsOfFile:save_file encoding:NSUnicodeStringEncoding error:&error];
		
		if([mac_address_string length] == 12) {
			create_file = NO;
		} else {
			create_file = YES;
		}
	} else {
		// something is wrong
		create_file = NO;
		mac_address_string = NULL;
	}
	
		
	if(create_file == YES) {
		// get mac adress
		if([self getPrimaryMACAddress:mac_adress]==KERN_SUCCESS) {
			mac_address_string = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",mac_adress[0], mac_adress[1], mac_adress[2], mac_adress[3], mac_adress[4], mac_adress[5]];
			
		} else {
			// or make one up 
			srandom(time(NULL));
			mac_address_string = [NSString stringWithFormat:@"xx%02x%02x%02x%02x%02x",random()%256, random()%256, random()%256, random()%256, random()%256];
		}
		//save to file
		error = nil;
		[mac_address_string writeToFile:save_file atomically:YES encoding:NSUnicodeStringEncoding error:&error];
		if(error != nil){
			mac_address_string = NULL;
		}
	}
	
	return mac_address_string;
} */


@end
