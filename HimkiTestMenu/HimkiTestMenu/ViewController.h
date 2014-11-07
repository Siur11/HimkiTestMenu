//
//  ViewController.h
//  HimkiTestMenu
//
//  Created by Суворов Юрий on 07.11.14.
//  Copyright (c) 2014 Devar OOO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SnapshotAppDelegate <NSObject>

- (UIImage *)snapshot;

@end


@interface ViewController : UIViewController

@property (nonatomic, retain) id<SnapshotAppDelegate> delegate;

@end
