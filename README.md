# -
一款运动型app
可以用延展为UIImage扩展以下方法，方便项目中以后的使用

 - 等比例压缩图片

```
.h
/**
 *  等比例压缩图片
 *
 *  @param sourceImage 原图
 *  @param size        压缩比例
 *
 *  @return
 */
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
```

```
.m
//压缩图片（等比例)
+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
```
 

 - 等比例缩放

```
.h
/**
 *  等比例缩放
 *
 *  @param image     需要缩放的图片
 *  @param scaleSize 缩放比例
 *
 *  @return 缩放后的图片
 */
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
```

```
.m
 - (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
```
 - 图片等比例显示

```
.h
/**
 *  图片等比例显示
 *
 *  @param img 获取的图片
 *  @param imageView  显示图片的imageView
 *
 *  @return
 */
+(void)resizeFrameWithImg:(UIImage *)img andImageView:(UIImageView *)imageView;
```

```
.m
+(void)resizeFrameWithImg:(UIImage *)img andImageView:(UIImageView *)imageView
{
    //img的尺寸
    CGFloat imgWidth=img.size.width;
    CGFloat imgHeight=img.size.height;
    
    //imgView的尺寸
    CGFloat vWidth=imageView.frame.size.width;
    CGFloat vHeight=imageView.frame.size.height;
    
    //宽高比
    CGFloat dImg=imgWidth/imgHeight;
    CGFloat dView=vWidth/vHeight;
    
    if (dImg > dView) {
        CGFloat changedHeight=vWidth * (imgHeight/imgWidth);
        imageView.frame=CGRectMake(imageView.frame.origin.x, (vHeight-changedHeight)/2 + imageView.frame.origin.y, vWidth, changedHeight);
    }
    else
    {
        CGFloat changedWidth=vHeight * (imgWidth/imgHeight);
        imageView.frame=CGRectMake(imageView.frame.origin.x + (vWidth-changedWidth)/2, imageView.frame.origin.y, changedWidth, vHeight);
    }
    
}
```

 

 - 压缩图片

```
.h
/**
 *  压缩图片
 *
 *  @param img  压缩之前
 *  @param size 尺寸
 *
 *  @return 压缩后的
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
```

```
.m
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
        // 创建一个bitmap的context
   
      // 并把它设置成为当前正在使用的context
    
        UIGraphicsBeginImageContext(size);
   
        // 绘制改变大小的图片
    
        [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    
       // 从当前context中创建一个改变大小后的图片
    
        UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
        // 使当前的context出堆栈
    
        UIGraphicsEndImageContext();
    
        //返回新的改变大小后的图片
    
        return scaledImage;
    
}
```

如果有什么不对的地方，望各位大神给出意见。
