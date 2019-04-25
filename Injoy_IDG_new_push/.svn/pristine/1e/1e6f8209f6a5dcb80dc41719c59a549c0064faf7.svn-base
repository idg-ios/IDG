//
//  VRGCalendarView.m
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "VRGCalendarView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+convenience.h"
#import "NSMutableArray+convenience.h"
#import "UIView+convenience.h"
#import "LunarCalendar.h"
#import "CYDatetime.h"
#import "NSDate+YYAdd.h"

@implementation VRGCalendarView
@synthesize currentMonth, delegate, labelCurrentMonth, animationView_A, animationView_B;
@synthesize markedDates, markedColors, calendarHeight, selectedDate;

#pragma mark - Select Date
#pragma mark 获取日期的相关信息

- (NSString *)readyDatabase:(NSString *)dbName {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSLog(@"%@", KNetworkFailRemind);
        }
    }
    return writableDBPath;
}

- (void)selectDate:(int)date {
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber10_8) {
        comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.currentMonth];
    } else {
        comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.currentMonth];
    }
    [comps setDay:date];
    self.selectedDate = [gregorian dateFromComponents:comps];

    int selectedDateYear = [selectedDate year];
    int selectedDateMonth = [selectedDate month];
    int currentMonthYear = [currentMonth year];
    int currentMonthMonth = [currentMonth month];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    labelCurrentMonth.text = [formatter stringFromDate:self.selectedDate];
    [labelCurrentMonth setFont:[UIFont boldSystemFontOfSize:17.f]];
    [labelCurrentMonth sizeToFit];

    if (selectedDateYear < currentMonthYear) {
        [self showPreviousMonth];
    } else if (selectedDateYear > currentMonthYear) {
        [self showNextMonth];
    } else if (selectedDateMonth < currentMonthMonth) {
        [self showPreviousMonth];
    } else if (selectedDateMonth > currentMonthMonth) {
        [self showNextMonth];
    } else {
        [self setNeedsDisplay];
    }

    CYDatetime *CYDate = [[[CYDatetime alloc] init] autorelease];
    CYDate.year = [selectedDate year];
    CYDate.month = [selectedDate month];
    CYDate.day = [selectedDate day];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    //每周的第一天从星期一开始
    [calendar setFirstWeekday:1];


    if ([delegate respondsToSelector:@selector(calendarView:dateSelected:lunarDict:)]) {
        [delegate calendarView:self dateSelected:self.selectedDate lunarDict:nil];
    }
}

#pragma mark - Mark Dates

//NSArray can either contain NSDate objects or NSNumber objects with an int of the day.
- (void)markDates:(NSArray *)dates {
    self.markedDates = dates;
    NSMutableArray *colors = [[NSMutableArray alloc] init];

    for (int i = 0; i < [dates count]; i++) {
        [colors addObject:[UIColor redColor]];
    }

    self.markedColors = [NSArray arrayWithArray:colors];
    [colors release];

    [self setNeedsDisplay];
}

//NSArray can either contain NSDate objects or NSNumber objects with an int of the day.
- (void)markDates:(NSArray *)dates withColors:(NSArray *)colors {
    self.markedDates = dates;
    self.markedColors = colors;

    [self setNeedsDisplay];
}

#pragma mark - Set date to now

