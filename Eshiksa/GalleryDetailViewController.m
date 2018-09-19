
#import "GalleryDetailViewController.h"
#import "GalleryDetailsCollectionViewCell.h"
#import "WebViewController.h"
#import "GalleryDetails.h"
#import "Constant.h"
#import "Base.h"
@interface GalleryDetailViewController ()
@property NSMutableArray *imageArray;

@end

@implementation GalleryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *folderid = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"folderid"];
    NSLog(@"**folderid ==%@",folderid);
    
    _myCollectionView.delegate=self;
    _myCollectionView.dataSource=self;
    
    [self parsingGallery];
    _hiddenView.hidden=YES;
    _viewDownload.hidden=YES;
    _imgView.hidden=YES;
}



-(void)parsingGallery
{
    
    queue=dispatch_queue_create("images", DISPATCH_QUEUE_CONCURRENT);
    queue=dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    
    [_galleryArr removeAllObjects];
    [_imageArray removeAllObjects];
    
    NSString *groupname = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"groupName"];
    NSLog(@"group name in circular==%@",groupname);
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"circular username ==%@",username);
    
    NSString *password = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"password"];
    NSLog(@"circular password ==%@",password);
    
    NSString *branchid = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"branchid"];
    NSLog(@"circular branchid ==%@",branchid);
    
    NSString *cyear = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"cyear"];
    NSLog(@"circular cyear ==%@",cyear);
    
    NSString *orgid = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"orgid"];
    NSLog(@"circular orgid ==%@",orgid);
    
    NSString *folderid = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"folderid"];
    NSLog(@"** folderid in api ==%@",folderid);
    
    NSString *urlstr=[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:gallery]];
    
    
    NSDictionary *parameterDict = @{
                                    @"groupname":groupname,
                                    @"username":username,
                                    @"password":password,
                                    @"folder_id":folderid,
                                    @"instUrl":instUrl,
                                    @"dbname":dbname,
                                    @"Branch_id":branchid,
                                    @"org_id":orgid,
                                    @"cyear":cyear,
                                    @"url":urlstr,
                                    @"tag":@"gallery_images"
                                    };
    
    
    [Constant executequery:urlstr strpremeter:parameterDict withblock:^(NSData * dbdata, NSError *error) {
        NSLog(@"data:%@",dbdata);
        if (dbdata!=nil) {
            
            NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:dbdata options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"response  gallery data:%@",maindic);
            
            _tag=[maindic objectForKey:@"tag"];
            _success=[maindic objectForKey:@"success"];
            _error=[maindic objectForKey:@"error"];
            
            NSDictionary *dic=[maindic objectForKey:@"gallery"];
            
            NSArray *imageArr=[dic objectForKey:@"images"];
            
            NSLog(@"****images arr:%@",imageArr);
            
           
            if([imageArr isEqual:[NSNull null]])
            {
                
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"No Images available" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alertView dismissViewControllerAnimated:YES completion:nil];
                                     }];
                [alertView addAction:ok];
                [self presentViewController:alertView animated:YES completion:nil];
            }
            else {
        
                NSArray *images = [dic objectForKey:@"images"];
                
                self.imageArray = [[NSMutableArray alloc]init];
                for (NSString *url in images) {
                    
                    NSLog(@"url :::: %@", url);
                    [self.imageArray addObject:url];
                }
                
                [_myCollectionView reloadData];
            }
        }
        [_myCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.imageArray.count;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GalleryDetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSLog(@"*********cell indexpath==%ld",(long)indexPath.row);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSURL *imageURL = [NSURL URLWithString: [self.imageArray objectAtIndex:indexPath.row]];
                       NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                       
                       dispatch_sync(dispatch_get_main_queue(), ^{
                        
                           cell.images.image = [UIImage imageWithData:imageData];
                           cell.subfolderName.text = [NSURL URLWithString: [self.imageArray objectAtIndex:indexPath.row]].lastPathComponent;
                           
                           //This needs to be set here now that the image is downloaded
                           // and you are back on the main thread
                           
                       });
                   });
     [cell.downloadBtn addTarget:self action:@selector(btnStartDownload:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downloadBtn setTag:indexPath.row];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GalleryDetailsCollectionViewCell *cell=[_myCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSLog(@"cell==%@",cell);
    _indxp=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    NSLog(@"indexpath==%ld",(long)indexPath.row);

}


-(void)btnStartDownload:(UIButton*)sender{

    indexBtn=sender.tag;
    NSLog(@"INDEX===%ld",indexBtn);
    
    _viewDownload.hidden=NO;
 
    [self saveImageInDocumentsDirectory];
    [self fetchImageInDocumentsDirectory:filePath];
    
}
-(NSData *)saveImageInDocumentsDirectory
{
   
   NSURL *url= [[NSURL alloc]initWithString:[self.imageArray objectAtIndex:indexBtn]];
    NSLog(@"selected url indexpath=====%@",url);
    
   data = [NSData dataWithContentsOfURL:url];
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *documentsPath = [paths objectAtIndex:_indxp]; //Get the docs directory
    filePath = [documentsPath stringByAppendingPathComponent:@"image.png"];
   [data writeToFile:filePath atomically:YES];
    return data;
}

-(void)fetchImageInDocumentsDirectory:(NSString*)filepath
{
    data = [NSData dataWithContentsOfFile:filePath]; // fetch image data from filepath
}

- (IBAction)btnShowImage:(id)sender {
    
    [self showImageFromDocumentDirectory:data];
   _hiddenView.hidden=NO;
   _imgView.hidden=NO;
}

-(void)showImageFromDocumentDirectory:(NSData*)dataOfImage
{
    UIImage *convertImageFromNSData = [UIImage imageWithData:dataOfImage];
    _imgView.image=convertImageFromNSData;
}
- (IBAction)dismissBtnClicked:(id)sender {
    [self removeAnimate];
    
}
- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    _viewDownload.hidden=YES;
    _hiddenView.hidden=YES;
    _imgView.hidden=YES;
    
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self.view];
    if (animated) {
        [self showAnimate];
    }
}



@end
