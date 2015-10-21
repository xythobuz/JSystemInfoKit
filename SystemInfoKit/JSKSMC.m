//
//  JSKSMC.m
//  SystemInfoKit
//
//  Created by Jack Whittaker on 10/19/15.
//  Copyright © 2015 jBot-42. All rights reserved.
//

#import "JSKSMC.h"

@interface JSKSMC()

@property (strong) SMCWrapper *smc;

@property (strong) NSDictionary *humanReadableNamesForKeys;

@end

@implementation JSKSMC

+ (instancetype)smc {
    
    static dispatch_once_t once;
    static id smc;
    dispatch_once(&once, ^{
        
        smc = [[self alloc] init];
    });
    
    return smc;
}

- (id)init {
    
    if (self = [super init]) {
        
        self.allTempKeys = @[ @"TCXC", @"TCXc", @"TC0P", @"TC0H", @"TC0D", @"TC0E", @"TC0F", @"TC1C", @"TC2C", @"TC3C", @"TC4C", @"TC5C", @"TC6C", @"TC7C", @"TC8C", @"TCAH", @"TCAD", @"TC1P", @"TC1H", @"TC1D", @"TC1E", @"TC1F", @"TCBH", @"TCBD", @"TCSC", @"TCSc", @"TCSA", @"TCGC", @"TCGc", @"TG0P", @"TG0D", @"TG1D", @"TG0H", @"TG1H", @"Ts0S", @"TM0P", @"TM1P", @"TM8P", @"TM9P", @"TM0S", @"TM1S", @"TM8S", @"TM9S", @"TN0D", @"TN0P", @"TN1P", @"TN0C", @"TN0H", @"TP0D", @"TPCD", @"TP0P", @"TA0P", @"TA1P", @"Th0H", @"Th1H", @"Th2H", @"Tm0P", @"Tp0P", @"Ts0P", @"Tb0P", @"TL0P", @"TW0P", @"TH0P", @"TH1P", @"TH2P", @"TH3P", @"TO0P", @"Tp0P", @"Tp0C", @"TB0T", @"TB1T", @"TB2T", @"TB3T", @"Tp1P", @"Tp1C", @"Tp2P", @"Tp3P", @"Tp4P", @"Tp5P", @"TS0C", @"TA0S", @"TA1S", @"TA2S", @"TA3S" ];
        
        self.allVoltageKeys = @[ @"VC0C", @"VC1C", @"VC2C", @"VC3C", @"VC4C", @"VC5C", @"VC6C", @"VC7C", @"VV1R", @"VG0C", @"VM0R", @"VN1R", @"VN0C", @"VD0R", @"VD5R", @"VP0R", @"Vp0C", @"VV2S", @"VR3R", @"VV1S", @"VH05", @"VV9S", @"VD2R", @"VV7S", @"VV3S", @"VV8S", @"VeES", @"VBAT", @"Vb0R" ];
        
        self.allCurrentKeys = @[ @"IC0C", @"IC1C", @"IC2C", @"IC0R", @"IC5R", @"IC8R", @"IC0G", @"IC0M", @"IG0C", @"IM0C", @"IM0R", @"IN0C", @"ID0R", @"ID5R", @"IO0R", @"IB0R", @"IPBR" ];
        
        self.allPowerKeys = @[ @"PC0C", @"PC1C", @"PC2C", @"PC3C", @"PC4C", @"PC5C", @"PC6C", @"PC7C", @"PCPC", @"PCPG", @"PCPD", @"PCTR", @"PCPL", @"PC1R", @"PC5R", @"PGTR", @"PG0R", @"PM0R", @"PN0C", @"PN1R", @"PC0R", @"PD0R", @"PD5R", @"PH02", @"PH05", @"Pp0R", @"PD2R", @"PO0R", @"PBLC", @"PB0R", @"PDTR", @"PSTR" ];
        
        self.humanReadableNamesForKeys = @{ @"TCXC" : @"PECI CPU",
                                            @"TCXc" : @"PECI CPU",
                                            @"TC0P" : @"CPU 1 Proximity",
                                            @"TC0H" : @"CPU 1 Heatsink",
                                            @"TC0D" : @"CPU 1 Package",
                                            @"TC0E" : @"CPU 1",
                                            @"TC0F" : @"CPU 1",
                                            @"TC1C" : @"CPU Core 1",
                                            @"TC2C" : @"CPU Core 2",
                                            @"TC3C" : @"CPU Core 3",
                                            @"TC4C" : @"CPU Core 4",
                                            @"TC5C" : @"CPU Core 5",
                                            @"TC6C" : @"CPU Core 6",
                                            @"TC7C" : @"CPU Core 7",
                                            @"TC8C" : @"CPU Core 8",
                                            @"TCAH" : @"CPU 1 Heatsink Alt.",
                                            @"TCAD" : @"CPU 1 Package Alt.",
                                            @"TC1P" : @"CPU 2 Proximity",
                                            @"TC1H" : @"CPU 2 Heatsink",
                                            @"TC1D" : @"CPU 2 Package",
                                            @"TC1E" : @"CPU 2",
                                            @"TC1F" : @"CPU 2",
                                            @"TCBH" : @"CPU 2 Heatsink Alt.",
                                            @"TCBD" : @"CPU 2 Package Alt.",
                                            
                                            @"TCSC" : @"PECI SA",
                                            @"TCSc" : @"PECI SA",
                                            @"TCSA" : @"PECI SA",
                                            
                                            @"TCGC" : @"PECI GPU",
                                            @"TCGc" : @"PECI GPU",
                                            @"TG0P" : @"GPU Proximity",
                                            @"TG0D" : @"GPU Die",
                                            @"TG1D" : @"GPU Die",
                                            @"TG0H" : @"GPU Heatsink",
                                            @"TG1H" : @"GPU Heatsink",
                                            
                                            @"Ts0S" : @"Memory Proximity",
                                            @"TM0P" : @"Mem Bank A1",
                                            @"TM1P" : @"Mem Bank A2",
                                            @"TM8P" : @"Mem Bank B1",
                                            @"TM9P" : @"Mem Bank B2",
                                            @"TM0S" : @"Mem Module A1",
                                            @"TM1S" : @"Mem Module A2",
                                            @"TM8S" : @"Mem Module B1",
                                            @"TM9S" : @"Mem Module B2",
                                            
                                            @"TN0D" : @"Northbridge Die",
                                            @"TN0P" : @"Northbridge Proximity 1",
                                            @"TN1P" : @"Northbridge Proximity 2",
                                            @"TN0C" : @"MCH Die",
                                            @"TN0H" : @"MCH Heatsink",
                                            @"TP0D" : @"PCH Die",
                                            @"TPCD" : @"PCH Die",
                                            @"TP0P" : @"PCH Proximity",
                                            
                                            @"TA0P" : @"Airflow 1",
                                            @"TA1P" : @"Airflow 2",
                                            @"Th0H" : @"Heatpipe 1",
                                            @"Th1H" : @"Heatpipe 2",
                                            @"Th2H" : @"Heatpipe 3",
                                            
                                            @"Tm0P" : @"Mainboard Proximity",
                                            @"Tp0P" : @"Powerboard Proximity",
                                            @"Ts0P" : @"Palm Rest",
                                            @"Tb0P" : @"BLC Proximity",
                                            
                                            @"TL0P" : @"LCD Proximity",
                                            @"TW0P" : @"Airport Proximity",
                                            @"TH0P" : @"HDD Bay 1",
                                            @"TH1P" : @"HDD Bay 2",
                                            @"TH2P" : @"HDD Bay 3",
                                            @"TH3P" : @"HDD Bay 4",
                                            @"TO0P" : @"Optical Drive",
                                            
                                            @"TB0T" : @"Battery TS_MAX",
                                            @"TB1T" : @"Battery 1",
                                            @"TB2T" : @"Battery 2",
                                            @"TB3T" : @"Battery",
                                            @"Tp0P" : @"Power Supply 1",
                                            @"Tp0C" : @"Power Supply 1 Alt.",
                                            @"Tp1P" : @"Power Supply 2",
                                            @"Tp1C" : @"Power Supply 2 Alt.",
                                            @"Tp2P" : @"Power Supply 3",
                                            @"Tp3P" : @"Power Supply 4",
                                            @"Tp4P" : @"Power Supply 5",
                                            @"Tp5P" : @"Power Supply 6",
                                            
                                            @"TS0C" : @"Expansion Slots",
                                            @"TA0S" : @"PCI Slot 1 Pos 1",
                                            @"TA1S" : @"PCI Slot 1 Pos 2",
                                            @"TA2S" : @"PCI Slot 2 Pos 1",
                                            @"TA3S" : @"PCI Slot 2 Pos 2",
                                            
                                            
                                            @"VC0C" : @"CPU Core 1",
                                            @"VC1C" : @"CPU Core 2",
                                            @"VC2C" : @"CPU Core 3",
                                            @"VC3C" : @"CPU Core 4",
                                            @"VC4C" : @"CPU Core 5",
                                            @"VC5C" : @"CPU Core 6",
                                            @"VC6C" : @"CPU Core 7",
                                            @"VC7C" : @"CPU Core 8",
                                            @"VV1R" : @"CPU VTT",
                                            
                                            @"VG0C" : @"GPU Core",
                                            
                                            @"VM0R" : @"Memory",
                                            
                                            @"VN1R" : @"PCH",
                                            @"VN0C" : @"MCH",
                                            
                                            @"VD0R" : @"Mainboard S0 Rail",
                                            @"VD5R" : @"Mainboard S5 Rail",
                                            @"VP0R" : @"12V Rail",
                                            @"Vp0C" : @"12V Vcc",
                                            @"VV2S" : @"Main 3V",
                                            @"VR3R" : @"Main 3.3V",
                                            @"VV1S" : @"Main 5V",
                                            @"VH05" : @"Main 5V",
                                            @"VV9S" : @"Main 12V",
                                            @"VD2R" : @"Main 12V",
                                            @"VV7S" : @"Auxiliary 3V",
                                            @"VV3S" : @"Standby 3V",
                                            @"VV8S" : @"Standby 5V",
                                            @"VeES" : @"PCIe 12V",
                                            
                                            @"VBAT" : @"Battery",
                                            @"Vb0R" : @"CMOS Battery",
                                            
                                            
                                            @"IC0C" : @"CPU Core",
                                            @"IC1C" : @"CPU VccIO",
                                            @"IC2C" : @"CPU VccSA",
                                            @"IC0R" : @"CPU Rail",
                                            @"IC5R" : @"CPU DRAM",
                                            @"IC8R" : @"CPU PLL",
                                            @"IC0G" : @"CPU GFX",
                                            @"IC0M" : @"CPU Memory",
                                            
                                            @"IG0C" : @"GPU Rail",
                                            
                                            @"IM0C" : @"Memory Controller",
                                            @"IM0R" : @"Memory Rail",
                                            
                                            @"IN0C" : @"MCH",
                                            
                                            @"ID0R" : @"Mainboard S0 Rail",
                                            @"ID5R" : @"Mainboard S5 Rail",
                                            @"IO0R" : @"Misc. Rail",
                                            
                                            @"IB0R" : @"Battery Rail",
                                            @"IPBR" : @"Charger BMON",
                                            
                                            
                                            @"PC0C" : @"CPU Core 1",
                                            @"PC1C" : @"CPU Core 2",
                                            @"PC2C" : @"CPU Core 3",
                                            @"PC3C" : @"CPU Core 4",
                                            @"PC4C" : @"CPU Core 5",
                                            @"PC5C" : @"CPU Core 6",
                                            @"PC6C" : @"CPU Core 7",
                                            @"PC7C" : @"CPU Core 8",
                                            @"PCPC" : @"CPU Cores",
                                            @"PCPG" : @"CPU GFX",
                                            @"PCPD" : @"CPU DRAM",
                                            @"PCTR" : @"CPU Total",
                                            @"PCPL" : @"CPU Total",
                                            @"PC1R" : @"CPU Rail",
                                            @"PC5R" : @"CPU S0 Rail",
                                            
                                            @"PGTR" : @"GPU Total",
                                            @"PG0R" : @"GPU Rail",
                                            
                                            @"PM0R" : @"Memory Rail",
                                            
                                            @"PN0C" : @"MCH",
                                            @"PN1R" : @"PCH Rail",
                                            
                                            @"PC0R" : @"Mainboard S0 Rail",
                                            @"PD0R" : @"Mainboard S0 Rail",
                                            @"PD5R" : @"Mainboard S5 Rail",
                                            @"PH02" : @"Main 3.3V Rail",
                                            @"PH05" : @"Main 5V Rail",
                                            @"Pp0R" : @"12V Rail",
                                            @"PD2R" : @"Main 12V Rail",
                                            @"PO0R" : @"Misc. Rail",
                                            @"PBLC" : @"Battery Rail",
                                            @"PB0R" : @"Battery Rail",
                                            
                                            @"PDTR" : @"DC In Total",
                                            @"PSTR" : @"System Total" };
    }
    
    return self;
}

