# JMSegmentControl
---

## 效果
![Alt Text](https://github.com/James-oc/JMShareSource/raw/master/screenshots/OC/JMSegmentControl/JMSegmentControl效果.gif)

## 代码
以下是示例参考代码：

```OC
-(void) setupSegmentControl {
    _segmentControl = [[JMSegmentControl alloc] initWithFrame:CGRectMake( 0,
                                                                         20,
                                                 self.view.frame.size.width,
                                                                         60)];
    // 设置代理
    _segmentControl.delegate                = self;
    // 设置项内容
    _segmentControl.items                   = @[@"发现音乐",@"我的音乐",@"控制中心",@"更多"];
    // 设置文本大小
    _segmentControl.fontSize                = 11;
    _segmentControl.backgroundColor         = [UIColor whiteColor];
    // 未选中文本颜色
    _segmentControl.unSelectedColor         = [UIColor blackColor];
    // 选中文本颜色
    _segmentControl.selectedColor           = [UIColor whiteColor];
    // 当前选中下标
    _segmentControl.selectedIndex           = 0;
    // 选中项底下线条颜色
    _segmentControl.bottomLineViewColor     = [UIColor orangeColor];
    // 选中项底下线条高度
    _segmentControl.bottomLineViewHeight    = _segmentControl.frame.size.height;
    
    _segmentControl.segmentControlViewBlock = ^(JMSegmentControl *segmentControl,NSInteger btnIndex,NSArray *itemArray) {
        // 在此自定义每项的视图
        UIButton *imageBtn = [UIButton getImageBtnWithWithType:UIButtonTypeCustom
                                                  titleBtnType:CImageUpTitleBottom
                                                         title:itemArray[btnIndex]
                                                     titleFont:[UIFont systemFontOfSize:segmentControl.fontSize]
                                           unSelectedImageName:@"Tab_Mine_UnSelected"
                                             selectedImageName:@"Tab_Mine_Selected"
                                           unSelectedTextColor:segmentControl.unSelectedColor
                                             selectedTextColor:segmentControl.selectedColor];
        UIEdgeInsets insets                 = imageBtn.imageEdgeInsets;
        insets.bottom                       = 0;
        imageBtn.imageEdgeInsets            = insets;
        
        return imageBtn;
    };
    
    [self.view addSubview:_segmentControl];
}

代理方法：
#pragma mark - JMSegmentControlDelegate
- (void)onValueChangeFrom:(NSInteger)fromIndex to:(NSInteger)toIndex
{

}
```
## 作者
James.xiao



