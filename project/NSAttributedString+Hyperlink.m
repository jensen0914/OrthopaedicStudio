//
//  NSAttributedString+Hyperlink.m
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

#import "NSAttributedString+Hyperlink.h"


@implementation NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL color:(NSColor*) linkcolor size:(CGFloat) textsize alignment:(NSTextAlignment) align
{
	
		NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:inString];
		NSRange range = NSMakeRange(0, [attrString length]);
		
		[attrString beginEditing];
	
		NSMutableParagraphStyle* aMutableParagraphStyle =[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		//[aMutableParagraphStyle setAlignment:NSCenterTextAlignment];
		[aMutableParagraphStyle setAlignment:align];
		[attrString addAttribute:NSParagraphStyleAttributeName value:aMutableParagraphStyle range:range];
	
		[attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
		[attrString addAttribute:NSForegroundColorAttributeName value:linkcolor range:range];
		[attrString addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:range];
	
		[attrString addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:textsize] range:range];
		//[attrString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Lucida Grande" size:8.0] range:range];
	
		[aMutableParagraphStyle release];
	
		// How to show an underline?
		// [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
		
		//NSMutableParagraphStyle *truncateStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
		//[truncateStyle setLineBreakMode:NSLineBreakByTruncatingTail];
		//[attrString addAttribute:NSParagraphStyleAttributeName value:truncateStyle range:range];
		
		[attrString endEditing];
		
		return [attrString autorelease];
}


// för att detta ska funka måste väl typen vara mutable? Används denna funktion någonstans?
-(id)appendWithString:(NSString*)inString size:(CGFloat) textsize align:(NSTextAlignment) align
{
	NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:inString];
	NSRange range = NSMakeRange(0, [attrString length]);
	
	[attrString beginEditing];
	[attrString addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:textsize] range:range];
	
	NSMutableParagraphStyle* aMutableParagraphStyle =[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[aMutableParagraphStyle setAlignment:align];
	[attrString addAttribute:NSParagraphStyleAttributeName value:aMutableParagraphStyle range:range];
	
	[aMutableParagraphStyle release];
	[attrString endEditing];
	
	[self appendAttributedString:attrString];
	
	return self;
}
@end
