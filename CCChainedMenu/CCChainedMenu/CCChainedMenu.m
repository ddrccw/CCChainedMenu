//
//  CCChainedMenu.m
//  iMCS
//
//  Created by ddrccw on 12-11-30.
//  Copyright (c) 2012年 ddrccw. All rights reserved.
//

#import "CCChainedMenu.h"
#import <QuartzCore/QuartzCore.h>

static const UInt8 kTagOffSet = 100;
static const UInt16 kMenuItemSpacing = 15;

static BOOL chainedMenuUnfoldDirectionIsLandscape(CCChainedMenuUnfoldDirection direction) {
    return ((direction == CCChainedMenuUnfoldDirectionLeft) ||
            (direction == CCChainedMenuUnfoldDirectionRight));
}

@interface CCChainedMenu () {
    CGSize maxSize_;
    CGSize minSize_;
}
@property (nonatomic, assign) CGPoint basePoint;

- (void)toggleMenu;
- (void)selectedMenuItem:(CCChainedMenuItem *)menuItem;
- (CAAnimationGroup *)blowupAnimationAtPoint:(CGPoint)p;
- (CAAnimationGroup *)shrinkAnimationAtPoint:(CGPoint)p;
- (void)relayoutMenu;
- (void)relayoutMenuItems;
- (void)unfoldMenu;
- (CAAnimationGroup *)unfoldAnimationForMenuItem:(CCChainedMenuItem *)item;
- (void)foldMenu;
- (CAAnimationGroup *)foldAnimationForMenuItem:(CCChainedMenuItem *)item;
@end

@implementation CCChainedMenu
@synthesize basePoint = _basePoint;
@synthesize switchBtn = _switchBtn;
@synthesize menuItems = _menuItems;
@synthesize unfold = _unfold;
@synthesize direction = _direction;
@synthesize delegate = _delegate;

- (void)dealloc {
    [_switchBtn release];
    [_menuItems release];
    [super dealloc];
}

- (id)initWithBasePoint:(CGPoint)basePoint
        unfoldDirection:(CCChainedMenuUnfoldDirection)direction
              menuItems:(NSArray *)menuItems {
    if (self = [super init]) {
        _basePoint = basePoint;
        self.backgroundColor = [UIColor clearColor];
        _direction = direction;
        
        _unfold = NO;
        _switchBtn = [[CCChainedMenuItem alloc] initWithBackgroundImage:[UIImage imageNamed:@"switchBtn"]
                                             backgroundHighlightedImage:[UIImage imageNamed:@"switchBtnHighlighted"]
                                                           contentImage:nil
                                                contentHighlightedImage:nil];
        _switchBtn.type = CCChainedMenuItemTypeTrunk;
        [self addSubview:_switchBtn];
        [_switchBtn addTarget:self
                       action:@selector(toggleMenu)
             forControlEvents:UIControlEventTouchUpInside];
        self.menuItems = menuItems;
        [self relayoutMenu];
    }
    return self;
}

- (void)toggleMenu {
    self.unfold = !self.unfold;
    self.switchBtn.selected = self.unfold;
}

- (void)setMenuItems:(NSArray *)menuItems {
    if (_menuItems != menuItems) {
        [menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CCChainedMenuItem *item = obj;
            [item removeTarget:self
                        action:@selector(selectedMenuItem:)
              forControlEvents:UIControlEventTouchUpInside];
            [item removeFromSuperview];
        }];
        
        [_menuItems release];
        _menuItems = [menuItems retain];
        
        __block UIView *tmpView = _switchBtn;
        [_menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CCChainedMenuItem *item = obj;
            item.tag = kTagOffSet + idx;
            item.alpha = 0;
            [item addTarget:self
                     action:@selector(selectedMenuItem:)
           forControlEvents:UIControlEventTouchUpInside];
            [self insertSubview:item belowSubview:tmpView];
            tmpView = item;
        }];
    }
}

