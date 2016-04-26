//
//  HistoryViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/30.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "HistoryViewController.h"
#import "MyTableViewCell.h"
#import "History.h"
#import "DetialHistoryViewController.h"

@interface HistoryViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *strArray;
    NSMutableArray *array0;
    BOOL byTime;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245/255. green:245/255. blue:245/255. alpha:1];
    
    byTime = YES;
    array0 = [@[] mutableCopy];
    self.dataArray = [@[] mutableCopy];
    //[self getArray];
    strArray = @[@"跑步ing",@"骑行ing",@"跑马ing",@"滑雪ing",@"游泳ing"];
    [self createRightButton];
    [self createLeftButton];
    
    self.myTableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [self getArray];
    [self.myTableView reloadData];
}

- (void)getArray {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSData *data = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"historyArray"]];
    if (data == nil) {
        self.dataArray = [@[] mutableCopy];
    } else {
        //self.dataArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSMutableArray *tempArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSInteger count = tempArray.count;
        for (int i = 0; i < count/2; i++) {
            [tempArray exchangeObjectAtIndex:i withObjectAtIndex:count - 1];
        }
        self.dataArray = tempArray;
        array0 = self.dataArray;
    }
    NSLog(@"列表数据: %@", self.dataArray);
}

- (void)createRightButton{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(delete:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)createLeftButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 65, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"距离优先" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeArray:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)changeArray:(UIButton *)sender{
    if (byTime == YES) {
        [sender setTitle:@"日期优先" forState:UIControlStateNormal];
        NSInteger count = self.dataArray.count;
        BOOL flag = YES;
        for (int i = 0; i < count - 1 && flag; i++) {
            for (int j = 0; j < count - i - 1; j++) {
                flag = NO;
                History *a1 = _dataArray[j];
                History *a2 = _dataArray[j + 1];
                NSInteger b1 = [a1.distance integerValue];
                NSInteger b2 = [a2.distance integerValue];
                if (b1 > b2) {
                    [_dataArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                    flag = YES;
                }
            }
        }
    } else if (byTime == NO) {
        [sender setTitle:@"距离优先" forState:UIControlStateNormal];
        self.dataArray = array0;
    }
    byTime = !byTime;
    [self.myTableView reloadData];
}

- (void)delete:(id)sender {
    //如果tableView正被编辑,就取消编辑状态
    //反之, 进入编辑
    if ([self.myTableView isEditing]) {
        [self.myTableView setEditing:NO animated:YES];
    } else {
        [self.myTableView setEditing:YES animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    History *history = self.dataArray[indexPath.row];
    
    cell.history = history;
    cell.myImageView.image = [UIImage imageWithData:history.imageData];
    if (history.name == nil) {
        cell.nameLabel.text = @"小邢爱运动";
    } else {
    cell.nameLabel.text = history.name;
    }
    cell.typeImageView.image = [UIImage imageNamed:[self getTypeImageWith:history.str]];
    cell.timeLabel.text = history.startTime;
    float a = [history.distance floatValue];
    cell.detialLabel.text = [NSString stringWithFormat:@"时长:%@    行程:%.2f km",history.time, a/1000.0];
    return cell;
}

- (NSString *)getTypeImageWith:(NSString *)str {
    for (int i = 0; i < 5; i++) {
        if ([str isEqualToString:strArray[i]]) {
            return [NSString stringWithFormat:@"sporticon%d", i];
        }
    }
    return @"huo";
}

#pragma mark - UITableViewDalegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = (MyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"toDetialHistory" sender:cell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //destinationViewController, 是目标界面, 只读的
    if ([segue.identifier isEqualToString:@"toDetialHistory"]) {
        DetialHistoryViewController *vc = segue.destinationViewController;
        vc.cell = (MyTableViewCell *)sender;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //如果是删除的话
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //先删数据源
        [self.dataArray removeObjectAtIndex:indexPath.row];
        //存入(更新)本地
        //进行储存
        NSData *historyData = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
        [self saveData:historyData toPath:@"historyArray"];
        
        //后删视图
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.myTableView reloadData];
    }
}

//往沙盒Cache存储数据
- (void)saveData:(id)data toPath:(NSString *)str{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    BOOL bo = [data writeToFile:[path stringByAppendingPathComponent:str] atomically:NO];
    
    //bo == YES?[[[UIAlertView alloc] initWithTitle:@"数据存储成功" message:@"数据存储成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show]:[[[UIAlertView alloc] initWithTitle:@"数据存储失败" message:@"数据存储失败" delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles: nil] show];
    if (bo == YES) {
        NSLog(@"更新删除成功");
    }
}


@end









