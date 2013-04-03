//
//  SearchTableViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 13-1-25.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "SearchTableViewController.h"
#import "AnswersTableViewController.h"
#import "Question.h"
#import "JSON.h"
#import "Defines.h"
#import "SVStatusHUD.h"
#import "UITabBarController+HideTabBar.h"
#import "LoginViewController.h"

@interface SearchTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate, MyJSONDelegate>

@property (nonatomic) CGPoint searchBarOrigin;

@property (nonatomic, strong) NSMutableArray *searchResult; //of questionID

@property (nonatomic, strong) UILabel *noResultLabel;

@property (strong, nonatomic) UIControl *searchBackgroundView;

@end

@implementation SearchTableViewController

@synthesize searchResult = _searchResult;

- (void)setSearchResult:(NSMutableArray *)searchResult
{
	self.noResultLabel.hidden = [searchResult count] == 0 ? NO : YES;
	if (_searchResult != searchResult) {
		_searchResult = searchResult;
//		[self.tableView reloadData];
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (NSMutableArray *)searchResult
{
	if (!_searchResult) {
		_searchResult = [[NSMutableArray alloc] init];
	}
	return  _searchResult;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];	
		
	//在这里不设置一下背景，应用开启后会卡死在界面，原因未知。。。
	UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg"]];
	[self.tableView setBackgroundView:tableBackgroundView];
	self.tableView.showsVerticalScrollIndicator = NO;
//	CGRect tableFrame = self.tableView.frame;
//	CGRect searchBarFrame = self.searchBar.frame;
//	tableFrame.origin.y += 8;
//	tableFrame.size.height -= 8;
	self.searchBarOrigin = self.searchBar.frame.origin;
	
	self.noResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, 220, 50)];
	self.noResultLabel.textAlignment = UITextAlignmentCenter;
	self.noResultLabel.hidden = YES;
	self.noResultLabel.backgroundColor = [UIColor clearColor];
	self.noResultLabel.text = @"抱歉,没有找到结果!";
	
	[self.view addSubview:self.noResultLabel];
	
	CGRect frame = self.view.frame;
	frame.origin.y += self.searchBar.frame.size.height / 2;
	self.searchBackgroundView = [[UIControl alloc] initWithFrame:frame];
	self.searchBackgroundView.alpha = 0;
	self.searchBackgroundView.backgroundColor = [UIColor blackColor];
	[self.searchBackgroundView addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
	NSLog(@"Search view did receive memory warning!");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload 
{
	self.noResultLabel = nil;
	self.searchResult = nil;
	[self.searchBackgroundView removeTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchDown];
	self.searchBackgroundView = nil;
	[super viewDidUnload]; 
}

- (void)fetchedData:(NSArray *)array
{
	NSMutableArray *questions = [NSMutableArray array];
	for (NSDictionary *question in array) {
		NSString *questionID = [question valueForKey:@"id"];
		NSArray *result = [Question MR_findByAttribute:@"questionID" withValue:questionID];
		if ([result count] == 1) {
			[questions addObject:result[0]];
		}
	}
	self.searchResult = questions;
}

- (void)searchWithKeywords:(NSString *)keyword
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS %@", keyword];
	NSArray *result = [Question MR_findAllWithPredicate:predicate];
	NSMutableArray *questions = [NSMutableArray arrayWithArray:result];
	self.searchResult = questions;
}



#pragma mark - UIScrollView 

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGSize searchSize = self.searchBar.frame.size;
	self.searchBar.frame = CGRectMake(self.searchBarOrigin.x, self.searchBarOrigin.y + scrollView.contentOffset.y, searchSize.width, searchSize.height);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	Question *question = (Question *)self.searchResult[indexPath.row];
	if ([segue.identifier isEqualToString:@"push to detail"])
	{
		AnswersTableViewController *detailView = segue.destinationViewController;
		detailView.question = question;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"first cell";
    QuestionCell *cell = (QuestionCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
	Question *question = (Question *)self.searchResult[indexPath.row];
	cell.questionTitle.text = question.title;
	cell.questionID.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
	cell.questionKeywords.text = question.tags;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *createDate = [dateFormatter stringFromDate:question.createTime];
	cell.questionAskedFrom.text = [NSString stringWithFormat:@"提问者: %@  %@", question.author, createDate];
	
	NSString *answerDate = [dateFormatter stringFromDate:question.answerTime];
	cell.questionAnsweredFrom.text = [NSString stringWithFormat:@"回答者: %@  %@", question.lastAnswerAuthor, answerDate];
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

#pragma mark - Table view datasource
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.searchResult count];
}

#pragma mark - searchbar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[UIView animateWithDuration:0.2 animations:^{
		self.searchBackgroundView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[self.searchBackgroundView removeFromSuperview];
	}];
	[searchBar setShowsCancelButton:NO animated:YES];
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//	if (![self.searchBar.text isEqualToString:@""]) {
//		JSON *myJSON = [[JSON alloc] init];
//		myJSON.delegate = self;
//		NSString *url = [kGetSearchResultURL stringByAppendingString:self.searchBar.text];
//		[myJSON getJSONDataFromURL:url];
//	}
	[self removeSearchBackgroundView];
	
	[self searchWithKeywords:searchBar.text];

	[searchBar setShowsCancelButton:NO animated:YES];
		[self.navigationController setNavigationBarHidden:NO animated:YES];
	[searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	[self addSearchBackgroundView];
	self.noResultLabel.hidden = YES;
	[searchBar setShowsCancelButton:YES animated:YES];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	return YES;
}

- (IBAction)cancelSearch:(id)sender
{
	[self removeSearchBackgroundView];
	[self.searchBar resignFirstResponder];
	[self.searchBar setShowsCancelButton:NO animated:YES];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)addSearchBackgroundView
{
	[self.view addSubview:self.searchBackgroundView];
	[UIView animateWithDuration:0.2 animations:^{
		self.searchBackgroundView.alpha = 0.8;
	} completion:^(BOOL finished) {
		[self.tableView setScrollEnabled:NO];
	}];
}

- (void)removeSearchBackgroundView
{
	[UIView animateWithDuration:0.2 animations:^{
		self.searchBackgroundView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[self.searchBackgroundView removeFromSuperview];
		[self.tableView setScrollEnabled:YES];
	}];
}
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//	for (id cancelButton in [searchBar subviews]) {
//		if ([cancelButton isKindOfClass:[UINavigationButton class]]) {
//			NSLog(@"%@", cancelButton);
//		}
//		NSLog(@"%@", cancelButton);
//		//		[cancelButton setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//		//		[cancelButton setBackgroundImage:nil forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//	}
//}

@end