- (void)selectedMenuItem:(CCChainedMenuItem *)menuItem {
    CAAnimationGroup *animationGroup = [self blowupAnimationAtPoint:menuItem.center];
    [menuItem.layer addAnimation:animationGroup forKey:@"blowup"];
    menuItem.center = menuItem.startPoint;
    for (CCChainedMenuItem *item in self.menuItems) {
        if (item.tag == menuItem.tag) {
            continue;
        }
        
        animationGroup = [self shrinkAnimationAtPoint:item.center];
        [item.layer addAnimation:animationGroup forKey:@"shrink"];
        item.center = item.startPoint;
    }
    if ([self.delegate respondsToSelector:@selector(chainedMenu:didSelectedItemAtIndex:)]) {
        [self.delegate chainedMenu:self didSelectedItemAtIndex:(menuItem.tag - kTagOffSet)];
    }
    
    float angle = 0;
    [UIView animateWithDuration:0.2f animations:^{
        _switchBtn.transform = CGAffineTransformMakeRotation(angle);
    }];
    _unfold = NO;
    self.switchBtn.selected = _unfold;
}

- (CAAnimationGroup *)blowupAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}

- (CAAnimationGroup *)shrinkAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = .3f;
    opacityAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1],
                               [NSNumber numberWithFloat:0],
                               nil];
    opacityAnimation.calculationMode = kCAAnimationLinear;
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}


- (void)relayoutMenu {
    if (!_menuItems || ![_menuItems count]) {
        return;
    }

    __block float length = 0;
    [_menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CCChainedMenuItem *item = obj;
        if (chainedMenuUnfoldDirectionIsLandscape(_direction)) {
            length += item.bounds.size.width;
        }
        else {
            length += item.bounds.size.height;
        }
    }];
    
    int count = [_menuItems count];
    CGRect rect = CGRectZero;
    CGSize switchBtnSize = _switchBtn.bounds.size;
    length += count * kMenuItemSpacing;
    switch (_direction) {
        case CCChainedMenuUnfoldDirectionRight:
            length += switchBtnSize.width;
            rect.origin = _basePoint;
            rect.size.width = length;
            rect.size.height = switchBtnSize.height;
            self.frame = rect;
            
            rect.origin = CGPointZero;
            rect.size = switchBtnSize;
            _switchBtn.frame = rect;
            break;
        case CCChainedMenuUnfoldDirectionDown:
            length += switchBtnSize.height;
            rect.origin = _basePoint;
            rect.size.width = switchBtnSize.width;
            rect.size.height = length;
            self.frame = rect;
 
            rect.origin = CGPointZero;
            rect.size = switchBtnSize;
            _switchBtn.frame = rect;
            break;
        case CCChainedMenuUnfoldDirectionLeft:
            rect.origin.x = _basePoint.x - length;
            rect.origin.y = _basePoint.y;
            rect.size.width = length + switchBtnSize.width;
            rect.size.height = switchBtnSize.height;
            self.frame = rect;
            
            rect.origin.x = length;
            rect.origin.y = 0;
            rect.size = switchBtnSize;
            _switchBtn.frame = rect;
            break;
        case CCChainedMenuUnfoldDirectionUp:
            rect.origin.x = _basePoint.x;
            rect.origin.y = _basePoint.y - length;
            rect.size.width = switchBtnSize.width;
            rect.size.height = length + switchBtnSize.height;
            self.frame = rect;
            
            rect.origin.x = 0;
            rect.origin.y = length;
            rect.size = switchBtnSize;
            _switchBtn.frame = rect;
            break;
        default:
            NSAssert(NO, @"direction invalid value!");
            break;
    }
   
    maxSize_ = self.bounds.size;
    minSize_ = _switchBtn.bounds.size;
    [self relayoutMenuItems];
}

