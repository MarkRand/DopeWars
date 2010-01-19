@import <AppKit/CPView.j>

@implementation PaneLayer : CALayer
{
    float       _rotationRadians;
    float       _scale;
    
    CPImage     _image;
    CALayer     _imageLayer;
    
    PageView    _pageView;
}

- (id)initWithPageView:(PageView)aPageView
{
    self = [super init];
    
    if (self)
    {
        _pageView = aPageView;
        
        _rotationRadians = 0.0;
        _scale = 1.0;
        
        _imageLayer = [CALayer layer];
        [_imageLayer setDelegate:self];
        
        [self addSublayer:_imageLayer];
    }
    
    return self;
}



- (PageView)pageView
{
    return _pageView;
}

- (void)setBounds:(CGRect)aRect
{
    [super setBounds:aRect];
    
    [_imageLayer setPosition:
        CGPointMake(CGRectGetMidX(aRect), 
        CGRectGetMidY(aRect))];
}

- (void)setImage:(CPImage)anImage
{
    if (_image == anImage)
        return;
    
    _image = anImage;
    
    if (_image)
        [_imageLayer setBounds:CGRectMake(0.0, 0.0, 
            [_image size].width, [_image size].height)];
    
    [_imageLayer setNeedsDisplay];
}

- (void)setRotationRadians:(float)radians
{
    if (_rotationRadians == radians)
        return;
        
    _rotationRadians = radians;
        
    [_imageLayer setAffineTransform:CGAffineTransformScale(
        CGAffineTransformMakeRotation(_rotationRadians), 
        _scale, _scale)];
}

- (void)setScale:(float)aScale
{
    if (_scale == aScale)
        return;
    
    _scale = aScale;
    
    [_imageLayer setAffineTransform:CGAffineTransformScale(
        CGAffineTransformMakeRotation(_rotationRadians), 
        _scale, _scale)];
}

- (void)drawInContext:(CGContext)aContext
{
    CGContextSetFillColor(aContext, [CPColor grayColor]);
    CGContextFillRect(aContext, [self bounds]);
}

- (void)imageDidLoad:(CPImage)anImage
{
    [_imageLayer setNeedsDisplay];
}

- (void)drawLayer:(CALayer)aLayer inContext:(CGContext)aContext
{
    var bounds = [aLayer bounds];
    
    if ([_image loadStatus] != 
        CPImageLoadStatusCompleted)
        [_image setDelegate:self];
    else
        CGContextDrawImage(aContext, bounds, _image);
}

@end


@implementation PageView : CPView
{
	CALayer _borderLayer;
    CALayer     _rootLayer;
    
    PaneLayer   _paneLayer;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        _rootLayer = [CALayer layer];
        
        [self setWantsLayer:YES];
        [self setLayer:_rootLayer];
        
        [_rootLayer setBackgroundColor:
            [CPColor whiteColor]];
        
        _paneLayer = [[PaneLayer alloc] 
            initWithPageView:self];
        
        [_paneLayer setBounds:CGRectMake(0, 0, 
            400 - 2 * 40, 400. - 2 * 40)];
        [_paneLayer setAnchorPoint:CGPointMakeZero()];
        [_paneLayer setPosition:CGPointMake(40, 40)];
        
        [_paneLayer setImage:[[CPImage alloc]
            initWithContentsOfFile:  
            @"Resources/sample.jpg" 
            size:CGSizeMake(500, 430)]];
        
        [_rootLayer addSublayer:_paneLayer];
		
		_borderLayer = [CALayer layer];

		[_borderLayer setAnchorPoint:CGPointMakeZero()];
		[_borderLayer setBounds:[self bounds]];
		[_borderLayer setDelegate:self];

		[_rootLayer addSublayer:_borderLayer];

        
        [_paneLayer setNeedsDisplay];
        
        [_rootLayer setNeedsDisplay];
    }
    
    return self;
}

	- (void)drawLayer:(CALayer)aLayer inContext:(CGContext)aContext
	{
		CGContextSetFillColor(aContext, [CPColor whiteColor]);

		var bounds = [aLayer bounds],
			width = CGRectGetWidth(bounds),
			height = CGRectGetHeight(bounds);

		CGContextFillRect(aContext, CGRectMake(0, 0, width, 40));
		CGContextFillRect(aContext, CGRectMake(0, 40, 
			40, height - 2 * 40));
		CGContextFillRect(aContext, CGRectMake(width - 40, 40, 
			40, height - 2 * 40));
		CGContextFillRect(aContext, CGRectMake(0, height - 40, 
			width, 40));
	}

	- (void)setEditing:(BOOL)isEditing
	{
		[_borderLayer setOpacity:isEditing ? 0.5 : 1.0];
	}

	- (void)mouseDown:(CPEvent)anEvent
	{
		if ([anEvent clickCount] == 2) 
		{
			[PhotoInspector inspectPaneLayer:_paneLayer];
		}
	}

	
@end


