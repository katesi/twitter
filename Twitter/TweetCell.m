//
//  TweetCell.m
//  Twitter
//
//  Created by Katerina Simonova on 2/26/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import "TweetCell.h"
#import "NSDate+DateTools.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) NSNumber *retweetID;
@end

@implementation TweetCell

- (void)onTap {
    NSLog(@"onTap fired");
    [self.delegate onViewPost:self.tweet];
    
}

- (void)awakeFromNib {
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    self.nameLabel.text = tweet.user.name;
    self.screenNameLabel.text = tweet.user.screenName;
    self.createdAtLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
    self.tweetLabel.text = tweet.text;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageURL] placeholderImage:nil];
    
    self.retweetButton.selected = self.tweet.retweeted;
    self.favoriteButton.selected = self.tweet.favorited;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [tap setDelegate:self];
    [self addGestureRecognizer:tap];
}

- (IBAction)onReply:(id)sender {
    [self.delegate onReply:self.tweet];
}

- (IBAction)onRetweet:(id)sender {
    NSNumber *tweetID = self.tweet.retweeted ? self.retweetID : self.tweet.id;
    if (tweetID) {
        
        [[TwitterClient sharedInstance] toggleRetweetWithId:tweetID forRetweetStatus:self.tweet.retweeted completion:^(NSDictionary *response, NSError *error) {
            if (self.tweet.retweeted) {
                self.retweetID = response[@"id"];
            }
            if (error) {
                NSLog(@"%@", error);
                [self toggleRetweet];
            }
        }];
        [self toggleRetweet];
    }
}

- (void)toggleRetweet {
    self.tweet.retweeted = !self.tweet.retweeted;
    self.retweetButton.selected = self.tweet.retweeted;
    if (!self.tweet.retweeted) {
        self.retweetID = nil;
    }
}



- (IBAction)onFavorit:(id)sender {
    
    [[TwitterClient sharedInstance] toggleFavoriteWithId:self.tweet.id forFavoriteStatus:self.tweet.favorited completion:^(NSDictionary *response, NSError *error) {
        if (error) {
            [self toggleFavorite];
        }
    }];
    [self toggleFavorite];
}

- (void)toggleFavorite {
    self.tweet.favorited = !self.tweet.favorited;
    self.favoriteButton.selected = self.tweet.favorited;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width;
}


@end
