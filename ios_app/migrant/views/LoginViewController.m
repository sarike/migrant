//
//  LoginViewController.m
//  iosmigrant
//
//  Created by comger on 13-7-22.
//
//

#import "LoginViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "PostViewController.h"
#import "LocalConfig.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize tbusername;
@synthesize tvpassword;
@synthesize btnlogin;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
        self.tabBarItem = item;
        self.title = @"Login";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tbusername release];
    [tvpassword release];
    [btnlogin release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTbusername:nil];
    [self setTvpassword:nil];
    [self setBtnlogin:nil];
    [super viewDidUnload];
}


- (IBAction)login:(id)sender {
    
    NSString *username = tbusername.text;
    NSString *password = tvpassword.text;
    NSString *url = [NSString stringWithFormat:@"http://192.168.1.166:8888/m/account/login?username=%@&password=%@",username,password ];
    NSLog(url);
    //NSURL *url = [NSURL URLWithString:@"http://192.168.1.166:8888"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [req setHTTPMethod:@"POST"];
    NSLog(@"%@", req);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@",JSON);
        BOOL *status = [[JSON objectForKey:@"status"] boolValue];
        NSNumber *flag = [JSON valueForKey:@"status"];
        
        if(status){
            //self.dataList = [JSON valueForKey:@"data"] ;
            NSDictionary *data = [JSON objectForKey:@"data"];
            /**
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:data];
            NSArray *cookies = [NSArray arrayWithObjects: cookie, nil];
            NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            [self loaddata:headers];
             **/
            
            [[LocalConfig Instance]setconfig:@"uid" :[data valueForKey:@"_id"]];
            [[LocalConfig Instance]setconfig:@"name" :[data valueForKey:@"name"]];
            
            /**
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"localconfig" ofType:@"plist"];
            NSMutableDictionary *config = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
            [config setDictionary:data];
            
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *plistPath1 = [paths objectAtIndex:0];
            
            //得到完整的文件名
            NSString *filename=[plistPath1 stringByAppendingPathComponent:@"localconfig.plist"];
            //输入写入
            [config writeToFile:filename atomically:YES];
            
            NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
            NSLog(@"%@", data1);
              **/
        }else{
            NSLog(@"server faild" );
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录提示" message:@"登录失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alert show];
            [alert release];
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"network faild" );
    }];
     
    
    [operation start];
    [operation waitUntilFinished];

}

-(void)loaddata:(NSDictionary *)headers{
    NSString *url = [NSString stringWithFormat:@"http://192.168.1.166:8888/m/city/page"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //[req setAllHTTPHeaderFields:headers];
    
    [req setHTTPMethod:@"GET"];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:req success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@",JSON);
        BOOL *status = [JSON objectForKey:@"status"];
        if(status){
            //self.dataList = [JSON valueForKey:@"data"] ;
            NSDictionary *data = [JSON objectForKey:@"data"];
            NSLog(@"%@",data);
        }else{
            NSLog(@"server faild" );
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"network faild" );
    }];
    
    [operation start];
    [operation waitUntilFinished];

}

-(void)backgrondTouch:(id)sender{
    [tbusername resignFirstResponder];
    [tvpassword resignFirstResponder];
}


@end
