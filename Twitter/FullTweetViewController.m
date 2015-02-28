//
//  FullTweetViewController.m
//  Twitter
//
//  Created by Katerina Simonova on 2/27/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import "FullTweetViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "PostTweetViewController.h"

@interface FullTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation FullTweetViewController

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem  alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    User *user = self.tweet.user;
    self.nameLabel.text = user.name;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageURL] placeholderImage:nil];

    self.tweetLabel.text = self.tweet.text;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (IBAction)onReply:(id)sender {
    [self onReply];
}

- (IBAction)onRetweet:(id)sender {
    NSNumber *tweetID = self.tweet.id;
    if (tweetID) {
        [[TwitterClient sharedInstance] toggleRetweetWithId:tweetID forRetweetStatus:self.tweet.retweeted completion:^(NSDictionary *response, NSError *error) {
            
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
 }

- (IBAction)onFavorite:(id)sender {
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

- (void)onReply {
    PostTweetViewController *postViewController = [[PostTweetViewController alloc] init];
    postViewController.tweet = self.tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:postViewController];
    [self presentViewController:nvc animated:YES completion:nil];
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
