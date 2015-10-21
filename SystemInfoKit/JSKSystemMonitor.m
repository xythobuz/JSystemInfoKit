//
//  JSKSystemMonitor.m
//  SystemInfoKit
//
//  Created by jBot-42 on 10/20/15.
//  Copyright (c) 2015 jBot-42. All rights reserved.
//

#import "JSKSystemMonitor.h"

@implementation JSKSystemMonitor

+ (instancetype)systemMonitor {
    
    static dispatch_once_t once;
    static id systemMonitor;
    dispatch_once(&once, ^{
        
        systemMonitor = [[self alloc] init];
    });
    
    return systemMonitor;
}

- (id)init {
    
    if (self = [super init]) {
        
        // Set up monitoring
        int mib1[2U] = { CTL_HW, HW_NCPU };
        size_t sizeOfNumCPUs = sizeof(numCPUs);
        int status = sysctl(mib1, 2U, &numCPUs, &sizeOfNumCPUs, NULL, 0U);
        if(status)
            numCPUs = 1;
        
        CPUUsageLock = [[NSLock alloc] init];
    }
    
    return self;
}

// Get the current (percent) cpu usage including user and system
- (JSKMCPUUsageInfo)cpuUsageInfo {
    
    // Set up variables
    natural_t numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo);
    
    // If there is no error, get the data
    if (err == KERN_SUCCESS) {
        
        [CPUUsageLock lock];
        
        float cpuAverage = 0;
        float cpuUserAverage = 0;
        float cpuSystemAverage = 0;
        float cpuIdleAverage = 0;
        float cpuNiceAverage = 0;
        
        // Get the data from all cpus
        for(unsigned i = 0U; i < numCPUs; ++i) {
            
            float inUse, user, system, idle, nice, total;
            
            if(prevCpuInfo) {
                
                inUse = (
                         (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                         );
                
                user = (
                        (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                        );
                
                system = (
                          (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          );
                
                nice = (
                        (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                        );
                
                total = inUse + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
                
                idle = (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
                
            } else {
                
                inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                
                user = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER];
                
                system = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM];
                
                nice = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                
                total = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
                
                idle = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            
            // Add to the average
            cpuAverage += (inUse / total) * 100;
            cpuUserAverage += (user / total) * 100;
            cpuSystemAverage += (system / total) * 100;
            cpuIdleAverage += (idle / total) * 100;
            cpuNiceAverage += (nice / total) * 100;
        }
        
        // Divide the average by number of cores
        cpuAverage /= numCPUs;
        cpuUserAverage /= numCPUs;
        cpuSystemAverage /= numCPUs;
        cpuIdleAverage /= numCPUs;
        cpuNiceAverage /= numCPUs;
        
        [CPUUsageLock unlock];
        
        if(prevCpuInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * numPrevCpuInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)prevCpuInfo, prevCpuInfoSize);
        }
        
        prevCpuInfo = cpuInfo;
        numPrevCpuInfo = numCpuInfo;
        
        cpuInfo = NULL;
        numCpuInfo = 0U;
        
        return (JSKMCPUUsageInfo){cpuAverage, cpuUserAverage, cpuSystemAverage, cpuIdleAverage, cpuNiceAverage};
        
    } else {
        
        // Return an error
        NSLog(@"Error fetching CPU usage - returning -1!");
        return (JSKMCPUUsageInfo){-1, -1, -1, -1, -1};
    }
}

// Get the system uptime
- (NSTimeInterval)systemUptime {
    
    NSTimeInterval uptime = [[NSProcessInfo processInfo] systemUptime];
    
    return uptime;
}

// Get the current memory usage
- (JSKMMemoryUsageInfo)memoryUsageInfo {
    
    // Set up variables
    int mib[6];
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    
    int pagesize;
    size_t length;
    length = sizeof (pagesize);
    
    // Get page size
    if (sysctl (mib, 2, &pagesize, &length, NULL, 0) < 0) {
        
        fprintf (stderr, "getting page size");
    }
    
    // Set up more variables
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    
    vm_statistics_data_t vmstat;
    
    // Get VM statistics
    if (host_statistics (mach_host_self (), HOST_VM_INFO, (host_info_t) &vmstat, &count) != KERN_SUCCESS) {
        
        fprintf (stderr, "Failed to get VM statistics.");
    }
    
    // Get task info
    task_basic_info_64_data_t info;
    unsigned size = sizeof (info);
    task_info (mach_task_self (), TASK_BASIC_INFO_64, (task_info_t) &info, &size);
    
    double unit = 1;
    
    // Calculate memory usages
    long long freeMemory = (vmstat.free_count * pagesize / unit);
    long long usedMemory = [[NSProcessInfo processInfo] physicalMemory] - freeMemory;
    long long wiredMemory = vmstat.wire_count * pagesize / unit;
    long long activeMemory = vmstat.active_count * pagesize / unit;
    long long inactiveMemory = vmstat.inactive_count * pagesize / unit;
    long long compressedMemory = [[NSProcessInfo processInfo] physicalMemory] - freeMemory - activeMemory - inactiveMemory - wiredMemory;
    
    return (JSKMMemoryUsageInfo){freeMemory, usedMemory, activeMemory, inactiveMemory, wiredMemory, compressedMemory};
}

// Get disk usage info
- (JSKMDiskUsageInfo)diskUsageInfo {
    
    // Init file manager
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    // Get file system info
    NSDictionary *infoDict = [fileManager attributesOfFileSystemForPath:@"/" error:nil];
    
    // Calculate info
    long long totalDiskSpace = [[infoDict valueForKey:@"NSFileSystemSize"] longLongValue];
    long long freeDiskSpace = [[infoDict valueForKey:@"NSFileSystemFreeSize"] longLongValue];
    long long usedDiskSpace = totalDiskSpace - freeDiskSpace;
    
    return (JSKMDiskUsageInfo){totalDiskSpace, freeDiskSpace, usedDiskSpace};
}

// Get network usage info
- (JSKMNetworkUsageInfo)networkUsageInfo {
    
    int mib[] = {CTL_NET, PF_ROUTE, 0, 0, NET_RT_IFLIST2, 0};
    
    size_t len;
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        
        fprintf(stderr, "sysctl: %s\n", strerror(errno));
        exit(1);
    }
    
    char *buf = (char *)malloc(len);
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        
        fprintf(stderr, "sysctl: %s\n", strerror(errno));
        exit(1);
    }
    
    char *lim = buf + len;
    char *next = NULL;
    
    u_int64_t totalInBytes = 0;
    u_int64_t totalOutBytes = 0;
    
    for (next = buf; next < lim; ) {
        
        struct if_msghdr *ifm = (struct if_msghdr *)next;
        
        next += ifm->ifm_msglen;
        
        if (ifm->ifm_type == RTM_IFINFO2) {
            
            struct if_msghdr2 *if2m = (struct if_msghdr2 *)ifm;
            
            totalInBytes += if2m->ifm_data.ifi_ibytes;
            totalOutBytes += if2m->ifm_data.ifi_obytes;
        }
    }
    
    free(buf);
    
    return (JSKMNetworkUsageInfo){totalInBytes, totalOutBytes};
}

