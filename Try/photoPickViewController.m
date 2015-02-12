//
//  photoPickViewController.m
//  Try
//
//  Created by Zhuoran Li on 12/10/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

#import "photoPickViewController.h"

@interface photoPickViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation photoPickViewController

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self showSelectPhotoFromSourceActionSheet];
}


-(void)showSelectPhotoFromSourceActionSheet{
    UIActionSheet *selectPhotoSourceActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select the Photo Source"
                                                                              delegate:self
                                                                     cancelButtonTitle:@"Canael"
                                                                destructiveButtonTitle:nil
                                                                     otherButtonTitles:@"From Album", @"From Camera", nil];
    [selectPhotoSourceActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self photoFromAlbum:nil];
    }else if (buttonIndex == 1){
        [self photoFromCamera:nil];
    }
}

-(IBAction)photoFromAlbum:(id)sender{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerController.sourceType];
    }
    pickerController.delegate = self;
    pickerController.allowsEditing = NO;
    [self presentViewController:pickerController animated:YES completion:^{
        
    }];
}

- (IBAction)photoFromCamera:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.allowsEditing = NO;
        pickerController.sourceType = sourceType;
        //UIView *ovarLayView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, 320, 254)];
        pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [self presentViewController:pickerController animated:YES completion:^{
        }];
    }else{
        NSLog(@"No camera");
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
