//
//  ViewController.m
//  DemoLocalization
//
//  Created by HoangToan on 11/10/15.
//  Copyright © 2015 AirFile. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.label.text = NSLocalizedString(@"Hello", @"Text for Label");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
