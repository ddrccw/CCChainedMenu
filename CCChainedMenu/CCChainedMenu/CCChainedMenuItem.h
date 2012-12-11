//
//  CCChainedMenuItem.h
//  iMCS
//
//  Created by ddrccw on 12-11-30.
//  Copyright (c) 2012年 ddrccw. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    CCChainedMenuItemTypeTrunk,
    CCChainedMenuItemTypeLeaf
};

typedef UInt8 CCChainedMenuItemType;

@interface CCChainedMenuItem : UIControl
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint farPoint;
@property (nonatomic, assign) CGPoint nearPoint;
@property (nonatomic, assign) CGPoint transitionPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CCChainedMenuItemType type;

- (id)initWithBackgroundImage:(UIImage *)backgroundImage
   backgroundHighlightedImage:(UIImage *)backgroundHighlightedImage
                 contentImage:(UIImage *)contentImage
      contentHighlightedImage:(UIImage *)contentHighlightedImage;
@end
