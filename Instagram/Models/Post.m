//
//  Post.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/5/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "Post.h"
#import "Comment.h"
@implementation Post
    
@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;
@dynamic created_At;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    newPost.created_At = [NSDate date];
    
    [newPost saveInBackgroundWithBlock: completion];
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
//@property (nonatomic, strong) NSString *postID;
//@property (nonatomic, strong) NSString *userID;
//@property (nonatomic, strong) PFUser *author;
//
//@property (nonatomic, strong) NSString *caption;
//@property (nonatomic, strong) PFFileObject *image;
//@property (nonatomic, strong) NSNumber *likeCount;
//@property (nonatomic, strong) NSNumber *commentCount;


//- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
//    self = [super init];
//    
//    //self.userID = dictionary[@"text"];
//    //self.author = [PFUser dictionary[@"author"]];
//    self.postID = dictionary[@"objectId"];
//    self.caption = dictionary[@"caption"];
//        self.image = dictionary[@"image"];
//        self.likeCount = dictionary[@"likeCount"];
//        self.commentCount = dictionary[@"commentCount"];
//        //self.createdAtString = [self formatDate: dictionary];
//    return self;
//}
//
//
//+ (NSMutableArray *)postsWithArray:(NSArray *)dictionaries{
//    NSMutableArray *posts = [NSMutableArray array];
//    for (NSDictionary *dictionary in dictionaries) {
//        Post *post = [[Post alloc] initWithDictionary:dictionary];
//        [posts addObject:post];
//    }
//    return posts;
//}

@end

