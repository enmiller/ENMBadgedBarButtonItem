//
//  MasterViewController.m
//  TestBadge
//
//  Created by Eric Miller on 5/21/14.
//  Copyright (c) 2014 Frozen Panda. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "ENMBadgedBarButtonItem.h"

static NSInteger count = 0;

@interface MasterViewController ()

@property (nonatomic, strong) ENMBadgedBarButtonItem *navButton;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Build your regular UIBarButtonItem with Custom View
    UIImage *image = [UIImage imageNamed:@"barbuttonimage"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,image.size.width, image.size.height);
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:image forState:UIControlStateNormal];
  
    self.navButton = [[ENMBadgedBarButtonItem alloc] initWithCustomView:button];
    self.navButton.badgeValue = @"0";
    self.navigationItem.leftBarButtonItem = self.navButton;
  
}

- (void)insertNewObject:(id)sender {
    count = 0;
    self.navButton.badgeValue = [NSString stringWithFormat:@"%zd", count];
}

#pragma mark - Private
- (void)buttonPress:(id)sender {
    count++;
    self.navButton.badgeValue = [NSString stringWithFormat:@"%zd", count];
}

@end