// Get SMC temp keys that are available on the current device
- (NSArray *)workingTempKeys {
    
    NSMutableArray *workingKeysMutable = [[NSMutableArray alloc] init];
    
    for (id key in self.allTempKeys) {
        
        const char *tempKey = [key UTF8String];
        
        // Use C strncpy as a workaround for UTF8String
        // returning const char * instead of char *
        char *copy = calloc(4, 1);
        strncpy(copy, tempKey, 4);
        
        NSNumber *temp;
        
        [self.smc readKey:copy intoNumber:&temp];
        
        free(copy);
        
        // Check if the temperature is 0
        if ([temp doubleValue] != 0) {
            
            [workingKeysMutable addObject:key];
        }
    }
    
    NSArray *workingKeys = [[NSArray alloc] initWithArray:workingKeysMutable];
    
    return workingKeys;
}

// Get SMC voltage keys that are available on the current device
- (NSArray *)workingVoltageKeys {
    
    NSMutableArray *workingKeysMutable = [[NSMutableArray alloc] init];
    
    for (id key in self.allVoltageKeys) {
        
        const char *keyChar = [key UTF8String];
        
        // Use C strncpy as a workaround for UTF8String
        // returning const char * instead of char *
        char *copy = calloc(4, 1);
        strncpy(copy, keyChar, 4);
        
        NSNumber *value;
        
        [self.smc readKey:copy intoNumber:&value];
        
        free(copy);
        
        // Check if the value is 0
        if ([value doubleValue] != 0) {
            
            [workingKeysMutable addObject:key];
        }
    }
    
    NSArray *workingKeys = [[NSArray alloc] initWithArray:workingKeysMutable];
    
    return workingKeys;
}

