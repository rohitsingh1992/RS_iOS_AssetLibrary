//
//  FirstViewController.h
//  ASSERT LIBRARY
//
//  Created by Rohit Singh on 14/01/15.
//  Copyright (c) 2015 TechAhead. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AVfoundation/AVFoundation.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>

@interface FirstViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)tapGetVideos:(id)sender;
- (IBAction)tapGetPics:(UIButton *)sender;

@end

