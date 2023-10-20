//
//  NSAttributedString+Hyperlink.h
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

@interface NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL color:(NSColor*) linkcolor size:(CGFloat) textsize alignment:(NSTextAlignment) align;
-(id)appendWithString:(NSString*)inString size:(CGFloat) textsize align:(NSTextAlignment) align;

@end
