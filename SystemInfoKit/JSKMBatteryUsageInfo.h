//
//  JSKMBatteryUsageInfo.h
//  SystemInfoKit
//
//  Created by jBot-42 on 10/20/15.
//  Copyright © 2015 jBot-42. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JSKMBatteryUsageInfo : NSObject

@property NSString *serial;
@property NSString *model;
@property NSString *manufacturer;
@property NSDate *dateOfManufacture;

@property BOOL present;
@property BOOL full;
@property BOOL acConnected;
@property BOOL charging;

@property double voltage;
@property double amperage;

@property double designCapacity;
@property double maximumCapacity;
@property double currentCapacity;

@property NSUInteger designCycleCount;
@property NSUInteger cycleCount;
@property NSUInteger ageInDays;

- (instancetype)initWithSerial:(NSString *)serial model:(NSString *)model manufacturer:(NSString *)manufacturer dateOfManufacture:(NSDate *)dateOfManufacture present:(BOOL)present full:(BOOL)full acConnected:(BOOL)acConnected charging:(BOOL)charging voltage:(double)voltage amperage:(double)amperage designCapacity:(double)designCapacity maximumCapacity:(double)maximumCapacity currentCapacity:(double)currentCapacity designCycleCount:(NSUInteger)designCycleCount cycleCount:(NSUInteger)cycleCount ageInDays:(NSUInteger)ageInDays;

@end
