//
//  GetPrimaryMACAddress.h
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


#define MAC_FILE	 @"x.orthomac"

@interface MACAddressManager : NSObject {

}

- (int)getPrimaryMACAddress:(UInt8 *) mac_address;
- (NSString*)getBestMACAddress:(NSString *) save_path;

@end