- (void)reset {
    NSCalendar *gregorian = [[[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *components =
            [gregorian               components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                    NSDayCalendarUnit) fromDate:[NSDate date]];
    self.currentMonth = [gregorian dateFromComponents:components]; //clean month

    [self updateSize];
    [self setNeedsDisplay];
    [delegate calendarView:self switchedToMonth:[currentMonth month] toYear:[currentMonth year] targetHeight:self.calendarHeight animated:NO];

    [self selectDate:[NSDate date].day];
}

#pragma mark - function

- (void)selectCurrentDate {
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber10_8) {
        comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    } else {
        comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    }
    [comps setDay:NSDate.date.day];
    self.selectedDate = [gregorian dateFromComponents:comps];

    int selectedDateYear = [selectedDate year];
    int selectedDateMonth = [selectedDate month];
    int currentMonthYear = [currentMonth year];
    int currentMonthMonth = [currentMonth month];

    if (selectedDateYear < currentMonthYear) {
        [self showPreviousMonth];
    } else if (selectedDateYear > currentMonthYear) {
        [self showNextMonth];
    } else if (selectedDateMonth < currentMonthMonth) {
        [self showPreviousMonth];
    } else if (selectedDateMonth > currentMonthMonth) {
        [self showNextMonth];
    } else {
        [self setNeedsDisplay];
    }

    CYDatetime *CYDate = [[[CYDatetime alloc] init] autorelease];
    CYDate.year = [selectedDate year];
    CYDate.month = [selectedDate month];
    CYDate.day = [selectedDate day];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    //每周的第一天从星期一开始
    [calendar setFirstWeekday:1];
}

#pragma mark - Next & Previous

- (void)showNextMonth {
    if (isAnimating) return;
    self.markedDates = nil;
    isAnimating = YES;
    prepAnimationNextMonth = YES;

    [self setNeedsDisplay];

    int lastBlock = [currentMonth firstWeekDayInMonth] + [currentMonth numDaysInMonth] - 1;
    int numBlocks = [self numRows] * 7;
    BOOL hasNextMonthDays = lastBlock < numBlocks;

    //Old month
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];

    //New month
    self.currentMonth = [currentMonth offsetMonth:1];
    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:toYear:targetHeight: animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] toYear:[currentMonth year] targetHeight:self.calendarHeight animated:YES];
    prepAnimationNextMonth = NO;
    [self setNeedsDisplay];

    UIImage *imageNextMonth = [self drawCurrentState];
    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kVRGCalendarViewTopBarHeight, kVRGCalendarViewWidth, targetSize - kVRGCalendarViewTopBarHeight)];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];

    //Animate
    animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    animationView_B = [[UIImageView alloc] initWithImage:imageNextMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    [animationHolder release];

    if (hasNextMonthDays) {
        animationView_B.frameY = animationView_A.frameY + animationView_A.frameHeight - (kVRGCalendarViewDayHeight + 3);
    } else {
        animationView_B.frameY = animationView_A.frameY + animationView_A.frameHeight - 3;
    }

    //Animation
    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:.35
                     animations:^{
                         [self updateSize];
                         //blockSafeSelf.frameHeight = 100;
                         if (hasNextMonthDays) {
                             animationView_A.frameY = -animationView_A.frameHeight + kVRGCalendarViewDayHeight + 3;
                         } else {
                             animationView_A.frameY = -animationView_A.frameHeight + 3;
                         }
                         animationView_B.frameY = 0;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         blockSafeSelf.animationView_A = nil;
                         blockSafeSelf.animationView_B = nil;
                         isAnimating = NO;
                         [animationHolder removeFromSuperview];
                     }
    ];
}

- (void)showPreviousMonth {
    if (isAnimating) return;
    isAnimating = YES;
    self.markedDates = nil;
    //Prepare current screen
    prepAnimationPreviousMonth = YES;
    [self setNeedsDisplay];
    BOOL hasPreviousDays = [currentMonth firstWeekDayInMonth] > 1;
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];

    //Prepare next screen
    self.currentMonth = [currentMonth offsetMonth:-1];
    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:toYear:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] toYear:[currentMonth year] targetHeight:self.calendarHeight animated:YES];
    prepAnimationPreviousMonth = NO;
    [self setNeedsDisplay];
    UIImage *imagePreviousMonth = [self drawCurrentState];

    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kVRGCalendarViewTopBarHeight, kVRGCalendarViewWidth, targetSize - kVRGCalendarViewTopBarHeight)];

    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];

    animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    [animationHolder release];

    if (hasPreviousDays) {
        animationView_B.frameY = animationView_A.frameY - (animationView_B.frameHeight - kVRGCalendarViewDayHeight) + 3;
    } else {
        animationView_B.frameY = animationView_A.frameY - animationView_B.frameHeight + 3;
    }

    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:.35
                     animations:^{
                         [self updateSize];

                         if (hasPreviousDays) {
                             animationView_A.frameY = animationView_B.frameHeight - (kVRGCalendarViewDayHeight + 3);

                         } else {
                             animationView_A.frameY = animationView_B.frameHeight - 3;
                         }

                         animationView_B.frameY = 0;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         blockSafeSelf.animationView_A = nil;
                         blockSafeSelf.animationView_B = nil;
                         isAnimating = NO;
                         [animationHolder removeFromSuperview];
                     }
    ];
}


