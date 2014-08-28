//
//  OSCFavoriteEntity.h
//  JLOSChina
//
//  Created by jimneylee on 14-8-28.
//  Copyright (c) 2014年 jimneylee. All rights reserved.
//

#import "JLNimbusEntity.h"

@interface OSCFavoriteEntity : JLNimbusEntity

@property (nonatomic, copy)   NSString *objectId;
@property (nonatomic, assign) OSCMyFavoriteCatalogType type;

@end
