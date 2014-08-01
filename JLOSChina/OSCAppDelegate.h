//
//  JLAppDelegate.h
//  JLOSChina
//
//  Created by jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
#import "OSCTabBarC.h"

@interface OSCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController *sidePanelController;
@property (strong, nonatomic) OSCTabBarC *tabBarC;

@end
