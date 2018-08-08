//
//  CustomDeleagte.m
//  TableViewDemo
//
//  Created by hpjr on 16/11/21.
//  Copyright © 2016年 sandsyu. All rights reserved.
//

#import "CustomDeleagte.h"
#import "UITableViewCell+Extension.h"

@interface CustomDeleagte()
@property (nonatomic, copy) NSString* cellIdentigier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) TableViewCellDidSelectBlock didSelectBlock;
@property (nonatomic, copy) TableViewCellHeightBlock heightBlock;
@end

@implementation CustomDeleagte

- (id)initWithItems:(NSArray *)aItems
     cellIdentifier:(NSString *)aIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
    cellHeightBlock:(TableViewCellHeightBlock)aHeightBlock
didSelectBlock:(TableViewCellDidSelectBlock)aDidSelectBlock{
    self = [super init];
    if (self) {
        self.items = aItems;
        self.cellIdentigier = aIdentifier;
        self.configureCellBlock = aConfigureCellBlock;
        self.heightBlock = aHeightBlock;
        self.didSelectBlock = aDidSelectBlock;
    }
    return self;
}


- (id)itemAtIndexPath:(NSIndexPath*)indexPath{
    return self.items[(NSUInteger)indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentigier];
    if (!cell) {
        [UITableViewCell registerTabelView:tableView nibIdentifier:self.cellIdentigier];
        cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentigier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(indexPath,cell,item);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [self itemAtIndexPath:indexPath];
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    self.didSelectBlock(indexPath,cell,item);
}

- (void)handleTableViewDataSourceAndDelegate:(UITableView *)aTableView{
    aTableView.delegate = self;
    aTableView.dataSource = self;
    aTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [self itemAtIndexPath:indexPath];
    return self.heightBlock(indexPath,item);
}
@end
