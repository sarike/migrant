//
//  PostCell.h
//  iosmigrant
//
//  Created by comger on 13-7-30.
//
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell{
    NSString *headimg;
    NSString *nickname;
    NSString *addon;
    NSString *body;
    
}
@property (retain, nonatomic) IBOutlet UIImageView *imghead;
@property (retain, nonatomic) IBOutlet UILabel *lbnickname;
@property (retain, nonatomic) IBOutlet UILabel *lbaddon;

@property (retain, nonatomic) IBOutlet UITextView *lbbody;

-(void)setValue:(NSDictionary *)info;

@end
