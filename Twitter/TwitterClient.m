//
//  TwitterClient.m
//  Twitter
//
//  Created by Katerina Simonova on 2/25/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"5PMw6Cj90dV2Eadsx6E1Axmna";
NSString * const kTwitterConsumerSecret = @"hXp7yM5miHtTerv2CmLQoVDNSNqljZzdplj7FZINpTOapcYgYl";
NSString * const kTwitterBaseURL = @"https://api.twitter.com";

@interface  TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);
@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseURL] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void) loginWithCompletion:(void (^)(User *user, NSError *error)) completion {
 
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got the request token!");
        
        NSURL * authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get request token");
        self.loginCompletion(nil, error);
    }];

}

- (void) openURL:(NSURL *) url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query]
                           success:^(BDBOAuth1Credential *accessToken) {
                               NSLog(@"Got the access token!");
                               
                               [self.requestSerializer saveAccessToken:accessToken];
                               
                               [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   
                                   User *user = [[User alloc] initWithDictionary:responseObject];
                                   
                                   [User setCurrenttUser:user];
                                   NSLog(@"current user name: %@", user.name);
                                   self.loginCompletion(user, nil);
                                   
                                   // NSLog(@"Current user: %@", responseObject);
                                   
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   NSLog(@"Failed getting current user");
                                   self.loginCompletion(nil, error);
                               }];
                               
                               /* [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                // NSLog(@"tweets: %@", responseObject);
                                
                                NSArray *tweets = [Tweet tweetsWithArray:responseObject];
                                for (Tweet *tweet in tweets) {
                                NSLog(@"tweet: %@, created at: %@", tweet.text, tweet.createdAt);
                                }
                                
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                NSLog(@"error getting tweets");
                                }]; */
                               
                           } failure:^(NSError *error) {
                               NSLog(@"Failed to get the access token!");
                           }];
    
}

- (void) homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

// ?? relative
- (void)updateStatusWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *response, NSError *error))completion {
    [self POST:@"https://api.twitter.com/1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}


- (void)destroyStatusWithId:(NSNumber *)tweetID completion:(void (^)(NSDictionary *response, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/destroy/%@.json", tweetID];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)toggleRetweetWithId:(NSNumber *)tweetID forRetweetStatus:(BOOL)isRetweet completion:(void (^)(NSDictionary *response, NSError *error))completion {
    if (isRetweet) {
        [self destroyStatusWithId:tweetID completion:completion];
    } else {
        [self retweetStatusWithId:tweetID completion:completion];
    }
}

- (void)retweetStatusWithId:(NSNumber *)tweetID completion:(void (^)(NSDictionary *response, NSError *error))completion {
    NSString *url = [NSString stringWithFormat:@"https://api.twitter.com/1.1/statuses/retweet/%@.json", tweetID];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}


///
- (void)createFavoriteWithId:(NSNumber *)tweetID completion:(void (^)(NSDictionary *response, NSError *error))completion {
    [self POST:@"https://api.twitter.com/1.1/favorites/create.json" parameters:@{@"id": tweetID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)destroyFavoriteDestroyWithId:(NSNumber *)tweetID completion:(void (^)(NSDictionary *response, NSError *error))completion {
    [self POST:@"https://api.twitter.com/1.1/favorites/destroy.json" parameters:@{@"id": tweetID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)toggleFavoriteWithId:(NSNumber *)tweetID forFavoriteStatus:(BOOL)isFavorite completion:(void (^)(NSDictionary *response, NSError *error))completion {
    if (isFavorite) {
        [self destroyFavoriteDestroyWithId:tweetID completion:completion];
    } else {
        [self createFavoriteWithId:tweetID completion:completion];
    }
}


@end
