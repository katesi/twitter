//
//  TweetCell.h
//  Twitter
//
//  Created by Katerina Simonova on 2/26/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetCellDelegate <NSObject>
-(void)onReply:(Tweet *)tweet;
-(void)onViewPost:(Tweet *) tweet;
@end

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, retain) id<TweetCellDelegate> delegate;

@end
