//
//  CustomAlertView.h
//  NearBy
//
//  Created by Coldfin Lab on 02/01/16.
//  Copyright (c) 2016 ved. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lbl_alertMessage;


-(void) hideView:(BOOL)animated afterdelay:(NSInteger)delay;
@end
