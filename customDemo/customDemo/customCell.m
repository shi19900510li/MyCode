//
//  customCell.m
//  customDemo
//
//  Created by joker on 2017/5/22.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "customCell.h"

@implementation customCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(UITableViewCell*)aCell custimObj:(id)obj indexPath:(NSIndexPath*)indexPath{
    aCell.textLabel.text = [NSString stringWithFormat:@"%@",obj];
}

@end
