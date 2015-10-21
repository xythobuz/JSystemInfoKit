//
//  JSKDNetworkReport.h
//  SystemInfoKit
//
//  Created by Jack Whittaker on 10/19/15.
//  Copyright © 2015 jBot-42. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSKDNetworkReport : NSObject

@property (strong) NSString *ipAddress;
@property (strong) NSString *publicIpAddress;
@property (strong) NSString *hostName;

- (instancetype)initWithIpAddress:(NSString *)ipAddress publicIpAddress:(NSString *)publicIpAddress hostName:(NSString *)hostName;

@end
