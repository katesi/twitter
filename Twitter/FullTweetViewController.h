//
//  FullTweetViewController.h
//  Twitter
//
//  Created by Katerina Simonova on 2/27/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"



@protocol FullTweetViewControllerDelegate <NSObject>
-(void)onViewPost:(Tweet *)tweet;
@end

@interface FullTweetViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<FullTweetViewControllerDelegate> delegate;

@end
