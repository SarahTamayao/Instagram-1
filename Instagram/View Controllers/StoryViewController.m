//
//  StoryViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "StoryViewController.h"
#import <Parse/Parse.h>
#import "Stories.h"
#import "StoriesViewController.h"

@interface StoryViewController ()
@property (strong, nonatomic) NSArray *stories;

@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.storyView.file = self.story[@"image"];
    [self.storyView loadInBackground];
    self.storyView.userInteractionEnabled = YES;
      UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(onSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
      
      [swipeGesture setDelegate:self];
      [self.storyView addGestureRecognizer:swipeGesture];
    // Do any additional setup after loading the view.
}
- (void)onSwipe: (id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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


