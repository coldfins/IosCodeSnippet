//
//  CustomAlertView.m
//  NearBy
//
//  Created by Coldfin Lab on 02/01/16.
//  Copyright (c) 2016 ved. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

-(void)awakeFromNib{
	NSLog(@"awake from nib set gesture");
    
    CATransition *transition = [CATransition animation];
    transition.type =kCATransitionFromTop;
    transition.duration = 2;
    transition.delegate = self;
    [self.layer addAnimation:transition forKey:nil];
    
    
    
	UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
																					  action:@selector(onClick_CloseView)];
	[self addGestureRecognizer:singleFingerTap];
	
}
-(id)init{
	self = [super init];
	if (self) {
		NSLog(@"set gesture");
		UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
										  action:@selector(onClick_CloseView)];
		[self addGestureRecognizer:singleFingerTap];
		
	}else{
	
	
	}
	
	return self;
}

-(id) initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
	}
	return self;
}

-(void) hideView:(BOOL)animated afterdelay:(NSInteger)delay{
	if (animated == YES) {
		
		[self fadeInAnimation:self withduration:delay];
		[self removeFromSuperview];
	}
}

-(void)fadeInAnimation:(UIView *)aView withduration:(NSInteger)delay{
	
	CATransition *transition = [CATransition animation];
	transition.type =kCATransitionFade;
	transition.duration = delay;
	transition.delegate = self;
	[aView.layer addAnimation:transition forKey:nil];
	
}
- (IBAction)onClick_closeView:(id)sender {
    [self onClick_CloseView];
}

-(void)onClick_CloseView{
	NSLog(@"tapped on view");
	CATransition *transition = [CATransition animation];
	transition.type =kCATransitionFade;
	transition.duration = 0.5;
	transition.delegate = self;
	[self.layer addAnimation:transition forKey:nil];
	[self removeFromSuperview];
}
@end
