//
//  JSKDCPUReport.h
//  SystemInfoKit
//
//  Created by jBot-42 on 10/19/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import <Foundation/Foundation.h>

#import "JSKCommon.h"

@interface JSKDCPUReport : NSObject

@property (strong) NSString *brand;
@property (strong) NSString *vendor;

@property NSUInteger cpuCount;
@property NSUInteger coreCount;
@property NSUInteger threadCount;

@property double frequency;

@property double l2Cache;
@property double l3Cache;

@property JSKDCPUArchitecture architecture;

- (instancetype)initWithBrand:(NSString *)brand vendor:(NSString *)vendor cpuCount:(NSUInteger)cpuCount coreCount:(NSUInteger)coreCount threadCount:(NSUInteger)threadCount frequency:(double)frequency l2Cache:(double)l2Cache l3Cache:(double)l3Cache architecture:(JSKDCPUArchitecture)architecture;

@end
