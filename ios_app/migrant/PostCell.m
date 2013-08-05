//
//  PostCell.m
//  iosmigrant
//
//  Created by comger on 13-7-30.
//
//

#import "PostCell.h"

@implementation PostCell
@synthesize imghead;
@synthesize lbnickname;
@synthesize lbaddon;
@synthesize lbbody;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setValue:(NSDictionary *)info{
    [imghead setImageWithURL:[NSURL URLWithString:@"http://pic.kuche.com/kp1/big/n_20357933131011.jpg"]];
    [lbnickname setText:[info valueForKey:@"username"]];
    [lbbody setText:[info valueForKey:@"body"]];
    [lbaddon setText:[info valueForKey:@"addon"]];
    [lbbody layoutIfNeeded];
}

- (void)dealloc {
    [lbnickname release];
    [lbaddon release];
    [lbbody release];
    [imghead release];
    [super dealloc];
}
@end
