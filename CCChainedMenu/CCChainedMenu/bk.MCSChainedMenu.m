//
//  CCChainedMenu.m
//  iMCS
//
//  Created by ddrccw on 12-11-30.
//  Copyright (c) 2012年 ddrccw. All rights reserved.
//

#import "CCChainedMenu.h"

static const UInt8 kTagOffSet = 100;
static const UInt16 kMenuItemSpacing = 10;
static const float kFoldAnimationDuration = .08f;
static const float kRotationAnimationDuration = 0.3f;
static const float kTranslationAnimationDuration = 0.08f;

static BOOL chainedMenuUnfoldDirectionIsLandscape(CCChainedMenuUnfoldDirection direction) {
    return ((direction == CCChainedMenuUnfoldDirectionLeft) ||
            (direction == CCChainedMenuUnfoldDirectionRight));
}

@interface CCChainedMenu ()
//@property (nonatomic, assign) int animationEndFlag;
//@property (nonatomic, assign) CGPoint basePoint;
//@property (nonatomic, retain) CCChainedMenuItem *switchBtn;
//
//- (void)toggleMenu;
//- (void)selectedMenuItem:(CCChainedMenuItem *)menuItem;
//
//@end
//
//@implementation CCChainedMenu
//@synthesize animationEndFlag = _animationEndFlag;
//@synthesize basePoint = _basePoint;
//@synthesize switchBtn = _switchBtn;
//@synthesize menuItems = _menuItems;
//@synthesize unfold = _unfold;
//@synthesize direction = _direction;
//@synthesize delegate = _delegate;
//
//- (void)dealloc {
//    [_switchBtn release];
//    [_menuItems release];
//    [super dealloc];
//}
//
//
//- (id)initWithBasePoint:(CGPoint)basePoint menuItems:(NSArray *)menuItems {
//    if (self = [super init]) {
//        _basePoint = basePoint;
//        self.backgroundColor = [UIColor clearColor];
//        _direction = CCChainedMenuUnfoldDirectionUp;
//        
//        _unfold = NO;
//        _switchBtn = [[CCChainedMenuItem alloc] initWithBackgroundImage:[UIImage imageNamed:@"switchBtnBackground"]
//                                              backgroundHighlightedImage:[UIImage imageNamed:@"switchBtnBackgroundHighlighted"]
//                                                            contentImage:[UIImage imageNamed:@"switchBtn"]
//                                                 contentHighlightedImage:nil];
//        [self addSubview:_switchBtn];
//        [_switchBtn addTarget:self
//                       action:@selector(toggleMenu)
//             forControlEvents:UIControlEventTouchUpInside];
//        self.menuItems = menuItems;
//        [self relayoutMenu];
//    }
//    return self;
//}
//
//- (void)toggleMenu {
//    self.unfold = !self.unfold;
//}
//
//- (void)setMenuItems:(NSArray *)menuItems {
//    if (_menuItems != menuItems) {
//        [menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            CCChainedMenuItem *item = obj;
//            [item removeTarget:self
//                        action:@selector(selectedMenuItem:)
//              forControlEvents:UIControlEventTouchUpInside];
//            [item removeFromSuperview];
//        }];
//        
//        [_menuItems release];
//        _menuItems = [menuItems retain];
//        
//        __block UIView *tmpView = _switchBtn;
//        [_menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            CCChainedMenuItem *item = obj;
//            item.tag = kTagOffSet + idx;
//            [item addTarget:self
//                     action:@selector(selectedMenuItem:)
//           forControlEvents:UIControlEventTouchUpInside];
//            [self insertSubview:item belowSubview:tmpView];
//            tmpView = item;
//        }];
//    }
//}
//
//- (void)selectedMenuItem:(CCChainedMenuItem *)menuItem {
//    CAAnimationGroup *animationGroup = [self blowupAnimationAtPoint:menuItem.center];
//    [menuItem.layer addAnimation:animationGroup forKey:@"blowup"];
//    menuItem.center = menuItem.startPoint;
//    for (CCChainedMenuItem *item in self.menuItems) {
//        if (item.tag == menuItem.tag) {
//            continue;
//        }
//        
//        animationGroup = [self shrinkAnimationAtPoint:item.center];
//        [item.layer addAnimation:animationGroup forKey:@"shrink"];
//        item.center = item.startPoint;
//    }
//    if ([self.delegate respondsToSelector:@selector(chainedMenu:didSelectedItemAtIndex:)]) {
//        [self.delegate chainedMenu:self didSelectedItemAtIndex:(menuItem.tag - kTagOffSet)];
//    }
//    
//    float angle = 0;
//    [UIView animateWithDuration:0.2f animations:^{
//        _switchBtn.transform = CGAffineTransformMakeRotation(angle);
//    }];
//    _unfold = NO;
//}
//
//- (CAAnimationGroup *)blowupAnimationAtPoint:(CGPoint)p
//{
//    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
//    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
//    
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
//    
//    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
//    
//    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
//    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
//    animationgroup.duration = 0.3f;
//    animationgroup.fillMode = kCAFillModeForwards;
//    
//    return animationgroup;
//}
//
//- (CAAnimationGroup *)shrinkAnimationAtPoint:(CGPoint)p
//{
//    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
//    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
//    
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
//    
//    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
//    
//    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
//    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
//    animationgroup.duration = 0.3f;
//    animationgroup.fillMode = kCAFillModeForwards;
//    
//    return animationgroup;
//}
//
//
//- (void)relayoutMenu {
//    if (!_menuItems || ![_menuItems count]) {
//        return;
//    }
//
//    __block float length = 0;
//    [_menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        CCChainedMenuItem *item = obj;
//        if (chainedMenuUnfoldDirectionIsLandscape(_direction)) {
//            length += item.bounds.size.width;
//        }
//        else {
//            length += item.bounds.size.height;
//        }
//    }];
//    
//    int count = [_menuItems count];
//    CGRect rect = CGRectZero;
//    CGSize switchBtnSize = _switchBtn.bounds.size;
//    length += count * kMenuItemSpacing;
//    switch (_direction) {
//        case CCChainedMenuUnfoldDirectionRight:
//            length += switchBtnSize.width;
//            rect.origin = _basePoint;
//            rect.size.width = length;
//            rect.size.height = switchBtnSize.height;
//            self.frame = rect;
//            
//            rect.origin = CGPointZero;
//            rect.size = switchBtnSize;
//            _switchBtn.frame = rect;
//            
//            break;
//        case CCChainedMenuUnfoldDirectionDown:
//            length += switchBtnSize.height;
//            rect.origin = _basePoint;
//            rect.size.width = switchBtnSize.width;
//            rect.size.height = length;
//            self.frame = rect;
//            
//            rect.origin = CGPointZero;
//            rect.size = switchBtnSize;
//            _switchBtn.frame = rect;
//            break;
//        case CCChainedMenuUnfoldDirectionLeft:
//            rect.origin.x = _basePoint.x - length;
//            rect.origin.y = _basePoint.y;
//            rect.size.width = length + switchBtnSize.width;
//            rect.size.height = switchBtnSize.height;
//            self.frame = rect;
//            
//            rect.origin.x = length;
//            rect.origin.y = 0;
//            rect.size = switchBtnSize;
//            _switchBtn.frame = rect;
//            break;
//        case CCChainedMenuUnfoldDirectionUp:
//            rect.origin.x = _basePoint.x;
//            rect.origin.y = _basePoint.y - length;
//            rect.size.width = switchBtnSize.width;
//            rect.size.height = length + switchBtnSize.height;
//            self.frame = rect;
//            
//            rect.origin.x = 0;
//            rect.origin.y = length;
//            rect.size = switchBtnSize;
//            _switchBtn.frame = rect;
//            break;
//        default:
//            NSAssert(NO, @"direction invalid value!");
//            break;
//    }
//    
//    [self relayoutMenuItems];
//}
//
//- (void)relayoutMenuItems {
//    const CGPoint startPoint = _switchBtn.center;
//    __block CGPoint endPoint = CGPointZero;
//    __block UIView *tmpView = _switchBtn;
//    [self.menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        endPoint = (!idx) ? tmpView.center : [(CCChainedMenuItem *)tmpView endPoint];;
//        CCChainedMenuItem *item = obj;
//        item.startPoint = startPoint;
//        item.center = startPoint;
//        item.transitionPoint = endPoint;
//        
//        switch (_direction) {
//            case CCChainedMenuUnfoldDirectionRight:
//                endPoint.x += tmpView.bounds.size.width + kMenuItemSpacing;
//                break;
//            case CCChainedMenuUnfoldDirectionDown:
//                endPoint.y += tmpView.bounds.size.height + kMenuItemSpacing;
//                break;
//            case CCChainedMenuUnfoldDirectionLeft:
//                endPoint.x -= tmpView.bounds.size.width + kMenuItemSpacing;
//                break;
//            case CCChainedMenuUnfoldDirectionUp:
//                endPoint.y -= tmpView.bounds.size.height + kMenuItemSpacing;
//                break;
//            default:
//                NSAssert(NO, @"direction invalid value!");
//                break;
//        }
//        
//        item.endPoint = endPoint;
//        tmpView = item;
//    }];
//}
//
//- (void)setUnfold:(BOOL)unfold {
//    if (_unfold == unfold) {
//        return;
//    }
//
//    _unfold = unfold;
//    // rotate menu switch button
//    float angle = (unfold) ? M_PI_4 : 0;
//    [UIView animateWithDuration:0.2f animations:^{
//        _switchBtn.transform = CGAffineTransformMakeRotation(angle);
//    }];
//    
//    self.userInteractionEnabled = NO;
//    if (unfold) {
//        self.animationEndFlag = 0;
//        [self unfoldMenu];
//    }
//    else {
//        self.animationEndFlag = [_menuItems count] - 1;
//        [self foldMenu];
//    }
//}
//
//- (void)unfoldMenu {
//    if (_animationEndFlag == [_menuItems count]) {
//        self.userInteractionEnabled = YES;
//        return;
//    }
//   
//    
//    for (CCChainedMenuItem *item in self.menuItems) {
//        CAAnimationGroup *animationgroup = (CAAnimationGroup *)[item.layer animationForKey:@"unfold"];
//        animationgroup = [self unfoldAnimationForMenuItem:item];
//        [animationgroup setValue:@"unfold" forKey:@"unfold"];
//        [item.layer addAnimation:animationgroup forKey:@"unfold"];
//        item.center = item.endPoint;
//    }
//    self.userInteractionEnabled = YES;
//
////    CCChainedMenuItem *item = (CCChainedMenuItem *)[_menuItems objectAtIndex:_animationEndFlag];
////
////    CAAnimationGroup *animationgroup = (CAAnimationGroup *)[item.layer animationForKey:@"unfold"];
////    animationgroup = [self unfoldAnimationForMenuItem:item];
////    [animationgroup setValue:@"unfold" forKey:@"unfold"];
////    [item.layer addAnimation:animationgroup forKey:@"unfold"];
////    item.center = item.endPoint;
//}
//
//- (CAAnimationGroup *)unfoldAnimationForMenuItem:(CCChainedMenuItem *)item {
//    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
//    NSArray *transformValues = [NSArray arrayWithObjects:
//                                [NSNumber numberWithFloat:((M_PI)/64)],
//                                [NSNumber numberWithFloat:(-((M_PI)/64))],
//                                [NSNumber numberWithFloat:((M_PI)/64)],
//                                [NSNumber numberWithFloat:(-((M_PI)/64))],
//                                [NSNumber numberWithFloat:((M_PI)/64)],
//                                [NSNumber numberWithFloat:(-((M_PI)/64))],
//                                [NSNumber numberWithFloat:0],
//                                nil];
//    
//    [shakeAnimation setValues:transformValues];
//    NSArray *times = [NSArray arrayWithObjects:
//                      [NSNumber numberWithFloat:0.14f],
//                      [NSNumber numberWithFloat:0.28f],
//                      [NSNumber numberWithFloat:0.42f],
//                      [NSNumber numberWithFloat:0.57f],
//                      [NSNumber numberWithFloat:0.71f],
//                      [NSNumber numberWithFloat:0.85f],
//                      [NSNumber numberWithFloat:1.0f],
//                      nil];
//    [shakeAnimation setKeyTimes:times];
//    shakeAnimation.fillMode = kCAFillModeForwards;
//    shakeAnimation.duration = .4f;
//    shakeAnimation.repeatCount = 5;
//    
//    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    positionAnimation.duration = .1f;
//    CGMutablePathRef path = CGPathCreateMutable();
////    item.center = item.transitionPoint;
////    CGPathMoveToPoint(path, NULL, item.transitionPoint.x, item.transitionPoint.y);
//    item.center = item.startPoint;
//    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
////    if (_animationEndFlag == ([_menuItems count] - 1)) {
////        //add bounce offset
////        positionAnimation.duration = .2f;
//        CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y + 30);
//        CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y - 30);
////    }
//    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
//    positionAnimation.path = path;
//    CGPathRelease(path);
//    
//    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
//    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation,
//                                 shakeAnimation,
//                                 nil];
//    animationgroup.duration = 2.f;
//
////    if (_animationEndFlag == ([_menuItems count] - 1)) {
////        //add bounce offset
////        animationgroup.duration = .2f;
////    }
//
//    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    animationgroup.delegate = self;
//    return animationgroup;
//}
//
//- (void)foldMenu {
//    if (_animationEndFlag < 0) {
//        self.userInteractionEnabled = YES;
//        return;
//    }
//   
//    for (CCChainedMenuItem *item in self.menuItems) {
//        CAAnimationGroup *animationgroup = [self foldAnimationForMenuItem:item];
//        [animationgroup setValue:@"fold" forKey:@"fold"];
//        [item.layer addAnimation:animationgroup forKey:@"fold"];
//        item.center = item.startPoint;
//    }
//    self.userInteractionEnabled = YES;
//
////    CCChainedMenuItem *item = (CCChainedMenuItem *)[_menuItems objectAtIndex:_animationEndFlag];
////    CAAnimationGroup *animationgroup = [self foldAnimationForMenuItem:item];
////    [animationgroup setValue:@"fold" forKey:@"fold"];
////    [item.layer addAnimation:animationgroup forKey:@"fold"];
////    item.center = item.startPoint;   
//}
//
//- (CAAnimationGroup *)foldAnimationForMenuItem:(CCChainedMenuItem *)item {
//    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],
//                              [NSNumber numberWithFloat:M_PI],
//                              [NSNumber numberWithFloat:0.0f],
//                              nil];
//    rotateAnimation.duration = kRotationAnimationDuration;
//    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
//                                [NSNumber numberWithFloat:.0],
//                                [NSNumber numberWithFloat:.4],
//                                [NSNumber numberWithFloat:.5],
//                                nil];
//    
//    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    positionAnimation.duration = .3f;
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
//    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
//    positionAnimation.path = path;
//    CGPathRelease(path);
//    
//    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
//    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
//    animationgroup.duration = .3f;
//    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    animationgroup.delegate = self;
//    return animationgroup;
//}
//
//////////////////////////////////////////////////////////////////////////////////
//#pragma mark - animation delegate
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    if (!flag) return;
//    
//    if ([[anim valueForKey:@"unfold"] isEqualToString:@"unfold"]) {
////        ++_animationEndFlag;
////        [self unfoldMenu]; 
//    }
//    else if ([[anim valueForKey:@"fold"] isEqualToString:@"fold"]) {
////        --_animationEndFlag;
////        [self foldMenu];
//    }
//}


@end
