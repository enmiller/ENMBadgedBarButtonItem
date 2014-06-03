//
//  DetailViewController.h
//  TestBadge
//
//
//  Created by Eric Miller on 5/21/14.
//  Copyright (c) 2014 Frozen Panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
