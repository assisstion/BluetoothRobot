//
//  JSViewController.h
//  Controller
//
//

#import <UIKit/UIKit.h>
#import "JSDPad.h"
#import "JSButton.h"
#import "JSAnalogueStick.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <QuartzCore/QuartzCore.h>

@interface JSViewController : UIViewController <JSDPadDelegate, JSButtonDelegate, JSAnalogueStickDelegate,
CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property CBCharacteristic * writeCharacteristic;

@property (weak, nonatomic) IBOutlet UILabel *directionlabel;
@property (weak, nonatomic) IBOutlet UILabel *buttonLabel;
@property (weak, nonatomic) IBOutlet UILabel *analogueLabel;
@property (weak, nonatomic) IBOutlet JSDPad *dPad;
@property (weak, nonatomic) IBOutlet JSButton *bButton;
@property (weak, nonatomic) IBOutlet JSButton *aButton;
@property (weak, nonatomic) IBOutlet JSAnalogueStick *analogueStick;
@property NSMutableArray *pressedButtons;

@end
