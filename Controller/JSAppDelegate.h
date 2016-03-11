//
//  JSAppDelegate.h
//  Controller
//
//
// Much of the interface work done here was previously created by James Addyman(Jamsoft) and taken from his website and work.
// His work has been edited and added to in order to serve our various functions. 

#import <UIKit/UIKit.h>

@class JSViewController;

@interface JSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JSViewController *viewController;

@end
