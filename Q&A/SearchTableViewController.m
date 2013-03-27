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
#import "RefreshView.h"
#import "JSON.h"
#import "Defines.h"
#import "SVStatusHUD.h"
#import "UITabBarController+HideTabBar.h"
#import "LoginViewController.h"

@interface SearchTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate, MyJSONDelegate>

@property (nonatomic) CGPoint searchBarOrigin;

@property (nonatomic, strong) NSMutableArray *searchResult; //of questionID

@end

@implementation SearchTableViewController

@synthesize searchResult = _searchResult;

- (void)setSearchResult:(NSMutableArray *)searchResult
{
	if (_searchResult != searchResult) {
		_searchResult = searchResult;
		[self setupFetchedResultsController];
		[self.tableView reloadData];
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
	self.debug = NO;		
		
	//在这里不设置一下背景，应用开启后会卡死在界面，原因未知。。。
	UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg"]];
	[self.tableView setBackgroundView:tableBackgroundView];
	
//	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
//	
//	[self.navigationController.navigationItem.rightBarButtonItem setBackgroundImage:[[UIImage imageNamed:@"navbar_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 8, 14, 8)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	
		
	self.tableView.showsVerticalScrollIndicator = NO;
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
	//	[self removeFromParentViewController];
	[super viewDidUnload]; 
}


#pragma mark - JSON delegate
- (void)fetchJSONFailed
{

}

- (void)fetchJSONDidFinished
{

	
}

- (void)fetchedData:(NSArray *)array
{
	NSMutableArray *questionIDs = [NSMutableArray array];
	for (NSDictionary *question in array) {
		NSString *questionID = [question valueForKey:@"id"];
		[questionIDs addObject:questionID];
	}
	self.searchResult = questionIDs;
	[self.tableView reloadData];
}


#pragma mark - UIScrollView 

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	return YES;
}

#pragma mark - --

- (void)setupFetchedResultsController
{
	//这里会将EntityName设置为navigationBar的title
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createTime"
																					 ascending:NO 
																					  selector:nil]];
	request.predicate = [NSPredicate predicateWithFormat:@"questionID IN %@", self.searchResult];
	request.fetchLimit = 10;
	NSArray *questions = [Question MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"questionID IN %@", self.searchResult]];
	Question *q = questions[0];
	NSLog(@"%@", q);

//	if (!self.fetchedResultsController) {
//		self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
//																			managedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]
//																			  sectionNameKeyPath:nil
//																					   cacheName:nil];
//	}
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath *index = [self.tableView indexPathForCell:sender];
	Question *question = [self.fetchedResultsController objectAtIndexPath:index];
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
	Question *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
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


#pragma mark - searchbar delegate

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
	if (![self.searchBar.text isEqualToString:@""]) {
		JSON *myJSON = [[JSON alloc] init];
		myJSON.delegate = self;
		NSString *url = [kGetSearchResultURL stringByAppendingString:self.searchBar.text];
		[myJSON getJSONDataFromURL:url];
	}
	return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	return NO;
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
