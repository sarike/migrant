//
//  LoginViewController.h
//  iosmigrant
//
//  Created by comger on 13-7-22.
//
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *tbusername;
@property (retain, nonatomic) IBOutlet UITextField *tvpassword;
@property (retain, nonatomic) IBOutlet UIButton *btnlogin;
  
- (IBAction)login:(id)sender;

- (IBAction)backgrondTouch:(id)sender;
@end
