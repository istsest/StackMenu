//
//  PCStackMenuItem.h
//  testStackMenu
//
//  Created by Joon on 13. 5. 30..
//  Copyright (c) 2013년 Joon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCStackMenuItem : UIView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withImage:(UIImage *)image alignment:(UITextAlignment)alignment;

@property (nonatomic)				BOOL			highlight;

@property (nonatomic, readonly)		UILabel			*stackTitleLabel;
@property (nonatomic, readonly) 	UIImageView		*stackIimageView;

@end


CGAffineTransform CGAffineTransformMakeRotationAt(CGFloat angle, CGPoint pt);
