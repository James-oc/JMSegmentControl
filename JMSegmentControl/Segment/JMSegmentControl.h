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

/**
 *@description 自定义每一项视图
 */
@property (nonatomic, copy  ) JMSegmentControlViewBlock segmentControlViewBlock;

/**
 *@description 每一项的内容
 */
@property (nonatomic, strong) NSArray                   *items;

/**
 *@description 当前选中下标
 */
@property (nonatomic, assign) NSInteger                 selectedIndex;

/**
 *@description 选中文字颜色
 */
@property (nonatomic, strong) UIColor                   *selectedColor;

/**
 *@description 未选中文字颜色
 */
@property (nonatomic, retain) UIColor                   *unSelectedColor;

/**
 *@description 文本字体大小
 */
@property (nonatomic, assign) CGFloat                   fontSize;

/**
 *@description 文本字体类型名
 */
@property (nonatomic, strong) NSString                  *fontName;

/**
 *@description 选中时的背景图片名
 */
@property (nonatomic, strong) NSString                  *selectedBackgroundImgName;

/**
 *@description 未选中时的背景图片名
 */
@property (nonatomic, strong) NSString                  *unSelectedBackgroundImgName;

/**
 *@description 底下线条颜色
 */
@property (nonatomic, strong) UIColor                   *bottomLineViewColor;

/**
 *@description 底下线条高度，默认3
 */
@property (nonatomic,assign ) float                     bottomLineViewHeight;

@end