- (JSKMBatteryUsageInfo *)batteryUsageInfo {
    
    mach_port_t masterPort;
    kern_return_t masterPortResult;
    
    masterPortResult = IOMasterPort(bootstrap_port, &masterPort);
    
    if (masterPortResult != kIOReturnSuccess) {
        
        return [[JSKMBatteryUsageInfo alloc] init];
    }
    
    io_registry_entry_t 	batteryEntry = IOServiceGetMatchingService(masterPort, IOServiceMatching("IOPMPowerSource"));
    
    if (batteryEntry == 0) {
       
        return [[JSKMBatteryUsageInfo alloc] init];
    }
    
    CFMutableDictionaryRef batteryProperties = NULL;
    kern_return_t result = IORegistryEntryCreateCFProperties(batteryEntry, &batteryProperties, NULL, 0);
    
    if (result != kIOReturnSuccess) {
        
        return [[JSKMBatteryUsageInfo alloc] init];
        
    } else {
        
        NSDictionary *batteryDictionary = (__bridge_transfer NSDictionary *)batteryProperties;
        
        /*updateWithIsPresent:[[batteryRawDict objectForKey:@"BatteryInstalled"] intValue]
									isFull:[[batteryRawDict objectForKey:@"FullyCharged"] intValue]
         isCharging:[[batteryRawDict objectForKey:@"IsCharging"] intValue]
         isACConnected:[[batteryRawDict objectForKey:@"ExternalConnected"] intValue]
         amperage:[batteryRawDict objectForKey:@"Amperage"]
						   currentCapacity:[batteryRawDict objectForKey:@"CurrentCapacity"]
         maxCapacity:[batteryRawDict objectForKey:@"MaxCapacity"]
         voltage:[batteryRawDict objectForKey:@"Voltage"]
         cycleCount:[batteryRawDict objectForKey:@"CycleCount"]
									health:@(([[batteryRawDict objectForKey:@"MaxCapacity"] intValue] / [[batteryRawDict objectForKey:@"DesignCapacity"] intValue])*100)
         temperature:@([[batteryRawDict objectForKey:@"Temperature"] doubleValue] / 100)
         power:@([[batteryRawDict objectForKey:@"Amperage"] doubleValue] / 1000 * [[batteryRawDict objectForKey:@"Voltage"] doubleValue] / 1000)
         age:@([differenceDate day])];*/
        
        NSString *serial = [batteryDictionary objectForKey:@"BatterySerialNumber"];
        NSString *model = [batteryDictionary objectForKey:@"DeviceName"];
        NSString *manufacturer = [batteryDictionary objectForKey:@"Manufacturer"];
        
        BOOL present = [[batteryDictionary objectForKey:@"BatteryInstalled"] boolValue];
        BOOL full = [[batteryDictionary objectForKey:@"FullyCharged"] boolValue];
        BOOL acConnected = [[batteryDictionary objectForKey:@"ExternalConnected"] boolValue];
        BOOL charging = [[batteryDictionary objectForKey:@"IsCharging"] boolValue];
        
        double voltage = [[batteryDictionary objectForKey:@"Voltage"] doubleValue] / 1000;
        double amperage = [[batteryDictionary objectForKey:@"Amperage"] doubleValue] / 1000;
        
        double designCapacity = [[batteryDictionary objectForKey:@"DesignCapacity"] doubleValue];
        double maximumCapacity = [[batteryDictionary objectForKey:@"MaxCapacity"] doubleValue];
        double currentCapacity = [[batteryDictionary objectForKey:@"CurrentCapacity"] doubleValue];
        
        NSUInteger designCycleCount = [[batteryDictionary objectForKey:@"DesignCycleCount9C"] unsignedIntegerValue];
        NSUInteger cycleCount = [[batteryDictionary objectForKey:@"CycleCount"] unsignedIntegerValue];
        
        // This code comes from Perceval Faramaz
        NSUInteger manufactureDateInt = [[batteryDictionary objectForKey:@"ManufactureDate"] intValue];
        
        NSDateComponents *manufactureDateComponents = [[NSDateComponents alloc] init];
        manufactureDateComponents.year = (manufactureDateInt >> 9) + 1980;
        manufactureDateComponents.month = (manufactureDateInt >> 5) & 0xF;
        manufactureDateComponents.day = manufactureDateInt & 0x1F;
        
        NSDate *dateOfManufacture = [[NSCalendar currentCalendar] dateFromComponents:manufactureDateComponents];
        
        NSUInteger ageInDays = [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:dateOfManufacture toDate:[NSDate date] options:0] day];
        
        JSKMBatteryUsageInfo *batteryUsageInfo = [[JSKMBatteryUsageInfo alloc] initWithSerial:serial model:model manufacturer:manufacturer dateOfManufacture:dateOfManufacture present:present full:full acConnected:acConnected charging:charging voltage:voltage amperage:amperage designCapacity:designCapacity maximumCapacity:maximumCapacity currentCapacity:currentCapacity designCycleCount:designCycleCount cycleCount:cycleCount ageInDays:ageInDays];
        
        return batteryUsageInfo;
    }
}

@end
