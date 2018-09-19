//
//  ConfirmPasswordVC.h
//  Eshiksa
//
//  Created by Punit on 16/08/18.
//  Copyright © 2018 Akhilesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPasswordVC : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *currentPassword;
    IBOutlet UITextField *confirmPassword;
    IBOutlet UITextField *newpassword;
}
@property (weak, nonatomic) IBOutlet UITextField *currentPassword;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *newpassword;

@property (nonatomic,strong) NSString *success,*email,*error,*tag,*user;

@end
