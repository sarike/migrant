//
//  LoginView.m
//  oschina
//
//  Created by wangjun on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
@synthesize webView;
@synthesize txt_Name;
@synthesize txt_Pwd;
@synthesize switch_Remember;
@synthesize isPopupByNotice;
//@synthesize parent;
//@synthesize parentClassName;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
    [self.webView setDelegate:self];
    
    self.navigationItem.title = @"登录";
    //决定是否显示用户名以及密码
    NSString *name = @"demo";
    NSString *pwd = @"";
    if (name && ![name isEqualToString:@""]) {
        self.txt_Name.text = name;
    }
    if (pwd && ![pwd isEqualToString:@""]) {
        self.txt_Pwd.text = pwd;
    }
    
    UIBarButtonItem *btnLogin = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleBordered target:self action:@selector(click_Login:)];
    self.navigationItem.rightBarButtonItem = btnLogin;
 
    
    NSString *html = @"<body style='background-color:#EBEBF3'>1, 您可以在 <a href='http://www.oschina.net'>http://www.oschina.net</a> 上免费注册一个账号用来登陆<p />2, 如果您的账号是使用OpenID的方式注册的，那么建议您在网页上为账号设置密码<p />3, 您可以点击 <a href='http://www.oschina.net/question/12_52232'>这里</a> 了解更多关于手机客户端登录的问题</body>";
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
    NSString *name = self.txt_Name.text;
    NSString *pwd = self.txt_Pwd.text;
    
    /**
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:api_login_validate]];
    [request setUseCookiePersistence:YES];
    [request setPostValue:name forKey:@"username"];
    [request setPostValue:pwd forKey:@"pwd"];
    [request setPostValue:@"1" forKey:@"keep_login"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestLogin:)];
    [request startAsynchronous];
    
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在登录" andView:self.view andHUD:request.hud];
     **/
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
