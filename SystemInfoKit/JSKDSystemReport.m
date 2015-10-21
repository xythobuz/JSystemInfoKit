//
//  JSKDSystemReport.m
//  SystemInfoKit
//
//  Created by Jack Whittaker on 10/19/15.
//  Copyright © 2015 jBot-42. All rights reserved.
//

#import "JSKDSystemReport.h"

@implementation JSKDSystemReport

- (instancetype)initWithUUID:(NSString *)uuid serial:(NSString *)serial rawModelString:(NSString *)rawModelString boardId:(NSString *)boardId physicalMemory:(long long)physicalMemory family:(JSKDDeviceFamily)family endianness:(JSKDEndianness)endianness displayResolution:(CGSize)displayResolution {
    
    if (self = [super init]) {
        
        self.uuid = uuid;
        self.serial = serial;
        self.rawModelString = rawModelString;
        self.boardId = boardId;
        self.physicalMemory = physicalMemory;
        self.family = family;
        self.endianness = endianness;
        self.displayResolution = displayResolution;
    }
    
    return self;

}

@end
