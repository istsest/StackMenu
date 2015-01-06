//
//  PCStackMenu.m
//  testStackMenu
//
//  Created by Joon on 13. 5. 30..
//  Copyright (c) 2013년 Joon. All rights reserved.
//

#import "PCStackMenu.h"


typedef enum
{
	PCStackMenuClockDirectionClockWise = 1,
	PCStackMenuClockDirectionCounterClockWise
} PCStackMenuClockDirection;

typedef enum
{
	PCStackMenuClockAreaRight = 1,
	PCStackMenuClockAreaLeft
} PCStackMenuClockArea;

@interface PCStackMenu ()
{
	UIWindow				*_overlayWindow;
	NSMutableArray			*_items;
	PCStackMenuDirection	_menuDirection;
	
	CGPoint						_startPoint;
//	PCStackMenuClockDirection	_clockDirection;
	PCStackMenuClockArea		_clockArea;
}

@end

@implementation PCStackMenu


- (void)clearHighlightWithExcept:(PCStackMenuItem *)selectedItem
{
	for(PCStackMenuItem *item in _items)
		item.highlight = (item == selectedItem);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet			*allTouches = [event allTouches];
	NSArray			*touchs = [allTouches allObjects];
	UITouch			*touch = [touchs lastObject];
	
	if([allTouches count] == 1)
	{
		[self clearHighlightWithExcept:nil];
		PCStackMenuItem	*stackItem = nil;
		for(PCStackMenuItem *item in _items)
		{
			CGPoint point = [touch locationInView:item];
			if([item pointInside:point withEvent:event])
			{
				stackItem = item;
				[self clearHighlightWithExcept:item];
				break;
			}
		}
		if(stackItem)
			stackItem.highlight = YES;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet			*allTouches = [event allTouches];
	NSArray			*touchs = [allTouches allObjects];
	UITouch			*touch = [touchs lastObject];
	
	if([allTouches count] == 1)
	{
		PCStackMenuItem	*stackItem = nil;
		for(PCStackMenuItem *item in _items)
		{
			CGPoint point = [touch locationInView:item];
			if([item pointInside:point withEvent:event])
			{
				stackItem = item;
				[self clearHighlightWithExcept:item];
				break;
			}
		}
		if(stackItem)
		{
			[self clearHighlightWithExcept:stackItem];
			[self dismissWithSelect:stackItem];
		}
		else
		{
			[self clearHighlightWithExcept:nil];
			[self dismiss];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet				*allTouches = [event allTouches];
	NSArray				*touchs = [allTouches allObjects];
	UITouch				*touch = [touchs lastObject];
	
	if([allTouches count] == 1)
	{
		PCStackMenuItem	*stackItem = nil;
		for(PCStackMenuItem *item in _items)
		{
			CGPoint point = [touch locationInView:item];
			if([item pointInside:point withEvent:event])
			{
				stackItem = item;
				[self clearHighlightWithExcept:item];
				break;
			}
		}
		if(!stackItem)
			[self clearHighlightWithExcept:nil];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self clearHighlightWithExcept:nil];
}

- (CGRect)originalPositionforCircle:(CGRect)rect
{
	CGRect ret = rect;
	ret.origin.x = _menuDirection == PCStackMenuDirectionHalfCircleRightArea ? _startPoint.x - ret.size.width : _startPoint.x;
	ret.origin.y = _startPoint.y - ret.size.height / 2;
	return ret;
}

- (void)show:(PCStackMenuBlock)block
{
	_block = block;
	
	for(int i = 0; i < [_items count]; i++)
	{
		PCStackMenuItem *stackItem = [_items objectAtIndex:i];
		stackItem.hidden = NO;
		if(_menuDirection == PCStackMenuDirectionHalfCircleRightArea || _menuDirection == PCStackMenuDirectionHalfCircleLeftArea)
			stackItem.frame = [self originalPositionforCircle:stackItem.frame];
	}
	
    [UIView animateWithDuration:0.2 animations:^{
		for(int i = 0; i < [_items count]; i++)
		{
			PCStackMenuItem *stackItem = [_items objectAtIndex:i];
			CGRect r = stackItem.frame;
			if(_menuDirection == PCStackMenuDirectionHalfCircleRightArea ||_menuDirection == PCStackMenuDirectionHalfCircleLeftArea)
			{
				r.origin.x = (_clockArea == PCStackMenuClockAreaLeft) ? _startPoint.x - r.size.width : _startPoint.x;
				r.origin.y += (int)(i - [_items count] / 2) * r.size.height;
				if([_items count] % 2 == 0)
					r.origin.y += r.size.height / 2;
			}
			else if(_menuDirection == PCStackMenuDirectionClockWiseUp || _menuDirection == PCStackMenuDirectionCounterClockWiseUp)
			{
				r.origin.y += i * r.size.height * -1;
			}
			else
			{
				r.origin.y += i * r.size.height * 1;
			}
			stackItem.frame = r;
			CGPoint point = [self centerPointForRotation:stackItem];
			if(_menuDirection == PCStackMenuDirectionHalfCircleRightArea)
				stackItem.transform = CGAffineTransformMakeRotationAt((int)(i - [_items count] / 2) * 6 * M_PI / 180, point);
			else if(_menuDirection == PCStackMenuDirectionHalfCircleLeftArea)
				stackItem.transform = CGAffineTransformMakeRotationAt((int)(i - [_items count] / 2) * -6 * M_PI / 180, point);
			else if(_menuDirection == PCStackMenuDirectionClockWiseUp || _menuDirection == PCStackMenuDirectionClockWiseDown)
				stackItem.transform = CGAffineTransformMakeRotationAt(i * 2 * M_PI / 180, point);
			else
				stackItem.transform = CGAffineTransformMakeRotationAt(i * -2 * M_PI / 180, point);
			stackItem.alpha = 1.0;
		}
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissWithSelect:(PCStackMenuItem *)selectedItem
{
	int selectedIndex = (int)[_items indexOfObject:selectedItem];
	selectedItem.highlight = YES;
	
    [UIView animateWithDuration:0.1 animations:^{
		CGRect r;
		for(int i = 0; i < [_items count]; i++)
		{
			PCStackMenuItem *stackItem = [_items objectAtIndex:i];
			if(i == 0)
				r = stackItem.frame;
			if(selectedItem != stackItem)
			{
				CGPoint point = [self centerPointForRotation:stackItem];
				stackItem.transform = CGAffineTransformMakeRotationAt(0 * M_PI / 180, point);
				if(_menuDirection == PCStackMenuDirectionHalfCircleRightArea || _menuDirection == PCStackMenuDirectionHalfCircleLeftArea)
					r = [self originalPositionforCircle:r];
				stackItem.frame = r;
				stackItem.alpha = 0.2;
			}
		}
    } completion:^(BOOL finished) {
		for(int i = 0; i < [_items count]; i++)
		{
			PCStackMenuItem *stackItem = [_items objectAtIndex:i];
			if(selectedItem != stackItem)
				stackItem.hidden = YES;
		}
		[UIView animateWithDuration:0.2 animations:^{
			PCStackMenuItem *stackItem = [_items objectAtIndex:selectedIndex];
			CGRect r = ((UIView *)[_items objectAtIndex:0]).frame;
			if(selectedItem == stackItem)
			{
				CGPoint point = [self centerPointForRotation:stackItem];
				stackItem.transform = CGAffineTransformMakeRotationAt(0 * M_PI / 180, point);
				if(_menuDirection == PCStackMenuDirectionHalfCircleRightArea || _menuDirection == PCStackMenuDirectionHalfCircleLeftArea)
					r = [self originalPositionforCircle:r];
				stackItem.frame = r;
				stackItem.alpha = 0.5;
			}
		} completion:^(BOOL finished) {
			if(_block)
				_block(selectedIndex);
			[self releaseMenu];
		}];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
		CGRect r;
		for(int i = 0; i < [_items count]; i++)
		{
			PCStackMenuItem *stackItem = [_items objectAtIndex:i];
			if(i == 0)
				r = stackItem.frame;
			CGPoint point = [self centerPointForRotation:stackItem];
			stackItem.transform = CGAffineTransformMakeRotationAt(0 * M_PI / 180, point);
			if(_menuDirection == PCStackMenuDirectionHalfCircleRightArea || _menuDirection == PCStackMenuDirectionHalfCircleLeftArea)
				r = [self originalPositionforCircle:r];
			stackItem.frame = r;
			stackItem.alpha = 0.2;
		}
    } completion:^(BOOL finished) {
		[self releaseMenu];
    }];
}

- (void)releaseMenu
{
	_block = nil;
	_overlayWindow = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (PCStackMenu *)showStackMenuWithTitles:(NSArray *)titles
							  withImages:(NSArray *)images
							atStartPoint:(CGPoint)startPoint
								  inView:(UIView *)parent
							  itemHeight:(CGFloat)itemHeight
						   menuDirection:(PCStackMenuDirection)direction
							onSelectMenu:(PCStackMenuBlock)block
{
	PCStackMenu *stackMenu = [[PCStackMenu alloc] initWithTitles:titles withImages:images atStartPoint:startPoint inView:parent itemHeight:itemHeight menuDirection:direction];
	[stackMenu show:block];
	return stackMenu;
}

- (PCStackMenu *)initWithTitles:(NSArray *)titles
					 withImages:(NSArray *)images
				   atStartPoint:(CGPoint)startPoint
						 inView:(UIView *)parent
					 itemHeight:(CGFloat)itemHeight
				  menuDirection:(PCStackMenuDirection)direction
{
	CGRect rect = [UIScreen mainScreen].bounds;
	self = [self initWithFrame:rect];
	
	_menuDirection = direction;
	_startPoint = [self convertPoint:startPoint fromView:parent];
//	_clockDirection	=	(	direction == PCStackMenuDirectionClockWiseUp ||
//							direction == PCStackMenuDirectionClockWiseDown ||
//							direction == PCStackMenuDirectionHalfCircleLeftArea) ?
//						PCStackMenuClockDirectionClockWise : PCStackMenuClockDirectionCounterClockWise;
	
	_clockArea		=	(	direction == PCStackMenuDirectionClockWiseUp ||
							direction == PCStackMenuDirectionCounterClockWiseDown ||
							direction == PCStackMenuDirectionHalfCircleLeftArea) ?
						PCStackMenuClockAreaLeft : PCStackMenuClockAreaRight;
	
	int max = (int)MAX([titles count], [images count]);
	for(int i = 0; i < max; i++)
	{
		CGFloat y = 0;
		if(direction == PCStackMenuDirectionHalfCircleRightArea || direction == PCStackMenuDirectionHalfCircleLeftArea)
			y = -itemHeight / 2;
		else if(direction == PCStackMenuDirectionClockWiseUp || direction == PCStackMenuDirectionCounterClockWiseUp)
			y = -itemHeight;
		CGPoint point = CGPointMake((_clockArea == PCStackMenuClockAreaLeft) ? 0 : startPoint.x, startPoint.y + y);
		CGSize size = CGSizeMake((_clockArea == PCStackMenuClockAreaLeft) ? startPoint.x : self.frame.size.width - startPoint.x,
								 itemHeight);
		CGRect r = CGRectMake(point.x, point.y, size.width, size.height);
		r = [self convertRect:r fromView:parent];
		NSString *title = (i < [titles count]) ? [titles objectAtIndex:i] : @"";
		UIImage *image = (i < [images count]) ? [images objectAtIndex:i] : nil;
		
		NSTextAlignment alignment = (_clockArea == PCStackMenuClockAreaRight) ? NSTextAlignmentLeft : NSTextAlignmentRight;
		PCStackMenuItem *stackItem = [[PCStackMenuItem alloc] initWithFrame:r withTitle:title withImage:image alignment:alignment];
		
		if(direction == PCStackMenuDirectionClockWiseUp || direction == PCStackMenuDirectionCounterClockWiseUp)
			stackItem.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
		else
			stackItem.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
//		if(_clockArea == PCStackMenuClockAreaRight)
//			stackItem.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin;
//		else
//			stackItem.autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
		
		stackItem.alpha = 0.5;
		stackItem.hidden = YES;
		[self addSubview:stackItem];
		[_items addObject:stackItem];
	}
		
	return self;
}

- (CGPoint)centerPointForRotation:(PCStackMenuItem *)item
{
	if(_menuDirection == PCStackMenuDirectionHalfCircleRightArea || _menuDirection == PCStackMenuDirectionHalfCircleLeftArea)
		return [item convertPoint:_startPoint fromView:self];

	CGFloat x = _menuDirection == PCStackMenuDirectionClockWiseUp || _menuDirection == PCStackMenuDirectionCounterClockWiseDown ? self.frame.size.width : -self.frame.size.width;
	CGFloat y = _menuDirection == PCStackMenuDirectionClockWiseDown || _menuDirection == PCStackMenuDirectionCounterClockWiseDown ? -item.frame.origin.y : self.frame.size.height - item.frame.origin.y;
	return CGPointMake(x, y);
}


- (void)statusBarFrameOrOrientationChanged:(NSNotification *)notification
{
    [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
}

- (void)rotateAccordingToStatusBarOrientationAndSupportedOrientations
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat angle = UIInterfaceOrientationAngleOfOrientation(statusBarOrientation);
    CGFloat statusBarHeight = [[self class] getStatusBarHeight];
	
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    CGRect frame = [[self class] rectInWindowBounds:self.window.bounds statusBarOrientation:statusBarOrientation statusBarHeight:statusBarHeight];
	
    [self setIfNotEqualTransform:transform frame:frame];
}

- (void)setIfNotEqualTransform:(CGAffineTransform)transform frame:(CGRect)frame
{
    if(!CGAffineTransformEqualToTransform(self.transform, transform))
    {
        self.transform = transform;
    }
    if(!CGRectEqualToRect(self.frame, frame))
    {
        self.frame = frame;
    }
}

+ (CGFloat)getStatusBarHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        return [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    else
    {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (CGRect)rectInWindowBounds:(CGRect)windowBounds statusBarOrientation:(UIInterfaceOrientation)statusBarOrientation statusBarHeight:(CGFloat)statusBarHeight
{
    CGRect frame = windowBounds;
    frame.origin.x += statusBarOrientation == UIInterfaceOrientationLandscapeLeft ? statusBarHeight : 0;
    frame.origin.y += statusBarOrientation == UIInterfaceOrientationPortrait ? statusBarHeight : 0;
    frame.size.width -= UIInterfaceOrientationIsLandscape(statusBarOrientation) ? statusBarHeight : 0;
    frame.size.height -= UIInterfaceOrientationIsPortrait(statusBarOrientation) ? statusBarHeight : 0;
    return frame;
}

CGFloat UIInterfaceOrientationAngleOfOrientation(UIInterfaceOrientation orientation)
{
    CGFloat angle;
	
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            angle = 0.0;
            break;
    }
	
    return angle;
}

UIInterfaceOrientationMask UIInterfaceOrientationMaskFromOrientation(UIInterfaceOrientation orientation)
{
    return 1 << orientation;
}

- (void)createOverlayWindow
{
	CGRect rect = [UIScreen mainScreen].bounds;
	_overlayWindow = [[UIWindow alloc] initWithFrame:rect];
	_overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_overlayWindow.backgroundColor = [UIColor clearColor];
	
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	[_overlayWindow makeKeyAndVisible];
	[_overlayWindow addSubview:self];
	
	[self statusBarFrameOrOrientationChanged:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if(self)
	{
		_items = [[NSMutableArray alloc] init];
		self.backgroundColor = [UIColor clearColor];
		[self createOverlayWindow];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		_items = [[NSMutableArray alloc] init];
		self.backgroundColor = [UIColor clearColor];
		[self createOverlayWindow];
    }
    return self;
}

@end
