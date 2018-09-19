
//  GalleryVideoCollectionViewCell.h

#import <UIKit/UIKit.h>

@interface GalleryVideoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *images;
@property (weak, nonatomic) IBOutlet UIView *viewLbl;
@property (weak, nonatomic) IBOutlet UILabel *subfolderName;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;


@end