#pragma mark - update size & row count

- (void)updateSize {
    self.frameHeight = self.calendarHeight;
    [self setNeedsDisplay];
}

- (float)calendarHeight {
    return kVRGCalendarViewTopBarHeight + [self numRows] * (kVRGCalendarViewDayHeight + 2) + 1;
}

- (int)numRows {
    float lastBlock = [self.currentMonth numDaysInMonth] + ([self.currentMonth firstWeekDayInMonth]);
    return ceilf(lastBlock / 7);
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];

//    self.selectedDate=nil;

    //Touch a specific day
    if (touchPoint.y > kVRGCalendarViewTopBarHeight) {
        float xLocation = touchPoint.x;
        float yLocation = touchPoint.y - kVRGCalendarViewTopBarHeight;

        int column;
        int row;

//        if (_isFromCXSignIN)
//        {
//            column = floorf(xLocation/(kVRGCalendarViewSignINDayWidth+((Screen_Width - 2*kMiddleMarginWidth)/4*3-310.0/4*3)/6.0));
//            row = floorf(yLocation/(kVRGCalendarViewDayHeight+2));
//        }else
//        {
        column = floorf(xLocation / (kVRGCalendarViewDayWidth + (kVRGCalendarViewWidth - 320) / 6.0 + 2));
        row = floorf(yLocation / (kVRGCalendarViewDayHeight + 2));
//        }

        int blockNr = (column + 1) + row * 7;
        int firstWeekDay = [self.currentMonth firstWeekDayInMonth]; //-1 because weekdays begin at 1, not 0
        int date = blockNr - firstWeekDay;
        [self selectDate:date];
        return;
    }

    self.markedDates = nil;
    self.markedColors = nil;

    CGRect rectArrowLeft;
    if (_isFromAttendance) {
        rectArrowLeft = CGRectMake(self.frame.size.width / 2.0, 0, 50, 40);
    } else {
        rectArrowLeft = CGRectMake(0, 0, 50, 40);
    }

    CGRect rectArrowRight = CGRectMake(self.frame.size.width - 50, 0, 50, 40);

    //Touch either arrows or month in middle
    if (CGRectContainsPoint(rectArrowLeft, touchPoint)) {
        [self showPreviousMonth];
    } else if (CGRectContainsPoint(rectArrowRight, touchPoint)) {
        [self showNextMonth];
    } else if (CGRectContainsPoint(self.labelCurrentMonth.frame, touchPoint)) {
        //Detect touch in current month
        int currentMonthIndex = [self.currentMonth month];
        int todayMonth = [[NSDate date] month];
        [self reset];
        if ((todayMonth != currentMonthIndex) && [delegate respondsToSelector:@selector(calendarView:switchedToMonth:toYear:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] toYear:[currentMonth year] targetHeight:self.calendarHeight animated:NO];
    }
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {

//    if (_isFromCXSignIN)
//    {
//#undef kVRGCalendarViewTopBarHeight
//#define kVRGCalendarViewTopBarHeight 30
//    }
    int firstWeekDay = [self.currentMonth firstWeekDayInMonth]; //-1 because weekdays begin at 1, not 0

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    labelCurrentMonth.text = [formatter stringFromDate:self.currentMonth];
    [labelCurrentMonth setFont:[UIFont boldSystemFontOfSize:17.f]];
    [labelCurrentMonth sizeToFit];
//    日历 考勤  行程
    if (_isFromAttendance) {
        labelCurrentMonth.frameX = roundf(self.frame.size.width * 3 / 4.0 - labelCurrentMonth.frameWidth / 2);
    } else if (_isFromCXSignIN) {
        [labelCurrentMonth removeFromSuperview];
    } else {
        labelCurrentMonth.frameX = roundf(self.frame.size.width / 2.0 - labelCurrentMonth.frameWidth / 2);
    }

    labelCurrentMonth.frameY = 10;
    [formatter release];
    [currentMonth firstWeekDayInMonth];

    CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect rectangle = CGRectMake(0, 0, self.frame.size.width, kVRGCalendarViewTopBarHeight);
    CGContextAddRect(context, rectangle);
    if (_isFromCXSignIN) {
        if (Layer_Normal) {
            CGContextSetFillColorWithColor(context, KSelectedBackgroudColor.CGColor);
        } else if (Layer_Management || Layer_Secretary) {
            CGContextSetFillColorWithColor(context, kMangermentTableColor.CGColor);
        } else if (Layer_Leader) {
            CGContextSetFillColorWithColor(context, kLeaderColor1.CGColor);
        }

    } else {
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }

    CGContextFillPath(context);

    //Arrows
    int arrowSize = 12;
    int xmargin = 20;
    int ymargin = 18;

    //Arrow Left
//    日历  考勤  行程

    if (_isFromAttendance) {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, self.frame.size.width / 2.0 + xmargin + arrowSize / 1.5, ymargin - 4);
        CGContextAddLineToPoint(context, self.frame.size.width / 2.0 + xmargin + arrowSize / 1.5, ymargin + arrowSize - 4);
        CGContextAddLineToPoint(context, self.frame.size.width / 2.0 + xmargin, ymargin + arrowSize / 2 - 4);
        CGContextAddLineToPoint(context, self.frame.size.width / 2.0 + xmargin + arrowSize / 1.5, ymargin - 4);
        CGContextSetFillColorWithColor(context,
                [UIColor blackColor].CGColor);
        CGContextFillPath(context);
    } else if (_isFromCXSignIN) {

    } else {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, xmargin + arrowSize / 1.5, ymargin);
        CGContextAddLineToPoint(context, xmargin + arrowSize / 1.5, ymargin + arrowSize);
        CGContextAddLineToPoint(context, xmargin, ymargin + arrowSize / 2);
        CGContextAddLineToPoint(context, xmargin + arrowSize / 1.5, ymargin);
        CGContextSetFillColorWithColor(context,
                [UIColor blackColor].CGColor);
        CGContextFillPath(context);
    }

    //Arrow right
    CGContextBeginPath(context);
    if (_isFromAttendance) {
        CGContextMoveToPoint(context, self.frame.size.width - (xmargin + arrowSize / 1.5), ymargin - 4);
        CGContextAddLineToPoint(context, self.frame.size.width - xmargin, ymargin + arrowSize / 2 - 4);
        CGContextAddLineToPoint(context, self.frame.size.width - (xmargin + arrowSize / 1.5), ymargin + arrowSize - 4);
        CGContextAddLineToPoint(context, self.frame.size.width - (xmargin + arrowSize / 1.5), ymargin - 4);
    } else if (_isFromCXSignIN) {

    } else {
        CGContextMoveToPoint(context, self.frame.size.width - (xmargin + arrowSize / 1.5), ymargin);
        CGContextAddLineToPoint(context, self.frame.size.width - xmargin, ymargin + arrowSize / 2);
        CGContextAddLineToPoint(context, self.frame.size.width - (xmargin + arrowSize / 1.5), ymargin + arrowSize);
        CGContextAddLineToPoint(context, self.frame.size.width - (xmargin + arrowSize / 1.5), ymargin);
    }


    CGContextSetFillColorWithColor(context,
            [UIColor blackColor].CGColor);
    CGContextFillPath(context);

    //Weekdays
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE";
    //always assume gregorian with monday first
    NSMutableArray *weekdays = [[NSMutableArray alloc] initWithArray:[dateFormatter shortWeekdaySymbols]];
    [dateFormatter release];
    [weekdays moveObjectFromIndex:0 toIndex:6];

    //chinese array for weekdays
    NSArray *chineseWeekdays;
    if (_isFromCXSignIN) {
        chineseWeekdays = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    } else {
        chineseWeekdays = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    }


    for (int i = 0; i < [weekdays count]; i++) {

        UIColor *color;
        if (i == 0 || i == 6) {
            // color = [UIColor colorWithHexString:@"0xf60000"];
            color = [UIColor blackColor];
        } else {
            color = [UIColor colorWithHexString:@"0x383838"];
        }

        NSString *weekdayValue = (NSString *) [chineseWeekdays objectAtIndex:i];
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:17];

        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *dic = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: color};
