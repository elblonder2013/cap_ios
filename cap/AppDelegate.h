//
//  AppDelegate.h
//  cap
//
//  Created by Alexei Pineda Caraballo on 7/22/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)showHome:(UIViewController *)current;
- (void)showLogin:(UIViewController *)current;
@end

