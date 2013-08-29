//
//  NewsView.m
//  iosapp
//
//  Created by comger on 13-8-23.
//  Copyright (c) 2013年 comger. All rights reserved.
//

#import "NewsView.h"
#import "SVProgressHUD.h"

@interface NewsView ()

@end

@implementation NewsView

@synthesize datalist;
@synthesize catalog;
@synthesize since;
@synthesize url;

//重新载入类型
- (void)reloadType:(int)ncatalog{
    self.catalog = ncatalog;
    self.datalist = [[NSMutableArray alloc]init];
    if(ncatalog==1){
        self.url = @"http://112.124.38.112:8888/m/report/city/51d28b24931e334378000ad3";
    }else if(ncatalog==2){
        self.url = @"http://112.124.38.112:8888/m/report/city/51d28b25931e334378000b11";
    }
    [self loadData];
    
}

-(void)loadData{
    [SVProgressHUD showInView:self.view];
    if(self.since){
        self.url = [NSString stringWithFormat:@"%@?since=%@",self.url,self.since ];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if([JSON objectForKey:@"status"]){
            NSArray *array = [JSON valueForKey:@"data"] ;
            for (NSDictionary *item in array) {
                [self.datalist addObject:item];
            }
            
            [self.table reloadData];
        }else{
            NSLog(@"server faild" );
        }
        [SVProgressHUD dismiss];
        //[SVProgressHUD dismissWithSuccess:@"Ok!"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
        [SVProgressHUD dismissWithError:[error localizedDescription]];
    }];
    [operation start];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.url = @"http://112.124.38.112:8888/m/report/city/51d28b24931e334378000ad3";
    [self loadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.datalist.count>0){
        return self.datalist.count+1;
    }else{
        return self.datalist.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.datalist count] > 0) {
        if ([indexPath row] < [self.datalist count])
        {
            NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCellIdentifier"];
            if (!cell) {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
                for (NSObject *o in objects) {
                    if ([o isKindOfClass:[NewsCell class]]) {
                        cell = (NewsCell *)o;
                        break;
                    }
                }
            }
            cell.lblTitle.font = [UIFont boldSystemFontOfSize:15.0];
            NSDictionary *n = [self.datalist objectAtIndex:indexPath.row];
            cell.lblTitle.text = [n valueForKey:@"title"];
            cell.lblAuthor.text = [n valueForKey:@"source"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.textLabel.text = @"加载更多";
            return cell;
        }
    }
}



#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected cell at section #%d and row #%d", indexPath.section, indexPath.row);
    if(indexPath.row<self.datalist.count){
    
    }else{
        NSDictionary *n = [self.datalist objectAtIndex:(indexPath.row-1)];
        self.since = [n valueForKey:@"_id"];
        [self loadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"资讯";
    self.datalist = [[NSMutableArray alloc]init];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload]; // Always call superclass methods first, since you are using inheritance
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
