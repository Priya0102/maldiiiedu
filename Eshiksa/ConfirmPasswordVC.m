//
//  ConfirmPasswordVC.m
//  Eshiksa
//
//  Created by Punit on 16/08/18.
//  Copyright © 2018 Akhilesh. All rights reserved.
//

#import "ConfirmPasswordVC.h"
#import "Constant.h"
#import "Base.h"
#import "StudentViewController.h"
#import "TeacherViewController.h"
@interface ConfirmPasswordVC ()

@end

@implementation ConfirmPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
         confirmPassword.delegate=self;
         newpassword.delegate=self;
         currentPassword.delegate=self;
    
    self.submitBtn.layer.masksToBounds=YES;
    self.submitBtn.layer.cornerRadius=8;
    

}
- (IBAction)submitBtnClicked:(id)sender {
    
    UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame=CGRectMake(self.view.window.center.x,self.view.window.center.y, 40.0, 40.0);
    indicator.center=self.view.center;
    [self.view addSubview:indicator];
    indicator.tintColor=[UIColor redColor];
    indicator.backgroundColor=[UIColor lightGrayColor];
    [indicator bringSubviewToFront:self.view];
    

    [indicator startAnimating];
    if(self.currentPassword.text.length==0 && self.newpassword.text.length==0 && self.confirmPassword.text.length==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Enter all credentials" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [indicator stopAnimating];
        
        [self presentViewController:alertView animated:YES completion:nil];
        
    }
    if(self.currentPassword.text.length==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"First enter your current password" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [indicator stopAnimating];
        
        [indicator stopAnimating];
        
        [self presentViewController:alertView animated:YES completion:nil];
    }
    if(self.newpassword.text.length==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"First Enter your new Password" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [indicator stopAnimating];
        
        [self presentViewController:alertView animated:YES completion:nil];
    }
    if(self.confirmPassword.text.length==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"First enter your confirm password" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [indicator stopAnimating];
        
        [self presentViewController:alertView animated:YES completion:nil];
    }
    if(self.confirmPassword.text != self.newpassword.text)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Please enter4 correct confirm password" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [indicator stopAnimating];
        
        [self presentViewController:alertView animated:YES completion:nil];
    }
    
    if(self.currentPassword.text.length>0 && self.newpassword.text.length>0 && self.confirmPassword.text.length>0)
    {
        NSLog(@"hi");
        
        [self forceDataParsing];
    }
}
-(void)forceDataParsing{
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"username==%@",username);
    
    NSString *mainstr1=[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:force_password]];
    
    NSDictionary *parameterDict = @{
                                    @"tag":@"forcepassword",
                                    @"username":username,
                                    @"password":self.currentPassword.text,
                                    @"newpassword":self.newpassword.text,
                                    @"branch_id":@"1",
                                    @"dbname":dbname
                                    };

    
    [Constant executequery:mainstr1 strpremeter:parameterDict
                 withblock:^(NSData * dbdata, NSError *error) {
                     NSLog(@"*****data:%@",dbdata);
                     if (dbdata!=nil) {
                         NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:dbdata options:NSJSONReadingAllowFragments error:nil];
                         NSLog(@"response data:%@",maindic);
                         
                         _tag=[maindic objectForKey:@"tag"];
                         _success=[maindic objectForKey:@"success"];
                         _error=[maindic objectForKey:@"error"];
                         
                         NSLog(@"***tag==%@& ***success=%@",_tag,_success);
                         
                         
                         [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                             
                         }];
                         if ([_success isEqual:@"0"]) {
                             
                             UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Entered credential is incorrect" preferredStyle:UIAlertControllerStyleAlert];
                             
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
                         else{
                             NSLog(@"***confirm password reset successfully***");
                             
                             [self navigatingFromLogin];
                         }
                     }
                 }];
}

-(void)navigatingFromLogin{
    
    NSString *groupname = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"groupName"];
    NSLog(@"***groupname==%@",groupname);
    
    if (groupname!=NULL)
    {
        if ([groupname isEqual:@"Student"])
        {
            StudentViewController *admin = [self.storyboard instantiateViewControllerWithIdentifier:@"ToStudent"];
            
            [self.navigationController pushViewController:admin animated:YES];
        }
        else
        {
            TeacherViewController *user = [self.storyboard instantiateViewControllerWithIdentifier:@"ToTeacher"];
            
            [self.navigationController pushViewController:user animated:YES];
        }
        
    }
    else
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Entered credential is incorrect" preferredStyle:UIAlertControllerStyleAlert];
        
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
}

@end
