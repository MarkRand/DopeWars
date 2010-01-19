/*
 * AppController-DopeWars.j
 * DopeWars application
 *
 * Created by Mark Randall.
 * Copyright 2009, Mark Randall All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "DopeWarsUserInterface.j"

@implementation AppController : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{

	// Enable debug logging
	CPLogRegister(CPLogPopup);
	CPLog.trace("Start application");

    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

	[contentView setBackgroundColor:[CPColor blackColor]];
	
	var bounds = [contentView bounds],
		dopeWarsUserInterface = [[DopeWarsUserInterface alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds) / 2.0 - 200.0, CGRectGetHeight(bounds) / 2.0 - 200.0, 400.0, 400.0)];

	CPLog.trace(dopeWarsUserInterface) ;
    [dopeWarsUserInterface setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
	CPLog.trace(dopeWarsUserInterface);
	
    [contentView addSubview:dopeWarsUserInterface];

	[theWindow orderFront:self];

}


@end
