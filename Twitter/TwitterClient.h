//
//  TwitterClient.h
//  Twitter
//
//  Created by Katerina Simonova on 2/25/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

- (void) loginWithCompletion:(void (^)(User *user, NSError *error)) completion;

- (void) openURL:(NSURL *) url;

- (void) homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion;

- (void)toggleRetweetWithId:(NSNumber *)tweetID forRetweetStatus:(BOOL)isRetweet completion:(void (^)(NSDictionary *response, NSError *error))completion;

- (void)toggleFavoriteWithId:(NSNumber *)tweetID forFavoriteStatus:(BOOL)isFavorite completion:(void (^)(NSDictionary *response, NSError *error))completion;

- (void)updateStatusWithParams:(NSDictionary *)params completion:(void (^)(NSDictionary *response, NSError *error))completion;

@end
