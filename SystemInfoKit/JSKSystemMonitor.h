//
//  JSKSystemMonitor.h
//  SystemInfoKit
//
//  Created by jBot-42 on 10/20/15.
//  Copyright (c) 2015 jBot-42. Licensed under the GNU General Public License.
//

#import <Cocoa/Cocoa.h>

#import "JSKCommon.h"
#import "JSKMNetworkReport.h"
#import "JSKMBatteryUsageInfo.h"

#import <sys/sysctl.h>

#import <netinet/in.h>
#import <net/if.h>
#import <net/route.h>

static processor_info_array_t cpuInfo, prevCpuInfo;
static mach_msg_type_number_t numCpuInfo, numPrevCpuInfo;

static unsigned numCPUs;

static NSLock *CPUUsageLock;

@interface JSKSystemMonitor : NSObject

+ (instancetype)systemMonitor;

@property (assign, atomic, readonly) JSKMCPUUsageInfo cpuUsageInfo;
@property (assign, atomic, readonly) NSTimeInterval systemUptime;
@property (assign, atomic, readonly) JSKMMemoryUsageInfo memoryUsageInfo;
@property (assign, atomic, readonly) JSKMDiskUsageInfo diskUsageInfo;
@property (assign, atomic, readonly) JSKMNetworkUsageInfo networkUsageInfo;
@property (assign, atomic, readonly) JSKMNetworkReport *networkInfo;
@property (assign, atomic, readonly) JSKMBatteryUsageInfo *batteryUsageInfo;

@end