//        if (_isFromCXSignIN)
//        {
//            [weekdayValue drawInRect:CGRectMake(i*(kVRGCalendarViewSignINDayWidth+((Screen_Width - 2*kMiddleMarginWidth)-310.0)/7.0), 40, kVRGCalendarViewSignINDayWidth, 30) withAttributes:dic];
//        }else
//        {
        [weekdayValue drawInRect:CGRectMake(i * (kVRGCalendarViewDayWidth + (kVRGCalendarViewWidth - 320) / 7.0 + 2), 40, kVRGCalendarViewDayWidth + 2, 30) withAttributes:dic];
//        }

        [paragraphStyle release];

    }

    [weekdays release];


    int numRows = [self numRows];

    CGContextSetAllowsAntialiasing(context, NO);

    //Grid background
    float gridHeight = numRows * (kVRGCalendarViewDayHeight + 2) + 1;
    CGRect rectangleGrid = CGRectMake(0, kVRGCalendarViewTopBarHeight, self.frame.size.width, gridHeight);
    CGContextAddRect(context, rectangleGrid);
    if (_isFromCXSignIN) {
        if (Layer_Normal) {
            CGContextSetFillColorWithColor(context, KSelectedBackgroudColor.CGColor);
        } else if (Layer_Management || Layer_Secretary) {
            CGContextSetFillColorWithColor(context, kMangermentTableColor.CGColor);
        } else if (Layer_Leader) {
            CGContextSetFillColorWithColor(context, kLeaderColor1.CGColor);
        }
    } else {
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }

    CGContextFillPath(context);

    //Grid white lines
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+1);
//    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+1);
//    for (int i = 1; i<7; i++)
//    {
//        CGContextMoveToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1-1, kVRGCalendarViewTopBarHeight);
//        CGContextAddLineToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1-1, kVRGCalendarViewTopBarHeight+gridHeight);
//        
//        if (i>numRows-1) continue;
//        //rows
//        CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1+1);
//        CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1+1);
//    }

