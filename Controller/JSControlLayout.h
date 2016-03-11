//
//  JSControlLayout.h
//  Controller
//
//

#import <UIKit/UIKit.h>
#import "JSDPad.h"
#import "JSButton.h"

@interface JSControlLayout : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) UIDeviceOrientation orientation;

@property (nonatomic, assign) id <JSDPadDelegate, JSButtonDelegate> delegate;

- (id)initWithLayout:(NSString *)layoutFile delegate:(id <JSDPadDelegate, JSButtonDelegate>)delegate;

@end
