//
//  comger.m
//  IOSBoilerplate
//
//  Created by Zk Huang on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "comger.h"



@interface comger ()

@end

@implementation comger

@synthesize dataItems;
@synthesize table;
@synthesize tvCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"done");
    self.title = @"comger";
    NSMutableDictionary *myitem;
    
    NSString *namekey = @"name";
    NSString *sexkey = @"sex";

    for (int i=0; i<10; i++) {
        myitem = [NSMutableDictionary dictionary];
        
        [myitem setObject:@"comger" forKey:namekey];
        [myitem setObjectb:@"man" forKey:sexkey];
        
        [dataItems addObject:myitem];
    }
    
    NSLog([dataItems count]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataItems count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    if(cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        if([nib count] > 0)
        {
            cell = self.tvCell;
        }
        else
        {
            NSLog(@"fail to load customcell nib file");
        }
        
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSUInteger row = [indexPath row];
    NSDictionary *rowdata = [dataItems objectAtIndex:row];
    
    UILabel *name = (UILabel *)[cell viewWithTag:knameTag];
    name.text = [rowdata objectForKey:@"name"];
    
    UILabel *sex = (UILabel *)[cell viewWithTag:ksexTag];
    sex.text = [rowdata objectForKey:@"sex"];
    
    return cell;
}

-(NSInteger)getIndex :(NSArray *) array{
    return [array count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index:%d",indexPath.row);
    NSLog(@"&gt;&gt;choose:%@",[dataItems objectAtIndex:[indexPath row]]);
    //NSInteger count = [[self alloc] getIndex:dataItems];
    NSLog(@"count:%@", [self getIndex:dataItems]);

}





- (void)dealloc
{
     
    [table release];
    
    [super dealloc];
}

@end
