//
//  JSKMNetworkReport.m
//  SystemInfoKit
//
//  Created by jBot-42 on 10/19/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import "JSKMNetworkReport.h"

@implementation JSKMNetworkReport

- (instancetype)initWithIpAddress:(NSString *)ipAddress publicIpAddress:(NSString *)publicIpAddress hostName:(NSString *)hostName {
    
    if (self = [super init]) {
        
        self.ipAddress = ipAddress;
        self.publicIpAddress = publicIpAddress;
        self.hostName = hostName;
    }
    
    return self;
}

@end
