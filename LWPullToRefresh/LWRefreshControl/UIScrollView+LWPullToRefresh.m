//
//  UIScrollView+LWPullToRefresh.m
//  LWPullToRefresh
//
//  Created by LiYonghui on 14-3-28.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "UIScrollView+LWPullToRefresh.h"
#import "LWRefreshControl.h"
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshControl;
static char UIScrollViewPullInfiniteControl;


@implementation UIScrollView (LWPullToRefresh)
@dynamic lwrefreshControl;
@dynamic infiniteControl;


#pragma mark

- (void)setPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    
    if (self.lwrefreshControl == nil) {
        LWRefreshControl *refreshControl = [[LWRefreshControl alloc] initWithScrollView:self position:LWPullToRefreshPositionTop];
        self.lwrefreshControl = refreshControl;
    }
    self.lwrefreshControl.actionHandler = actionHandler;
}

- (void)setInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {
    
    if (self.infiniteControl == nil) {
        LWRefreshControl *refreshControl = [[LWRefreshControl alloc] initWithScrollView:self position:LWPullToRefreshPositionBottom];
        self.infiniteControl = refreshControl;
    }
    self.infiniteControl.actionHandler = actionHandler;
}

- (void)removePullToRefreshActionHandler {
    if (self.lwrefreshControl != nil) {
        self.lwrefreshControl.actionHandler = nil;
        [self.lwrefreshControl removeFromSuperview];
    }
    self.lwrefreshControl = nil;
}

- (void)removeInfiniteScrollingActionHandler {
    
    if (self.infiniteControl != nil) {
        self.infiniteControl.actionHandler = nil;
        [self.infiniteControl removeFromSuperview];
    }
    self.infiniteControl = nil;
}


- (void)triggerPullToRefresh {
    if (self.lwrefreshControl) {
        [self.lwrefreshControl triggerPullToLoading];
    }
}

- (void)triggerInfiniteScrolling {
    if (self.infiniteControl) {
        [self.infiniteControl triggerPullToLoading];
    }
}


- (void)endRefreshLoading {
    [self.lwrefreshControl endLoading];
}

- (void)endRefreshLoadingAfterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(endRefreshLoading) withObject:nil afterDelay:delay];
}

- (void)endInfiniteLoading {
    [self.infiniteControl endLoading];
}

- (void)endInfiniteLoadingAfterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(endInfiniteLoading) withObject:nil afterDelay:delay];
}


- (void)endRefreshLoadingAfterDelay:(NSTimeInterval)delay infiniteLoadingEnable:(BOOL)enable {
    [self endRefreshLoadingAfterDelay:delay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delay + 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setInfiniteLoadingEnable:enable];
    });
}

- (void)endInfiniteLoadingAfterDelay:(NSTimeInterval)delay infiniteLoadingEnable:(BOOL)enable {
    [self endInfiniteLoadingAfterDelay:delay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((delay + 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setInfiniteLoadingEnable:enable];
    });
}

- (void)setPullToRefreshEnable:(BOOL)enable {
    if (self.refreshControl) {
        self.refreshControl.enabled = enable;
    }
}

- (void)setInfiniteLoadingEnable:(BOOL)enable {
    if (self.infiniteControl) {
        self.infiniteControl.enabled = enable;
    }
}


#pragma mark - Property
- (void)setLwrefreshControl:(LWRefreshControl *)lwrefreshControl {
    [self willChangeValueForKey:@"LWPullToRefreshControl"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshControl, lwrefreshControl, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"LWPullToRefreshControl"];
}

- (LWRefreshControl *)lwrefreshControl {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshControl);
}

- (void)setInfiniteControl:(LWRefreshControl *)infiniteControl {
    [self willChangeValueForKey:@"LWInfiniteControl"];
    objc_setAssociatedObject(self, &UIScrollViewPullInfiniteControl, infiniteControl, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"LWInfiniteControl"];
}

- (LWRefreshControl *)infiniteControl {
    return objc_getAssociatedObject(self, &UIScrollViewPullInfiniteControl);
}



@end
