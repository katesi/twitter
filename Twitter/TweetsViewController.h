//
//  TweetsViewController.h
//  Twitter
//
//  Created by Katerina Simonova on 2/26/15.
//  Copyright (c) 2015 Katerina Simonova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetsViewController : UIViewController

- (void)onViewPost:(Tweet *) tweet;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
