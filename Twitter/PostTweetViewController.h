//
//  PostTweetViewController.h
//  Twitter
//
//  Created by Katerina Simonova on 2/27/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol PostTweetViewControllerDelegate <NSObject>
-(void)onTweet:(Tweet *)tweet;
@end

@interface PostTweetViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<PostTweetViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
