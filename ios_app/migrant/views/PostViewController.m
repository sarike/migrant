//
//  PostViewController.m
//  iosmigrant
//
//  Created by comger on 13-7-22.
//
//

#import "PostViewController.h"
#import "AFJSONRequestOperation.h"
#import "LoginViewController.h"
#import "LocalConfig.h"
#import "PostCell.h"

@interface PostViewController ()

@end

@implementation PostViewController
@synthesize dataList;
@synthesize since;
@synthesize url;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
        
        self.tabBarItem = item;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ListViewController

// This is the core method you should implement
- (void)reloadTableViewDataSource {
	_reloading = YES;
    
    // Here you would make an HTTP request or something like that
    // Call [self doneLoadingTableViewData] when you are done
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataList count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if([indexPath row] == ([self.dataList count])) {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text=@"More..";
        return cell;
    }else {
        PostCell *cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:@"PostCellIdentifier"];
        if (!cell)
        {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
            for (NSObject *o in objects) {
                if([o isKindOfClass:[PostCell class]]){
                    cell = (PostCell *)o;
                    break;
                }
            }

        }
        cell.img.image = [UIImage imageNamed:@"avatar_loading.jpg"];
        NSDictionary *p = [self.dataList objectAtIndex:indexPath.row];

        cell.lbl_answer_chinese.text = @"回答" ;
        cell.txt_Title.text = [p valueForKey:@"body"];
        cell.txt_Title.font = [UIFont boldSystemFontOfSize:14.0];
        cell.lbl_AnswerCount.text = [NSString stringWithFormat:@"%d", 5];
        cell.lblAuthor.text = [NSString stringWithFormat:@"%@", [p valueForKey:@"admin"]];
        return cell;
    }

  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.dataList count]) {
        self.since = [[self.dataList objectAtIndex:([self.dataList count]-1)] objectForKey:@"_id"];
        UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];
        loadMoreCell.textLabel.text=@"loading more …";
        [self performSelectorInBackground:@selector(loaddata) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
}

-(void)setsince:(NSString *)_since{
    self.since = _since;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataList = [[NSMutableArray alloc] init];

    if([[LocalConfig Instance]shareconfig:@"uid"]==nil){
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请登录后查看信息" delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"登录", nil];
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }else{
        [self loaddata];
    }
    

}

-(void)loaddata{
    self.url =  @"http://192.168.1.166:8888/m/post/home";
    if(self.since!=nil){
        url = [NSString stringWithFormat: @"%@?since=%@",url,self.since];
    }
    

    NSLog(self.url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog([self.dataList length]);
        if([JSON objectForKey:@"status"]){
            //self.dataList = [JSON valueForKey:@"data"] ;
            NSArray *array = [JSON valueForKey:@"data"] ;
            
            for (NSDictionary *item in array) {
                [self.dataList addObject:item];
            }
            [self.table reloadData];
        }else{
            NSLog(@"server faild" );
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"network faild" );
    }];
    
    [operation start];
}

- (void)viewDidUnload
{
    self.dataList = nil;
    [super viewDidUnload]; // Always call superclass methods first, since you are using inheritance
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"登录"]) {
        LoginViewController *loginview = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginview animated:YES];
        return;
    }
}

@end
