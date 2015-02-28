//
//  User.h
//  Twitter
//
//  Created by Katerina Simonova on 2/25/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;


@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString* screenName;
@property (nonatomic, strong) NSString* profileImageURL;
@property (nonatomic, strong) NSString* tagline;


-(id) initWithDictionary:(NSDictionary *) dictionary;

+ (User *) currentUser;
+ (void) setCurrenttUser:(User *) currentUser;

+ (void) logout;

@end
