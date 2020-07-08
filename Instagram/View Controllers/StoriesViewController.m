//
//  StoriesViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "StoriesViewController.h"
#import "StoryViewController.h"
#import <Parse/Parse.h>

@interface StoriesViewController () <UIPageViewControllerDataSource>


@end

@implementation StoriesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    //NSLog(@"%@", self.stories);
    NSLog(@"INDEX: %@", self.index);
    int index = [self.index intValue];
    StoryViewController *initialVC = (StoryViewController *)[self viewControllerAtIndex:index];
    NSArray *viewControllerss = [NSArray arrayWithObject:initialVC];
    
    [self setViewControllers:viewControllerss direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Do any additional setup after loading the view.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIViewController*) viewControllerAtIndex: (NSUInteger) index{
    StoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryViewController"];
    Stories *story = self.stories[index];
    viewController.story = story;
    viewController.index = index;
    
    return viewController;
    
}
- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    
    NSUInteger index = ((StoryViewController*)viewController).index;
    if(index == NSNotFound)
    {
        return nil;
    }
    index++;
    if(index == self.stories.count)
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];

    
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    NSUInteger index = ((StoryViewController*)viewController).index;
    if(index == 0 || index == NSNotFound){
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
    
}
@end


