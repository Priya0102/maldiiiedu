//
//  GalleryDetailViewController.h
//  Eshiksa


#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface GalleryDetailViewController :UIViewController
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    dispatch_queue_t queue;
    NSData *data;
    NSString *filePath;
    NSInteger indexBtn;
}
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray *galleryArr;
@property(nonatomic,retain)NSString *folderIdStr,*titleStr,*indxpath,*indxp;
@property (nonatomic,strong) NSString *success,*email,*error,*tag,*user;

- (IBAction)btnShowImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewDownload;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property(weak,nonatomic) IBOutlet UILabel *downloadLabelText;


@end
