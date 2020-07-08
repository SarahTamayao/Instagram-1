//
//  ProfileViewController.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/6/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "ProfileCell.h"
#import "Post.h"
#import "CommentsViewController.h"
@import Parse;
@interface ProfileViewController () <UIImagePickerControllerDelegate , UICollectionViewDelegate, UICollectionViewDataSource, ProfileCellDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property int followerCount;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 0.9;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    User *user = [PFUser currentUser];
    self.navigationItem.title = user[@"username"];
    self.usernameLabel.text = user[@"username"];
    self.photoImageView.file = user[@"profilePic"];
    self.photoImageView.layer.cornerRadius = 48;
    self.photoImageView.layer.masksToBounds = YES;
    PFQuery *queryUsers = [PFUser query];
    queryUsers.limit = 20;
    [queryUsers findObjectsInBackgroundWithBlock:^(NSArray* users, NSError * _Nullable error) {
        NSLog(@"HereWeAre");
        NSLog(@"%@", users);
        for(PFUser *user in users)
        {
            NSLog(@"HereWeAreAGAAAIN");
            NSLog(@"%@", user);
            PFRelation *relation = [user relationForKey:@"Following"];
            PFQuery *query = [relation query];
            query.limit = 20;
            [query findObjectsInBackgroundWithBlock:^(NSArray<User*>* _Nullable following, NSError * _Nullable error) {
                PFUser *currentUser = [PFUser currentUser];
                       for(PFUser *user in following)
                       {
                           if([user.username isEqual:(currentUser.username)]){
                               NSLog(@"yessir");
                               self.followerCount += 1;
                           }
                       }
                self.followersLabel.text = [NSString stringWithFormat:@"%d", self.followerCount];
               }];
            
        }
        NSLog(@"%d", self.followerCount);

    }];
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"Following"];
    PFQuery *query = [relation query];
    [query includeKey:@"author"];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray<User*>* _Nullable following, NSError * _Nullable error) {
            self.followingLabel.text = [NSString stringWithFormat:@"%ld", following.count];
    }];
    [self.photoImageView loadInBackground];
    [self fecthPost];
    // Do any additional setup after loading the view.
}
- (void)profileCell:(ProfileCell *)profileCell didTap:(Post *)post{
    self.post = post;
    NSLog(@"Hello");
    [self performSegueWithIdentifier:@"detailsSegue" sender:nil];
}

- (void)fecthPost {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            //NSLog(@"%@", posts);
            self.posts = [posts mutableCopy];
            self.postLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.posts.count];
            [self.collectionView reloadData];
        }
        else {
        }
    }];
}
- (IBAction)onProfilePicEdit:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(editedImage);
    // get image data and check if that is not nil
    PFFileObject *profilePicture = [PFFileObject fileObjectWithName:@"image.png" data:imageData];
    User *user = [PFUser currentUser];
    user.profilePic = profilePicture;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"Profile Pic added");
        }
    }];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
 - (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ProfileCell *profileCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath: indexPath];
    Post *post = self.posts[indexPath.item];
    [profileCell loadPost:post];
    profileCell.delegate = self;
    return profileCell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CommentsViewController *commentsViewController = [segue destinationViewController];
    commentsViewController.post = self.post;
}


@end
