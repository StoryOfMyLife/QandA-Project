//
//  PageViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 13-1-31.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "PageViewController.h"
#import "QuestionTableViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
	self.pageViewController.delegate = self;
	
	[self.pageViewController setViewControllers:@[[self viewControllerForSegmentIndex:0], [self viewControllerForSegmentIndex:1], [self viewControllerForSegmentIndex:2]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
	
	[self addChildViewController:self.pageViewController];
	[self.view addSubview:self.pageViewController.view];
	
	// Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
	CGRect pageViewRect = self.view.bounds;
	self.pageViewController.view.frame = pageViewRect;
	
	[self.pageViewController didMoveToParentViewController:self];
	
	// Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
	self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	// Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
	UIViewController *currentViewController = self.pageViewController.viewControllers[0];
	NSArray *viewControllers = @[currentViewController];
	[self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
	
	self.pageViewController.doubleSided = NO;
	return UIPageViewControllerSpineLocationMin;
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    QuestionTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"first table view"];
    switch (index) {
        case 0:
            vc.flag = 0;
            break;
        case 1:
            vc.flag = 1;
            break;
		case 2:
			vc.flag = 2;
		default:
			break;
    }
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(QuestionTableViewController *)vc
{
    NSUInteger index = vc.flag;
    return [self viewControllerForSegmentIndex:(index - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(QuestionTableViewController *)vc
{
    NSUInteger index = vc.flag;
    return [self viewControllerForSegmentIndex:(index + 1)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
