//
//  SystemInfoKitTests.m
//  SystemInfoKitTests
//
//  Created by jBot-42 on 10/19/15.
//  Copyright © 2015 jBot-42. Licensed under the GNU General Public License.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import <SystemInfoKit/SystemInfoKit.h>

@interface SystemInfoKitTests : XCTestCase

@end

@implementation SystemInfoKitTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test {
    
    JSKDevice *device = [JSKDevice device];
    
    NSLog(@"UUID: %@", device.systemInfo.uuid);
    NSLog(@"Serial: %@", device.systemInfo.serial);
    NSLog(@"Model: %@", device.systemInfo.rawModelString);
    NSLog(@"Board ID: %@", device.systemInfo.boardId);
    NSLog(@"Physical Memory: %lld B", device.systemInfo.physicalMemory);
    NSLog(@"Family: %@", stringFromJSKDDeviceFamily(device.systemInfo.family));
    NSLog(@"Byte Order: %@", stringFromJSKDEndianness(device.systemInfo.endianness));
    NSLog(@"Screen Resolution: %.00f x %.00f", device.systemInfo.displayResolution.width, device.systemInfo.displayResolution.height);
    
    NSLog(@"CPU Vendor: %@", device.cpuInfo.vendor);
    NSLog(@"CPU Brand: %@", device.cpuInfo.brand);
    
    NSLog(@"CPU Count: %lu", (unsigned long)device.cpuInfo.cpuCount);
    NSLog(@"Core Count: %lu", device.cpuInfo.coreCount);
    NSLog(@"Thread Count: %lu", device.cpuInfo.threadCount);
    
    NSLog(@"CPU Frequency: %f GHz", device.cpuInfo.frequency);
    
    NSLog(@"L2 Cache: %f MB", device.cpuInfo.l2Cache);
    NSLog(@"L3 Cache: %f MB", device.cpuInfo.l3Cache);
    
    NSLog(@"CPU Architecture: %@", stringFromJSKDCPUArchitecture(device.cpuInfo.architecture));
    
    JSKSystemMonitor *systemMonitor = [JSKSystemMonitor systemMonitor];
    
    JSKMCPUUsageInfo cpuUsageInfo = systemMonitor.cpuUsageInfo;
    
    NSLog(@"CPU Usage: %f %% Idle, %f %% User, %f %% System, %f %% Nice, %f %% Used", cpuUsageInfo.idle, cpuUsageInfo.user, cpuUsageInfo.system, cpuUsageInfo.nice, cpuUsageInfo.usage);
    
    JSKMMemoryUsageInfo memoryUsageInfo = systemMonitor.memoryUsageInfo;
    
    NSLog(@"Memory Usage: %lld Free, %lld Used, %lld Active, %lld Inactive, %lld Compressed, %lld Wired", memoryUsageInfo.freeMemory, memoryUsageInfo.usedMemory, memoryUsageInfo.activeMemory, memoryUsageInfo.inactiveMemory, memoryUsageInfo.compressedMemory, memoryUsageInfo.wiredMemory);
    
    JSKMDiskUsageInfo diskUsageInfo = systemMonitor.diskUsageInfo;
    
    NSLog(@"Disk Usage: %lld Free, %lld Used, %lld Total", diskUsageInfo.freeDiskSpace, diskUsageInfo.usedDiskSpace, diskUsageInfo.totalDiskSpace);
    
    JSKMNetworkUsageInfo networkUsageInfo = systemMonitor.networkUsageInfo;
    
    NSLog(@"Network Usage: %lld Out, %lld In", networkUsageInfo.totalOutBytes, networkUsageInfo.totalInBytes);
    
    NSLog(@"System Uptime: %f", systemMonitor.systemUptime);
    
    JSKMBatteryUsageInfo *batteryUsageInfo = systemMonitor.batteryUsageInfo;
    
    NSLog(@"Battery Serial: %@", batteryUsageInfo.serial);
    NSLog(@"Battery Model: %@", batteryUsageInfo.model);
    NSLog(@"Battery Manufacturer: %@", batteryUsageInfo.manufacturer);
    NSLog(@"Battery Date Of Manufacture: %@", batteryUsageInfo.dateOfManufacture);
    
    NSLog(@"Battery Installed: %hhd", batteryUsageInfo.present);
    NSLog(@"Battery Fully Charged: %hhd", batteryUsageInfo.full);
    NSLog(@"Battery Connected To Charger: %hhd", batteryUsageInfo.acConnected);
    NSLog(@"Battery Charging: %hhd", batteryUsageInfo.charging);
    
    NSLog(@"Battery Voltage: %f V", batteryUsageInfo.voltage);
    NSLog(@"Battery Amperage: %f A", batteryUsageInfo.amperage);
    
    NSLog(@"Battery Design Capacity: %f mAh", batteryUsageInfo.designCapacity);
    NSLog(@"Battery Maximum Capacity: %f mAh", batteryUsageInfo.maximumCapacity);
    NSLog(@"Battery Current Capacity: %f mAh", batteryUsageInfo.currentCapacity);
    
    NSLog(@"Battery Design Cycle Count: %lu Cycles", (unsigned long)batteryUsageInfo.designCycleCount);
    NSLog(@"Battery Cycle Count: %lu Cycles", (unsigned long)batteryUsageInfo.cycleCount);
    NSLog(@"Battery Age: %lu Days", (unsigned long)batteryUsageInfo.ageInDays);
}

@end
