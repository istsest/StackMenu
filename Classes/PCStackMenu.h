//
//  PCStackMenu.h
//  testStackMenu
//
//  Created by Joon on 13. 5. 30..
//  Copyright (c) 2013년 Joon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCStackMenuItem.h"

typedef enum
{
	PCStackMenuDirectionClockWiseUp = 1,
	PCStackMenuDirectionClockWiseDown,
	PCStackMenuDirectionCounterClockWiseUp,
	PCStackMenuDirectionCounterClockWiseDown
} PCStackMenuDirection;

typedef void (^PCStackMenuBlock)(NSInteger selectedMenuIndex);

@interface PCStackMenu : UIView
{
	PCStackMenuBlock		_block;
}

@property (nonatomic, strong)	NSMutableArray		*items;


+ (PCStackMenu *)showStackMenuWithTitles:(NSArray *)titles
							  withImages:(NSArray *)images
							atStartPoint:(CGPoint)startPoint
								  inView:(UIView *)parent
							  itemHeight:(CGFloat)itemHeight
						   menuDirection:(PCStackMenuDirection)direction
							onSelectMenu:(PCStackMenuBlock)block;

- (PCStackMenu *)initWithTitles:(NSArray *)titles
					 withImages:(NSArray *)images
				   atStartPoint:(CGPoint)startPoint
						 inView:(UIView *)parent
					 itemHeight:(CGFloat)itemHeight
				  menuDirection:(PCStackMenuDirection)direction;

- (void)show:(PCStackMenuBlock)block;
- (void)dismiss;

@end
