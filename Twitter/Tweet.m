//
//  Tweet.m
//  Twitter
//
//  Created by Katerina Simonova on 2/25/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

-(id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        
        self.text = dictionary[@"text"];
        NSString *createdAtString = dictionary[@"created_at"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        
        self.createdAt = [formatter dateFromString:createdAtString];
        
        self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
        self.retweetCount = [dictionary[@"retweet_count"] integerValue];
       
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        self.id = dictionary[@"id"];

    }
    
    return self;
}

+ (NSArray *) tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
