//
//  JTCalendarMonthWeekDaysView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMonthWeekDaysView.h"


@implementation JTCalendarMonthWeekDaysView

    UILabel *view;
NSString *day;
static NSArray *cacheDaysOfWeeks;

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
    for(NSString *day in [self daysOfWeek]){
        UILabel *view = [UILabel new];
        
        view.font = self.calendarManager.calendarAppearance.weekDayTextFont;
        view.textColor = self.calendarManager.calendarAppearance.weekDayTextColor;
        
        view.textAlignment = NSTextAlignmentCenter;
        view.text = day;
        
        [self addSubview:view];
    }
}
//when calendar will completely done then after i will set the navigation bar and all
- (NSArray *)daysOfWeek
{
    if(cacheDaysOfWeeks){
        return cacheDaysOfWeeks;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSMutableArray *days = nil;
    
    switch(self.calendarManager.calendarAppearance.weekDayFormat) {
        case JTCalendarWeekDayFormatSingle:
            days = [[dateFormatter veryShortStandaloneWeekdaySymbols] mutableCopy];
            break;
    case JTCalendarWeekDayFormatShort:
            days = [[dateFormatter shortStandaloneWeekdaySymbols] mutableCopy];
            break;
    case JTCalendarWeekDayFormatFull:
            days = [[dateFormatter standaloneWeekdaySymbols] mutableCopy];
            break;
    }
    
    for(NSInteger i = 0; i < days.count; ++i){
        NSString *day = days[i];
        [days replaceObjectAtIndex:i withObject:[day uppercaseString]];
    }
    
    // Redorder days for be conform to calendar
    {
        NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
        NSUInteger firstWeekday = (calendar.firstWeekday + 6) % 7; // Sunday == 1, Saturday == 7
        
        for(int i = 0; i < firstWeekday; ++i){
            id day = [days firstObject];
            [days removeObjectAtIndex:0];
            [days addObject:day];
        }
    }
    
    cacheDaysOfWeeks = days;
    
    return cacheDaysOfWeeks;
}

- (void)layoutSubviews
{
    CGFloat x = 0;
    CGFloat width = self.frame.size.width / 7.;
    CGFloat height = self.frame.size.height;
    
    if(self.calendarManager.calendarAppearance.readFromRightToLeft){
        for(UIView *view in [[self.subviews reverseObjectEnumerator] allObjects]){
            view.frame = CGRectMake(x, 0, width, height);
            x = CGRectGetMaxX(view.frame);
        }
    }
    else{
        for(UIView *view in self.subviews){
            view.frame = CGRectMake(x, 0, width, height);
            x = CGRectGetMaxX(view.frame);
        }
    }
    
    // No need to call [super layoutSubviews]
}

+ (void)beforeReloadAppearance
{
    cacheDaysOfWeeks = nil;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
//    NSLog(@"Date: %@", key);
    
    static NSDateFormatter *dateFormatter;
      dateFormatter = [NSDateFormatter new];
     dateFormatter.dateFormat = @"EEE";
    day = [dateFormatter stringFromDate:date];
//    NSLog(@"day..%@",day);

    
}


- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    
    return dateFormatter;
}


- (void)reloadAppearance
{
    for(int i = 0; i < self.subviews.count; ++i){
        view = [self.subviews objectAtIndex:i];
        
        view.font = self.calendarManager.calendarAppearance.weekDayTextFont;
        
        //weekDay Color(s,m...)
        view.textColor = [UIColor colorWithRed:148./256. green:148./256. blue:148./256. alpha:1.];//[UIColor whiteColor];//self.calendarManager.calendarAppearance.weekDayTextColor;
        
        
        
        if(i == 0)
        {
            view.text = @"Sun";
        }
        else if(i == 1)
        {
            view.text = @"Mon";
            
        }
        else if(i == 2)
        {
            view.text = @"Tue";
            
        }
        else if(i == 3)
        {
            view.text = @"Wed";
            
        }
        else if(i == 4)
        {
             view.text = @"Thu";
        }
        else if(i == 5)
        {
            view.text = @"Fri";
        }
        else
        {
            view.text = @"Sat";
        }

        
        if([view.text isEqualToString:day])
        {
            view.textColor = [UIColor greenColor];
        }
        
        
        
//        NSLog(@"view....%@",view.text);
    }
}

@end
