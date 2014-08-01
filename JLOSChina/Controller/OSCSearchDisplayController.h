//
//  OSCSearchDisplayController.h
//  JLOSChina
//
//  Created by Lee jimney on 6/2/14.
//  Copyright (c) 2014 jimneylee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OSCSearchDisplayDelegate;

// 由于无法继承UISearchDisplayController，所以此处采用引入一个属性来实现封装
@interface OSCSearchDisplayController : NSObject

@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic, weak) id<OSCSearchDisplayDelegate> delegate;

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController *)viewController;

@end

@protocol OSCSearchDisplayDelegate <NSObject>

- (void)searchWithKeywords:(NSString *)keywords selectedScopeButtonIndex:(NSInteger)selectedScope;

@end