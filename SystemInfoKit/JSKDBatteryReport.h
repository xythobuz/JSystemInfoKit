//
//  JSKDBatteryReport.h
//  SystemInfoKit
//
//  Created by jBot-42 on 10/22/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import <Foundation/Foundation.h>

@interface JSKDBatteryReport : NSObject

@property NSString *serial;
@property NSString *model;
@property NSString *manufacturer;
@property NSDate *dateOfManufacture;

- (instancetype)initWithSerial:(NSString *)serial model:(NSString *)model manufacturer:(NSString *)manufacturer dateOfManufacture:(NSDate *)dateOfManufacture;

@end
