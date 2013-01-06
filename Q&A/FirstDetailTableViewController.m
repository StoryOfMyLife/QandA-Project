//
//  FirstDetailTableViewController.m
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "FirstDetailTableViewController.h"
#import "AnswerCell.h"
#import "QuestionDetailCell.h"
#import "Answer+Insert.h"
#import "Video+Insert.h"
#import "Question+Insert.h"

@interface FirstDetailTableViewController ()

@end

@implementation FirstDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setQuestion:(Question *)question
{
	if (_question != question) {
		_question = question;
		[self setupFetchedResultsController];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Answer"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"createTime" 
																					 ascending:NO 
																					  selector:nil]];
	request.predicate = [NSPredicate predicateWithFormat:@"toQuestion.questionID = %@", self.question.questionID];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.question.answers count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *topCellIdentifier = @"top cell";
	NSString *CellIdentifier = @"detail cell";
	if (0 == indexPath.row) {
		QuestionDetailCell *topCell = [tableView dequeueReusableCellWithIdentifier:topCellIdentifier];
		[self configureCell:topCell atIndexPath:indexPath];
		return topCell;
	} else {
		AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		[self configureCell:cell atIndexPath:indexPath];
		return cell;
	}
}

- (void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	if ([cell isKindOfClass:[QuestionDetailCell class]]) {
		QuestionDetailCell *questionDetailCell = (QuestionDetailCell *)cell;
		questionDetailCell.title.text = [questionDetailCell.title.text stringByAppendingString:self.question.title];
		questionDetailCell.author.text = [questionDetailCell.author.text stringByAppendingString:self.question.author];
		questionDetailCell.createTime.text = [questionDetailCell.createTime.text stringByAppendingString:[dateFormatter stringFromDate:self.question.createTime]];
		questionDetailCell.videoDuration.text = [questionDetailCell.videoDuration.text stringByAppendingString:self.question.questionVideo.duration];
	} else if ([cell isKindOfClass:[AnswerCell class]]) {
		AnswerCell *answerCell = (AnswerCell *)cell;
		NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
		Answer *answer = [self.fetchedResultsController objectAtIndexPath:index];
		answerCell.author.text = [answerCell.author.text stringByAppendingString:answer.author];

		answerCell.createTime.text = [answerCell.createTime.text stringByAppendingString:[dateFormatter stringFromDate:answer.createTime]];
		
		answerCell.videoDuration.text = [answerCell.videoDuration.text stringByAppendingString:answer.answerVideo.duration];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (0 == indexPath.row) {
		return 155;
	} else {
		return 80;
	}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
