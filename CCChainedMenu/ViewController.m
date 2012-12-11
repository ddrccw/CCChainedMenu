//
//  ViewController.m
//  CCChainedMenu
//
//  Created by chenche on 12-12-10.
//  Copyright (c) 2012年 ddrccw@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "CCChainedMenu.h"

@interface ViewController () <CCChainedMenuDelegate> {
    CGPoint lastPoint_;
}
@property (nonatomic, retain) CCChainedMenu *chainedMenu;
@end

@implementation ViewController
@synthesize chainedMenu = _chainedMenu;

- (void)dealloc {
    [_chainedMenu release];
    [super dealloc];
}

- (void)viewDidUnload {
    self.chainedMenu = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CCChainedMenuItem *med = [[CCChainedMenuItem alloc]
                              initWithBackgroundImage:[UIImage imageNamed:@"bg"]
                              backgroundHighlightedImage:nil
                              contentImage:[UIImage imageNamed:@"up"]
                              contentHighlightedImage:nil];
    
    CCChainedMenuItem *report = [[CCChainedMenuItem alloc]
                                 initWithBackgroundImage:[UIImage imageNamed:@"bg"]
                                 backgroundHighlightedImage:nil
                                 contentImage:[UIImage imageNamed:@"down"]
                                 contentHighlightedImage:nil];
    
    CCChainedMenuItem *vitalSign = [[CCChainedMenuItem alloc]
                                    initWithBackgroundImage:[UIImage imageNamed:@"bg"]
                                    backgroundHighlightedImage:nil
                                    contentImage:[UIImage imageNamed:@"clipboard"]
                                    contentHighlightedImage:nil];
    
    CCChainedMenuItem *note = [[CCChainedMenuItem alloc]
                               initWithBackgroundImage:[UIImage imageNamed:@"bg"]
                               backgroundHighlightedImage:nil
                               contentImage:[UIImage imageNamed:@"download"]
                               contentHighlightedImage:nil];
    
    
    NSArray *menuItems = [NSArray arrayWithObjects:med,
                          report,
                          vitalSign,
                          note,
                          nil];
    [med release]; [report release]; [vitalSign release]; [note release];
    _chainedMenu = [[CCChainedMenu alloc] initWithBasePoint:CGPointMake(0, 500)
                                            unfoldDirection:CCChainedMenuUnfoldDirectionUp
                                                   menuItems:menuItems];
    _chainedMenu.delegate = self;
    [self.view addSubview:_chainedMenu];

    
    UILongPressGestureRecognizer *moveRecognizer = [[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleMove:)];
    moveRecognizer.minimumPressDuration = 1.f;
    [self.chainedMenu addGestureRecognizer:moveRecognizer];
    [moveRecognizer release];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - gesture -
- (void)handleMove:(UILongPressGestureRecognizer *)moveRecognizer {
    if (UIGestureRecognizerStateBegan == moveRecognizer.state) {
        lastPoint_ = [moveRecognizer locationInView:self.view];
    }
    else if (UIGestureRecognizerStateChanged == moveRecognizer.state) {
        CGPoint currentPoint = [moveRecognizer locationInView:self.view];
        float maxY = 0;
        maxY = self.view.frame.size.height - self.chainedMenu.visibleSize.height;
        
        float offsetY = currentPoint.y - lastPoint_.y;
        
        CGRect newFrame = self.chainedMenu.frame;
        newFrame.origin.y += offsetY;
        if ([self.chainedMenu unfold]) {
            if (newFrame.origin.y > maxY) {
                newFrame.origin.y = maxY;
            }
            if (newFrame.origin.y <= 0) {
                newFrame.origin.y = 0;
            }
        }
        else {
            static float inVisibleHeight = 0;
            static float maxFixY = 0;
            static float minFixY = 0;
            inVisibleHeight = self.chainedMenu.bounds.size.height - self.chainedMenu.visibleSize.height;
            maxFixY = maxY - inVisibleHeight;
            minFixY = -inVisibleHeight;
            if (newFrame.origin.y > maxFixY) {
                newFrame.origin.y = maxFixY;
            }
            if (newFrame.origin.y < minFixY) {
                newFrame.origin.y = minFixY;
            }
        }
        
        self.chainedMenu.frame = newFrame;
        lastPoint_ = currentPoint;
    }
    else if (UIGestureRecognizerStateEnded == moveRecognizer.state) {
        CGRect attachedMenuFrame = self.chainedMenu.frame;
        float offsetX = lastPoint_.x - attachedMenuFrame.origin.x;
        if (fabsf(offsetX) < self.view.frame.size.width / 4) {
            return;
        }
        
        float moveOffset = self.view.frame.size.width - attachedMenuFrame.size.width;
        CGPoint toPoint = self.chainedMenu.center;
        toPoint.x = (offsetX > 0) ? (toPoint.x + moveOffset) : (toPoint.x - moveOffset) ;
        
        [UIView transitionWithView:self.chainedMenu
                          duration:.3f
                           options:UIViewAnimationOptionCurveEaseIn
                        animations:^{
                            self.chainedMenu.center = toPoint;
                        }
                        completion:nil];
    }
}
////////////////////////////////////////////////////////////////////////////////
#pragma mark - CCChainedMenu delegate -
- (void)chainedMenu:(CCChainedMenu *)chainedMenu didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"index(%d) seleted", index);
}

- (void)chainedMenuWillUnfold {
    CGRect rect = self.chainedMenu.frame;
    if (rect.origin.y < 0) {
        rect.origin.y = 0;
        self.chainedMenu.frame = rect;
    }
}
@end
