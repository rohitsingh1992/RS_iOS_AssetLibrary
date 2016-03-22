//
//  FirstViewController.m
//  ASSERT LIBRARY
//
//  Created by Rohit Singh on 14/01/15.
//  Copyright (c) 2015 TechAhead. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController (){

    NSMutableArray *arrayFiles;
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    arrayFiles = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark----Table View Delegate And Data Source Methods-------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  arrayFiles.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
      cell.textLabel.text = [[arrayFiles objectAtIndex:indexPath.row] objectForKey:@"assetDuration"];
    
  //  NSLog(@"url in cell for row index path %@ \n ",[[arrayFiles objectAtIndex:indexPath.row] objectForKey:@"assetDuration"]);

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *strUrl = [[arrayFiles objectAtIndex:indexPath.row] objectForKey:@"assetURL"];
    [self saveVideoFromURL:strUrl];
    
}


- (IBAction)tapGetVideos:(id)sender {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
//    ALAssetsLibraryGroupsEnumerationResultsBlock listBlock = ^(ALAssetsGroup *group, BOOL *stop){
//        if (group) {
//            [group setAssetsFilter:[ALAssetsFilter allVideos]];
//            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//                if (result) {
//                    [arrayFiles addObject:result];
//                    NSString *duration = [[result valueForProperty:ALAssetPropertyDuration] stringValue];
//                    NSString *url = [NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyAssetURL]];
//                   // [arrayFiles addObject:url];
//                    NSLog(@"url %@ \n duration %@",url,duration);
//                }
//                [_tableView reloadData];
//                
//                
//            }];
//        }
//    
//    };

    
    
//    ALAssetsLibraryAccessFailureBlock failBlock = ^(NSError *error) { // error handler block
//        NSString *errorTitle = [error localizedDescription];
//        NSString *errorMessage = [error localizedRecoverySuggestion];
//        NSLog(@"%@...\n %@\n",errorTitle,errorMessage);
//    };

    
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result)
                {
                    NSString *strDuration = [[result valueForProperty:ALAssetPropertyDuration] stringValue];
                    NSString *strUrl = [NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyAssetURL]];
                    NSString *strDate = [NSString stringWithFormat:@"%@",[result valueForProperty:ALAssetPropertyDate]];
                    
                    
                    NSDictionary *dict = @{@"assetURL":strUrl,@"assetDuration":strDuration,@"assetType":@"video",@"date":strDate};
                    
                    [arrayFiles addObject:dict];
                    [_tableView reloadData];
                }
                if (stop)
                {
                    
                }
                
            }];
            
        }
       


    } failureBlock:nil];
    
    
}

- (IBAction)tapGetPics:(UIButton *)sender
{
}

-(void)saveVideoFromURL:(NSString *)str{
    NSURL *url = [NSURL fileURLWithPath:str];
    AVURLAsset *assetURL = [[AVURLAsset alloc] initWithURL:url options:nil];
    
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    
    
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) // substitute YOURURL with your url of video
     {
         ALAssetRepresentation *rep = [asset defaultRepresentation];
         
         Byte *buffer = (Byte*) malloc (rep.size);
         NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
         NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
        // [data writeToFile:photoFile atomically:YES]; //you can remove this if only nsdata needed
     }
                 failureBlock:^(NSError *err) {
                     NSLog(@"Error: %@",[err localizedDescription]);
                 }];
}

-(void)generateImage:(NSString *)videoPath
{
    NSURL *url = [NSURL fileURLWithPath:videoPath];
    
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    
    CMTime thumbTime = CMTimeMakeWithSeconds(30,30);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        // TODO Do something with the image
    };
    
    CGSize maxSize = CGSizeMake(128, 128);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
}

@end