//    CGContextStrokePath(context);
//    
//    //Grid dark lines
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"0xcfd4d8"].CGColor);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight);
//    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight);
//    for (int i = 1; i<7; i++)
//    {
//        //columns
//        CGContextMoveToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1, kVRGCalendarViewTopBarHeight);
//        CGContextAddLineToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1, kVRGCalendarViewTopBarHeight+gridHeight);
//        
//        if (i>numRows-1) continue;
//        //rows
//        CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1);
//        CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1);
//    }
    if (_isFromCXSignIN) {

    } else {
        CGContextMoveToPoint(context, 0, gridHeight + kVRGCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, kVRGCalendarViewWidth, gridHeight + kVRGCalendarViewTopBarHeight);
        CGContextSetStrokeColorWithColor(context, [UIColor groupTableViewBackgroundColor].CGColor);
        CGContextStrokePath(context);
    }


    CGContextSetAllowsAntialiasing(context, YES);

    //Draw days
    CGContextSetFillColorWithColor(context,
            [UIColor colorWithHexString:@"0x383838"].CGColor);

    int numBlocks = numRows * 7;
    NSDate *previousMonth = [self.currentMonth offsetMonth:-1];
    int currentMonthNumDays = [currentMonth numDaysInMonth];
    int prevMonthNumDays = [previousMonth numDaysInMonth];

    int selectedDateBlock = ([selectedDate day] - 1) + firstWeekDay;

    //prepAnimationPreviousMonth nog wat mee doen

    //prev next month
    BOOL isSelectedDatePreviousMonth = prepAnimationPreviousMonth;
    BOOL isSelectedDateNextMonth = prepAnimationNextMonth;

    if (!self.selectedDate) {
        isSelectedDatePreviousMonth = ([selectedDate year] == [currentMonth year] && [selectedDate month] < [currentMonth month]) || [selectedDate year] < [currentMonth year];

        if (!isSelectedDatePreviousMonth) {
            isSelectedDateNextMonth = ([selectedDate year] == [currentMonth year] && [selectedDate month] > [currentMonth month]) || [selectedDate year] > [currentMonth year];
        }
    }

    if (isSelectedDatePreviousMonth) {
        int lastPositionPreviousMonth = firstWeekDay - 1;
        selectedDateBlock = lastPositionPreviousMonth - ([selectedDate numDaysInMonth] - [selectedDate day]);
    } else if (isSelectedDateNextMonth) {
        selectedDateBlock = [currentMonth numDaysInMonth] + (firstWeekDay - 1) + [selectedDate day];
    }


