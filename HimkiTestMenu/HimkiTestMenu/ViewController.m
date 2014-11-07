//
//  ViewController.m
//  HimkiTestMenu
//
//  Created by Суворов Юрий on 07.11.14.
//  Copyright (c) 2014 Devar OOO. All rights reserved.
//

#import "ViewController.h"

#import "SideBarController.h"
#import "Social/Social.h"

#import "testView.h"


#define HOME_URL @"http://himki.center"


@interface ViewController () <SideBarControllerDelegate, UIPopoverControllerDelegate>

@property testView *testView;
@property SideBarController *sideBar;

@end

@implementation ViewController
{
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testView = [[testView alloc] init];
    self.delegate = self.testView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureMenu];
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.sideBar insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(size.width - 70, (size.height/2) - 25) Size:size];
}





- (void)configureMenu
{
    NSArray *imageList = @[[UIImage imageNamed:@"snapshot.png"],
                           [UIImage imageNamed:@"facebook.png"],
                           [UIImage imageNamed:@"twitter.png"],
                           [UIImage imageNamed:@"web.png"],
                           [UIImage imageNamed:@"information.png"]];
    self.sideBar = [[SideBarController alloc] initWithImages:imageList MenuImage:[UIImage imageNamed:@"menu.png"]];
    self.sideBar.delegate = self;
    
    [self.sideBar insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(self.view.frame.size.width - 70, (self.view.frame.size.height/2) - 25) Size:self.view.frame.size];
    self.sideBar.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2f];
}


- (void) onCompliteSaveImage:(UIImage *)image didFinishSavingWithError:(NSError *)error ContextInfo:(void *)contextInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Сохранение" message:@"Выполнено" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}






#pragma mark -
#pragma mark - SideBarController delegate

- (void)menuButtonClicked:(int)index
{
    switch (index) {
        case 0:
        {
            UIImage *image = [self.delegate snapshot];
            if (image != nil)
            {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(onCompliteSaveImage:didFinishSavingWithError:ContextInfo:), nil);
            }
            break;
        }
        case 1:
        {
            UIImage *image = [self.delegate snapshot];
            if (image != nil)
            {
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
                {
                    SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                    
                    [facebookSheet setInitialText:@""];
                    [facebookSheet addImage:image];
                    [facebookSheet addURL:[NSURL URLWithString:HOME_URL]];
                    [self presentViewController:facebookSheet animated:YES completion:nil];
                }
            }
            break;
        }
        case 2:
        {
            UIImage *image = [self.delegate snapshot];
            if (image != nil)
            {
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                {
                    SLComposeViewController *twitSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                    
                    [twitSheet setInitialText:@""];
                    [twitSheet addImage:image];
                    [twitSheet addURL:[NSURL URLWithString:HOME_URL]];
                    [self presentViewController:twitSheet animated:YES completion:nil];
                }
            }
            break;
        }
        case 3:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:HOME_URL]];
            break;
        }
        case 4:
        {
            UIViewController* content = [[UIViewController alloc] init];
            content.view.frame = CGRectMake(0, 0, 320., 400.);
            
            UIPopoverController* aPopover = [[UIPopoverController alloc]
                                             initWithContentViewController:content];
            aPopover.delegate = self;
            
            [aPopover presentPopoverFromRect:self.sideBar.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
        }
        default:
            break;
    }
}





@end
