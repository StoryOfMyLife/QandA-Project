//
//  FirstTableViewController.m
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#define SEGMENT_HEIGHT 45

#define kNumberOfPages 3

#import "FirstViewController.h"
#import "NewQorAViewController.h"

@interface FirstViewController () <UIScrollViewDelegate>
{
	BOOL segmentedControlUsed;
}
@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic) NSInteger lastSelectedSegmentIndex;

@property (nonatomic, strong) NSMutableArray *questionViewControllers;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.questionScrollView.pagingEnabled = YES;
    self.questionScrollView.contentSize = CGSizeMake(self.questionScrollView.frame.size.width * kNumberOfPages, self.questionScrollView.frame.size.height);
    self.questionScrollView.showsHorizontalScrollIndicator = NO;
    self.questionScrollView.showsVerticalScrollIndicator = NO;
    self.questionScrollView.scrollsToTop = NO;
    self.questionScrollView.delegate = self;
	
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < kNumberOfPages; i++) {
		[controllers addObject:[self viewControllerForSegmentIndex:i]];
	}
	self.questionViewControllers = controllers;
	
	[self loadScrollViewWithPage:0];
	[self loadScrollViewWithPage:1];
	[self loadScrollViewWithPage:2];
	
	//初始化segmentControl
	self.segmentedControl.selectedSegmentIndex = 1;
	[self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
	
	self.lastSelectedSegmentIndex = self.segmentedControl.selectedSegmentIndex;
	for (int i = 0; i < 3; i++) {
		[self.segmentedControl setImage:[UIImage imageNamed:@"clock"] forSegmentAtIndex:i];
	}
}

- (void)loadScrollViewWithPage:(NSInteger)page
{
	if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
	
	QuestionTableViewController *questionViewController = [self.questionViewControllers objectAtIndex:page];
	//这行保证tableview可以正常push
	[self addChildViewController:questionViewController];
	if (questionViewController.view.superview == nil) {
		CGRect frame = self.questionScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        questionViewController.view.frame = frame;
        [self.questionScrollView addSubview:questionViewController.view];
	}
}

- (IBAction)pageValueDidChange:(UISegmentedControl *)sender
{
	segmentedControlUsed = YES;
	NSInteger page = sender.selectedSegmentIndex;
	CGRect frame = self.questionScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
	[self.questionScrollView scrollRectToVisible:frame animated:YES];
	[self scrcollViewControllers:self.questionViewControllers enableScrollToTopAtIndex:page];
}

- (void)scrcollViewControllers:(NSArray *)scrollViewControllers enableScrollToTopAtIndex:(NSInteger)index
{
	NSUInteger count = [scrollViewControllers count];
	if (index >= count || index < 0) {
		return;
	}
	for (id vc in scrollViewControllers) {
		if ([vc isKindOfClass:[QuestionTableViewController class]]) {
			QuestionTableViewController *questionVC = (QuestionTableViewController *)vc;
			if (questionVC.flag == index) {
				questionVC.tableView.scrollsToTop = YES;
			} else {
				questionVC.tableView.scrollsToTop = NO;
			}
		}
	}
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (segmentedControlUsed) {
		return;
	}
	//页面显示在屏幕的部分超过50%，则返回当前页的page
	CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.segmentedControl.selectedSegmentIndex = page;
	[self scrcollViewControllers:self.questionViewControllers enableScrollToTopAtIndex:page];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    segmentedControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    segmentedControlUsed = NO;
}

#pragma mark - 

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setSegmentedControl:nil];
	[self setQuestionScrollView:nil];
	[self setQuestionViewControllers:nil];
	[self setCurrentViewController:nil];
	[super viewDidUnload];
}



#pragma mark - 以下是之前处理页面之间滑动的方法，现在不用了，现在改用scrollView
/*	//初始化待显示的子view,加在viewDidLoad中
	UIViewController *vc = [self viewControllerForSegmentIndex:self.segmentedControl.selectedSegmentIndex];
    [self addChildViewController:vc];
	//注意：添加手势一定要在addChildViewController后
	[self addSwipeGestureIntoView:vc.view];
	CGRect rect = CGRectMake(0, SEGMENT_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - SEGMENT_HEIGHT);
    vc.view.frame = rect;
    [self.view addSubview:vc.view];
    self.currentViewController = vc;
*/
#pragma mark - 滑动手势处理
/*
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

- (void)addSwipeGestureIntoView:(UIView *)view
{
	//添加手势滑动
	UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	[view addGestureRecognizer:recognizerLeft];
	
	UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	recognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
	[view addGestureRecognizer:recognizerRight];
}

#pragma mark - segmentedControl切换处理
//#warning 有bug，点快的时候视图会叠加
- (IBAction)didSegmentControlValueChange:(UISegmentedControl *)sender
{
	NSInteger currentSelectedSegmentIndex = sender.selectedSegmentIndex;
	UIViewController *newVC = [self viewControllerForSegmentIndex:currentSelectedSegmentIndex];
	
	[self.currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:newVC];
	[self addSwipeGestureIntoView:newVC.view];
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
	
    [self transitionFromViewController:self.currentViewController toViewController:newVC duration:0.4 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		//这里添加改变view属性的代码来产生动画
		newVC.view.center = currentSelectedSegmentIndex > _lastSelectedSegmentIndex ? lefterCenter : righterCenter;
		newVC.view.alpha = 1;
		self.currentViewController.view.alpha = 0;
		self.currentViewController.view.center = currentSelectedSegmentIndex > _lastSelectedSegmentIndex ? leftCenter : rightCenter;
    } completion:^(BOOL finished) {
		if (finished) {
			[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
				newVC.view.center = middleCenter;
			} completion:^(BOOL finished){
				if (finished) {
					self.currentViewController.view.alpha = 1;
					[self.currentViewController removeFromParentViewController];
					[newVC didMoveToParentViewController:self];
					self.currentViewController = newVC;
					self.lastSelectedSegmentIndex = currentSelectedSegmentIndex;
				}	
			}];	
		}
    }];	
}
*/

@end
