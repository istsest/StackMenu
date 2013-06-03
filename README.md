Stack Menu looks like Mac OS X.
==========================

<iframe width="420" height="315" src="http://www.youtube.com/embed/xwepfN18pjU" frameborder="0" allowfullscreen></iframe>

<pre><code>
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
</code></pre>
