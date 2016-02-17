//
//  QQSegmentView.m
//  QuanQuan
//
//  Created by Tony Chen on 13-8-6.
//  Copyright (c) 2013年 Suryani. All rights reserved.
//

#import "JMSegmentControl.h"

#define JM_Seg_Btn_Origin_Tag   1000

@interface JMSegmentControl()
{
    BOOL    bIsRedraw;
    UIView  *_bottomLineView;
}

@end

@implementation JMSegmentControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  = [UIColor clearColor];
        _selectedIndex        = -1;
        _fontSize             = 14;
        _selectedColor        = [UIColor redColor];
        _unSelectedColor      = [UIColor blackColor];
        _selectedIndex        = -1;
        _bottomLineViewHeight = 3;
    }
    return self;
}

#pragma mark - UI
- (void)redraw {
    NSArray *subViews = self.subviews;
    
    if (subViews != nil && subViews.count != 0) {
        for(int i = 0;i < subViews.count;i++){
            [[subViews objectAtIndex:i] removeFromSuperview];
        }
    }
    
    if (_bottomLineView != nil) {
        [_bottomLineView removeFromSuperview];
        _bottomLineView = nil;
    }
    
    NSMutableArray *sizeArray = [[NSMutableArray alloc] initWithCapacity:_items.count];
    CGFloat totalWidth = 0.0;
    for (int i = 0; i < _items.count; i++) {
        NSString *item = [_items objectAtIndex:i];

        CGSize contentSize = CGSizeZero;
        if (_fontName == nil || [_fontName isEqualToString:@""]) {
            NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:_fontSize],NSFontAttributeName, nil];
            contentSize = [item boundingRectWithSize:CGSizeMake(FLT_MAX, 1) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        }else {
            NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:_fontName size:_fontSize],NSFontAttributeName, nil];
            contentSize = [item boundingRectWithSize:CGSizeMake(FLT_MAX, 1) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        }
        
        [sizeArray addObject:[NSValue valueWithCGSize:contentSize]];
        totalWidth += contentSize.width;
    }
    CGFloat x = 0.0;
    CGFloat separatorWidth = 0;
    for (int i = 0; i < _items.count; i++) {
        NSString *item = [_items objectAtIndex:i];
        CGFloat width = (self.frame.size.width - totalWidth - separatorWidth) / _items.count + [[sizeArray objectAtIndex:i] CGSizeValue].width;
        UIButton *itemBtn;
        if (_segmentControlViewBlock != nil) {
            itemBtn = _segmentControlViewBlock(self,i,_items);
        }else {
            itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [itemBtn setTitle:item forState:UIControlStateNormal];
            [itemBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [itemBtn setTitleColor:_unSelectedColor forState:UIControlStateNormal];
            [itemBtn setTitleColor:_selectedColor forState:UIControlStateSelected];
            
            if (_fontName == nil || [_fontName isEqualToString:@""]) {
                itemBtn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
            }else {
                itemBtn.titleLabel.font = [UIFont fontWithName:_fontName size:_fontSize];
            }
        }
        
        itemBtn.frame = CGRectMake(x, 0, width, self.frame.size.height);
        itemBtn.tag = (i + JM_Seg_Btn_Origin_Tag);
        [itemBtn addTarget:self
                    action:@selector(onClick:)
          forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:itemBtn];
        
        x += width;
    }
}

#pragma mark - Properties
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex || bIsRedraw == true) {
        bIsRedraw = false;
        NSArray *viewArray = self.subviews;
        for (int i = 0; i < viewArray.count; i++) {
            UIView *subview = [viewArray objectAtIndex:i];
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subview;
                if ((btn.tag - JM_Seg_Btn_Origin_Tag) == selectedIndex) {
                    btn.selected  = YES;
                    if (_bottomLineViewColor != nil) {
                        if (!_bottomLineView) {
                            _bottomLineView = [[UIView alloc] init];
                            _bottomLineView.backgroundColor = _bottomLineViewColor;
                            [self addSubview:_bottomLineView];
                        }
                        [self bringSubviewToFront:btn];
                        
                        CGRect viewFrame       = btn.frame;
                        viewFrame.origin.y     = CGRectGetHeight(viewFrame) - _bottomLineViewHeight;
                        viewFrame.size.height  = _bottomLineViewHeight;
                        _bottomLineView.frame  = viewFrame;
                    }else {
                        if (_selectedBackgroundName != nil && ![_selectedBackgroundName isEqualToString:@""]) {
                            [btn setBackgroundImage:[UIImage imageNamed:_selectedBackgroundName] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:nil forState:UIControlStateNormal];
                        }
                    }
                }
                else {
                    btn.selected  = NO;
                    if (_unSelectedBackgroundName != nil && ![_unSelectedBackgroundName isEqualToString:@""]) {
                        [btn setBackgroundImage:[UIImage imageNamed:_unSelectedBackgroundName] forState:UIControlStateNormal];
                    }else {
                        [btn setBackgroundImage:nil forState:UIControlStateNormal];
                    }
                }
            }
        }
        
        NSInteger fromIndex = _selectedIndex;
        _selectedIndex = selectedIndex;

        if (selectedIndex != -1) {
            if (_delegate && [_delegate respondsToSelector:@selector(onValueChangeFrom:to:)]) {
                [_delegate onValueChangeFrom:fromIndex to:selectedIndex];
            }
        }
    }
}

- (void)setItems:(NSArray *)items {
    _items = items;
    [self redraw];
}

-(void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self redraw];
    bIsRedraw = true;
    [self setSelectedIndex:_selectedIndex];
}

-(void)setUnSelectedColor:(UIColor *)unSelectedColor {
    _unSelectedColor = unSelectedColor;
    [self redraw];
    bIsRedraw = true;
    [self setSelectedIndex:_selectedIndex];
}

-(void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self redraw];
    bIsRedraw = true;
    [self setSelectedIndex:_selectedIndex];
}

-(void)setSelectedBackgroundName:(NSString *)selectedBackgroundName {
    _selectedBackgroundName = selectedBackgroundName;
    [self redraw];
    bIsRedraw = true;
    [self setSelectedIndex:_selectedIndex];
}

-(void)setUnSelectedBackgroundName:(NSString *)unSelectedBackgroundName {
    _unSelectedBackgroundName = unSelectedBackgroundName;
    [self redraw];
    bIsRedraw = true;
    [self setSelectedIndex:_selectedIndex];
}

-(void)setBottomLineViewColor:(UIColor *)bottomLineViewColor {
    _bottomLineViewColor = bottomLineViewColor;
    [self redraw];
    bIsRedraw = YES;
    [self setSelectedIndex:_selectedIndex];
}

-(void)setBottomLineViewHeight:(float)bottomLineViewHeight {
    _bottomLineViewHeight = bottomLineViewHeight;
    [self redraw];
    bIsRedraw = YES;
    [self setSelectedIndex:_selectedIndex];
}

-(void)setSegmentControlViewBlock:(JMSegmentControlViewBlock)segmentControlViewBlock {
    _segmentControlViewBlock = segmentControlViewBlock;
    [self redraw];
    bIsRedraw = YES;
    [self setSelectedIndex:_selectedIndex];
}

#pragma mark - Event Response
- (void)onClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self setSelectedIndex:(button.tag - JM_Seg_Btn_Origin_Tag)];
}

@end
