//
//  ViewController.m
//  testStackMenu
//
//  Created by Joon on 13. 5. 30..
//  Copyright (c) 2013년 Joon. All rights reserved.
//

#import "ViewController.h"
#import "PCStackMenu.h"

@interface ViewController ()

- (IBAction)stackMenu:(id)sender;
- (IBAction)stackMenu2:(id)sender;
- (IBAction)stackMenu3:(id)sender;
- (IBAction)stackMenu4:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stackMenu:(id)sender
{
	UIButton *button = (UIButton *)sender;
	[PCStackMenu showStackMenuWithTitles:[NSArray arrayWithObjects:@"Setting", @"Search", @"Twitter", @"Message", @"Share", @"More ...", nil]
							  withImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"gear@2x.png"], [UIImage imageNamed:@"magnifier@2x.png"], [UIImage imageNamed:@"twitter@2x.png"], [UIImage imageNamed:@"speech@2x.png"], [UIImage imageNamed:@"actions@2x"], nil]
							atStartPoint:CGPointMake(button.frame.origin.x + button.frame.size.width, button.frame.origin.y)
								  inView:self.view
							  itemHeight:40
						   menuDirection:PCStackMenuDirectionClockWiseUp
							onSelectMenu:^(NSInteger selectedMenuIndex) {
											 NSLog(@"menu index : %d", selectedMenuIndex);
										 }];
}

- (IBAction)stackMenu2:(id)sender
{
	UIButton *button = (UIButton *)sender;
	PCStackMenu *stackMenu = [[PCStackMenu alloc] initWithTitles:[NSArray arrayWithObjects:@"Setting", @"Search", @"Twitter", @"Message", @"Share", @"More ...", nil]
													  withImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"gear@2x.png"], [UIImage imageNamed:@"magnifier@2x.png"], [UIImage imageNamed:@"twitter@2x.png"], [UIImage imageNamed:@"speech@2x.png"], [UIImage imageNamed:@"actions@2x"], nil]
													atStartPoint:CGPointMake(button.frame.origin.x, button.frame.origin.y)
														  inView:self.view
													  itemHeight:40
												   menuDirection:PCStackMenuDirectionCounterClockWiseUp];
	for(PCStackMenuItem *item in stackMenu.items)
		item.stackTitleLabel.textColor = [UIColor yellowColor];
				
	[stackMenu show:^(NSInteger selectedMenuIndex) {
		NSLog(@"menu index : %d", selectedMenuIndex);
	}];
}

- (IBAction)stackMenu3:(id)sender
{
	UIButton *button = (UIButton *)sender;
	PCStackMenu *stackMenu = [[PCStackMenu alloc] initWithTitles:[NSArray arrayWithObjects:@"Setting", @"Search", @"Twitter", @"Message", @"Share", @"More ...", nil]
													  withImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"gear@2x.png"], [UIImage imageNamed:@"magnifier@2x.png"], [UIImage imageNamed:@"twitter@2x.png"], [UIImage imageNamed:@"speech@2x.png"], [UIImage imageNamed:@"actions@2x"], nil]
													atStartPoint:CGPointMake(button.frame.origin.x, button.frame.origin.y + button.frame.size.height)
														  inView:self.view
													  itemHeight:40
												   menuDirection:PCStackMenuDirectionClockWiseDown];
	for(PCStackMenuItem *item in stackMenu.items)
		item.stackTitleLabel.textColor = [UIColor greenColor];
	
	[stackMenu show:^(NSInteger selectedMenuIndex) {
		NSLog(@"menu index : %d", selectedMenuIndex);
	}];
}

- (IBAction)stackMenu4:(id)sender
{
	UIButton *button = (UIButton *)sender;
	PCStackMenu *stackMenu = [[PCStackMenu alloc] initWithTitles:[NSArray arrayWithObjects:@"Setting", @"Search", @"Twitter", @"Message", @"Share", @"More ...", nil]
													  withImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"gear@2x.png"], [UIImage imageNamed:@"magnifier@2x.png"], [UIImage imageNamed:@"twitter@2x.png"], [UIImage imageNamed:@"speech@2x.png"], [UIImage imageNamed:@"actions@2x"], nil]
													atStartPoint:CGPointMake(button.frame.origin.x + button.frame.size.width, button.frame.origin.y + button.frame.size.height)
														  inView:self.view
													  itemHeight:40
												   menuDirection:PCStackMenuDirectionCounterClockWiseDown];
	for(PCStackMenuItem *item in stackMenu.items)
		item.stackTitleLabel.textColor = [UIColor cyanColor];
	
	[stackMenu show:^(NSInteger selectedMenuIndex) {
		NSLog(@"menu index : %d", selectedMenuIndex);
	}];
}

@end
