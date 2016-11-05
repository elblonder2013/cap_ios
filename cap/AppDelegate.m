//
//  AppDelegate.m
//  cap
//
//  Created by Alexei Pineda Caraballo on 7/22/16.
//  Copyright © 2016 Alexei Pineda Caraballo. All rights reserved.
//

#import "AppDelegate.h"
#import "Static.h"
#import "GestorV.h"
#import "LoginViewController.h"
#import "HomeAdministradorVC.h"
#import "HomeContadorVC.h"
#import "HomeInversionistaVC.h"
#import "HomeJuridicoVC.h"
#import "HomeUsuario.h"
#import "HomeSocioInversionistaVC.h"
#import "HomeGerenteVC.h"
#import "Common.h"
#import "Constants.h"
#import "HomePromotorVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Static
    [[Static sharedInstance] loadInitial];
    
    // Appearance
    [self appearance];
    
    // Cache
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    
    
    // Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.backgroundColor = BackgroundColor;
    self.window.rootViewController = [self decideRootViewController];
    [self.window makeKeyAndVisible];
    [GestorV getGV].alto = self.window.frame.size.height;
    [GestorV getGV].ancho = self.window.frame.size.width;
    
    return YES;

}



- (UIViewController *)decideRootViewController
{
    UINavigationController *navigationController;
    
    // If Login
    if ([[Static sharedInstance] isLogin])
    {
        /*HomeViewController *homeController = [[HomeViewController alloc] init];
        
        navigationController = [[UINavigationController alloc]
                                initWithRootViewController:homeController];*/
    }
    else
    {
        LoginViewController *loginController;
        /*if (IS_IPAD)
         loginController = [[HomeViewController alloc]
         initWithNibName:@"LoginControllerIPAD" bundle:nil];
         else*/
        loginController = [[LoginViewController alloc]
                           initWithNibName:@"LoginViewController" bundle:nil];
        
        navigationController = [[UINavigationController alloc]
                                initWithRootViewController:loginController];
        navigationController.navigationBarHidden = YES;
    }
    
    return navigationController;
}

- (void)showHome:(UIViewController *)current
{
    
    UINavigationController *homeController;
    NSString * rol = [GestorV getGV].rol;
    if ([rol isEqualToString:@"ADMIN"]) {
        homeController = (HomeAdministradorVC *)[[HomeAdministradorVC alloc] init];
    }
   else  if ([rol isEqualToString:@"GERENTE"]) {
        homeController = (HomeGerenteVC *)[[HomeGerenteVC alloc] init];
    }
   else  if ([rol isEqualToString:@"PROMOTOR"]) {
       homeController = (HomePromotorVC *)[[HomePromotorVC alloc] init];
   }
   else  if ([[GestorV getGV].rol isEqualToString:@"contador"]) {
        homeController = [[HomeContadorVC alloc] init];
    }
   else  if ([[GestorV getGV].rol isEqualToString:@"INVERSIONISTA"]) {
       homeController = [[HomeInversionistaVC alloc] init];
   }
   else  if ([[GestorV getGV].rol isEqualToString:@"jurídico"]) {
       homeController = [[HomeJuridicoVC alloc] init];
   }
   else  if ([[GestorV getGV].rol isEqualToString:@"socio_inversionista"]) {
       homeController = [[HomeSocioInversionistaVC alloc] init];
   }
   else  if ([[GestorV getGV].rol isEqualToString:@"usuario"]) {
       homeController = [[HomeUsuario alloc] init];
   }
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeController];
    
    UIView *overlayView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    [navigationController.view addSubview:overlayView];
    self.window.rootViewController = navigationController;
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCrossDissolve animations:
     ^{
         overlayView.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         [overlayView removeFromSuperview];
         [current removeFromParentViewController];
     }];
}

- (void)showLogin:(UIViewController *)current
{
    LoginViewController *loginController = [[LoginViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    navigationController.navigationBarHidden = YES;
    
    UIView *overlayView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    [navigationController.view addSubview:overlayView];
    self.window.rootViewController = navigationController;
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionCrossDissolve animations:
     ^{
         overlayView.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         [overlayView removeFromSuperview];
         [current removeFromParentViewController];
     }];
}


- (void)appearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
