//
//  CustomDeleagte.h
//  TableViewDemo
//
//  Created by hpjr on 16/11/21.
//  Copyright © 2016年 sandsyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock)(NSIndexPath* indexPath, id cell, id item);
typedef void (^TableViewCellDidSelectBlock)(NSIndexPath* indexPath, id cell, id item);
typedef CGFloat (^TableViewCellHeightBlock)(NSIndexPath* indexPath, id item);


@interface CustomDeleagte : NSObject <UITableViewDataSource,UITableViewDelegate>

- (id)initWithItems:(NSArray *)aItems
     cellIdentifier:(NSString *)aIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
    cellHeightBlock:(TableViewCellHeightBlock)aHeightBlock
     didSelectBlock:(TableViewCellDidSelectBlock)aDidSelectBlock;

- (void)handleTableViewDataSourceAndDelegate:(UITableView*)aTableView;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, copy) NSArray *items;

@end
