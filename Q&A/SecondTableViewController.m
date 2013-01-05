//
//  SecondTableViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 12-12-24.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "SecondTableViewController.h"
#import "FirstDetailTableViewController.h"
#import "JSON.h"
#import "Question.h"
#import "SVStatusHUD.h"

@interface SecondTableViewController () <MyJSONDelegate>

@end

@implementation SecondTableViewController


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
//	self.parentViewController.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.debug = NO;
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
	self.parentViewController.navigationItem.rightBarButtonItem = rightButton;
	
	[self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"questionID" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
	request.predicate = [NSPredicate predicateWithFormat:@"%K like %@", @"answerCount", @"(0)"];
	request.fetchLimit = 10;

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
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
	cell.questionID.text = question.questionID;
	cell.questionKeywords.text = question.tags;
	cell.questionAnsweredFrom.text = question.lastAnswerAuthor;
	cell.questionAskedFrom.text = question.author;
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
	dispatch_async(dispatch_get_main_queue(), ^{
		[SVStatusHUD showWithImage:[UIImage imageNamed:@"wifi_"] withString1:@"加载失败" string2:@"请检查连接!" duration:1];
	});	
}

- (void)fetchJSONDidFinished
{
	NSLog(@"success");
}

@end
