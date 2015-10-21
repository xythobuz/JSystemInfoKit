//
//  JSKMBatteryUsageInfo.m
//  SystemInfoKit
//
//  Created by Jack Whittaker on 10/20/15.
//  Copyright © 2015 jBot-42. All rights reserved.
//

#import "JSKMBatteryUsageInfo.h"

@implementation JSKMBatteryUsageInfo

- (instancetype)initWithSerial:(NSString *)serial model:(NSString *)model manufacturer:(NSString *)manufacturer dateOfManufacture:(NSDate *)dateOfManufacture present:(BOOL)present full:(BOOL)full acConnected:(BOOL)acConnected charging:(BOOL)charging voltage:(double)voltage amperage:(double)amperage designCapacity:(double)designCapacity maximumCapacity:(double)maximumCapacity currentCapacity:(double)currentCapacity designCycleCount:(NSUInteger)designCycleCount cycleCount:(NSUInteger)cycleCount ageInDays:(NSUInteger)ageInDays {
    
    if (self = [super init]) {
        
        self.serial = serial;
        self.model = model;
        self.manufacturer = manufacturer;
        self.dateOfManufacture = dateOfManufacture;
        self.present = present;
        self.full = full;
        self.acConnected = acConnected;
        self.charging = charging;
        self.voltage = voltage;
        self.amperage = amperage;
        self.designCapacity = designCapacity;
        self.maximumCapacity = maximumCapacity;
        self.currentCapacity = currentCapacity;
        self.designCycleCount = designCycleCount;
        self.cycleCount = cycleCount;
        self.ageInDays = ageInDays;
    }
    
    return self;
}


@end
