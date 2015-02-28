//
//  PostTweetViewController.m
//  Twitter
//
//  Created by Katerina Simonova on 2/27/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import "PostTweetViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface PostTweetViewController ()


@end

@implementation PostTweetViewController
- (IBAction)onTap:(id)sender {
    
    [self.tweetText resignFirstResponder];
}

- (IBAction)onPost:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"status"] = self.tweetText.text;
    
    if (self.tweet != nil) {
       params[@"in_reply_to_status_id"] = self.tweet.id;
    }
    [[TwitterClient sharedInstance] updateStatusWithParams:params completion:^(NSDictionary *response, NSError *error) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:response];
        [self.delegate onTweet:tweet];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];

}

- (void)onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Left Navigation
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem  alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    // Compose setup
    User *user = [User currentUser];
    self.nameLabel.text = user.name;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profileImageURL] placeholderImage:nil];
    
    [self updateCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.tweetText.delegate = self;
    [self.tweetText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onEditingChanged:(id)sender {
    [self updateCount];
}

- (IBAction)onValueChanged:(id)sender {
    [self updateCount];
}

- (void)keyboardFrameDidChange:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //self.tweetTextViewBottomConstraint.constant = keyboardSize.height;
}

- (void)textViewDidChange:(UITextView *)textView{
    [self updateCount];
}



- (void)updateCount {
    NSInteger remainingCount = 140 - [self.tweetText.text length];
    self.countLabel.text = [NSString stringWithFormat:@"Characters left: %ld", remainingCount];
    self.countLabel.textColor = (remainingCount < 0) ? [UIColor redColor] : [UIColor grayColor];
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
