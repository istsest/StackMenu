//
//  PCStackMenuItem.m
//  testStackMenu
//
//  Created by Joon on 13. 5. 30..
//  Copyright (c) 2013년 Joon. All rights reserved.
//

#import "PCStackMenuItem.h"
#import <QuartzCore/QuartzCore.h>

@interface PCStackMenuItem ()
{
	UIView					*_highlightView;
}

@end


@implementation PCStackMenuItem


- (BOOL)highlight
{
	return (_highlightView != nil);
}

- (void)setHighlight:(BOOL)highlight
{
	if(!highlight && _highlightView == nil)
		return;
	if(highlight && _highlightView != nil)
		return;
	
	if(highlight)
	{
		_highlightView = [[UIView alloc] initWithFrame:self.bounds];
		_highlightView.layer.cornerRadius = 10;
		_highlightView.layer.masksToBounds = YES;
		_highlightView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.2];
		[super addSubview:_highlightView];
	}
	else
	{
		[_highlightView removeFromSuperview];
		_highlightView = nil;
	}
}

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withImage:(UIImage *)image alignment:(UITextAlignment)alignment
{
    self = [self initWithFrame:frame];
    if (self)
	{
		CGRect rect = CGRectMake(alignment == UITextAlignmentLeft ? 0 : frame.size.width - frame.size.height, 0, frame.size.height, frame.size.height);
		_stackIimageView = [[UIImageView alloc] initWithFrame:rect];
		_stackIimageView.contentMode = UIViewContentModeScaleAspectFit;
		_stackIimageView.image = image;
		[self addSubview:_stackIimageView];

		rect = CGRectMake(alignment == UITextAlignmentRight ? 0 : frame.size.height + 5, 0, frame.size.width - frame.size.height - 5, frame.size.height - 4);
		_stackTitleLabel = [[UILabel alloc] initWithFrame:rect];
		_stackTitleLabel.textAlignment = alignment;
		_stackTitleLabel.font = [UIFont boldSystemFontOfSize:16];
		_stackTitleLabel.backgroundColor = [UIColor clearColor];
		_stackTitleLabel.textColor = [UIColor whiteColor];
		_stackTitleLabel.shadowColor = [UIColor darkGrayColor];
		_stackTitleLabel.shadowOffset = CGSizeMake(2, 2);
		_stackTitleLabel.text = title;
		CGSize labelSize = [title sizeWithFont:_stackTitleLabel.font];
		rect.size.width = labelSize.width + 10;
		_stackTitleLabel.frame = rect;
		[self addSubview:_stackTitleLabel];
		
		CGFloat width = labelSize.width + (_stackIimageView ? _stackIimageView.frame.size.width + 5 : 0);
		if(alignment == UITextAlignmentRight)
			frame.origin.x += (frame.size.width - width) - 4;
		frame.size.width = width + 8;
		self.frame = frame;

		rect = _stackIimageView.frame;
		rect.origin.x = alignment == UITextAlignmentLeft ? 0 : frame.size.width - frame.size.height;
		_stackIimageView.frame = rect;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
	{
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
    }
    return self;
}

CGAffineTransform CGAffineTransformMakeRotationAt(CGFloat angle, CGPoint pt)
{
    const CGFloat fx = pt.x;
    const CGFloat fy = pt.y;
    const CGFloat fcos = cos(angle);
    const CGFloat fsin = sin(angle);
    return CGAffineTransformMake(fcos, fsin, -fsin, fcos, fx - fx * fcos + fy * fsin, fy - fx * fsin - fy * fcos);
}

@end
