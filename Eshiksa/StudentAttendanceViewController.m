

#import "StudentAttendanceViewController.h"
#import "Constant.h"
#import "StudentAttendance.h"
#import "BaseViewController.h"
#import "Base.h"
@interface StudentAttendanceViewController ()

@end

@implementation StudentAttendanceViewController
@synthesize totalLectureTxt;
@synthesize presentTxt;
@synthesize absentTxt;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestdata];
}
-(void)requestdata{
    
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


     NSString *str=[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:attendance]];
    
    NSDictionary *parameterDict = @{
                                    @"groupname":groupname,
                                    @"username":username,
                                    @"password":password,
                                    @"instUrl":instUrl,
                                    @"dbname":dbname,
                                    @"Branch_id":branchid,
                                    @"org_id":orgid,
                                    @"cyear":cyear,
                                    @"url":str,
                                    @"tag":@"attendance"
                                    };
    
   
    [Constant executequery:str strpremeter:parameterDict withblock:^(NSData * dbdata, NSError *error) {
        NSLog(@"data:%@",dbdata);
        if (dbdata!=nil) {
            NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:dbdata options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"response data:%@",maindic);
   
            _tag=[maindic objectForKey:@"tag"];
            _success=[maindic objectForKey:@"success"];
            _error=[maindic objectForKey:@"error"];
            _rollnumber=[maindic objectForKey:@"rollno"];

            NSLog(@"tag==%@& success=%@",_tag,_success);
            

            NSDictionary *dic=[maindic objectForKey:@"attendance "];
            
            StudentAttendance *s=[[StudentAttendance alloc]init];
            s.totalLecture=[[dic objectForKey:@"total_lecture"]description];
            s.presentLecture=[[dic objectForKey:@"present_lecture"]description];
            s.absentLecture=[[dic objectForKey:@"absent_lecture"]description];
            
            
            _totalLecture.text=s.totalLecture;
            _presentLecture.text=s.presentLecture;
            _absentLecture.text=s.absentLecture;
            NSLog(@"####totalLecture#%@",s.totalLecture);
        NSLog(@"####_presentLecture#%@",s.presentLecture);
              NSLog(@"####absentLecture#%@",s.absentLecture);
          
         }
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    
    
    totalLectureTxt.text = [@"ATTENDANCE_SUBJECTWISE_DETAILS_TOTAL_LECTURE" localize];
    presentTxt.text=[@"ATTENDANCE_SUBJECTWISE_DETAILS_PRESENT_LECTURE" localize];
    absentTxt.text = [@"ATTENDANCE_SUBJECTWISE_DETAILS_ABSENT_LECTURE" localize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage:) name:@"notificationName" object:nil];
}

-(void)changeLanguage:(NSNotification*)notification
{
    totalLectureTxt.text = [@"ATTENDANCE_SUBJECTWISE_DETAILS_TOTAL_LECTURE" localize];
    presentTxt.text=[@"ATTENDANCE_SUBJECTWISE_DETAILS_PRESENT_LECTURE" localize];
    absentTxt.text = [@"ATTENDANCE_SUBJECTWISE_DETAILS_ABSENT_LECTURE" localize];
}

- (void)viewDidLayoutSubviews{
    NSString *language = [@"" currentLanguage];
    if ([language isEqualToString:@"hi"])
    {
        [self setBackButtonLocalize];
    }
}

- (void)setBackButtonLocalize{
    self.navigationItem.title = [@"ATTENDANCE" localize];
}
@end
