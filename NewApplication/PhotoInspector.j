@import <AppKit/CPPanel.j>
@import <AppKit/CPWindowController.j>
@import "PageView.j"

var PhotoInspectorSharedInstance    = nil;

@implementation PhotoInspector : CPWindowController
{
    CPSlider    _scaleSlider;
    CPSlider    _rotationSlider;
    
    PaneLayer   _paneLayer;
}

+ (PhotoInspector)sharedPhotoInspector
{
    if (!PhotoInspectorSharedInstance)
        PhotoInspectorSharedInstance = [[PhotoInspector alloc] init];
    
    return PhotoInspectorSharedInstance;
}


- (id)init
{
    var theWindow = [[CPPanel alloc]
        initWithContentRect:CGRectMake(0, 0, 225, 125) 
        styleMask:CPHUDBackgroundWindowMask | CPClosableWindowMask];
        
    self = [super initWithWindow:theWindow];
    
    if (self)
    {
        [theWindow setTitle:@"Inspector"];
        [theWindow setFloatingPanel:YES];
		
		[theWindow setDelegate:self];
        
        var contentView = [theWindow contentView],
            centerX = (CGRectGetWidth([contentView bounds]) - 135) / 2;
        
        scaleSlider = [[CPSlider alloc]
            initWithFrame:CGRectMake(centerX, 13, 135, 16)];
        
        [scaleSlider setMinValue:50];
        [scaleSlider setMaxValue:150];
        [scaleSlider setValue:100];
        
		[scaleSlider setTarget:self];
		[scaleSlider setAction:@selector(scale:)];

        [contentView addSubview:scaleSlider];
        
        var scaleStartLabel = [self labelWithTitle:"50%"],
            scaleEndLabel = [self labelWithTitle:"150%"];
        
        [scaleStartLabel setFrameOrigin:CGPointMake(centerX - 
            CGRectGetWidth([scaleStartLabel frame]), 10)];
        [scaleEndLabel setFrameOrigin:
            CGPointMake(CGRectGetMaxX([scaleSlider frame]), 10)];
        
        [contentView addSubview:scaleStartLabel];
        [contentView addSubview:scaleEndLabel];
        
        rotationSlider = [[CPSlider alloc]
            initWithFrame:CGRectMake(centerX, 43, 135, 16)];
        
        [rotationSlider setMinValue:0];
        [rotationSlider setMaxValue:360];
        [rotationSlider setValue:0];
        
        [contentView addSubview:rotationSlider];
		
		[rotationSlider setTarget:self];
		[rotationSlider setAction:@selector(rotate:)];


        var rotationStartLabel = [self labelWithTitle:"0\u00B0"],
            rotationEndLabel = [self labelWithTitle:"360\u00B0"];
        
        [rotationStartLabel setFrameOrigin:CGPointMake(centerX - 
            CGRectGetWidth([rotationStartLabel frame]), 40)];
        [rotationEndLabel setFrameOrigin:
            CGPointMake(CGRectGetMaxX([rotationSlider frame]), 40)];
    
        [contentView addSubview:rotationStartLabel];
        [contentView addSubview:rotationEndLabel];
    }
    
    return self;
}

- (CPTextField)labelWithTitle:(CPString)aTitle
{
    var label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    
    [label setStringValue:aTitle];
    [label setTextColor:[CPColor whiteColor]];
    
    [label sizeToFit];

    return label;
}

- (void)scale:(id)aSender
{
    [_paneLayer setScale:[aSender value] / 100.0];
}

- (void)rotate:(id)aSender
{
    [_paneLayer setRotationRadians:PI / 180 * [aSender value]];
}

+ (void)inspectPaneLayer:(PaneLayer)anPaneLayer
{
    var inspector = [self sharedPhotoInspector];
    [inspector setPaneLayer:anPaneLayer];
    
    [inspector showWindow:self];
}

- (void)windowWillClose:(id)aSender
{
    [self setPaneLayer:nil];
}

- (void)setPaneLayer:(PaneLayer)anPaneLayer
{
    if (_paneLayer == anPaneLayer)
        return;
        
    [[_paneLayer pageView] setEditing:NO];
    
    _paneLayer = anPaneLayer;
    
    var page = [_paneLayer pageView];
    
    [page setEditing:YES];
    
    if (_paneLayer)
    {
        var frame = [page convertRect:[page bounds] toView:nil],
            windowSize = [[self window] frame].size;
        
        [[self window] setFrameOrigin:
            CGPointMake(CGRectGetMidX(frame) - 
            windowSize.width / 2.0, CGRectGetMidY(frame))];
    }
}
@end
