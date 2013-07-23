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
        BOOL *status = [JSON objectForKey:@"status"];
        if(status){
            //self.dataList = [JSON valueForKey:@"data"] ;
            NSDictionary *data = [JSON objectForKey:@"data"];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:data];
            NSArray *cookies = [NSArray arrayWithObjects: cookie, nil];
            NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
            [self loaddata:headers];
            
        }else{
            NSLog(@"server faild" );
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
