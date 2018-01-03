//
//  YWNavViewController.m
//  运维宝
//
//  Created by 贾斌 on 2017/10/19.
//  Copyright © 2017年 com.stlm. All rights reserved.
//

#import "YWNavViewController.h"

@interface YWNavViewController ()

@end

@implementation YWNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//当第一次使用这个类的时候调用1次
+ (void)initialize{
    
    // 设置UINavigationBarTheme的主
    [self setupNavigationBarTheme];
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
    
}

+ (void)setupNavigationBarTheme
{
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    //设置导航条背景用图片来填充
    [appearance setBackgroundImage:[UIImage imageNamed:@"navbg"] forBarMetrics:UIBarMetricsDefault];
    appearance.shadowImage = [UIImage new];
    UIFont* font = [UIFont systemFontOfSize:18.0];
    NSDictionary* textAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance]setTitleTextAttributes:textAttributes];
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = FONT_BOLD_20;
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    //textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs];
}

+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    //item字体颜色设置
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    //textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /**设置背景**/
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
    //    [appearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
}

//能拦截所有push进来的子控制器

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_back" highImageName:@"" target:self action:@selector(back)];
        //viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"icon_btn_po" highImageName:@"icon_btn_po" target:self action:@selector(more)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
#warning 这里用的是self, 因为self就是当前正在使用的导航控制器
    [self popViewControllerAnimated:YES];
}

- (void)more
{
    //弹出更多控制器view
    //    UIViewController *vc = [[UIViewController alloc] init];
    //    vc.view.backgroundColor = LSRandomColor;
    //    [self.navigationController pushViewController:vc  animated:YES];
    YWLog(@"更多");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
