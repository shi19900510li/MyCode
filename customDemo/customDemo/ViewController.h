//
//  ViewController.h
//  customDemo
//
//  Created by joker on 2017/5/22.
//  Copyright © 2017年 sandsyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDeleagte.h"
#import "customCell.h"
#import "UITableViewCell+Extension.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) UITableView* tab;
@property (nonatomic, strong) CustomDeleagte* customDeleagte;
@property (nonatomic, strong) NSMutableArray* dataArr;

@end

