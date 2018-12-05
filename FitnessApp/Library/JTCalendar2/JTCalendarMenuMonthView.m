//
//  JTCalendarMenuMonthView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMenuMonthView.h"

@interface JTCalendarMenuMonthView(){
    UILabel *textLabel;
}

@end

@implementation JTCalendarMenuMonthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    {
        textLabel = [UILabel new];
        [self addSubview:textLabel];
     
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
    }
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    textLabel.text = self.calendarManager.calendarAppearance.monthBlock(currentDate, self.calendarManager);
}

- (void)layoutSubviews
{
//    NSLog(@"%f",self.frame.size.width);
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width , self.frame.size.height);
   // textLabel.frame = CGRectMake(0, 0, self.frame.size.width + 20, self.frame.size.height);
    // No need to call [super layoutSubviews]
}

- (void)reloadAppearance
{//
    textLabel.textColor = [UIColor colorWithRed:95./256. green:95./256. blue:95./256. alpha:1];//self.calendarManager.calendarAppearance.menuMonthTextColor;//[UIColor colorWithRed:132/255 green:132/255 blue:132/255 alpha:1];//[UIColor whiteColor];//
    textLabel.font = self.calendarManager.calendarAppearance.menuMonthTextFont;
}

@end
