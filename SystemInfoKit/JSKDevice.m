//
//  JSKDevice.m
//  SystemInfoKit
//
//  Created by Jack Whittaker on 10/19/15.
//  Copyright © 2015 jBot-42. All rights reserved.
//

#import "JSKDevice.h"

@interface JSKDevice()

- (void)getSystemInfo;
- (void)getCPUInfo;
- (void)getNetworkInfo;

@end

@implementation JSKDevice

+ (instancetype)device {
    
    static dispatch_once_t once;
    static id device;
    dispatch_once(&once, ^{
        
        device = [[self alloc] init];
    });
    
    return device;
}

- (id)init {
    
    if (self = [super init]) {
        
        [self getCPUInfo];
        [self getNetworkInfo];
        [self getSystemInfo];
    }
    
    return self;
}

- (void)getCPUInfo {
    
    NSString *brand = sysctlNSStringForKey(kSysctlCPUBrand);
    
    if ([brand isEqualToString:@""]) {
        
        brand = @"Unknown";
    }
    
    NSString *vendor = sysctlNSStringForKey(kSysctlCPUVendor);
    
    if ([vendor isEqualToString:@""]) {
        
        vendor = @"GenuineIntel"; // Most likely intel
    }
    
    double count = sysctlDoubleForKey(kSysctlCPUCount);
    
    if (count == 0) {
        
        count = 1; // Most likely 1 CPU
    }
    
    double coreCount = sysctlDoubleForKey(kSysctlCPUCoreCount);
    
    if (coreCount == 0) {
        
        coreCount = -1;
    }
    
    double threadCount = sysctlDoubleForKey(kSysctlCPUThreadCount);
    
    if (threadCount == 0) {
        
        threadCount = -1;
    }
    
    float frequency = sysctlFloatForKey(kSysctlCPUFrequency);
    
    if (frequency == 0) {
        
        frequency = -1;
    }
    
    frequency /= 1000000000;
    
    float l2Cache = sysctlFloatForKey(kSysctlCPUL2Cache);
    
    if (l2Cache == 0) {
        
        l2Cache = -1;
    }
    
    l2Cache /= BYTES_IN_MiB;
    
    float l3Cache = sysctlFloatForKey(kSysctlCPUL3Cache);
    
    if (l3Cache == 0) {
        
        l3Cache = -1;
    }
    
    l3Cache /= BYTES_IN_MiB;
    
    int architectureRaw = sysctlDoubleForKey(kSysctlCPUArchitecture);
    JSKDCPUArchitecture architecture;
    
    if (architectureRaw == 0) {
        
        architecture = JSKDCPUArchitectureUnknown;
    
    } else if (architectureRaw == CPU_TYPE_X86) {
        
        architecture = JSKDCPUArchitectureX86;
        
        if (architectureRaw == CPU_TYPE_X86_64) {
            
            architecture = JSKDCPUArchitectureX86_64;
        }
    }

    JSKDCPUReport *report = [[JSKDCPUReport alloc] initWithBrand:brand vendor:vendor cpuCount:count coreCount:coreCount threadCount:threadCount frequency:frequency l2Cache:l2Cache l3Cache:l3Cache architecture:architecture];
    
    self.cpuInfo = report;
}

