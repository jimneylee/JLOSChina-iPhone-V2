//
//  RCTopicDetailC.h
//  JLOSChina
//
//  Created by Lee jimney on 12/10/13.
//  Copyright (c) 2013 jimneylee. All rights reserved.
//

#import "JLNimbusTableViewController.h"

// TODO:楼层调转
@interface OSCCommonDetailC : JLNimbusTableViewController

- (id)initWithTopicId:(NSString *)topicId
            topicType:(OSCCatalogType)type;
- (void)replyTopicWithFloorAtSomeone:(NSString *)floorAtsomeoneString;

@end
