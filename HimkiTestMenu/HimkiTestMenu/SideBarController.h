//
//  CDSideBarController.h
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideBarControllerDelegate <NSObject>

- (void)menuButtonClicked:(int)index;

@end




@interface SideBarController : NSObject

    @property (nonatomic, retain) UIColor *backgroundColor;
    @property (nonatomic, retain) UIImage *menuImage;
    @property (nonatomic) BOOL isOpen;
    @property (nonatomic) CGRect frame;



    @property (nonatomic, retain) id<SideBarControllerDelegate> delegate;

- (SideBarController*)initWithImages:(NSArray*)images MenuImage:(UIImage*)menuImage;
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position Size:(CGSize)size;

@end
