//
//  FirstTableViewController.m
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "QuestionTableViewController.h"
#import "AnswersTableViewController.h"
#import "Question.h"
#import "RefreshView.h"
#import "JSON.h"
#import "Defines.h"
#import "SVStatusHUD.h"
#import "UITabBarController+HideTabBar.h"
#import "LoginViewController.h"

@interface QuestionTableViewController () <UIScrollViewDelegate, MyJSONDelegate, RefreshViewDelegate>

@property (strong, nonatomic) RefreshView *refreshView;

@property (nonatomic) CGPoint currentScrollOffset;

@property (nonatomic, strong) NSArray *questions;

@end

@implementation QuestionTableViewController

- (void)setPredicate:(NSPredicate *)predicate
{
	if (_predicate != predicate) {
		_predicate = predicate;
	}
	self.questions = [Question MR_findAllSortedBy:@"createTime" ascending:NO withPredicate:_predicate];
}

- (void)setQuestions:(NSArray *)questions
{
	if (_questions != questions) {
		_questions = questions;
		[self.tableView reloadData];
	}
}

- (void)setRefreshView:(RefreshView *)refreshView
{
	if (_refreshView != refreshView) {
		_refreshView = refreshView;
		[_refreshView setupWithOwner:self.tableView delegate:self];
	}
}

#pragma mark - view life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//加载下拉刷新view
	NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"RefreshView" owner:self options:nil];
    self.refreshView = [nibs objectAtIndex:0];
	
	//在这里不设置一下背景，应用开启后会卡死在界面，原因未知。。。
	[self.tableView setBackgroundView:nil];
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	self.currentScrollOffset = self.tableView.contentOffset;
	
	self.tableView.showsVerticalScrollIndicator = NO;
//	[self refresh];
}

- (void)didReceiveMemoryWarning
{
	NSLog(@"QustionTableView did receive memory warning!");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload 
{
//	self.fetchedResultsController = nil;
	self.refreshView = nil;
	//	[self removeFromParentViewController];
	[super viewDidUnload]; 
}

#pragma mark - MyJSONDelegate
- (void)fetchJSONFailed
{
	NSLog(@"获取JSON数据失败!");
	dispatch_async(dispatch_get_main_queue(), ^{
		[self refreshFailed];
		[SVStatusHUD showWithImage:[UIImage imageNamed:@"wifi_"] withString1:@"加载失败" string2:@"请检查连接!" duration:1];
	});	
}

- (void)fetchJSONDidFinished
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSLog(@"获取JSON数据成功");
		self.questions = [Question MR_findAllSortedBy:@"createTime" ascending:NO withPredicate:self.predicate];
		[self refreshFinished];
	});		
}
#pragma mark - RefreshView method

- (void)refreshViewDidCallBack {
    [self refresh];
}
// 刷新
- (void)refresh 
{
	Account *account = [Account sharedAcount];
	if (account.isloginedIn) {
		[self.refreshView startLoading];
		JSON *myJSON = [[JSON alloc] init];
		myJSON.delegate = self;
		NSString *url = [kGetQuestionURL stringByAppendingString:account.accessToken];
		[myJSON getJSONDataFromURL:url
						   success:nil 
						   failure:nil];
	} else {
		LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"login view"];
		[self presentViewController:loginView animated:YES completion:NULL];
	}
}

- (void)refreshFailed
{
	[self.refreshView stopLoading];
}

- (void)refreshFinished
{
	[self.refreshView finishLoading];
	[self.tableView reloadData];
}

#pragma mark - UIScrollView 
// 刚拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshView scrollViewWillBeginDragging:scrollView];
}
// 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshView scrollViewDidScroll:scrollView];
	
	if (scrollView.dragging) {
		//只有内容超过屏幕大小时，才启动tabbar隐藏
		if (scrollView.contentSize.height > scrollView.frame.size.height) {
			if (scrollView.contentOffset.y > self.currentScrollOffset.y &&
				scrollView.contentOffset.y > 0) {
				scrollView.superview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//				[self makeTabbarHidden:YES animated:YES];
				[self.tabBarController makeTabbarInvisible:YES animated:YES];
			} else if (scrollView.contentOffset.y < self.currentScrollOffset.y &&
					   scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.size.height) {
//				[self makeTabbarHidden:NO animated:YES];
				[self.tabBarController makeTabbarInvisible:NO animated:YES];
			}
			self.currentScrollOffset = scrollView.contentOffset;
		}
	}	
}

// 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	return YES;
}

#pragma mark - UITableView delegate
- (IBAction)swipeBack:(id)sender
{
//	NSLog(@"%@", [[self.navigationController viewControllers] description]);
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	Question *question = self.questions[indexPath.row];
	if ([segue.identifier isEqualToString:@"push to detail"])
	{
		AnswersTableViewController *detailView = segue.destinationViewController;
		detailView.question = question;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.questions count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"first cell";
    QuestionCell *cell = (QuestionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	UIImageView *tablecellBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablecell_bg"]];
	[cell setBackgroundView:tablecellBackgroundView];
	
	UIImageView *tablecellSelectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tablecell_selected_bg"]];
	[cell setSelectedBackgroundView:tablecellSelectedBackgroundView];
	
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(QuestionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	// Configure the cell...
	Question *question = self.questions[indexPath.row];
	cell.questionTitle.text = question.title;
	cell.questionID.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
	cell.questionKeywords.text = [question.tags isEqualToString:@"【】"] ? nil : question.tags;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *createDate = [dateFormatter stringFromDate:question.createTime];
	cell.questionAskedFrom.text = [NSString stringWithFormat:@"提问: %@  %@", question.author, createDate];
	
	NSString *answerDate = [dateFormatter stringFromDate:question.answerTime];
	cell.questionAnsweredFrom.text = [NSString stringWithFormat:@"最后回答: %@  %@", question.lastAnswerAuthor, answerDate];
	cell.answerCount.text = [NSString stringWithFormat:@"回复: %d", [question.answerCount intValue]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}

@end
