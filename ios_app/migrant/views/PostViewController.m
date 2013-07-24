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

@interface PostViewController ()

@end

@implementation PostViewController
@synthesize dataList;
@synthesize since;
@synthesize url;
@synthesize parent;

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
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Cell #%d", indexPath.row];
    //cell.textLabel.text = [[self.dataList objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    if([indexPath row] == ([self.dataList count])) {
        //创建loadMoreCell
        cell.textLabel.text=@"More..";
    }else {
        cell.textLabel.text=[[self.dataList objectAtIndex:indexPath.row] valueForKey:@"name"];    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [NSString stringWithFormat:@"Section %i", section];
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
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PostViewController* vc = [[PostViewController alloc] init];
        //[vc getFinalRemViewController:self];
        NSString *_parent = [[self.dataList objectAtIndex:(indexPath.row)] objectForKey:@"_id"];
        [vc setParent:_parent];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
        
    }
}

-(void)setsince:(NSString *)_since{
    self.since = _since;
}

-(void)setParent:(NSString *)_parent{
    self.parent = _parent;
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
    self.url =  @"http://192.168.1.166:8888/m/city/list";
    if(self.since!=nil){
        //url = [NSString stringWithFormat: @"%@?since=%@",url,self.since];
    }
    
    if(self.parent!=nil){
        url = [NSString stringWithFormat: @"%@/%@",url,self.parent];
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
