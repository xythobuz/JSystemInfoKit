//
//  JSKDSystemReport.h
//  SystemInfoKit
//
//  Created by jBot-42 on 10/19/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import <Foundation/Foundation.h>

#import "JSKCommon.h"

@interface JSKDSystemReport : NSObject

@property (strong) NSString *uuid;
@property (strong) NSString *serial;
@property (strong) NSString *rawModelString;
@property (strong) NSString *boardId;
@property long long physicalMemory;
@property JSKDDeviceFamily family;
@property JSKDEndianness endianness;
@property CGSize displayResolution;

- (instancetype)initWithUUID:(NSString *)uuid serial:(NSString *)serial rawModelString:(NSString *)rawModelString boardId:(NSString *)boardId physicalMemory:(long long)physicalMemory family:(JSKDDeviceFamily)family endianness:(JSKDEndianness)endianness displayResolution:(CGSize)displayResolution;

@end
