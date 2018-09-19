//
//  GalleryVideosVC.h
//  Eshiksa
//
//  Created by Punit on 04/06/18.
//  Copyright © 2018 Akhilesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface GalleryVideosVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NSURLSessionDelegate,NSURLSessionDataDelegate>
{
    dispatch_queue_t queue;
    NSInteger indexBtn;
    NSData *data;
    NSString *filePath;
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray *galleryArr,*videoArr;
@property(nonatomic,retain)NSString *folderIdStr,*titleStr,*indxpath,*indxp;
@property (nonatomic,strong) NSString *success,*email,*error,*tag,*user;
@property (weak, nonatomic) IBOutlet UIView *viewDownload;
@property (weak, nonatomic) IBOutlet UILabel *labelDownloadStatus;
//- (IBAction)viewDownload:(id)sender;

@end
