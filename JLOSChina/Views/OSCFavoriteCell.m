//
//  RCNodeCell.m
//  JLOSChina
//
//  Created by jimneylee on 13-12-11.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "OSCFavoriteCell.h"
#import "OSCFavoriteEntity.h"

#define TITLE_FONT_SIZE [UIFont systemFontOfSize:16.f]

@interface OSCFavoriteCell()
@end
@implementation OSCFavoriteCell

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    CGFloat height = 0.f;
    CGFloat contentViewMarin = CELL_PADDING_10;
    
    OSCFavoriteEntity* o = (OSCFavoriteEntity*)object;
    CGFloat kContentLength =  tableView.width - contentViewMarin * 2;
    
    height = height + contentViewMarin;

#if 1
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:o.title
                                    attributes:@{NSFontAttributeName:TITLE_FONT_SIZE}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){kContentLength, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
#else
    CGSize size = [o.title sizeWithFont:SUBTITLE_FONT_SIZE
                                        constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                            lineBreakMode:NSLineBreakByWordWrapping];
#endif
    height = height + size.height;
    height = height + contentViewMarin;
    
    return height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.textLabel.font = TITLE_FONT_SIZE;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.numberOfLines = 0;
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse
{
    [super prepareForReuse];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat contentViewMarin = CELL_PADDING_10;
    CGFloat kContentLength = self.contentView.width - contentViewMarin * 2;

#if 1
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:self.textLabel.text
                                    attributes:@{NSFontAttributeName:TITLE_FONT_SIZE}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){kContentLength, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
#else
    CGSize size = [self.detailTextLabel.text sizeWithFont:SUBTITLE_FONT_SIZE
                                         constrainedToSize:CGSizeMake(kContentLength, FLT_MAX)
                                             lineBreakMode:NSLineBreakByWordWrapping];
#endif
    self.textLabel.frame = CGRectMake(contentViewMarin, contentViewMarin,
                                      kContentLength, size.height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldUpdateCellWithObject:(id)object
{
    [super shouldUpdateCellWithObject:object];
    if ([object isKindOfClass:[OSCFavoriteEntity class]]) {
        OSCFavoriteEntity* o = (OSCFavoriteEntity*)object;
        self.textLabel.text = o.title;
    }
    return YES;
}

@end
