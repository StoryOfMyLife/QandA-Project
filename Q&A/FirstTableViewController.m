//
//  FirstTableViewController.m
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "FirstTableViewController.h"
#import "FirstDetailTableViewController.h"
#import "JSON.h"
#import "Question.h"

@interface FirstTableViewController () <MyJSONDelegate>

@end

@implementation FirstTableViewController

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
}

- (IBAction)refresh:(id)sender
{
	JSON *myJSON = [[JSON alloc] init];
	myJSON.delegate = self;
	[myJSON getJSONDataFromURL:kURL intoDocument:nil];

	NSLog(@"refreshed!");
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.debug = NO;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(refresh:)];
	self.parentViewController.navigationItem.rightBarButtonItem = rightButton;
	self.fetchedResultsController = [Question MR_fetchAllSortedBy:@"questionID" 
                                                        ascending:YES 
                                                    withPredicate:nil
                                                          groupBy:nil
                                                         delegate:self
                                                        inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//	if ([segue.identifier isEqualToString:@"push to detail"])
//	{
//		FirstDetailTableViewController *detailView = segue.destinationViewController;
//		detailView.tableView.delegate = self;
//	}
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"first cell";
    FirstTableCell *cell = (FirstTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(FirstTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	// Configure the cell...
	Question *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
	//	NSLog(@"%@", question);
	cell.questionTitle.text = question.questionTitle;
	cell.questionID.text = question.questionID;
	cell.questionKeywords.text = question.questionKeywords;
	cell.questionAnsweredFrom.text = question.questionWhoAnswered;
	cell.questionAskedFrom.text = question.questionWhoAsked;
	cell.answerCount.text = question.answerCount;
}

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

- (void)viewDidUnload 
{
	self.fetchedResultsController = nil;
	[super viewDidUnload]; 
}

#pragma mark - JSON delegate
- (void)fetchJSONFailed
{
	NSLog(@"failed");
}

- (void)fetchJSONDidFinished
{
	NSLog(@"success");
}

@end
