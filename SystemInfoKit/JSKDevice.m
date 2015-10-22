//
//  JSKDevice.m
//  SystemInfoKit
//
//  Created by jBot-42 on 10/19/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import "JSKDevice.h"

@interface JSKDevice()

- (void)getSystemInfo;
- (void)getCPUInfo;
- (void)getBatteryInfo;

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
        [self getSystemInfo];
        [self getBatteryInfo];
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

- (void)getBatteryInfo {
    
    mach_port_t masterPort;
    kern_return_t masterPortResult;
    
    masterPortResult = IOMasterPort(bootstrap_port, &masterPort);
    
    if (masterPortResult != kIOReturnSuccess) {
        
        JSKDBatteryReport *report = [[JSKDBatteryReport alloc] init];
        
        self.batteryInfo = report;
    }
    
    io_registry_entry_t 	batteryEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("IOPMPowerSource"));
    
    if (batteryEntry == 0) {
        
        JSKDBatteryReport *report = [[JSKDBatteryReport alloc] init];
        
        self.batteryInfo = report;
    }
    
    CFMutableDictionaryRef batteryProperties = NULL;
    kern_return_t result = IORegistryEntryCreateCFProperties(batteryEntry, &batteryProperties, NULL, 0);
    
    if (result != kIOReturnSuccess) {
        
        JSKDBatteryReport *report = [[JSKDBatteryReport alloc] init];
        
        self.batteryInfo = report;
        
    } else {
        
        NSDictionary *batteryDictionary = (__bridge_transfer NSDictionary *)batteryProperties;
        
        NSString *serial = [batteryDictionary objectForKey:@"BatterySerialNumber"];
        NSString *model = [batteryDictionary objectForKey:@"DeviceName"];
        NSString *manufacturer = [batteryDictionary objectForKey:@"Manufacturer"];
        
        // This code comes from Perceval Faramaz
        NSUInteger manufactureDateInt = [[batteryDictionary objectForKey:@"ManufactureDate"] intValue];
        
        NSDateComponents *manufactureDateComponents = [[NSDateComponents alloc] init];
        manufactureDateComponents.year = (manufactureDateInt >> 9) + 1980;
        manufactureDateComponents.month = (manufactureDateInt >> 5) & 0xF;
        manufactureDateComponents.day = manufactureDateInt & 0x1F;
        
        NSDate *dateOfManufacture = [[NSCalendar currentCalendar] dateFromComponents:manufactureDateComponents];
        
        JSKDBatteryReport *report = [[JSKDBatteryReport alloc] initWithSerial:serial model:model manufacturer:manufacturer dateOfManufacture:dateOfManufacture];
        
        self.batteryInfo = report;
    }
}

@end
