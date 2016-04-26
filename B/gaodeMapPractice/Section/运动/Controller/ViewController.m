//
//  ViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/23.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//


//key:76e596f92f58672b614fe9c3840b76cf


#import "ViewController.h"
#import "MapViewController.h"
#import "DataManager.h"
#import "TypeViewController.h"
#import "History.h"

#import "TishiManager.h"


@interface ViewController ()<UIAlertViewDelegate>{
    
    IBOutlet UILabel *timeLabel;//运动时间
    IBOutlet UILabel *kmLabel;//总路程
    IBOutlet UILabel *kmhLabel;//时速
    
    IBOutlet UIView *sView1;
    IBOutlet UILabel *sLabel1;//热量消耗值
    IBOutlet UIImageView *sImageView1;
    IBOutlet UIView *sView2;
    IBOutlet UILabel *sLabel2;//平均配速值
    IBOutlet UIImageView *sImageView2;
    IBOutlet UIView *sView3;
    IBOutlet UILabel *sLabel3;//当前时速值
    IBOutlet UIImageView *sImageView3;
    
    IBOutlet UIButton *startButton;//开始暂停按钮
    IBOutlet UIButton *reCover;//复位按钮
    
    IBOutlet UIImageView *stateImageView;//跑步或者骑行的图片
    IBOutlet UILabel *stateLabel;//跑步或骑行文字
    
    UIButton *changeButton;//切换页面按钮
    BOOL flag;
    
    //计时器
    BOOL timeState;
    //秒数
    NSInteger second;
    
    DataManager *dataManager;
    
    TishiManager *tishiManager;
    
}

@property (nonatomic, strong) NSMutableArray *historyArray;//储存记录的数组

@property (nonatomic, retain) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"%@",[NSBundle mainBundle].bundleIdentifier);
    
    flag = YES;
    
    //self.historyArray = [@[] mutableCopy];
    //self.historyArray = [NSMutableArray arrayWithCapacity:0];
    
    [self creatMapView];
    
    [self creatDataView];
    
    [self.view insertSubview:self.MyDataView aboveSubview:self.MyMapView];
    
    [self creatChangeButton];
    
    [self createTimer];
    
    [self createNavButton];
    
    dataManager = [DataManager shareDataManager];
    
    tishiManager = [TishiManager shareTishiManager];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (dataManager.type == nil) {
        stateImageView.image = [UIImage imageNamed:@"huo"];
        stateImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(add)];
        [stateImageView addGestureRecognizer:tap];
        stateLabel.text = @"o可选o";
    } else {
    stateImageView.image = [UIImage imageNamed:dataManager.type];
    stateLabel.text = dataManager.str;
    }
}

//创建左右两个
- (void)createNavButton{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(writeToLocal)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(savePicture)];
    self.navigationItem.rightBarButtonItem = right;
}

//选择运动类型跳转
- (void)add{
    [self performSegueWithIdentifier:@"toType" sender:nil];
}

