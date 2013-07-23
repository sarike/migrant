//
//  PullDownExample.m
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "PullDownExample.h"
#import "AFJSONRequestOperation.h"


@implementation PullDownExample

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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
        cell.textLabel.text=[[self.dataList objectAtIndex:indexPath.row] valueForKey:@"body"];    }
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
        UIViewController* vc = [[PullDownExample alloc] init];
        //[vc getFinalRemViewController:self];
        NSString *_since = [[self.dataList objectAtIndex:(indexPath.row)] objectForKey:@"_id"];
        [vc setSince:_since];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
        
    }
}

-(void)setsince:(NSString *)_since{
    self.since = _since;
}

-(void)loadMore  
{
    NSMutableArray *more;
    more=[[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<10; i++) {
        [more addObject:[NSString stringWithFormat:@"cell ++%i",i]];
    }
    //加载你的数据
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO];
    [more release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Pull down example";
    self.dataList = [[NSMutableArray alloc] init];
    
    
    [self loaddata];
}

-(void)loaddata{
    self.url =  @"http://192.168.1.166:8888/m/post/city";
    if(self.since!=nil){
        url = [NSString stringWithFormat: @"%@?since=%@",url,self.since];
    }
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

@end