//    NSDate *todayDate = [NSDate date];
//    int todayBlock = -1;

//    if ([todayDate month] == [currentMonth month] && [todayDate year] == [currentMonth year]) {
//        todayBlock = [todayDate day] + firstWeekDay - 1;
//    }

    for (int i = 0; i < numBlocks; i++) {
        int targetDate;
        int targetColumn = i % 7;
        int targetRow = i / 7;
        int targetX;
//        if (_isFromCXSignIN) {
//            targetX = targetColumn * (kVRGCalendarViewSignINDayWidth+((Screen_Width - 2*kMiddleMarginWidth)/4*3-310.0/4*3)/7.0);
//        }else
//        {
        targetX = targetColumn * (kVRGCalendarViewDayWidth + (kVRGCalendarViewWidth - 320) / 7.0 + 2);
//        }

        int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight + 2);

        CYDatetime *CYDate = [[[CYDatetime alloc] init] autorelease];

        // BOOL isCurrentMonth = NO;
        if (i < firstWeekDay) { //previous month
            targetDate = (prevMonthNumDays - firstWeekDay) + (i + 1);
//            NSString *hex = (isSelectedDatePreviousMonth) ? @"0x383838" : @"aaaaaa";
            NSString *hex = @"aaaaaa";

            if (targetColumn == 0 || targetColumn == 6) {
//                CGContextSetFillColorWithColor(context,
//                                           [UIColor colorWithHexString:@"0xf39999"].CGColor);

                CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:hex].CGColor);
            } else {
                CGContextSetFillColorWithColor(context,
                        [UIColor colorWithHexString:hex].CGColor);
            }

            if ([self.currentMonth month] == 1) {
                CYDate.year = [self.currentMonth year] - 1;
                CYDate.month = 12;
            } else {
                CYDate.year = [self.currentMonth year];
                CYDate.month = [self.currentMonth month] - 1;
            }
        } else if (i >= (firstWeekDay + currentMonthNumDays)) { //next month
            targetDate = (i + 1) - (firstWeekDay + currentMonthNumDays);
            NSString *hex = @"aaaaaa";

            if (targetColumn == 0 || targetColumn == 6) {
                /* CGContextSetFillColorWithColor(context,
                        [UIColor colorWithHexString:@"0xf60000"].CGColor);
                */
                CGContextSetFillColorWithColor(context,
                        [UIColor colorWithHexString:hex].CGColor);
            } else {
                CGContextSetFillColorWithColor(context,
                        [UIColor colorWithHexString:hex].CGColor);
            }

            if ([self.currentMonth month] == 12) {
                CYDate.year = [self.currentMonth year] + 1;
                CYDate.month = 1;
            } else {
                CYDate.year = [self.currentMonth year];
                CYDate.month = [self.currentMonth month] + 1;
            }
        } else { //current month
            // isCurrentMonth = YES;
            targetDate = (i - firstWeekDay) + 1;
            NSString *hex = (isSelectedDatePreviousMonth || isSelectedDateNextMonth) ? @"0xaaaaaa" : @"0x383838";

            if (targetColumn == 0 || targetColumn == 6) {
                /*  CGContextSetFillColorWithColor(context,
                         [UIColor colorWithHexString:@"0xf60000"].CGColor); */
                CGContextSetFillColorWithColor(context,
                        [UIColor blackColor].CGColor);
            } else {
                CGContextSetFillColorWithColor(context,
                        [UIColor colorWithHexString:hex].CGColor);
            }

            CYDate.year = [self.currentMonth year];
            CYDate.month = [self.currentMonth month];
        }

        CYDate.day = targetDate;
        LunarCalendar *lunarCalendar = [[CYDate convertDate] chineseCalendarDate];
        NSString *lunarDate = [lunarCalendar.DayLunar isEqualToString:@"初一"] ? lunarCalendar.MonthLunar : [NSString stringWithFormat:
                @"%@", [lunarCalendar.SolarTermTitle isEqualToString:@""] ? lunarCalendar.DayLunar : lunarCalendar.SolarTermTitle];


        NSString *date = [NSString stringWithFormat:@"%i", targetDate];

        //draw selected date

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月"];
        NSString *current = [formatter stringFromDate:currentMonth];
        NSString *select = [formatter stringFromDate:selectedDate];

        for (NSString *flag in self.selectedDateArr) {
            // 循环所有有日期的会议
            NSDate *aDate = [NSDate dateWithString:flag format:@"yyyy-MM-dd"];
            if ([current isEqualToString:[aDate stringWithFormat:@"yyyy年MM月"]] && targetDate == aDate.day) {
                CGContextAddArc(context, targetX + kVRGCalendarViewDayWidth / 2.0, targetY + kVRGCalendarViewDayWidth / 2.0, kVRGCalendarViewDayHeight / 2.0, 0, 2 * M_PI, 0);
                // CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                CGContextSetFillColorWithColor(context, kColorWithRGB(255.f, 182.f, 193.f).CGColor);
                CGContextFillPath(context);
                CGContextSetFillColorWithColor(context,
                        [UIColor whiteColor].CGColor);
            }
        }

        if ([current isEqualToString:select] && i == selectedDateBlock) {
            if (_isFromCXSignIN) {
                CGContextAddArc(context, targetX + 22, targetY + 20, 17, 0, 2 * M_PI, 0);
                if (Layer_Normal) {
                    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:170 / 255.0 green:233 / 255.0 blue:152 / 255.0 alpha:1].CGColor);
                } else if (Layer_Management || Layer_Secretary) {
                    CGContextSetFillColorWithColor(context, kMangermentLineColor.CGColor);
                } else if (Layer_Leader) {
                    CGContextSetFillColorWithColor(context, kLeaderColor2.CGColor);
                }

                CGContextFillPath(context);
                CGContextSetFillColorWithColor(context,
                        [UIColor blackColor].CGColor);
            } else {
                // 选中
                CGContextAddArc(context, targetX + kVRGCalendarViewDayWidth / 2.0, targetY + kVRGCalendarViewDayWidth / 2.0, kVRGCalendarViewDayHeight / 2.0, 0, 2 * M_PI, 0);
                CGContextSetFillColorWithColor(context, kColorWithRGB(214.f, 233.f, 246.f).CGColor);
                CGContextFillPath(context);
                CGContextSetFillColorWithColor(context,
                        [UIColor whiteColor].CGColor);
            }
        }

        if (i >= firstWeekDay && i < (firstWeekDay + currentMonthNumDays)) {
            if ([current isEqualToString:[[NSDate date] stringWithFormat:@"yyyy年MM月"]] &&
                    [NSDate date].day == targetDate) {
                // 当前日期
                CGContextAddArc(context, targetX + kVRGCalendarViewDayWidth / 2.0, targetY + kVRGCalendarViewDayWidth / 2.0, kVRGCalendarViewDayHeight / 2.0, 0, 2 * M_PI, 0);
                // CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                CGContextSetFillColorWithColor(context, kColorWithRGB(125.f, 192.f, 239.f).CGColor);
                CGContextFillPath(context);
                CGContextSetFillColorWithColor(context,
                        [UIColor whiteColor].CGColor);
            }
        }

        [formatter release];

        if (_isFromCXSignIN) {
            [date drawInRect:CGRectMake(targetX, targetY + 8, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight) withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
            [lunarDate drawInRect:CGRectMake(targetX - 1, targetY + 25, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight) withFont:[UIFont fontWithName:@"HelveticaNeue" size:8] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        } else {
            [date drawInRect:CGRectMake(targetX, targetY + 8, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight) withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
            [lunarDate drawInRect:CGRectMake(targetX, targetY + 27, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight) withFont:[UIFont fontWithName:@"HelveticaNeue" size:8] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
        }


//         UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
//        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
//        paragraphStyle.alignment = NSTextAlignmentCenter;
//        NSDictionary* dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
//        [date drawInRect:CGRectMake(targetX, targetY+8, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight) withAttributes:dic];
//        [paragraphStyle release];
    }

//        CGContextClosePath(context);


//    Draw markings
    if (!self.markedDates || isSelectedDatePreviousMonth || isSelectedDateNextMonth) return;

    for (int i = 0; i < [self.markedDates count]; i++) {
        id markedDateObj = [self.markedDates objectAtIndex:i];
        int targetDate;
        if ([markedDateObj isKindOfClass:[NSNumber class]]) {
            targetDate = [(NSNumber *) markedDateObj intValue];
        } else if ([markedDateObj isKindOfClass:[NSDate class]]) {
            NSDate *date = (NSDate *) markedDateObj;
            targetDate = [date day];
        } else {
            continue;
        }

        int targetBlock = firstWeekDay + (targetDate - 1);
        int targetColumn = targetBlock % 7;
        int targetRow = targetBlock / 7;

        int targetX = targetColumn * (kVRGCalendarViewDayWidth + (kVRGCalendarViewWidth - 320) / 6.0 + 2) + 7;
        int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight + 2) + 38;

        CGContextAddArc(context, targetX + 14, targetY - 4, 3, 0, 2 * M_PI, 0);

        UIColor *color;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月"];
        NSString *current = [formatter stringFromDate:currentMonth];
        NSString *select = [formatter stringFromDate:selectedDate];
        if ([current isEqualToString:select] && selectedDateBlock == targetBlock) {
            color = [UIColor whiteColor];
        } else {
            color = (UIColor *) [markedColors objectAtIndex:i];
        }
        [formatter release];

        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillPath(context);
    }
}

#pragma mark - Draw image for animation

- (UIImage *)drawCurrentState {
    float targetHeight;
//    if (_isFromCXSignIN)
//    {
//        targetHeight = kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewSignINDayWidth+((Screen_Width - 2*kMiddleMarginWidth)/4*3-310.0/4*3)/6.0+2);
//        UIGraphicsBeginImageContext(CGSizeMake((Screen_Width - 2*kMiddleMarginWidth)/4*3, targetHeight-kVRGCalendarViewTopBarHeight));
//        CGContextRef c = UIGraphicsGetCurrentContext();
//        CGContextTranslateCTM(c, 0, -kVRGCalendarViewTopBarHeight);    // <-- shift everything up by 40px when drawing.
//        [self.layer renderInContext:c];
//        UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return viewImage;
//    }else
//    {
    targetHeight = kVRGCalendarViewTopBarHeight + [self numRows] * (kVRGCalendarViewDayHeight + (kVRGCalendarViewWidth - 320) / 6.0 + 2) + 1;
    UIGraphicsBeginImageContext(CGSizeMake(kVRGCalendarViewWidth, targetHeight - kVRGCalendarViewTopBarHeight));
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -kVRGCalendarViewTopBarHeight);    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
//    }


}