// Get SMC current keys that are available on the current device
- (NSArray *)workingCurrentKeys {
    
    NSMutableArray *workingKeysMutable = [[NSMutableArray alloc] init];
    
    for (id key in self.allCurrentKeys) {
        
        const char *keyChar = [key UTF8String];
        
        // Use C strncpy as a workaround for UTF8String
        // returning const char * instead of char *
        char *copy = calloc(4, 1);
        strncpy(copy, keyChar, 4);
        
        NSNumber *value;
        
        [self.smc readKey:copy intoNumber:&value];
        
        free(copy);
        
        // Check if the value is 0
        if ([value doubleValue] != 0) {
            
            [workingKeysMutable addObject:key];
        }
    }
    
    NSArray *workingKeys = [[NSArray alloc] initWithArray:workingKeysMutable];
    
    return workingKeys;
}

// Get SMC power keys that are available on the current device
- (NSArray *)workingPowerKeys {
    
    NSMutableArray *workingKeysMutable = [[NSMutableArray alloc] init];
    
    for (id key in self.allPowerKeys) {
        
        const char *keyChar = [key UTF8String];
        
        // Use C strncpy as a workaround for UTF8String
        // returning const char * instead of char *
        char *copy = calloc(4, 1);
        strncpy(copy, keyChar, 4);
        
        NSNumber *value;
        
        [self.smc readKey:copy intoNumber:&value];
        
        free(copy);
        
        // Check if the value is 0
        if ([value doubleValue] != 0) {
            
            [workingKeysMutable addObject:key];
        }
    }
    
    NSArray *workingKeys = [[NSArray alloc] initWithArray:workingKeysMutable];
    
    return workingKeys;
}