- (void)savePicture{
    //屏幕截图
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)               image: (UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片已保存!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

- (void)creatDataView {
    
    //设置边线
    kmLabel.layer.borderWidth = 1;
    kmLabel.layer.borderColor = [UIColor grayColor].CGColor;
    kmhLabel.layer.borderWidth = 1;
    kmhLabel.layer.borderColor = [UIColor grayColor].CGColor;
    kmLabel.layer.borderWidth = 1;
    kmLabel.layer.borderColor = [UIColor grayColor].CGColor;
    sView1.layer.borderWidth = 1;
    sView1.layer.borderColor = [UIColor grayColor].CGColor;
    sView2.layer.borderWidth = 1;
    sView2.layer.borderColor = [UIColor grayColor].CGColor;
    sView3.layer.borderWidth = 1;
    sView3.layer.borderColor = [UIColor grayColor].CGColor;
    //设置开始按钮和定位精度
    startButton.layer.cornerRadius = startButton.bounds.size.width/2.0;
    startButton.clipsToBounds = YES;
    startButton.layer.borderWidth = 8;
    startButton.layer.borderColor = [UIColor colorWithRed:160/255. green:82/255. blue:45/255. alpha:0.5].CGColor;
    //[startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    reCover.layer.cornerRadius = reCover.bounds.size.height/2.0;
    reCover.clipsToBounds = YES;
    reCover.layer.borderWidth = 5;
    reCover.layer.borderColor = [UIColor colorWithRed:160/255. green:82/255. blue:45/255. alpha:0.4].CGColor;
    reCover.hidden = YES;
    [reCover setImage:[UIImage imageNamed:@"recover"] forState:UIControlStateNormal];
}

- (void)creatMapView {
    MapViewController *mapView = [[MapViewController alloc] init];
    self.MyMapView.frame = self.view.bounds;
    self.MyMapView = mapView.view;
    [self.view addSubview:self.MyMapView];
    [self addChildViewController:mapView];
}

- (void)createTimer {
    timeState = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self.timer invalidate];
    second = 0;

}

//类型图标随着运用开始(停止)闪烁
- (void)animate{
    [UIView animateWithDuration:0.5 animations:^{
        stateImageView.alpha = 0.3;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            stateImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)timerAction {
    [self animate];
    second++;
    
    dataManager.time = second;
    
    NSInteger i, j, k;
    NSString *str1, *str2, *str3;
    i = second/3600;
    j = second%3600/60;
    k = second%3600%60;
    
    if (i < 10) {
        str1 = [NSString stringWithFormat:@"0%ld", (long)i];
    } else {
        str1 = [NSString stringWithFormat:@"%ld", (long)i];
    }
    if (j < 10) {
        str2 = [NSString stringWithFormat:@"0%ld", (long)j];
    } else {
        str2 = [NSString stringWithFormat:@"%ld", (long)j];
    }
    if (k < 10) {
        str3 = [NSString stringWithFormat:@"0%ld", (long)k];
    } else {
        str3 = [NSString stringWithFormat:@"%ld", (long)k];
    }
    
    timeLabel.text = [NSString stringWithFormat:@"%@ : %@ : %@", str1, str2, str3];
    
    [self showData];
}

- (void)showData{
    //总路程
    kmLabel.text = [NSString stringWithFormat:@"%.2f", dataManager.distance/1000.0];
    //总的速度(km/h)
    kmhLabel.text = [NSString stringWithFormat:@"       %.0f", dataManager.speed];
    //卡路里消耗
    sLabel1.text = [NSString stringWithFormat:@"%.1f", dataManager.kcal];
    //平均速度(m/s)
    sLabel2.text = [NSString stringWithFormat:@"%.1f", dataManager.avgSpeed];
    //当前时速(m/s)
    sLabel3.text = [NSString stringWithFormat:@"%.1f", dataManager.tempSpeed];
    
    //本地提示设置
    if (dataManager.distance/1000. == [tishiManager.distance floatValue]) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        //触发时间
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        //设置弹窗内容
        localNotification.alertBody = tishiManager.words;
        //当点击通知的时候,进入应用显示的加载图片...
        //localNotification.alertLaunchImage
        //设置一下需要传值的数据
        //localNotification.userInfo = @{@"name":@"xingjin"};
        //设置一下消息的声音
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        //把本地通知加进APP里面
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

- (void)creatChangeButton {
    changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.highlighted = NO;
    changeButton.frame = CGRectMake(self.view.bounds.size.width - 80, self.view.bounds.size.height - 120 - 50, 80, 120);
    [changeButton setTitle:@"切换" forState:UIControlStateNormal];
    [changeButton setImage:[UIImage imageNamed:@"changeButton01"] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeAnimation) forControlEvents:UIControlEventTouchDown];
    changeButton.selected = NO;
    changeButton.layer.shadowOffset = CGSizeMake(5, 5);
    changeButton.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:changeButton];
    [self.view bringSubviewToFront:changeButton];
}

- (void)changeAnimation {
    changeButton.alpha = 0;
    
    flag = !flag;
    
        if (flag == NO) {
            [UIView animateWithDuration:1.5 animations:^{
                [changeButton setImage:[UIImage imageNamed:@"changeButton02"] forState:UIControlStateNormal];
                changeButton.alpha = 0.9;
            }];
            [UIView transitionWithView:self.view duration:0.7 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                [self.view insertSubview:self.MyMapView aboveSubview:self.MyDataView];
            } completion:nil];
            
        } else {
            [UIView animateWithDuration:1.5 animations:^{
                [changeButton setImage:[UIImage imageNamed:@"changeButton01"] forState:UIControlStateNormal];
                changeButton.alpha = 0.9;
            }];
            [UIView transitionWithView:self.view duration:0.7 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                [self.view insertSubview:self.MyDataView aboveSubview:self.MyMapView];
            } completion:nil];
        }
}

