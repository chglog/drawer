# 抽屉效果
### 效果如下
![抽屉效果](https://images2018.cnblogs.com/blog/755161/201806/755161-20180604143909766-168459242.gif)

### 用法
* 继承ViewController 实现如下代码即可

```objc
#import "SlideViewController.h"
 
@interface SlideViewController ()
 
@end
 
@implementation SlideViewController
 
- (void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"%s",__func__);
     
    // 创建一个tableView控制器
    UITableViewController *tableVc = [[UITableViewController alloc] init];
     
    tableVc.view.frame = self.mainV.bounds;
     
    [self.mainV addSubview:tableVc.view];
     
    // 设计原理,如果A控制器的view成为b控制器view的子控件,那么这个A控制器必须成为B控制器的子控制器
    [self addChildViewController:tableVc];
     
     
     
    UIViewController *VC = [[UIViewController alloc] init];
     
    UIImageView *imagev = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"胸小别讲话"]];
     
    //    imagev.contentMode = UIViewContentModeScaleAspectFill;
     
    imagev.frame = VC.view.frame;
     
    [VC.view addSubview:imagev];
     
    [self.rightV addSubview:VC.view];
     
    [self addChildViewController:VC];
     
     
     
     
}
 
@end
```
