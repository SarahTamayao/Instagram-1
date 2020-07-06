//
//  TabBarViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/5/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
const CGFloat kBarHeight = 70;
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = kBarHeight;
    tabFrame.origin.y = self.view.frame.size.height - kBarHeight;
    self.tabBar.frame = tabFrame;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
