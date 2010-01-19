/*
 * DopeWarsUserInterface.j
 * Creates the user interface for the DopeWars game
 *
 * Created by Mark Randall.
 * Copyright 2009, Mark Randall All rights reserved.
 */
 
@implementation DopeWarsUserInterface : CPView
{
   var label;
   var _view ;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    { 
		CPLog.trace("Initialising dope wars UI with frame");
		
		label = [[CPTextField alloc] initWithFrame:CGRectMake(0,0,100,100)];
		[label setTextColor:[CPColor whiteColor]];
		[label setStringValue:@"Dope Wars!"];

		[self addSubview:label];

		var button = [[CPButton alloc] initWithFrame: CGRectMake(
						CGRectGetWidth([self bounds])/2.0 - 40,
						CGRectGetMaxY([label frame]) + 10,
						80, 24
					 )];

		[button setAutoresizingMask:CPViewMinXMargin | 
									CPViewMaxXMargin | 
									CPViewMinYMargin | 
									CPViewMaxYMargin];

		[button setTitle:"swap57"];

		[button setTarget:self];
		[button setAction:@selector(swap:)];                
					  
		[self addSubview:button];

		CPLog.trace("Added subview");
	}
	else
	{
		alert("Self is blank!") ;
	}
	
	return self ;
}

- (void)swap:(id)sender
{
    if ([label stringValue] == "Hello World!")
	{
        [label setStringValue:"Goodbye!"];
	}
    else
        [label setStringValue:"Hello World!"];
}

@end