- (void)getNetworkInfo {
    
    NSString *ipAddress = @"";
    
    NSArray *addresses = [[NSHost currentHost] addresses];
    
    for (NSString *address in addresses) {
        
        if (![address hasPrefix:@"127"] && [[address componentsSeparatedByString:@"."] count] == 4) {
            
            ipAddress = address;
        }
    }
    
    if ([ipAddress isEqualToString:@""]) {
        
        ipAddress = [[NSHost currentHost] address];
    }
    
    NSTask *task = [[NSTask alloc] init];
    
    [task setLaunchPath:@"/usr/bin/curl"];
    [task setArguments:[NSArray arrayWithObjects:@"-s",@"http://checkip.dyndns.org", nil]];
    
    NSPipe *pipe = [NSPipe pipe];
    
    [task setStandardOutput:pipe];
    [task launch];
    
    NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSMutableString *publicIpAddress = [NSMutableString stringWithCapacity:dataString.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:dataString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    while ([scanner isAtEnd] == NO) {
        
        NSString *buffer;
        
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            
            [publicIpAddress appendString:buffer];
            
        } else {
            
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    JSKDNetworkReport *report = [[JSKDNetworkReport alloc] initWithIpAddress:ipAddress publicIpAddress:publicIpAddress hostName:[[NSHost currentHost] name]];
    
    self.networkInfo = report;
}

- (void)getSystemInfo {
    
    mach_port_t masterPort;
    kern_return_t masterPortResult;
    
    masterPortResult = IOMasterPort(bootstrap_port, &masterPort);
    
    if (masterPortResult != kIOReturnSuccess) {
        
        return;
    }
    
    io_registry_entry_t platformExpertEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("IOPlatformExpertDevice"));
    
    if (platformExpertEntry == 0) {
        
        return;
    }
    
    CFMutableDictionaryRef platformExpertProperties = NULL;
    kern_return_t result = IORegistryEntryCreateCFProperties(platformExpertEntry, &platformExpertProperties, NULL, 0);
    
    if (result != kIOReturnSuccess) {
        
        return;
    }
    
    NSDictionary *platformExpertDictionary = (__bridge_transfer NSDictionary *)platformExpertProperties;
    
    NSString *uuid = [platformExpertDictionary objectForKey:@kIOPlatformUUIDKey];
    NSString *serial = [platformExpertDictionary objectForKey:@kIOPlatformSerialNumberKey];
    NSString *rawModelString = sysctlNSStringForKey(kSysctlModelString);
    NSString *boardId = [platformExpertDictionary objectForKey:@"boardID"];
    
    JSKDDeviceFamily family;
    
    if ([rawModelString hasPrefix:@"MacBookPro"]) {
        
        family = JSKDDeviceFamilyMacBookPro;
        
    } else if ([rawModelString hasPrefix:@"MacBookAir"]) {
        
        family = JSKDDeviceFamilyMacBookAir;
        
    } else if ([rawModelString hasPrefix:@"MacBook"]) {
        
        family = JSKDDeviceFamilyMacBook;
        
    } else if ([rawModelString hasPrefix:@"iMac"]) {
        
        family = JSKDDeviceFamilyiMac;
        
    } else if ([rawModelString hasPrefix:@"MacMini"]) {
        
        family = JSKDDeviceFamilyMacMini;
        
    } else if ([rawModelString hasPrefix:@"MacPro"]) {
        
        family = JSKDDeviceFamilyMacPro;
        
    } else if ([rawModelString hasPrefix:@"Xserve"]) {
        
        family = JSKDDeviceFamilyXserve;
        
    } else {
        
        family = JSKDDeviceFamilyUnknown;
    }
    
    double endiannessRaw = sysctlDoubleForKey(kSysctlByteOrder);
    JSKDEndianness endianness;
    
    if (endiannessRaw == 0) {

        endianness = JSKDEndiannessUnknown;
    }
    
    if (endiannessRaw == 1234) {
        
        endianness = JSKDEndiannessLittle;
        
    } else if (endiannessRaw == 4321) {
        
        endianness = JSKDEndiannessBig;
        
    } else {
        
        endianness = JSKDEndiannessUnknown;
    }
    
    
    JSKDSystemReport *report = [[JSKDSystemReport alloc] initWithUUID:uuid serial:serial rawModelString:rawModelString boardId:boardId physicalMemory:[[NSProcessInfo processInfo] physicalMemory] family:family endianness:endianness displayResolution:[NSScreen mainScreen].frame.size];
    
    self.systemInfo = report;
}

@end
