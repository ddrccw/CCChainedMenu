//
//  CCChainedMenu.h
//  iMCS
//
//  Created by ddrccw on 12-11-30.
//  Copyright (c) 2012年 ddrccw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCChainedMenuItem.h"

enum {
    CCChainedMenuUnfoldDirectionUp = 1 << 0,
    CCChainedMenuUnfoldDirectionDown = 1 << 1,
    CCChainedMenuUnfoldDirectionLeft = 1 << 2,
    CCChainedMenuUnfoldDirectionRight = 1 << 3
};

typedef UInt8 CCChainedMenuUnfoldDirection;

@class CCChainedMenu;
@protocol CCChainedMenuDelegate <NSObject>
- (void)chainedMenu:(CCChainedMenu *)chainedMenu
didSelectedItemAtIndex:(NSInteger)index;

@optional
- (void)chainedMenuWillUnfold;

@end

@interface CCChainedMenu : UIView
@property (nonatomic, retain) CCChainedMenuItem *switchBtn;
@property (nonatomic, retain) NSArray *menuItems;
@property (nonatomic, assign) BOOL unfold;
@property (nonatomic, assign) CCChainedMenuUnfoldDirection direction;
@property (nonatomic, assign) id<CCChainedMenuDelegate> delegate;

- (id)initWithBasePoint:(CGPoint)basePoint
        unfoldDirection:(CCChainedMenuUnfoldDirection)direction
              menuItems:(NSArray *)menuItems;
- (CGSize)visibleSize;
@end
