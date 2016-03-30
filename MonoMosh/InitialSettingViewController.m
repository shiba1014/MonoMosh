//
//  InitalSettingViewController.m
//  MonoMosh
//
//  Created by Paul McCartney on 2016/03/16.
//  Copyright © 2016年 嶋本夏海. All rights reserved.
//

#import "InitialSettingViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>
#import <PFFacebookUtils.h>
#import "MMDatePickerView.h"
#import "MBProgressHUD.h"

@interface InitialSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIImageView *profileImageView;
    IBOutlet UITableView *tableView;
    NSString *username,*bdStr;
    NSDateFormatter *df;
    UILabel *bdLabel;
    UITextField *tf;
    MMDatePickerView *DPV;
}

-(IBAction)create:(id)sender;

@end

@implementation InitialSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd"];
    
    [self loadData];
    [self setDatePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if(indexPath.row == 0)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"username";
        if(!tf){
            tf = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, tableView.frame.size.width-100, 44)];
            tf.delegate = self;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:tf];
        }
        tf.text = username;
        
    }else{
        cell.textLabel.text = @"birth day";
        if (!bdLabel) {
            bdLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, tableView.frame.size.width-100, 44)];
            bdLabel.text = bdStr;
            [cell.contentView addSubview:bdLabel];
        }
    }
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        [tv deselectRowAtIndexPath:indexPath animated:YES];
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            DPV.frame = CGRectMake(0, self.view.bounds.size.height - 200, self.view.bounds.size.width, 200);
        } completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)loadData {

    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            username = userData[@"name"];
            [tableView reloadData];
            
//            NSString *location = userData[@"location"][@"name"];
//            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];
            NSLog(@"BD %@",birthday);
//            NSString *relationship = userData[@"relationship_status"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            
            // Run network request asynchronously
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:
             ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (
                     connectionError == nil && data != nil) {
                     // Set the image in the imageView
                     UIImage *profileImage = [[UIImage alloc] initWithData:data];
                     profileImageView.image = profileImage;
                 }
             }];
        }else{
            NSLog(@"Error:%@",error);
        }
    }];
}

-(void)loadFriends{

    FBSDKGraphRequest *req = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends?limit=5000&fields=picture,name,id" parameters:nil];
    [req startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(error){
            NSLog(@"%@",error);
        }else{
            NSDictionary *friendsData = (NSDictionary *)result;
            NSArray *data = friendsData[@"data"];
            NSLog(@"friends == %@",data);
        }
    }];
}

-(IBAction)create:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFUser *currentUser = [PFUser currentUser];
    NSData *imageData = UIImagePNGRepresentation(profileImageView.image);
    PFFile *imageFile = [PFFile fileWithName:@"profileImage.png" data:imageData];
    currentUser[@"profileImageFile"] = imageFile;
    currentUser[@"usernameForUser"] = username;
    currentUser[@"birthDay"] = DPV.datePicker.date;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(succeeded){
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSLog(@"saveError:%@",error);
        }
    }];
}

-(void)setDatePicker{
    DPV = [MMDatePickerView view];
    DPV.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200);
    DPV.datePicker.maximumDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    dc.year = -100;
    NSDate *minDate = [calendar dateByAddingComponents:dc toDate:[NSDate date] options:0];
    DPV.datePicker.minimumDate = minDate;
    
    dc.year = -20;
    NSDate *defaultDate = [calendar dateByAddingComponents:dc toDate:[NSDate date] options:0];
    DPV.datePicker.date = defaultDate;
    
    bdStr = [df stringFromDate:DPV.datePicker.date];
    
    [DPV.doneButton addTarget:self action:@selector(tappedDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DPV];
}

-(void)tappedDone{
    NSLog(@"done");
    NSLog(@"date %@",DPV.datePicker.date);
    bdLabel.text = [df stringFromDate:DPV.datePicker.date];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        DPV.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200);
    } completion:nil];
}

@end
