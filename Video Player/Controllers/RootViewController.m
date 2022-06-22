//
//  RootViewController.m
//  Video Player
//
//  Created by Vu Huy on 22/06/2022.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Where is the Movie Server?" message:@"Please enter the server URL to continue." preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"URL"];
        [textField setReturnKeyType:UIReturnKeyNext];
        [textField setKeyboardType:UIKeyboardTypeURL];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *fields = alert.textFields;
        
        if (fields.count < 1) {
            return;
        }
        
        UITextField *urlField = fields[0];
        
        if ([urlField isEqual:@""]) {
            return;
        }
        
        Config *config = [Config getInstance];
        config.baseURL = [NSString stringWithFormat:@"http://%@", urlField.text];
        
        ListViewController *listVC = [[ListViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:listVC];
        navigationController.title = @"My Movie";
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:navigationController animated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
