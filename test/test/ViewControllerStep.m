//
//  ViewControllerStep.m
//  test
//
//  Created by NutriPhone on 11/9/14.
//  Copyright (c) 2014 EricksonLab. All rights reserved.
//

#import "ViewControllerStep.h"

@interface ViewControllerStep ()

@end

@implementation ViewControllerStep

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _cal = [[stepCalculator alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveStep:) name:STEP_COUNT_CHANGED_NOTIFICATION object:nil];
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
-(void)receiveStep:(NSNotification *)note {
    NSLog(@"Something");
}

- (IBAction)clickStep:(id)sender {
    [_cal run];
}


@end
