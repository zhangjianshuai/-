//
//  DetialViewController.m
//  gaodeMapPractice
//
//  Created by lanouhn on 15/5/27.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "DetialViewController.h"
#import "Person.h"
#import "DataManager.h"

@interface DetialViewController ()<UINavigationControllerDelegate ,UIImagePickerControllerDelegate>{
    Person *person;
    NSData *imageData;
    DataManager *dataManager;
    IBOutlet UIButton *okButton;
}

@end

@implementation DetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"用户信息";
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255. green:245/255. blue:245/255. alpha:1];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1"]];
    
    self.image.layer.cornerRadius = 20;
    self.image.clipsToBounds = YES;
    
    okButton.layer.cornerRadius = 14;
    okButton.clipsToBounds = YES;
    okButton.layer.borderWidth = 1;
    okButton.layer.borderColor = [UIColor whiteColor].CGColor;
    okButton.showsTouchWhenHighlighted = YES;
    
    //读数据
    dataManager = [DataManager shareDataManager];
    [self showData];
    
    //收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
    [self.view addGestureRecognizer:tap];
    
    //选图片手势
    self.image.userInteractionEnabled = YES;
    UITapGestureRecognizer *choosePic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrImageClicked)];
    [self.image addGestureRecognizer:choosePic];
}

- (void)showData{
    Person *p = dataManager.person;
    self.image.image = [UIImage imageWithData:p.imageData];
    self.nameLabel.text = p.name;
    self.genderLabel.text = p.gender;
    self.heightLabel.text = p.height;
    self.weightLabel.text = p.weight;
}

//收键盘
- (void)tapScreen {
    [self.view endEditing:YES];
}

- (void)choosePic{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)ok:(id)sender {
    person = [Person creatPersonWithImageData:imageData name:self.nameLabel.text gender:self.genderLabel.text height:self.heightLabel.text weight:self.weightLabel.text];
    NSLog(@"%@", person);
    
    //归档存至本地
    [self archieveObject];
}

//归档
- (void)archieveObject{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    BOOL bo = [NSKeyedArchiver archiveRootObject:person toFile:[path stringByAppendingPathComponent:@"archieve"]];
    
    //bo == YES?[[[UIAlertView alloc] initWithTitle:@"数据存储成功" message:@"数据存储成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil] show]:[[[UIAlertView alloc] initWithTitle:@"数据存储失败" message:@"数据存储失败" delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles: nil] show];
    if (bo == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//选取图片
- (void)UesrImageClicked
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}


#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    //从info里面获取编辑后的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //直接转成data类型
    imageData = UIImagePNGRepresentation(image);
    
    self.image.image = image;
}

//info
/*
 2015-05-27 14:53:21.059 gaodeMapPractice[3512:1283677] {
UIImagePickerControllerCropRect = "NSRect: {{0, 423}, {639, 640}}";
UIImagePickerControllerEditedImage = "<UIImage: 0x1550a9a0> size {638, 640} orientation 0 scale 1.000000";
UIImagePickerControllerMediaType = "public.image";
UIImagePickerControllerOriginalImage = "<UIImage: 0x15763820> size {639, 1134} orientation 0 scale 1.000000";
UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=8250476E-3015-40EC-B223-2D25B3EBB0C3&ext=JPG";
*/




@end
