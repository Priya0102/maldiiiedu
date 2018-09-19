/*
 ****videos arr:(
 "http://erp.eshiksa.net/edemo_fees//esh/upload/images/gallery/upload/videos/VID-20180418-WA0009.mp4.png",
 "http://erp.eshiksa.net/edemo_fees//esh/upload/images/gallery/upload/videos/VID-20180418-WA0009.mp4.png"
 )

 
 */
#import "GalleryVideosVC.h"
#import "GalleryVideo.h"
#import "GalleryVideoCollectionViewCell.h"
#import "WebViewController.h"
#import "Base.h"
#import "Constant.h"
@interface GalleryVideosVC ()
{
    NSURLSession *mySession;
    NSString *myPath;
    AVPlayer *player;
}
@property NSMutableArray *videosArray;
@end

@implementation GalleryVideosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewDownload.hidden=YES;
    NSString *folderid = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"folderid"];
    NSLog(@"** folderid ==%@",folderid);
    
    _myCollectionView.delegate=self;
    _myCollectionView.dataSource=self;
    
    [self parsingGallery];
}


-(void)parsingGallery
{
    
    queue=dispatch_queue_create("videos", DISPATCH_QUEUE_CONCURRENT);
    queue=dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    
    [_galleryArr removeAllObjects];
    [_videoArr removeAllObjects];
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

            _tag=[maindic objectForKey:@"tag"];
            _success=[maindic objectForKey:@"success"];
            _error=[maindic objectForKey:@"error"];
            
            NSDictionary *dic=[maindic objectForKey:@"gallery"];
            
           NSArray *vidArr=[dic objectForKey:@"videos"];
            
          
            NSLog(@"****videos arr:%@",vidArr);
             if([vidArr isEqual:[NSNull null]])
            {
                
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"No Videos available" preferredStyle:UIAlertControllerStyleAlert];
                
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
                NSArray *videos = [dic objectForKey:@"videos"];
                
                self.videosArray = [[NSMutableArray alloc]init];
                for (NSString *url in videos) {
                    
                    NSLog(@"videos url:::: ::: %@", url);
                    
                    [self.videosArray addObject:url];
           }
                [_myCollectionView reloadData];
          }
        }
        [_myCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }];
    
}
/*-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"gallery count%lu",(unsigned long)_galleryArr.count);
    return _galleryArr.count;
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GalleryVideoCollectionViewCell *cell=[_myCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    GalleryVideo *ktemp=[_galleryArr objectAtIndex:indexPath.row];
   
    if ( [videoresult length] > 0 )
        
    {
        NSString *videoStrUrl=[videoresult substringToIndex:[videoresult length]-4];

        NSLog(@"IMGAE RESULT=%@",videoStrUrl);
        
        NSString *myString = videoStrUrl;
        NSArray* spliteArray = [myString componentsSeparatedByString: @"/"];
        NSString* lastString = [spliteArray lastObject];
        NSLog(@"lastString %@",lastString);
        cell.subfolderName.text=lastString;
        NSLog(@"subfolderStr== %@",cell.subfolderName.text);
    }
    
    cell.images.image=[UIImage imageNamed:@"galleryNew.png"];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:videoresult]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.images.image = img1;
        });
    });
    
    return  cell;
}
*/
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.videosArray.count;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    GalleryVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSURL *imageURL = [NSURL URLWithString: [self.videosArray objectAtIndex:indexPath.row]];
                       NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                       
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           
                           cell.images.image = [UIImage imageWithData:imageData];
                           cell.subfolderName.text = [NSURL URLWithString:[self.videosArray objectAtIndex:indexPath.row]].lastPathComponent;
                           NSLog(@"SUBFOLDER NAME:::: ::: %@",  cell.subfolderName.text);
                           
                       });
                   });
    
    [cell.downloadBtn addTarget:self action:@selector(btnStartDownload:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downloadBtn setTag:indexPath.row];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GalleryVideoCollectionViewCell *cell=[_myCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
      NSLog(@"cell==%@",cell);
    _indxp=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    NSLog(@"indexpath==%ld",(long)indexPath.row);
    

    
}


-(void)btnStartDownload:(UIButton*)sender{
    
    indexBtn=sender.tag;
    NSLog(@"INDEX video===%ld",indexBtn);
    
    _viewDownload.hidden=NO;
    [self saveImageInDocumentsDirectory];
    
   /* NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    mySession=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //NSURLSessionDownloadTask *task=[mySession downloadTaskWithURL:[NSURL URLWithString:@"http://dev.exiv2.org/attachments/344/MOV_0234.mp4"]];
    
    NSURLSessionDownloadTask *task=[mySession downloadTaskWithURL:[NSURL URLWithString:[self.videosArray objectAtIndex:indexBtn]]];
    
    NSLog(@"selected url video indexpath=====%@",task);
    
    [task resume];*/
}
-(NSData *)saveImageInDocumentsDirectory
{
    
    NSURL *url= [[NSURL alloc]initWithString:[self.videosArray objectAtIndex:indexBtn]];
    NSLog(@"selected url video indexpath=====%@",url);
    
    data = [NSData dataWithContentsOfURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPath = [paths objectAtIndex:_indxp]; //Get the docs directory
    filePath = [documentsPath stringByAppendingPathComponent:@"video.mp4"];
    [data writeToFile:filePath atomically:YES];
    return data;
}
-(void)fetchImageInDocumentsDirectory:(NSString*)filepath
{
    data = [NSData dataWithContentsOfFile:filePath]; // fetch image data from filepath
}

/*-(void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location{
    
    self.labelDownloadStatus.text=@"Video Download Completed";
     myPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0]stringByAppendingString:[[@"http://dev.exiv2.org/attachments/344/MOV_0234.mp4" componentsSeparatedByString:@"/"]lastObject]];
   
    NSFileManager *fileM=[NSFileManager defaultManager];
    [fileM moveItemAtURL:location toURL:[NSURL fileURLWithPath:myPath] error:nil];
    
    
}
-(void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    float totalSize=(totalBytesExpectedToWrite/1024)/1024.f;
    float writtenSize=(totalBytesWritten/1024)/1024.f;
    self.labelDownloadStatus.text=[NSString stringWithFormat:@"Downloading...\n%.2f MB of %.2f MB",writtenSize,totalSize];
   
}
- (IBAction)viewDownload:(id)sender {
    AVPlayerItem *item=[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:myPath]];
    player=[AVPlayer playerWithPlayerItem:item];
    [player play];
    
}
 */
@end