- (NSUInteger)numberOfFans {
    
    return [self rawValueForKey:@"FNum"];
}

// Get CPU temperature in degrees celsius
- (double)cpuTemperatureInDegreesCelsius {
    
    NSArray *keys = @[@"TC0P", @"TC0D", @"TC1C", @"TC2C"];
    
    double maximum = 0;
    
    for (int i = 0; i < keys.count; i++) {
        
        const char *tempKey = [keys[i] UTF8String];
        
        // Use C strncpy as a workaround for UTF8String
        // returning const char * instead of char *
        char *copy = calloc(4, 1);
        strncpy(copy, tempKey, 4);
        
        NSNumber *temp;
        
        [self.smc readKey:copy intoNumber:&temp];
        
        if ([temp doubleValue] > maximum) {
            
            maximum = [temp doubleValue];
        }
        
        free(copy);
    }
    
    return maximum;
}

// Get CPU temperature in degrees fahrenheit
- (double)cpuTemperatureInDegreesFahrenheit {
    
    return celsiusToFahrenheit([self cpuTemperatureInDegreesCelsius]);
}

- (NSString *)humanReadableNameForKey:(NSString *)key {
    
    return [self.humanReadableNamesForKeys objectForKey:key];
}

- (double)temperatureInCelsiusForKey:(NSString *)key {
    
    const char *tempKey = [key UTF8String];
    
    // Use C strncpy as a workaround for UTF8String
    // returning const char * instead of char *
    char *copy = calloc(4, 1);
    strncpy(copy, tempKey, 4);
    
    NSNumber *temp;
    
    [self.smc readKey:copy intoNumber:&temp];
    
    free(copy);
    
    // Check if the temperature is 0
    if ([temp doubleValue] != 0) {
        
        return [temp doubleValue];
        
    } else {
        
        NSLog(@"Error getting temperature - returning -1!");
        return -1;
    }
}

- (double)temperatureInFahrenheitForKey:(NSString *)key {
    
    return celsiusToFahrenheit([self temperatureInCelsiusForKey:key]);
}

- (double)speedOfFan:(NSUInteger)fan {
    
    return [self rawValueForKey:[NSString stringWithFormat:@"F%luAc", (unsigned long)fan]];
}

- (double)safeMinimumSpeedOfFan:(NSUInteger)fan {
    
    return [self rawValueForKey:[NSString stringWithFormat:@"F%luMn", (unsigned long)fan]];
}

- (double)safeMaximumSpeedOfFan:(NSUInteger)fan {
    
    return [self rawValueForKey:[NSString stringWithFormat:@"F%luMx", (unsigned long)fan]];
}

- (double)rawValueForKey:(NSString *)key {
    
    const char *tempKey = [key UTF8String];
    
    // Use C strncpy as a workaround for UTF8String
    // returning const char * instead of char *
    char *copy = calloc(4, 1);
    strncpy(copy, tempKey, 4);
    
    NSNumber *value;
    
    [self.smc readKey:copy intoNumber:&value];
    
    free(copy);
    
    // Check if the value is 0
    return [value doubleValue];
}

@end
