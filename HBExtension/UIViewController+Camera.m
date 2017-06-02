//
//  HBImagePickerController+Camera.m
//  EditImageDemo
//
//  Created by HUANGBO on 15/4/8.
//  Copyright (c) 2015年 YY.COM All rights reserved.
//

#import "UIViewController+Camera.h"
#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"

//#import "AppDelegate.h"
//#import "VPImageCropperViewController.h"
#import "UIImage+HBExtension.h"

@implementation UIViewController(Camera)

#define KEY_OBJECT_DISMISSBLOCKER @"HBImagePickerController.Camera"
#define KEY_methodName @"delegate"

const char * OperationKey = "OperationKey";
const char * editModeKey = "editModeKey";

-(void)setUIViewControllerCameraDelegate:(id)delegate
{
    objc_setAssociatedObject(self, &OperationKey,delegate, OBJC_ASSOCIATION_ASSIGN);
}
-(void)cancelUIViewControllerCameraDelegate {
    //取消该关联变量，置空
    objc_setAssociatedObject(self, &OperationKey, nil, OBJC_ASSOCIATION_ASSIGN);
//    //取消全部关联变量
//    objc_removeAssociatedObjects(arr);
}


-(id)getUIViewControllerCameraDelegate
{
    return objc_getAssociatedObject(self, &OperationKey);
}

-(void)setEditMode:(BOOL)editMode
{
    objc_setAssociatedObject(self, &editModeKey,[NSNumber numberWithBool:editMode],OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)editMode
{
    NSNumber *edit = objc_getAssociatedObject(self, &editModeKey);
    return edit.boolValue;
}
#pragma mark - present ablum
- (void)presentAblumViewControllerWithAnimated: (BOOL)flag completion:(void (^)(void))completionx
{
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    if (self.editMode) {
        mediaUI.allowsEditing = YES;
    }
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:nil];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 相机相关

-(void)presentCameraViewControllerWithAnimated: (BOOL)flag completion:(void (^)(void))completion
{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:nil message:@"设备不支持拍照功能" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
//        [self presentMessageTips_:@"设备不支持拍照功能"];
        return;
    }
    UIImagePickerController *m_imagePicker = [[UIImagePickerController alloc] init];
    [m_imagePicker setDelegate:self];
    [m_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    if (self.editMode) {
        [m_imagePicker setAllowsEditing:YES];
    }
    [self presentViewController:m_imagePicker animated:flag completion:completion];
}

static NSDictionary * infoDic;


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.image"]){
            infoDic =[NSDictionary dictionaryWithDictionary:info];
            UIWindow * wiondow = [[[UIApplication  sharedApplication] windows] firstObject];
            [MBProgressHUD hideAllHUDsForView:wiondow animated:YES];
            [self dismissViewControllerAnimated:YES completion:^{                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                infoDic = [NSDictionary dictionaryWithDictionary:info];
                UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
                MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
                HUD.detailsLabelText = @"处理中...";
                [self handleCamera:info];
                [HUD hide:YES];
            }];
        }
    }
    else
    {

        [self dismissViewControllerAnimated:YES completion:^{
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            infoDic = [NSDictionary dictionaryWithDictionary:info];
            UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
            MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
            HUD.detailsLabelText = @"处理中...";
            [HUD show:YES];
            id delegate = [self getUIViewControllerCameraDelegate];
            [self handleAblumInfo:info imageblock:^(UIImage *image) {
                [HUD hide:YES];
                if (delegate && [delegate respondsToSelector:@selector(hb_imagePickerController:cameraDidFinishPickingMediaWithImage:)])
                {
                    [delegate hb_imagePickerController:self cameraDidFinishPickingMediaWithImage:image];
                }
            }];
        }];
        
    }
}

-(void)handleCamera:(NSDictionary *)info
{
    UIImage * image = [self handleCanmearInfo:info];
    id delegate = [self getUIViewControllerCameraDelegate];
    if (delegate && [delegate respondsToSelector:@selector(hb_imagePickerController:cameraDidFinishPickingMediaWithImage:)])
    {
        [delegate hb_imagePickerController:self cameraDidFinishPickingMediaWithImage:image];
    }
}
-(UIImage *)handleCanmearInfo:(NSDictionary *)info
{
    NSData *data;
    //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，
    
//    NSValue *cropRectValue =  [info objectForKey:UIImagePickerControllerCropRect];
//    CGRect cropRect = cropRectValue.CGRectValue;
    //UIImagePickerControllerOriginalImage
    UIImage *EditedImage;
    if (self.editMode) {
        EditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else
    {
         EditedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    //图片压缩，因为原图都是很大的，不必要传原图
    float scalerat = 0.5;
    UIImage *scaleImage  = [self scaleImage:EditedImage toScale:scalerat];
    //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
    if (UIImagePNGRepresentation(scaleImage) == nil) {
        //将图片转换为JPG格式的二进制数据
        data = UIImageJPEGRepresentation(scaleImage, scalerat);
//        fileName = [NSString stringWithFormat:@"ios_dz%dp_%@.jpg",2,@"ddd"];
    } else {
        //将图片转换为PNG格式的二进制数据
        data = UIImagePNGRepresentation(scaleImage);
    } //        //将二进制数据生成UIImage
    
    UIImage *image = [UIImage imageWithData:data];
    return image;
    
}


-(void)handleAblumInfo:(NSDictionary *)info imageblock:(void(^)(UIImage * image))imageblock
{
    NSURL *imageURL ;
    if (self.editMode) {
        UIImage * img  = [info objectForKey:UIImagePickerControllerEditedImage];
        imageblock(img);
        return;
    }
    else
    {
        imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    }
//    NSURL *imageURL = [info valueForKey:UIImagePickerControllerEditedImage];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        UIImage *image=[UIImage imageWithCGImage:myasset.defaultRepresentation.fullScreenImage];
//                    UIImageJPEGRepresentation(image, 0.5);
        CGImageRef iref = [representation fullResolutionImage];
//        NSString *fileName = representation.filename;
        
        imageblock(image);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (iref) {
                
            }
        });
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
  
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    
}

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
