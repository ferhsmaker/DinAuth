//
//  LMCustomTabBar.h
//  iMemento
//
//  Created by David Jorge on 06/09/11.
//  Copyright (c) 2011 iphonedroid. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const int kTagBtnPromocion;
@interface LMCustomTabBarC : UITabBarController {
    NSArray *_btnsTabBar;
}

@property (nonatomic, strong) NSArray* btnsTabBar;
@property (nonatomic, strong) UILabel *indicatorLabel;
@property (atomic) BOOL indexing;

-(void)addCustomElements;
-(void)startIndexingIndicator;
-(void)stopIndexingIndicator;

@end
