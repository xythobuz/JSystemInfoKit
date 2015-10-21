//
//  JSKDCPUReport.m
//  SystemInfoKit
//
//  Created by jBot-42 on 10/19/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import "JSKDCPUReport.h"

@implementation JSKDCPUReport

- (instancetype) initWithBrand:(NSString *)brand vendor:(NSString *)vendor cpuCount:(NSUInteger)cpuCount coreCount:(NSUInteger)coreCount threadCount:(NSUInteger)threadCount frequency:(double)frequency l2Cache:(double)l2Cache l3Cache:(double)l3Cache architecture:(JSKDCPUArchitecture)architecture {
    
    if (self = [super init]) {
        
        self.brand = brand;
        self.vendor = vendor;
        self.cpuCount = cpuCount;
        self.coreCount = coreCount;
        self.threadCount = threadCount;
        self.frequency = frequency;
        self.l2Cache = l2Cache;
        self.l3Cache = l3Cache;
        self.architecture = architecture;
    }
    
    return self;
}

@end
