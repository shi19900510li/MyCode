//
//  ViewController.m
//  customDemo
//
//  Created by joker on 2017/5/22.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import "ViewController.h"
#import "CDRecordVideoViewController.h"
#import "CDSearchViewController.h"
#import "CDShareViewController.h"
#import "UIViewController+NavBarHidden.h"
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface ViewController () <CDRecordVideoDelegate>
@end

@implementation ViewController

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self hy_viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self hy_viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self hy_viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [[NSMutableArray alloc]initWithArray:@[@"测试拍视频",@"UISearchController",@"测试系统分享",@"上传和下载"]];;
    
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    TableViewCellConfigureBlock ConfigBlock = ^(NSIndexPath* indexPath,id cell,id item){
        NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
        [cell configure:cell custimObj:dic indexPath:indexPath];
    };
    
    TableViewCellDidSelectBlock DidBlock = ^(NSIndexPath* indexPath,id cell,id item){
        if (indexPath.row == 0) {
            [self openRecordVideoViewController];
        } else if (indexPath.row == 1) {
            [self openSearchViewController];
        } else if (indexPath.row == 2) {
            [self openShareViewController];
        } else if (indexPath.row == 3) {
            [self openShareViewController];
        }
    };
    TableViewCellHeightBlock heightBlock = ^CGFloat(NSIndexPath* indexPath,id item){
        return 44;
    };
    
    self.customDeleagte = [[CustomDeleagte alloc]initWithItems:self.dataArr
                                                cellIdentifier:@"customCell"
                                            configureCellBlock:ConfigBlock
                                               cellHeightBlock:heightBlock
                                                didSelectBlock:DidBlock];
    
    [self.customDeleagte handleTableViewDataSourceAndDelegate:self.tab];
    [self.view addSubview:self.tab];
    
    [self configHeaderView];

}

- (void)configHeaderView {
    [self setKeyScrollView:self.tab scrolOffsetY:50 options:HYHidenControlOptionLeft | HYHidenControlOptionRight];
    //设置tableView的头部视图
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    imageView.image = [UIImage imageNamed:@"lol"];
    self.tab.tableHeaderView = imageView;
    [self setNavBarBackgroundImage:[UIImage imageNamed:@"2.jpg"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (IBAction)leftBarButtonAction:(id)sender {
    //添加数据 一次三条
    for (int i = 0; i<3; i++) {
        NSUInteger number = self.dataArr.count;
        [self.dataArr addObject:[NSString stringWithFormat:@"第%ld行",number+1]];
    }
    //更新数据源
    [self.customDeleagte setItems:self.dataArr];
    [self.tab reloadData];
}


#pragma mark 进入录视频
- (void)openRecordVideoViewController {
    CDRecordVideoViewController *cdRecord = [[CDRecordVideoViewController alloc]init];
    cdRecord.delegate = self;
    [self presentViewController:cdRecord animated:YES completion:nil];
}

- (void)openSearchViewController {
    CDSearchViewController *cdSearch = [[CDSearchViewController alloc]init];
    [self.navigationController pushViewController:cdSearch animated:YES];
}

- (void)openShareViewController {
    CDShareViewController *cdRecord = [[CDShareViewController alloc]init];
    [self.navigationController pushViewController:cdRecord animated:YES];
}

- (void)uploadAndDownload {
    CDShareViewController *cdRecord = [[CDShareViewController alloc]init];
    [self.navigationController pushViewController:cdRecord animated:YES];
}

#pragma mark CDRecordVideoDelegate
- (void)finishWechatShortVideoCapture:(NSURL *)filePath showImage:(UIImage *)image {
    NSLog(@"finishWechatShortVideoFilePath:%@",filePath);
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

@end
