//
//  JSKDevice.h
//  SystemInfoKit
//
//  Created by jBot-42 on 10/19/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import <Cocoa/Cocoa.h>

#import "JSKCommon.h"
#import "JSKDSystemReport.h"
#import "JSKDCPUReport.h"

#import <mach/machine.h>

@interface JSKDevice : NSObject

+ (instancetype)device;

@property (strong) JSKDSystemReport *systemInfo;
@property (strong) JSKDCPUReport *cpuInfo;

@end
