//
//  JSKSMC.h
//  SystemInfoKit
//
//  Created by jBot-42 on 10/19/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import <Cocoa/Cocoa.h>

#import "JSKCommon.h"

#import "SMCWrapper/SMCWrapper.h"

@interface JSKSMC : NSObject

+ (instancetype)smc;

@property (strong) NSArray *allTempKeys;
@property (strong) NSArray *allVoltageKeys;
@property (strong) NSArray *allCurrentKeys;
@property (strong) NSArray *allPowerKeys;

@property (assign, atomic, readonly) NSArray *workingTempKeys;
@property (assign, atomic, readonly) NSArray *workingVoltageKeys;
@property (assign, atomic, readonly) NSArray *workingCurrentKeys;
@property (assign, atomic, readonly) NSArray *workingPowerKeys;

@property (assign, atomic, readonly) NSUInteger numberOfFans;

@property (assign, atomic, readonly) double cpuTemperatureInDegreesCelsius;
@property (assign, atomic, readonly) double cpuTemperatureInDegreesFahrenheit;

- (NSString *)humanReadableNameForKey:(NSString *)key;

- (double)temperatureInCelsiusForKey:(NSString *)key;
- (double)temperatureInFahrenheitForKey:(NSString *)key;

- (double)speedOfFan:(NSUInteger)fan;
- (double)safeMinimumSpeedOfFan:(NSUInteger)fan;
- (double)safeMaximumSpeedOfFan:(NSUInteger)fan;

- (double)rawValueForKey:(NSString *)key;

@end
