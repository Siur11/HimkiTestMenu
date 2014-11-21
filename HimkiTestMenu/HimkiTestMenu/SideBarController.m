//
//  CDSideBarController.m
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import "SideBarController.h"


#define SECONDS_FOR_CLOSE 15


@interface SideBarController()

@property UIView *backgroundMenuView;
@property UIButton *menuButton;
@property NSMutableArray *buttonList;

@end


@implementation SideBarController



#pragma mark - 
#pragma mark Init


//----------------------------------------------------------------------------------------------------------------------------------
- (instancetype)initWithImages:(NSArray*)images MenuImage:(UIImage*)menuImage
{
    self = [super init];
    if (self) {
        self.menuImage = menuImage;
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.frame = CGRectMake(0, 0, 40, 40);
        self.menuButton.frame = CGRectMake(0, 0, 40, 40);
        [self.menuButton setImage:self.menuImage forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
        self.backgroundMenuView = [[UIView alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        self.buttonList = [[NSMutableArray alloc] initWithCapacity:images.count];
    
        int index = 0;
        for (UIImage *image in [images copy])
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:image forState:UIControlStateNormal];
            button.frame = CGRectMake(20, 50 + (80 * index), 50, 50);
            button.tag = index;
            [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonList addObject:button];
            ++index;
        }
    }
    return self;
}


//----------------------------------------------------------------------------------------------------------------------------------
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position Size:(CGSize)size
{
    [self dismissMenu];

    self.frame = CGRectMake(position.x, position.y, self.menuButton.frame.size.width, self.menuButton.frame.size.height);

    self.menuButton.frame = CGRectMake(position.x, position.y, self.menuButton.frame.size.width, self.menuButton.frame.size.height);
    [view addSubview:self.menuButton];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [view addGestureRecognizer:singleTap];
    
    for (UIButton *button in self.buttonList)
    {
        [self.backgroundMenuView addSubview:button];
    }

    self.backgroundMenuView.frame = CGRectMake(size.width, 0, 90, size.height);
    self.backgroundMenuView.backgroundColor = self.backgroundColor;
    [view addSubview:self.backgroundMenuView];
}


#pragma mark - 
#pragma mark Menu button action

- (void)dismissMenuWithSelection:(UIButton*)button
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                         [self dismissMenu];
                     }];
}


- (void)dismissMenu
{
    if (self.isOpen)
    {
        self.isOpen = !self.isOpen;
       [self performDismissAnimation];
    }
}


- (void)showMenu
{
    if (!self.isOpen)
    {
        self.isOpen = !self.isOpen;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, SECONDS_FOR_CLOSE * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self dismissMenu];
        });
    }
}


- (void)onMenuButtonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(menuButtonClicked:)])
        [self.delegate menuButtonClicked:(int)button.tag];
    [self dismissMenuWithSelection:button];
}




#pragma mark -
#pragma mark - Animations

- (void)performDismissAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        self.menuButton.alpha = 1.0f;
        self.menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        self.backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
}



- (void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            self.menuButton.alpha = 0.0f;
            self.menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
            self.backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
        }];
    });
    for (UIButton *button in self.buttonList)
    {
        [NSThread sleepForTimeInterval:0.02f];
        dispatch_async(dispatch_get_main_queue(), ^{
            button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                 usingSpringWithDamping:.3f
                  initialSpringVelocity:10.f
                                options:0 animations:^{
                                    button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                                }
                             completion:^(BOOL finished) {
                             }];
        });
    }
}


-(void)setMenuImage:(UIImage *)menuImage
{
    _menuImage = menuImage;
    [self.menuButton setImage:self.menuImage forState:UIControlStateNormal];
}


-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.backgroundMenuView.backgroundColor = self.backgroundColor;
}

@end
