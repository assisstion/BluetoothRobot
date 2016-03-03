//
//  JSViewController.m
//  Controller
//
//  Created by James Addyman on 28/03/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//
// Bluetooth Code:
// http://www.raywenderlich.com/52080/introduction-core-bluetooth-building-heart-rate-monitor
// http://code.tutsplus.com/tutorials/ios-7-sdk-core-bluetooth-practical-lesson--mobile-20741
// http://embeddedsoftdev.blogspot.ca/p/ehal-nrf51.html
// https://github.com/I-SYST/iOS/blob/master/BlinkyBle/BlinkyBle/ViewController.m

#import "JSViewController.h"
#import "JSDPad.h"

#ifndef CBTutorial_SERVICES_h
#define CBTutorial_SERVICES_h

#define TRANSFER_SERVICE_UUID           @"713D0000-503E-4C75-BA94-3148F18D941E"

#define TRANSFER_CHARACTERISTIC_UUID    @"713D0002-503E-4C75-BA94-3148F18D941E"
#define TRANSFER_WRITE_UUID             @"713D0003-503E-4C75-BA94-3148F18D941E"
#define TRANSFER_RESET_UUID             @"713D0004-503E-4C75-BA94-3148F18D941E"


#define NOTIFY_MTU 20


#endif

typedef struct
{
    double x;
    double y;
} Coords;

@interface JSViewController () {
    
    
    NSMutableArray *_pressedButtons;
    
}

- (NSString *)stringForDirection:(JSDPadDirection)direction;

@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    //_data = [[NSMutableData alloc] init];
    
    [[self.aButton titleLabel] setText:@"A"];
    [self.aButton setBackgroundImage:[UIImage imageNamed:@"button"]];
    [self.aButton setBackgroundImagePressed:[UIImage imageNamed:@"button-pressed"]];
    
    
    [[self.bButton titleLabel] setText:@"B"];
    [self.bButton setBackgroundImage:[UIImage imageNamed:@"button"]];
    [self.bButton setBackgroundImagePressed:[UIImage imageNamed:@"button-pressed"]];
    
    _pressedButtons = [NSMutableArray new];
    
    [self updateDirectionLabel];
    [self updateButtonLabel];
    [self updateAnalogueLabel];
}

