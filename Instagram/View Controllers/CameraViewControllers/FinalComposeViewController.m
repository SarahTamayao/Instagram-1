//
//  FinalComposeViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/5/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "FinalComposeViewController.h"
#import "Post.h"
#import "JGProgressHUD.h"

@interface FinalComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *captionText;

@end

@implementation FinalComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.image;
    self.captionText.delegate = self;
    self.captionText.text = @"Write a caption...";
    self.captionText.textColor = [UIColor lightGrayColor];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write a caption..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a caption...";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}
- (IBAction)post:(id)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Posting to Instagram";
    [HUD showInView:self.view];
    [Post postUserImage:self.image withCaption:self.captionText.text withCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"POSTED");
            [HUD dismiss];
            [self performSegueWithIdentifier:@"back" sender:nil];
        }
    }];
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
