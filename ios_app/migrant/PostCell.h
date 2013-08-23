//
//  PostCell.h
//  oschina
//
//  Created by wangjun on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lbl_AnswerCount;
@property (retain, nonatomic) IBOutlet UIImageView *img;
@property (retain, nonatomic) IBOutlet UILabel *lblAuthor;
@property (retain, nonatomic) IBOutlet UITextView *txt_Title;
@property (retain, nonatomic) IBOutlet UILabel *lbl_answer_chinese;

@end
