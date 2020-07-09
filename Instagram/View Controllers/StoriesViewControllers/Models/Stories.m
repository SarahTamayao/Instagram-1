//
//  Stories.m
//  Instagram
//
//  Created by Xurxo Riesco on 7/7/20.
//  Copyright © 2020 Xurxo Riesco. All rights reserved.
//

#import "Stories.h"

@implementation Stories
    
@dynamic author;
@dynamic image;
@dynamic created_At;

+ (nonnull NSString *)parseClassName {
    return @"Stories";
}
+ (void) postUserStories: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Stories *newStory = [Stories new];
    newStory.image = [self getPFFileFromImage:image];
    newStory.author = [PFUser currentUser];
    newStory.created_At = [NSDate date];
    
    [newStory saveInBackgroundWithBlock: completion];
}
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}
@end
