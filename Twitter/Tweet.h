//
//  Tweet.h
//  Twitter
//
//  Created by Katerina Simonova on 2/25/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) User* user;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoriteCount;



- (id) initWithDictionary:(NSDictionary *) dictionary;

+ (NSArray *) tweetsWithArray:(NSArray *)array;

@end
