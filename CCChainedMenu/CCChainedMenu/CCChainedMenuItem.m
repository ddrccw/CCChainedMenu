//
//  CCChainedMenuItem.m
//  iMCS
//
//  Created by ddrccw on 12-11-30.
//  Copyright (c) 2012年 ddrccw. All rights reserved.
//

#import "CCChainedMenuItem.h"
#import <QuartzCore/QuartzCore.h>
@interface CCChainedMenuItem ()
@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UIImageView *contentImageView;
@end

@implementation CCChainedMenuItem
@synthesize backgroundImageView = _backgroundImageView;
@synthesize contentImageView = _contentImageView;
@synthesize startPoint = _startPoint;
@synthesize transitionPoint = _transitionPoint;
@synthesize endPoint = _endPoint;
@synthesize type = _type;

- (void)dealloc {
    [_backgroundImageView release];
    [_contentImageView release];
    [super dealloc];
}

- (id)initWithBackgroundImage:(UIImage *)backgroundImage
   backgroundHighlightedImage:(UIImage *)backgroundHighlightedImage
                 contentImage:(UIImage *)contentImage
      contentHighlightedImage:(UIImage *)contentHighlightedImage
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        _type = CCChainedMenuItemTypeLeaf;
        _backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage
                                                 highlightedImage:backgroundHighlightedImage];
        _contentImageView = [[UIImageView alloc] initWithImage:contentImage
                                              highlightedImage:contentHighlightedImage];
        [self addSubview:_backgroundImageView];
        [self addSubview:_contentImageView];
        
        self.bounds = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        _backgroundImageView.frame = self.bounds;
        _contentImageView.center = _backgroundImageView.center;
        
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = .8;
        self.layer.shadowRadius = 2.0f;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (CCChainedMenuItemTypeTrunk != _type) {
        [self.backgroundImageView setHighlighted:highlighted];
        [self.contentImageView setHighlighted:highlighted];
    }
}

- (void)setSelected:(BOOL)selected {
    if (CCChainedMenuItemTypeTrunk == _type) {
        [self.backgroundImageView setHighlighted:selected];
        [self.contentImageView setHighlighted:selected];
    }
}

@end
