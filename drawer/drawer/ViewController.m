//
//  ViewController.m
//  drawer
//
//  Created by 陈弘根 on 2018/6/4.
//  Copyright © 2018年 陈弘根. All rights reserved.
//

#import "ViewController.h"

// @"frame"

#define XMGkeyPath(objc, keyPath) @(((void)objc.keyPath, #keyPath))

// 在宏里面如果在参数前添加了#,就会把参数变成C语言字符串

// 获取屏幕的宽度
#define screenW [UIScreen mainScreen].bounds.size.width

// 获取屏幕的高度
#define screenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有的子控件
    [self setUpAllChildView];
    
    // 添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [_mainV addGestureRecognizer:pan];
    
    // KVO作用:时刻监听某个对象的某个属性的改变
    // _main frame属性的改变
    // Observer:观察者
    // KeyPath:监听的属性
    // NSKeyValueObservingOptionNew:表示监听新值的改变
    [_mainV addObserver:self forKeyPath:XMGkeyPath(_mainV, frame) options:NSKeyValueObservingOptionNew context:nil];
    
    // 给控制器的view添加一个点按
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    [self.view addGestureRecognizer:tap];
    
    
}

- (void)tap
{
    if (_mainV.frame.origin.x != 0) {
        // 把_mainV还原最开始的位置
        
        [UIView animateWithDuration:0.25 animations:^{
            _mainV.frame = self.view.bounds;
            
        }];
        
    }
}

// 只要监听的属性一改变,就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (_mainV.frame.origin.x > 0) { // 往右滑动,显示左边控件,隐藏右边控件
        _rightV.hidden = YES;
    }else if (_mainV.frame.origin.x < 0){ // 往左滑动,显示右边控件
        _rightV.hidden = NO;
    }
}

// 注意:当对象被销毁的时候,一定要注意移除观察者
- (void)dealloc
{
    // 移除观察者
    [_mainV removeObserver:self forKeyPath:XMGkeyPath(_mainV, frame)];
}

#define targetR 300

#define targetL -230

- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取手势的偏移量
    CGPoint transP = [pan translationInView:_mainV];
    
    // 获取x轴的偏移量,相对于上一次
    CGFloat offsetX = transP.x;
    
    // 修改最新的main.frame,
    _mainV.frame = [self frameWithOffsetX:offsetX];
    
    // 复位
    [pan setTranslation:CGPointZero inView:_mainV];
    
    // 判断下当前手指有没有抬起,表示手势结束
    if (pan.state == UIGestureRecognizerStateEnded) { // 手指抬起,定位
        // x>屏幕的一半,定位到右边某个位置
        CGFloat target = 0;
        if (_mainV.frame.origin.x > screenW * 0.5) {
            target = targetR;
        }else if (CGRectGetMaxX(_mainV.frame) < screenW * 0.5){
            // 最大的x < 屏幕一半的时候,定义到左边某个位置
            target = targetL;
        }
        
        
        // 获取x轴的偏移量
        CGFloat offsetX = target - _mainV.frame.origin.x;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _mainV.frame = [self frameWithOffsetX:offsetX];
        }];
        
    }
}

#define XMGMaxY 100

// 给定一个x轴的偏移量计算下最新main的frame
- (CGRect)frameWithOffsetX:(CGFloat)offsetX
{
    
    // 获取当前main的frame
    CGRect frame = _mainV.frame;
    
    // 计算当前的x,y,w,h
    // 获取最新的x
    CGFloat x = frame.origin.x + offsetX;
    
    // 获取最新的y
    CGFloat y = x / screenW * XMGMaxY;
    
    // 当用户往左边移动的时候,_main.x < 0,y需要增加,为正
    if (frame.origin.x < 0) {
        y = -y;
    }
    
    // 获取最新的h
    CGFloat h = screenH - 2 * y;
    
    // 获取缩放比例
    CGFloat scale = h / screenH;
    
    // 获取最新的w
    CGFloat w = screenW * scale;
    
    
    return CGRectMake(x, y, w, h);
}



// 添加所有的子控件
- (void)setUpAllChildView
{
    // left
    UIView *leftV = [[UIView alloc] initWithFrame:self.view.bounds];
    leftV.backgroundColor = [UIColor greenColor];
    [self.view addSubview:leftV];
    _leftV = leftV;
    
    // right
    UIView *rightV = [[UIView alloc] initWithFrame:self.view.bounds];
    rightV.backgroundColor = [UIColor blueColor];
    [self.view addSubview:rightV];
    _rightV = rightV;
    
    // main
    UIView *mainV = [[UIView alloc] initWithFrame:self.view.bounds];
    mainV.backgroundColor = [UIColor redColor];
    [self.view addSubview:mainV];
    _mainV = mainV;
}

@end
