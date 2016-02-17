//
//  QQSegmentView.h
//  QuanQuan
//
//  Created by Tony Chen on 13-8-6.
//  Copyright (c) 2013年 Suryani. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMSegmentControl;

typedef UIButton * (^JMSegmentControlViewBlock) (JMSegmentControl *segmentControl,NSInteger btnIndex,NSArray *itemArray);

@protocol JMSegmentControlDelegate <NSObject>

- (void)onValueChangeFrom:(NSInteger)fromIndex to:(NSInteger)toIndex;

@end

@interface JMSegmentControl : UIControl

@property (nonatomic, assign) id<JMSegmentControlDelegate > delegate;

@property (nonatomic, copy  ) JMSegmentControlViewBlock segmentControlViewBlock;

@property (nonatomic, strong) NSArray                   *items;
@property (nonatomic, assign) NSInteger                 selectedIndex;
@property (nonatomic, strong) UIColor                   *selectedColor;// 选中文字颜色
@property (nonatomic, retain) UIColor                   *unSelectedColor;// 未选中文字颜色
@property (nonatomic, assign) CGFloat                   fontSize;
@property (nonatomic, strong) NSString                  *fontName;
@property (nonatomic, strong) NSString                  *selectedBackgroundName;
@property (nonatomic, strong) NSString                  *unSelectedBackgroundName;
@property (nonatomic, strong) UIColor                   *bottomLineViewColor;// 底下线条颜色(不为空时就用,优先级比selectedBackgroundName高)
@property (nonatomic,assign ) float                     bottomLineViewHeight;// 默认3

@end
