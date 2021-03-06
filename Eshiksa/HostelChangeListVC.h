//
//  HostelChangeListVC.h
//  Eshiksa
//
//  Created by Punit on 02/05/18.
//  Copyright © 2018 Akhilesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostelChangeListVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic,retain)NSString*tag,*success,*error,*successMsg;

@property (nonatomic,strong) NSMutableArray *remarkArr,*remarkDateArr,*remarkStatusArr,*remarkRequestedStatusArr,*remarkGivenArr;
@property (strong, nonatomic) IBOutlet UITextView *noSchedule;

@end