- (void)relayoutMenuItems {
    const CGPoint startPoint = _switchBtn.center;
    const int farOffset = 10;
    const int nearOffset = 5;
    __block CGPoint endPoint = CGPointZero;
    __block CGPoint farPoint = CGPointZero;
    __block CGPoint nearPoint = CGPointZero;
    __block UIView *tmpView = _switchBtn;
    [self.menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        endPoint = (!idx) ? tmpView.center : [(CCChainedMenuItem *)tmpView endPoint];;
        CCChainedMenuItem *item = obj;
        item.startPoint = startPoint;
        item.center = startPoint;
        item.transitionPoint = endPoint;
        
        switch (_direction) {
            case CCChainedMenuUnfoldDirectionRight:
                endPoint.x += tmpView.bounds.size.width + kMenuItemSpacing;
                farPoint = nearPoint = endPoint;
                farPoint.x += farOffset;
                nearPoint.x -= nearOffset;
                break;
            case CCChainedMenuUnfoldDirectionDown:
                endPoint.y += tmpView.bounds.size.height + kMenuItemSpacing;
                farPoint = nearPoint = endPoint;
                farPoint.y += farOffset;
                nearPoint.y -= nearOffset;
                break;
            case CCChainedMenuUnfoldDirectionLeft:
                endPoint.x -= tmpView.bounds.size.width + kMenuItemSpacing;
                farPoint = nearPoint = endPoint;
                farPoint.x -= farOffset;
                nearPoint.x += nearOffset;
                break;
            case CCChainedMenuUnfoldDirectionUp:
                endPoint.y -= tmpView.bounds.size.height + kMenuItemSpacing;
                farPoint = nearPoint = endPoint;
                farPoint.y -= farOffset;
                nearPoint.y += nearOffset;
                break;
            default:
                NSAssert(NO, @"direction invalid value!");
                break;
        }
        
        item.endPoint = endPoint;
        item.farPoint = farPoint;
        item.nearPoint = nearPoint;
        tmpView = item;
    }];
}

- (CGSize)visibleSize {
    return self.unfold ? maxSize_ : minSize_ ;
}

- (void)setUnfold:(BOOL)unfold {
    if (_unfold == unfold) {
        return;
    }

    _unfold = unfold;
    // rotate menu switch button
    float angle = (unfold) ? M_PI_4 : 0;
    [UIView animateWithDuration:0.2f animations:^{
        _switchBtn.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    if (unfold) {
        if ([self.delegate respondsToSelector:@selector(chainedMenuWillUnfold)]) {
            [self.delegate chainedMenuWillUnfold];
        }
        [self unfoldMenu];
    }
    else {
        [self foldMenu];
    }
}

- (void)unfoldMenu {
    for (CCChainedMenuItem *item in self.menuItems) {
        CAAnimationGroup *animationgroup = [self unfoldAnimationForMenuItem:item];
        [animationgroup setValue:@"unfold" forKey:@"unfold"];
        [item.layer addAnimation:animationgroup forKey:@"unfold"];
        item.center = item.endPoint;
        item.alpha = 1;
    }
}

- (CAAnimationGroup *)unfoldAnimationForMenuItem:(CCChainedMenuItem *)item {
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    NSArray *transformValues = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:((M_PI)/64)],
                                [NSNumber numberWithFloat:0],
                                [NSNumber numberWithFloat:(-((M_PI)/64))],
                                [NSNumber numberWithFloat:0],
                                nil];
    
    [shakeAnimation setValues:transformValues];
    NSArray *times = [NSArray arrayWithObjects:
                      [NSNumber numberWithFloat:0.25f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.75f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [shakeAnimation setKeyTimes:times];
    shakeAnimation.fillMode = kCAFillModeForwards;
    shakeAnimation.duration = .13f;
    shakeAnimation.repeatCount = 8;
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = .15f;
    CGMutablePathRef path = CGPathCreateMutable();
    item.center = item.startPoint;
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = .15f;
    opacityAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:1],
                               nil];
    opacityAnimation.calculationMode = kCAAnimationLinear;
 
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation,
                                 shakeAnimation,
                                 opacityAnimation,
                                 nil];
    animationgroup.duration = 2.f;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    return animationgroup;
}

- (void)foldMenu {
    for (CCChainedMenuItem *item in self.menuItems) {
        CAAnimationGroup *animationgroup = [self foldAnimationForMenuItem:item];
        [animationgroup setValue:@"fold" forKey:@"fold"];
        [item.layer addAnimation:animationgroup forKey:@"fold"];
        item.center = item.startPoint;
        item.alpha = 0;
    }
}

- (CAAnimationGroup *)foldAnimationForMenuItem:(CCChainedMenuItem *)item {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = .3f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);

    CAKeyframeAnimation *fadeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    positionAnimation.duration = .3f;
    fadeAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1],
                                                       [NSNumber numberWithFloat:0],
                                                       nil];
    fadeAnimation.calculationMode = kCAAnimationLinear;
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation,
                                                          fadeAnimation,
                                                          nil];
    animationgroup.duration = .3f;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationgroup.delegate = self;
    return animationgroup;
}

@end
