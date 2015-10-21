//
//  JSKDNetworkReport.h
//  SystemInfoKit
//
//  Created by jBot-42 on 10/19/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import <Foundation/Foundation.h>

@interface JSKDNetworkReport : NSObject

@property (strong) NSString *ipAddress;
@property (strong) NSString *publicIpAddress;
@property (strong) NSString *hostName;

- (instancetype)initWithIpAddress:(NSString *)ipAddress publicIpAddress:(NSString *)publicIpAddress hostName:(NSString *)hostName;

@end
