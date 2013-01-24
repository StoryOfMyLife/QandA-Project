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

@interface QuestionTableViewController () <UIScrollViewDelegate>

@end

@implementation QuestionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//	self.parentViewController.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
//	self.parentViewController.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.debug = NO;		
	[self setupFetchedResultsController];	
	
	//在这里不设置一下背景，应用开启后会卡死在界面，原因未知。。。
	UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableView_bg"]];
	[self.tableView setBackgroundView:tableBackgroundView];
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createTime"
																					 ascending:NO 
																					  selector:nil]];
	request.fetchLimit = 10;
	if (self.flag == 2) {
		request.predicate = [NSPredicate predicateWithFormat:@"answerCount = 0"];
	} else if (self.flag == 0) {
		request.predicate = [NSPredicate predicateWithFormat:@"answerCount > 0"];
	}
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"first cell";
    QuestionCell *cell = (QuestionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(QuestionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	// Configure the cell...
	Question *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
	//	NSLog(@"%@", question);
	cell.questionTitle.text = question.title;
	cell.questionID.text = [NSString stringWithFormat:@"%d", indexPath.row];
	cell.questionKeywords.text = question.tags;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *createDate = [dateFormatter stringFromDate:question.createTime];
	cell.questionAskedFrom.text = [NSString stringWithFormat:@"提问者：%@ %@", question.author, createDate];
	
	NSString *answerDate = [dateFormatter stringFromDate:question.answerTime];
	cell.questionAnsweredFrom.text = [NSString stringWithFormat:@"回答者：%@ %@", question.lastAnswerAuthor, answerDate];
	cell.answerCount.text = [NSString stringWithFormat:@"%d", [question.answerCount intValue]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        Question *selectedPerson  = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        // Remove the person
        [selectedPerson MR_deleteInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        
        [[NSManagedObjectContext MR_contextForCurrentThread] MR_save];		
    }
}

- (void)viewDidUnload 
{
	self.fetchedResultsController = nil;
	[self removeFromParentViewController];
	[super viewDidUnload]; 
}

@end