-(void)viewDidDisappear:(BOOL)animated{
    [_centralManager stopScan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)stringForDirection:(JSDPadDirection)direction
{
    NSString *string = nil;
    
    switch (direction) {
        case JSDPadDirectionNone:
            string = @"None";
            break;
        case JSDPadDirectionUp:
            string = @"Up";
            break;
        case JSDPadDirectionDown:
            string = @"Down";
            break;
        case JSDPadDirectionLeft:
            string = @"Left";
            break;
        case JSDPadDirectionRight:
            string = @"Right";
            break;
        case JSDPadDirectionUpLeft:
            string = @"Up Left";
            break;
        case JSDPadDirectionUpRight:
            string = @"Up Right";
            break;
        case JSDPadDirectionDownLeft:
            string = @"Down Left";
            break;
        case JSDPadDirectionDownRight:
            string = @"Down Right";
            break;
        default:
            string = @"None";
            break;
    }
    
    return string;
}

- (void)updateDirectionLabel
{
    [self.directionlabel setText:[NSString stringWithFormat:@"Direction: %@", [self stringForDirection:[self.dPad currentDirection]]]];
}

- (void)updateButtonLabel
{
    NSString *buttonString = @"";
    
    for(JSButton *button in _pressedButtons)
    {
        if ([buttonString length])
        {
            buttonString = [buttonString stringByAppendingFormat:@", "];
        }
        
        if ([button isEqual:self.aButton])
        {
            buttonString = [buttonString stringByAppendingFormat:@"A"];
        }
        else if ([button isEqual:self.bButton])
        {
            buttonString = [buttonString stringByAppendingFormat:@"B"];
        }
    }
    
    [self.buttonLabel setText:[NSString stringWithFormat:@"Buttons pressed: %@", buttonString]];
}

- (void)updateAnalogueLabel
{
    [self.analogueLabel setText:[NSString stringWithFormat:@"Analogue: %.1f , %.1f", self.analogueStick.xValue, self.analogueStick.yValue]];
}

#pragma mark - JSDPadDelegate

- (void)dPad:(JSDPad *)dPad didPressDirection:(JSDPadDirection)direction
{
    NSLog(@"Changing direction to: %@", [self stringForDirection:direction]);
    [self updateDirectionLabel];
}

- (void)dPadDidReleaseDirection:(JSDPad *)dPad
{
    NSLog(@"Releasing DPad");
    [self updateDirectionLabel];
}

#pragma mark - JSButtonDelegate

- (void)buttonPressed:(JSButton *)button
{
    if ([_pressedButtons containsObject:button])
    {
        NSLog(@"Button is already being tracked as pressed");
        return;
    }
    
    if ([button isEqual:self.aButton])
    {
        [_pressedButtons addObject:self.aButton];
    }
    else if ([button isEqual:self.bButton])
    {
        [_pressedButtons addObject:self.bButton];
    }
    
    [self updateButtonLabel];
}

- (void)buttonReleased:(JSButton *)button
{
    if ([_pressedButtons containsObject:button] == NO)
    {
        NSLog(@"Button has already been released");
        return;
    }
    
    if ([button isEqual:self.aButton])
    {
        //UInt8 data[2] = {1, 0};
        //[self writeData:[NSData dataWithBytes:data length:2]];
        
        [_pressedButtons removeObject:self.aButton];
    }
    else if ([button isEqual:self.bButton])
    {
        //UInt8 data[2] = {2, 0};
        //[self writeData:[NSData dataWithBytes:data length:2]];

        [_pressedButtons removeObject:self.bButton];
    }
    
    [self updateButtonLabel];
    
}

-(void)writeData:(NSData *) data{
    if(self.discoveredPeripheral != nil && self.characteristic != nil){
        NSLog(@"Sent data");
        //Send a bluetooth event
        [self.discoveredPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
    }
}

#pragma mark - JSAnalogueStickDelegate

- (void)analogueStickDidChangeValue:(JSAnalogueStick *)analogueStick
{
    Coords coords = [self convertX:analogueStick.xValue andY:analogueStick.yValue];
    UInt8 fx = (coords.x + 1) * 127 + 1;
    UInt8 fy = (coords.y + 1) * 127 + 1;
    NSLog(@"left: %i right: %i", fx, fy);
    UInt8 data[2] = {fx, fy};
    
    
    [self writeData:[NSData dataWithBytes:data length:2]];
    [self updateAnalogueLabel];
}

#pragma mark - CBCentralManagerDelegate

//Bluetooth handlers

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connected");
    
    [_centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    //[_data setLength:0];
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    if (_discoveredPeripheral != peripheral) {
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        _discoveredPeripheral = peripheral;
        
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        [_centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Failed to connect");
    [self cleanup];
}

- (void)cleanup {
    
    // See if we are subscribed to a characteristic on the peripheral
    if (_discoveredPeripheral.services != nil) {
        for (CBService *service in _discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            [_discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
        }
    }
    
    [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // You should test all scenarios
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        NSLog(@"Scanning started");
    }
}

#pragma mark - CBPeripheralDelegate

//Peripheral handlers

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID], [CBUUID UUIDWithString:TRANSFER_WRITE_UUID], [CBUUID UUIDWithString:TRANSFER_RESET_UUID]] forService:service];
    }
    // Discover other characteristics
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
         NSLog(@"Discovered characteristic %@", characteristic);
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_WRITE_UUID]]) {
            self.characteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_RESET_UUID]]) {
            self.resetChar = characteristic;
            //[peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error");
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        //[_textview setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        [_centralManager cancelPeripheralConnection:peripheral];
    }
    
    //[_data appendData:characteristic.value];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    [self enableWrite];
    
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
        
    } else {
        // Notification has stopped
        [_centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    _discoveredPeripheral = nil;
    
    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

-(Coords)convertX: (double) x andY:(double) y{
    double r = sqrt(x*x + y*y);
    double theta = atan2(x, y);
    theta = theta + M_PI/4;
    double newX = r * cos(theta);
    double newY = r * sin(theta);
    double maxValue = fmax(fabs(x), fabs(y));
    return [self normalizeX:newX andY:newY withMax:maxValue];
}

-(Coords)normalizeX: (double) x andY: (double) y withMax: (double) maxValue{
    if(maxValue == 0){
        return [self makeCoordWithX:x andY:y];
    }
    double ratio = fabs(fmax(fabs(x), fabs(y)) / maxValue);
    return [self makeCoordWithX:x/ratio andY:y/ratio];
}

-(Coords)makeCoordWithX: (double) x andY: (double) y{
    Coords coord;
    coord.x = x;
    coord.y = y;
    return coord;
}

-(void) enableWrite
{
    NSLog(@"Enable write");

    //CBUUID *uuid_service = [CBUUID UUIDWithString:TRANSFER_SERVICE_UUID];
    //CBUUID *uuid_char = [CBUUID UUIDWithString:TRANSFER_RESET_UUID];
    unsigned char bytes[] = {0x01};
    NSData *d = [[NSData alloc] initWithBytes:bytes length:1];
    if(self.discoveredPeripheral != nil && self.resetChar != nil){
        NSLog(@"Sent data 0");
        //Send a bluetooth event
        [self.discoveredPeripheral writeValue:d forCharacteristic:self.resetChar type:CBCharacteristicWriteWithoutResponse];
    }
    //[self writeValue:uuid_service characteristicUUID:uuid_char p:activePeripheral data:d];
}

@end