- (IBAction)clickStartButton:(id)sender {
    
    CATransition *anim = [CATransition animation];
    anim.duration = 0.8;
    //水波动画
    anim.type = @"rippleEffect";
    [startButton.layer addAnimation:anim forKey:nil];
    
    timeState = !timeState;
    if (timeState == YES) {
        [self.timer invalidate];
        reCover.hidden = NO;
        [reCover.layer addAnimation:anim forKey:nil];
        [startButton setImage:[UIImage imageNamed:@"puse"] forState:UIControlStateNormal];
        
        dataManager.isRuning = NO;
    }
    if (timeState == NO) {
        anim.type = @"suckEffect";
        [reCover.layer addAnimation:anim forKey:nil];
        [startButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        if ([self.timer isValid]) {
            [self.timer fire];
        } else {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        }
        reCover.hidden = YES;
        
        dataManager.isRuning = YES;
        dataManager.time = second;
    }

}
- (IBAction)clickCoverButton:(id)sender {
    second = 0;
    timeLabel.text = @"00 : 00 : 00";

    [dataManager recover];
    [self showData];
}

//存本次的运动记录到本地
- (void)writeToLocal{
    if (dataManager.time == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"亲,空数据咱就别保存了~" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    } else {
        //记录下运动开始的时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"China"];
        [formatter setTimeZone:timeZone];
        NSString *str = [formatter stringFromDate:[NSDate date]];
        dataManager.startTimeStr = str;
        
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"亲,确定存储本次的运动记录么~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil] show];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        //写个通知,让地图界面截图
        [[NSNotificationCenter defaultCenter] postNotificationName:@"takePhoto" object:nil userInfo:nil];
        
        //先取本地数组
        [self getArray];
        //获取此次运动数据
        History *history = [History createHistory];
        //添加数据
        [self.historyArray addObject:history];
        
        //进行储存
        NSData *historyData = [NSKeyedArchiver archivedDataWithRootObject:self.historyArray];
        
        [self saveData:historyData toPath:@"historyArray"];
        
    } else {
        NSLog(@"取消");
    }
}

//往沙盒Cache存储数据
- (void)saveData:(id)data toPath:(NSString *)str{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

    BOOL bo = [data writeToFile:[path stringByAppendingPathComponent:str] atomically:NO];
    
    //bo == YES?[[[UIAlertView alloc] initWithTitle:@"数据存储成功" message:@"数据存储成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show]:[[[UIAlertView alloc] initWithTitle:@"数据存储失败" message:@"数据存储失败" delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles: nil] show];
}

- (void)getArray {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSData *data = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"historyArray"]];
    if (data == nil) {
        self.historyArray = [@[] mutableCopy];
    } else {
        self.historyArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    NSLog(@"本地已有记录: %@", self.historyArray);
}

@end











