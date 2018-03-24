//
//  NSDate+RMCalendarLogic.h
//  RMCalendar
//
//  Created by Kiddie on 15/7/15.
//  Copyright © 2015年 Kiddie(http://www.ruanman.net). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RMCalendarLogic)

- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDate *)dayInTheFollowingMonth:(int)month;//获取当前日期之后的几个月

/** 获取当前月份之前的几个月 */
- (NSDate *)dayInBeforeMonth:(int)month;

- (NSDate *)dayInTheFollowingDay:(int)day;//获取当前日期之后的几个天



- (NSDateComponents *)dateComponents;

- (BOOL)isWeekday;

- (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

- (NSString *)stringFromDate;//NSDate转NSString

- (NSString *)stringFromDateWithFormatter:(NSString *)formatter;

+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

-(int)getWeekIntValueWithDate;



//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate;
//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(int)week;

@end
