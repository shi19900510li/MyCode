//
//  UITableViewCell+Extension.m
//  TableViewDemo
//
//  Created by hpjr on 16/11/21.
//  Copyright © 2016年 sandsyu. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)

//注册cell
+ (void)registerTabelView:(UITableView*)aTable
            nibIdentifier:(NSString*)identifier{
    [aTable registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
}

//载入数据
- (void)configure:(UITableViewCell*)aCell
        custimObj:(id)obj
        indexPath:(NSIndexPath*)indexPath{
    
}

//根据数据源计算cell高度 默认返回44.0f
+ (CGFloat)getCellHeightWitCustomObj:(id)obj
                           indexPath:(NSIndexPath*)indexPath{
    return 44.0f;
}
@end
