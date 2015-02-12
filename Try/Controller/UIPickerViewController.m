//
//  UIPickerViewController.m
//  Try
//
//  Created by Zhuoran Li on 1/16/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

#import "UIPickerViewController.h"

@interface UIPickerViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) NSArray *foods;

@property (strong, nonatomic) IBOutlet UITextField *tf_fruit;
@property (strong, nonatomic) IBOutlet UITextField *tf_maindish;
@property (strong, nonatomic) IBOutlet UITextField *tf_drink;
@property (strong, nonatomic) IBOutlet UITextField *tf_time;

@property (strong, nonatomic) UIPickerView *foodPicker;
@property (strong, nonatomic) UIDatePicker *dataPicker;


@end

@implementation UIPickerViewController

-(void)viewDidLoad{
    _foodPicker = [[UIPickerView alloc] init];
    _foodPicker.dataSource = self;
    _foodPicker.delegate = self;
    
    self.tf_fruit.inputView = _foodPicker;
    self.tf_maindish.inputView = _foodPicker;
    self.tf_drink.inputView = _foodPicker;
    
    UIToolbar *foodToolBar = [[UIToolbar alloc] init];
    foodToolBar.barTintColor = [UIColor grayColor];
    foodToolBar.frame = CGRectMake(0,0,self.view.frame.size.width,40);
    UIBarButtonItem *randomButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Random"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(randomPicker)];
    [randomButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneClick)];
    [doneButton setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    foodToolBar.items = @[randomButton, spaceButton, doneButton];
    self.tf_fruit.inputAccessoryView = foodToolBar;
    self.tf_maindish.inputAccessoryView = foodToolBar;
    self.tf_drink.inputAccessoryView = foodToolBar;
    
    
    _dataPicker = [[UIDatePicker alloc] init];
    _dataPicker.datePickerMode = UIDatePickerModeDate;
    _dataPicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    UIToolbar *dateToolBar = [[UIToolbar alloc] init];
    dateToolBar.barTintColor = [UIColor grayColor];
    dateToolBar.frame = CGRectMake(0,0,self.view.frame.size.width,40);
    UIBarButtonItem *doneButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(datedoneClick)];
    [doneButton1 setTintColor:[UIColor whiteColor]];
    dateToolBar.items = @[spaceButton, doneButton1];
    self.tf_time.inputView = _dataPicker;
    self.tf_time.inputAccessoryView = dateToolBar;
    
    [super viewDidLoad];

}

-(void)randomPicker{
    for (int i = 0; i < self.foods.count; i++) {
        int row = arc4random() % [self.foods[i] count];
        [self.foodPicker selectRow:row inComponent:i animated:YES];
        [self pickerView:nil didSelectRow:row inComponent:i];
    }
}

-(void)doneClick{
    [self.view endEditing:YES];
    for (int i = 0; i < self.foods.count; i++) {
        [self pickerView:nil didSelectRow:[self.foodPicker selectedRowInComponent:i] inComponent:i];
    }
}

-(void)datedoneClick{
    [self.view endEditing:YES];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-DD"];
    NSString *newDate = [formatter stringFromDate:self.dataPicker.date];
    self.tf_time.text = [NSString stringWithFormat:@"%@", newDate];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.foods.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.foods[component] count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.foods[component][row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.tf_fruit.text = self.foods[component][row];
    }else if (component == 1){
        self.tf_maindish.text = self.foods[component][row];
    }else{
        self.tf_drink.text = self.foods[component][row];
    }
}

-(NSArray *)foods{
    if (_foods == nil) {
        _foods = @[@[@"f",@"r",@"u",@"i",@"t"], @[@"m",@"a",@"i",@"n"], @[@"d",@"r",@"i",@"n",@"k"]];
    }
    return _foods;
}

@end




