#pragma mark - Init

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, kVRGCalendarViewWidth, 0)];
    if (self) {
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds = YES;

        isAnimating = NO;
        labelCurrentMonth = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, kVRGCalendarViewWidth - 68, 40)];
        [self addSubview:labelCurrentMonth];
        labelCurrentMonth.backgroundColor = [UIColor whiteColor];
        labelCurrentMonth.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        labelCurrentMonth.textColor = [UIColor colorWithHexString:@"0x383838"];
        labelCurrentMonth.textAlignment = NSTextAlignmentCenter;

        [self performSelector:@selector(reset) withObject:nil afterDelay:0.1]; //so delegate can be set after init and still get called on init
        //        [self reset];

    }
    return self;
}

- (id)initWithFromCXSignIN:(BOOL)fromCXSignIn {
    self = [super initWithFrame:CGRectMake(-kMiddleMarginWidth, 0, kVRGCalendarViewWidth, 0)];

    if (self) {
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds = YES;
        isAnimating = NO;
        labelCurrentMonth = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, kVRGCalendarViewWidth - 68, 40)];
        [self addSubview:labelCurrentMonth];
        labelCurrentMonth.backgroundColor = [UIColor whiteColor];
        labelCurrentMonth.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        labelCurrentMonth.textColor = [UIColor colorWithHexString:@"0x383838"];
        labelCurrentMonth.textAlignment = NSTextAlignmentCenter;

        [self performSelector:@selector(reset) withObject:nil afterDelay:0.1]; //so delegate can be set after init and still get called on init
        //        [self reset];

    }
    return self;
}

@end
