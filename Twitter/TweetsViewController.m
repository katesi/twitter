//
//  TweetsViewController.m
//  Twitter
//
//  Created by Katerina Simonova on 2/26/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "FullTweetViewController.h"


#import "PostTweetViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, PostTweetViewControllerDelegate, FullTweetViewControllerDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *tweets;

@property (nonatomic, assign) BOOL isLoadingData;
@property (nonatomic, assign) BOOL noMoreTweets;
@property (nonatomic, strong) NSNumber *lastTweetId;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
 /*   [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        for (Tweet *tweet in tweets) {
            NSLog(@"text: %@", tweet.text);
        }
    }];*/
    
  //  self.title = @"Tweets";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem  alloc] initWithTitle:@"Sign out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem  alloc] initWithTitle:@"New Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onCompose)];
   // self.navigationItem.title = @"Timeline";

    
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 120;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
    
    [self loadData];

}

- (void)onReply:(Tweet *)tweet {
    [self presentComposer:tweet];
}

- (void)onViewPost:(Tweet *) tweet {
    [self presentFullView:tweet];
}



- (void)loadData {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = [NSMutableArray arrayWithArray:tweets];
        Tweet *lastTweet = [self.tweets lastObject];
        self.lastTweetId = lastTweet.id;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tweet = self.tweets[indexPath.row];
    
    if (indexPath.row == self.tweets.count - 2) {
        [self appendData];
    }
    return cell;
}

- (void)appendData {
    if (self.isLoadingData || self.noMoreTweets) {
        return;
    }
    self.isLoadingData = YES;
    [[TwitterClient sharedInstance] homeTimelineWithParams:@{@"max_id": self.lastTweetId} completion:^(NSArray *tweets, NSError *error) {
        NSMutableArray *newTweets = [NSMutableArray arrayWithArray:tweets];
        Tweet *lastTweet = [newTweets lastObject];
        if ([lastTweet.id integerValue] == [self.lastTweetId integerValue]) {
            self.noMoreTweets = YES;
            return;
        }
        [self.tweets addObjectsFromArray:newTweets];
        self.lastTweetId = lastTweet.id;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        self.isLoadingData = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onLogout:(id)sender {
    [User logout];
}

- (void)onCompose {
    [self presentComposer:nil];
}
- (void)onLogout {
     [User logout];
}

- (void)presentComposer:(Tweet *)tweet {
    PostTweetViewController *postViewController = [[PostTweetViewController alloc] init];
   
    postViewController.delegate = self;
    
    if (tweet) {
        postViewController.tweet = tweet;
    }
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:postViewController];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)presentFullView:(Tweet *)tweet {
    FullTweetViewController *fullViewController = [[FullTweetViewController alloc] init];
    
    fullViewController.delegate = self;
    
    if (tweet) {
        fullViewController.tweet = tweet;
    }
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fullViewController];
    [self presentViewController:nvc animated:YES completion:nil];

}


- (void)onTweet:(Tweet *)tweet {
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
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
