//
//  DatePickerViewController.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/03/16.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "DatePickerViewController.h"

@protocol DatePickerViewControllerDelegate;

@interface DatePickerViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) id<DatePickerViewControllerDelegate> delegate;

-(IBAction)closePickerView:(id)sender;

@end

@protocol DatePickerViewControllerDelegate <NSObject>

-(void)applySelectedString:(NSDate *)str;
-(void)closePickerView:(DatePickerViewController *)controller;

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.datePicker.maximumDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *date = [[NSDateComponents alloc]init];
    date.year = -100;
    NSDate *minDate = [calendar dateByAddingComponents:date toDate:[NSDate date] options:0];
    self.datePicker.minimumDate = minDate;
    
    date.year = -20;
    NSDate *selectedDate = [calendar dateByAddingComponents:date toDate:[NSDate date] options:0];
    self.datePicker.date = selectedDate;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closePickerView:(id)sender{
     // デリゲート先の処理を呼び出し、選択された文字列を親Viewに表示させる
    [self.delegate applySelectedString:_datePicker.date];
    
    // datePickerを閉じるための処理を呼び出す
    [self.delegate closePickerView:self];
    
}

@end
