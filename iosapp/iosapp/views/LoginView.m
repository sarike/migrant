//
//  LoginView.m
//  oschina
//
//  Created by wangjun on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginView.h"
#import "AFJSONRequestOperation.h"
#import "LocalConfig.h"

@implementation LoginView
@synthesize webView;
@synthesize txt_Name;
@synthesize txt_Pwd;
@synthesize switch_Remember;
@synthesize isPopupByNotice;



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
    [self.webView setDelegate:self];
    
    self.navigationItem.title = @"登录";
    //决定是否显示用户名以及密码
    NSString *name = [[LocalConfig Instance]shareconfig:@"name"];
    NSString *pwd = @"";
    if (name && ![name isEqualToString:@""]) {
        self.txt_Name.text = name;
    }
    if (pwd && ![pwd isEqualToString:@""]) {
        self.txt_Pwd.text = pwd;
    }
    
    UIBarButtonItem *btnLogin = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleBordered target:self action:@selector(click_Login:)];
    self.navigationItem.rightBarButtonItem = btnLogin;
 
    
    NSString *html = @"<body style='background-color:#EBEBF3'>1, test web content <a href='http://www.baidu.com'>百度</a></body>";
    [self.webView loadHTMLString:html baseURL:nil];
    self.webView.hidden = NO;
}

- (void)viewDidUnload
{
    [self setTxt_Name:nil];
    [self setTxt_Pwd:nil];
    [self setSwitch_Remember:nil];
    [self setWebView:nil];

    [super viewDidUnload];
}
- (void)viewDidDisappear:(BOOL)animated
{
    
}
- (IBAction)click_Login:(id)sender 
{    
    NSString *username = self.txt_Name.text;
    NSString *password = self.txt_Pwd.text;
    
    NSString *url = [NSString stringWithFormat:@"http://112.124.38.112:8888/m/account/login?username=%@&password=%@",username,password ];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [req setHTTPMethod:@"POST"];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        BOOL *status = [[JSON objectForKey:@"status"] boolValue];      
        if(status){
            NSDictionary *data = [JSON objectForKey:@"data"];         
            [[LocalConfig Instance]setconfig:@"uid" :[data valueForKey:@"_id"]];
            [[LocalConfig Instance]setconfig:@"name" :[data valueForKey:@"name"]];
            NSLog(@"uid:%@",[[LocalConfig Instance]shareconfig:@"uid"]);
            [self.navigationController popViewControllerAnimated:YES];
            //LocalConfig get uid
           
        }else{
            [self alert:@"登录失败"];
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [self alert:@"网络请求异常"];
    }];
    
    
    [operation start];
    [operation waitUntilFinished];
    
}

-(void)alert:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}

- (IBAction)textEnd:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgrondTouch:(id)sender 
{
    [self.txt_Pwd resignFirstResponder];
    [self.txt_Name resignFirstResponder];
}


- (void)analyseUserInfo:(NSString *)xml
{
    @try {
       
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

#pragma 浏览器链接处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [[UIApplication sharedApplication] openURL:request.URL];
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) 
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
