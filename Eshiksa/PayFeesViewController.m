//
//  PayFeesViewController.m
//  Eshiksa
//
//  Created by Punit on 08/05/18.
//  Copyright © 2018 Akhilesh. All rights reserved.


#import "PayFeesViewController.h"
#import "Constant.h"
#import "PayFees.h"
#import "PayFeesTableViewCell.h"
#import "PayNowViewController.h"
#import "BaseViewController.h"
#import "Base.h"
@interface PayFeesViewController (){
    NSString *amountAdded,*amountAdded2;
}

@end

@implementation PayFeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableview setSeparatorColor:[UIColor clearColor]];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    

    _feesNameArr=[[NSMutableArray alloc]init];
    _feesAmountArr=[[NSMutableArray alloc]init];
    _dueDateArr=[[NSMutableArray alloc]init];
    _dueAmountArr=[[NSMutableArray alloc]init];
    _paidAmountArr=[[NSMutableArray alloc]init];
    _totalConcessionAmountArr=[[NSMutableArray alloc]init];
    _headFineAmountArr=[[NSMutableArray alloc]init];
    _payArr=[[NSMutableArray alloc]init];
    
//    [self parsingPayFees];
//}
//-(void)parsingPayFees{
//
    UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame=CGRectMake(self.view.window.center.x,self.view.window.center.y, 40.0, 40.0);
    indicator.center=self.view.center;
    [self.view addSubview:indicator];
    
    
    indicator.tintColor=[UIColor redColor];
    indicator.backgroundColor=[UIColor lightGrayColor];
    [indicator bringSubviewToFront:self.view];
    [indicator startAnimating];
    
    [_feesNameArr removeAllObjects];
    [_feesAmountArr removeAllObjects];
    [_dueDateArr removeAllObjects];
    [_dueAmountArr removeAllObjects];
    [_paidAmountArr removeAllObjects];
    [_totalConcessionAmountArr removeAllObjects];
    [_headFineAmountArr removeAllObjects];
    [_payArr removeAllObjects];
    
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
    
    NSString *urlstr=[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:fees_v2]];
    
    
    NSDictionary *parameterDict = @{
                                    @"groupname":groupname,
                                    @"username":username,
                                    @"password":password,
                                    @"dbname":dbname,
                                    @"Branch_id":branchid,
                                    @"org_id":orgid,
                                    @"cyear":cyear,
                                    @"url": urlstr,
                                    @"tag":@"due"
                                    };
    
    
    [Constant executequery:urlstr strpremeter:parameterDict withblock:^(NSData * dbdata, NSError *error) {
        NSLog(@"data:%@",dbdata);
        if (dbdata!=nil) {
            
            NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:dbdata options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"response  due_fees  data:%@",maindic);
            
            NSArray *ciculararr=[maindic objectForKey:@"due_fees"];
            NSLog(@"due_fees:%@",ciculararr);
     
            if(ciculararr.count==0)
            {
               
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"No data available" preferredStyle:UIAlertControllerStyleAlert];
                    
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
            for (NSArray *coverUrlArray in ciculararr) {
    
            for(NSDictionary *temp in coverUrlArray)
            {
                NSString *str1=[[temp objectForKey:@"fees_name"]description];
                NSString *str2=[[temp objectForKey:@"fees_amount"]description];
                NSString *str3=[[temp objectForKey:@"due_date"]description];
                NSString *str4=[[temp objectForKey:@"due_amount"]description];
                NSString *str5=[[temp objectForKey:@"paid_amount"]description];
                NSString *str6=[[temp objectForKey:@"total_concession_amount"]description];
                NSString *str7=[[temp objectForKey:@"head_fine_amount"]description];
                NSString *str8=[[temp objectForKey:@"batch_id"]description];
                NSString *str9=[[temp objectForKey:@"course_id"]description];
                NSString *str10=[[temp objectForKey:@"department_id"]description];
                NSString *str11=[[temp objectForKey:@"session_id"]description];
                NSString *str12=[[temp objectForKey:@"student_id"]description];
                NSString *str13=[[temp objectForKey:@"fees_id"]description];
                NSString *str14=[[temp objectForKey:@"online_pay_discount"]description];

                NSLog(@"fees_name=%@  fees_amount=%@ due_date=%@ due_amount=%@ paid_amount=%@ total concession_amount=%@ head_fine_amount=%@ batch_id=%@ course_id=%@ department_id=%@ session_id=%@ student_id=%@ fees_id=%@ online_pay_discount=%@",str1,str2,str3,str4,str5,str6,str7,str8,str9,str10,str11,str12,str13,str14);

                    PayFees *k1=[[PayFees alloc]init];
                    k1.fees_nameStr=str1;
                    k1.fees_amountStr=str2;
                    k1.due_dateStr=str3;
                    k1.due_amountStr=str4;
                    k1.paid_amountStr=str5;
                    k1.total_concession_amountStr=str6;
                    k1.head_fine_amountStr=str7;
                    k1.batchIdStr=str8;
                    k1.courseIdStr=str9;
                    k1.departmentIdStr=str10;
                    k1.sessionIdStr=str11;
                    k1.studentIdStr=str12;
                    k1.feesIdStr=str13;
                    k1.onlinePayDiscStr=str14;
   
                    [_payArr addObject:k1];
            
               }
                    [_tableview reloadData];
             }
            }
        }
        [_tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
            
            [indicator stopAnimating];
        });
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _payArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayFeesTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    PayFees *ktemp=[_payArr objectAtIndex:indexPath.row];
    
    cell.fees_name.text=ktemp.fees_nameStr;
    cell.fees_amount.text=ktemp.fees_amountStr;
    cell.due_date.text=ktemp.due_dateStr;
    cell.due_amount.text=ktemp.due_amountStr;
    cell.paid_amount.text=ktemp.paid_amountStr;
    cell.total_concession_amount.text=ktemp.total_concession_amountStr;
    cell.head_fine_amount.text=ktemp.head_fine_amountStr;
    cell.courseid.text=ktemp.courseIdStr;
    cell.batchid.text=ktemp.batchIdStr;
    cell.departmentId.text=ktemp.departmentIdStr;
    cell.sessionId.text=ktemp.sessionIdStr;
    cell.studentId.text=ktemp.studentIdStr;
    cell.feesId.text=ktemp.feesIdStr;
    cell.onlinepayDiscountAmt.text=ktemp.onlinePayDiscStr;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:ktemp.feesIdStr forKey:@"feesId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    int result = [ktemp.fees_amountStr intValue] + [ktemp.head_fine_amountStr intValue];
     amountAdded = [NSString stringWithFormat:@"%d", result];
    NSLog(@"amountAdded  %@",amountAdded);
    
    [[NSUserDefaults standardUserDefaults] setObject:amountAdded forKey:@"amountadded"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    int result1=[ktemp.total_concession_amountStr intValue]+[ktemp.onlinePayDiscStr intValue];
    amountAdded2 = [NSString stringWithFormat:@"%d", result1];
    NSLog(@"amountAdded2==  %@",amountAdded2);
    
    [[NSUserDefaults standardUserDefaults] setObject:amountAdded2 forKey:@"amountadded2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button addTarget:self
//               action:@selector(buttonClicked:)
//     forControlEvents:UIControlEventTouchUpInside];
//    [button setTitle:@"Expand" forState:UIControlStateNormal];
//    //[button setBackgroundImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
//    button.frame = CGRectMake(80.0,210.0,160.0, 40.0);
//    [self.view addSubview:button];
    
    return cell;
}
//-(void) buttonClicked:(UIButton*)sender
//{
//    NSLog(@"you clicked on button %ld", sender.tag);
//    [[self tableview] beginUpdates];
//    [[self tableview] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: 0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [[self tableview] endUpdates];
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PayFeesTableViewCell *cell=[_tableview cellForRowAtIndexPath:indexPath];
    _sessionIdStr=cell.sessionId.text;
    _studentIdStr=cell.studentId.text;
    _departmentIdStr=cell.departmentId.text;
    _batchIdStr=cell.batchid.text;
    _courseIdStr=cell.courseid.text;
    _totalAmtStr=cell.fees_amount.text;

    _indxp=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    NSLog(@"indexpath==%ld & course id in did select row=%@ fees amount=%@",(long)indexPath.row,_courseIdStr,_totalAmtStr);
    
    [self performSegueWithIdentifier:@"payNow" sender:[self.tableview cellForRowAtIndexPath:indexPath]];
    
}
/*- (void) collapseExpandButtonTap:(id) sender
{
    UIButton* aButton = (UIButton*)sender; //It's actually a button
    NSIndexPath* aPath = [self indexPathForCellWithButtonTag:aButton.tag]; //Let's assume that you have only one section and button tags directly correspond to rows of your cells.
    //expandedCells is a mutable set declared in your interface section or private class extensiont
    if ([_expandedCells containsObject:aPath])
    {
        [_expandedCells removeObject:aPath];
    }
    else
    {
        [_expandedCells addObject:aPath];
    }
    [_tableview beginUpdates];
    [_tableview endUpdates]; //Yeah, that old trick to animate cell expand/collapse
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kExpandedCellHeight = 150;
    CGFloat kNormalCellHeigh = 50;
    
    if ([_expandedCells containsObject:indexPath])
    {
        return kExpandedCellHeight; //It's not necessary a constant, though
    }
    else
    {
        return kNormalCellHeigh; //Again not necessary a constant
    }
}
*/
/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
//        return 180.0; // Expanded height
//    }
//    return 60.0; // Normal height
}*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"payNow"])
    {
        
        PayNowViewController *kvc = [segue destinationViewController];
        
        kvc.totalAmountStr=_totalAmtStr;
        kvc.courseIdStr=_courseIdStr;
        kvc.batchIdStr=_batchIdStr;
        kvc.departmentIdStr=_departmentIdStr;
        kvc.sessionIdStr=_sessionIdStr;
        kvc.studentIdStr=_studentIdStr;
        kvc.indxpath=_indxp;
        
        NSLog(@"course id in segue=%@ batch id=%@ student id=%@ department id=%@  session id=%@",kvc.courseIdStr,_batchIdStr,_studentIdStr,_departmentIdStr,_sessionIdStr);
        
    }
}
- (void)viewDidLayoutSubviews{
    NSString *language = [@"" currentLanguage];
    if ([language isEqualToString:@"hi"])
    {
        [self setBackButtonLocalize];
    }
}

- (void)setBackButtonLocalize{
    self.navigationItem.title = [@"PAY_FEES" localize];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([indexPath isEqual:self.expandedIndexPath])
//        return 100;
//    
//    return 50;
//}
@end
