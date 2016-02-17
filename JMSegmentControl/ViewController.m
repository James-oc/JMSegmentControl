//
//  ViewController.m
//  JMSegmentControl
//
//  Created by shengxiao on 16/2/17.
//  Copyright © 2016年 shengxiao. All rights reserved.
//

#import "ViewController.h"
#import "JMSegmentControl.h"
#import "UIButton+JMExtension.h"

@interface ViewController ()<JMSegmentControlDelegate,UIScrollViewDelegate>
{
    JMSegmentControl *_segmentControl;
    NSArray          *_segmentedArray;
    UIScrollView     *_contentView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
  
    [self setupSegmentControl];
    
    [self setupContentViews];
}

-(void) setupSegmentControl {
    _segmentedArray = @[@"发现音乐",@"我的音乐",@"控制中心",@"更多"];
    _segmentControl = [[JMSegmentControl alloc] initWithFrame:CGRectMake(0,
                                                                                           20,
                                                                                           self.view.frame.size.width,
                                                                                           60)];
    
    _segmentControl.delegate               = self;
    _segmentControl.items                  = _segmentedArray;
    _segmentControl.fontSize               = 11;
    _segmentControl.backgroundColor        = [UIColor whiteColor];
    _segmentControl.unSelectedColor        = [UIColor blackColor];
    _segmentControl.selectedColor          = [UIColor whiteColor];
    _segmentControl.selectedBackgroundName = nil;
    _segmentControl.selectedIndex          = 0;
    _segmentControl.bottomLineViewColor    = [UIColor orangeColor];
    _segmentControl.bottomLineViewHeight   = _segmentControl.frame.size.height;
    
    _segmentControl.segmentControlViewBlock = ^(JMSegmentControl *segmentControl,NSInteger btnIndex,NSArray *itemArray) {
        // 自定义
        UIButton *imageBtn = [UIButton getImageBtnWithImageTitleBtnType:CImageUpTitleBottom title:itemArray[btnIndex] unSelectedImageName:@"Tab_Mine_UnSelected" selectedImageName:@"Tab_Mine_Selected" unSelectedTextColor:segmentControl.unSelectedColor selectedTextColor:segmentControl.selectedColor withTextFont:[UIFont systemFontOfSize:segmentControl.fontSize] withBtnType:UIButtonTypeCustom];
        UIEdgeInsets insets = imageBtn.imageEdgeInsets;
        insets.bottom       = 0;
        imageBtn.imageEdgeInsets = insets;
        
        return imageBtn;
    };
    
    [self.view addSubview:_segmentControl];
}

-(void) setupContentViews {
    float offY   = CGRectGetHeight(_segmentControl.frame) + _segmentControl.frame.origin.y;
    float width  = CGRectGetWidth(self.view.frame);
    float height = CGRectGetHeight(self.view.frame) - offY;

    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offY, width, height)];
    _contentView.delegate = self;
    _contentView.scrollEnabled = YES;
    _contentView.pagingEnabled = YES;
    [_contentView setContentSize:CGSizeMake(width * _segmentedArray.count, CGRectGetHeight(_contentView.frame))];
    
    [self.view addSubview:_contentView];
    
    for (int i = 0; i < _segmentedArray.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
        view.backgroundColor = [self randomColor];
        
        [_contentView addSubview:view];
    }
}

#pragma mark - Private
- (UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView == _contentView) {
        //把这个动作放在这里，而不是scrollViewDidScroll，这样就使得点击造成的滑动，和拖拽（Drag）造成的滑动，都只会调用_segmentControl.selectedIndex一次。
        NSInteger remainder = (NSInteger)targetContentOffset->x % (NSInteger)CGRectGetWidth(scrollView.frame);   // 求余数保证整数倍的时候处理
        NSInteger page = (NSInteger)(targetContentOffset->x / CGRectGetWidth(scrollView.frame));
        if (remainder == 0) {
            _segmentControl.selectedIndex = page;
        }
    }
}

#pragma mark - JMSegmentControlDelegate
- (void)onValueChangeFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    [_contentView setContentOffset:CGPointMake(toIndex * CGRectGetWidth(self.view.frame), 0) animated:YES];
}
@end
