//
//  JSKDBatteryReport.m
//  SystemInfoKit
//
//  Created by jBot-42 on 10/22/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import "JSKDBatteryReport.h"

@implementation JSKDBatteryReport

- (instancetype)initWithSerial:(NSString *)serial model:(NSString *)model manufacturer:(NSString *)manufacturer dateOfManufacture:(NSDate *)dateOfManufacture {
    
    if (self = [super init]) {
        
        self.serial = serial;
        self.model = model;
        self.manufacturer = manufacturer;
        self.dateOfManufacture = dateOfManufacture;
    }
    
    return self;
}

@end
