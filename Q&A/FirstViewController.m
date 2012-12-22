//
//  FirstTableViewController.m
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#define SEGMENT_HEIGHT 45

#import "FirstViewController.h"

@interface FirstViewController ()

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic) NSInteger lastSelectedSegmentIndex;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//初始化segmentControl
	self.segmentedControl.selectedSegmentIndex = 1;
	self.lastSelectedSegmentIndex = self.segmentedControl.selectedSegmentIndex;
	for (int i = 0; i < 3; i++) {
		[self.segmentedControl setImage:[UIImage imageNamed:@"clock"] forSegmentAtIndex:i];
	}
	//初始化待显示的子view
	UIViewController *vc = [self viewControllerForSegmentIndex:self.segmentedControl.selectedSegmentIndex];
    [self addChildViewController:vc];
	CGRect rect = CGRectMake(0, SEGMENT_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - SEGMENT_HEIGHT);
    vc.view.frame = rect;
    [self.view addSubview:vc.view];
    self.currentViewController = vc;
}

#pragma mark - 滑动手势处理
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{	
	CGRect rect = CGRectMake(0, SEGMENT_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - SEGMENT_HEIGHT);
	CGPoint lefterCenter = CGPointMake(rect.origin.x + rect.size.width / 2 - 20, rect.origin.y + rect.size.height / 2);
	CGPoint righterCenter = CGPointMake(rect.origin.x + rect.size.width / 2 + 20, rect.origin.y + rect.size.height / 2);
	CGPoint middleCenter = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
	
	if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
		if (self.segmentedControl.selectedSegmentIndex < 2) {
			self.segmentedControl.selectedSegmentIndex++;
			[self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
		} else if (self.segmentedControl.selectedSegmentIndex == 2) {
			[UIView animateWithDuration:0.2 animations:^{
				self.currentViewController.view.center = lefterCenter;
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.2 animations:^{
					self.currentViewController.view.center = middleCenter;
				}];
			}];
		}
	}
	if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
		if (self.segmentedControl.selectedSegmentIndex > 0) {
			self.segmentedControl.selectedSegmentIndex--;
			[self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
		} else if (self.segmentedControl.selectedSegmentIndex == 0) {
			[UIView animateWithDuration:0.2 animations:^{
				self.currentViewController.view.center = righterCenter;
			} completion:^(BOOL finished) {
				[UIView animateWithDuration:0.2 animations:^{
					self.currentViewController.view.center = middleCenter;
				}];
			}];
		}		
	}
}

#pragma mark - segmentedControl切换处理
#warning 有bug，有时候视图会叠加
- (IBAction)didSegmentControlValueChange:(UISegmentedControl *)sender
{
	NSInteger currentSelectedSegmentIndex = sender.selectedSegmentIndex;
	UIViewController *newVC = [self viewControllerForSegmentIndex:currentSelectedSegmentIndex];
	[self.currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:newVC];
	//以下是页面左右滑动切换效果的实现
	CGRect rect = CGRectMake(0, SEGMENT_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - SEGMENT_HEIGHT);
	CGPoint leftCenter = CGPointMake(rect.origin.x - rect.size.width / 2, rect.origin.y + rect.size.height / 2);
	CGPoint lefterCenter = CGPointMake(rect.origin.x + rect.size.width / 2 - 10, rect.origin.y + rect.size.height / 2);
	CGPoint rightCenter = CGPointMake(rect.size.width * 3 / 2, rect.origin.y + rect.size.height / 2);
	CGPoint righterCenter = CGPointMake(rect.origin.x + rect.size.width / 2 + 10, rect.origin.y + rect.size.height / 2);
	CGPoint middleCenter = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
	
	newVC.view.frame = rect;
	//移动view来切换
	newVC.view.center = currentSelectedSegmentIndex > _lastSelectedSegmentIndex ? rightCenter :leftCenter;
	//渐隐view来切换
	newVC.view.alpha = 0;
    [self transitionFromViewController:self.currentViewController toViewController:newVC duration:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		//这里添加改变view属性的代码来产生动画
		newVC.view.center = currentSelectedSegmentIndex > _lastSelectedSegmentIndex ? lefterCenter : righterCenter;
		newVC.view.alpha = 1;
		self.currentViewController.view.alpha = 0;
		self.currentViewController.view.center = currentSelectedSegmentIndex > _lastSelectedSegmentIndex ? leftCenter : rightCenter;
    } completion:^(BOOL finished) {
		[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			newVC.view.center = middleCenter;
		} completion:^(BOOL finished){
			self.currentViewController.view.alpha = 1;
			[self.currentViewController removeFromParentViewController];
			[newVC didMoveToParentViewController:self];
			self.currentViewController = newVC;
			self.lastSelectedSegmentIndex = currentSelectedSegmentIndex;
		}];		
    }];	
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index) {
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"first table view"];
            break;
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"second table view"];
            break;
		case 2:
			vc = [self.storyboard instantiateViewControllerWithIdentifier:@"third table view"];
		default:
			break;
    }
    return vc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setSegmentedControl:nil];
	[super viewDidUnload];
}
@end
