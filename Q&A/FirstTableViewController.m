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

//@property (nonatomic, strong) NSArray *questions;

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

- (void)setQuestionDatabase:(UIManagedDocument *)questionDatabase
{
	if (_questionDatabase != questionDatabase) {
		_questionDatabase = questionDatabase;
		[self useDocument];
	}
}



- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.questionDatabase.fileURL path]]) {
        // does not exist on disk, so create it
        [self.questionDatabase saveToURL:self.questionDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
			if (success) {
				[self setupFetchedResultsController];
				JSON *myJSON = [[JSON alloc] init];
				myJSON.delegate = self;
				[myJSON getJSONDataFromURL:kURL intoDocument:self.questionDatabase];
			} else {
				NSLog(@"保存失败 at Path : %@", [self.questionDatabase.fileURL path]);
			}
            
        }];
    } else if (self.questionDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.questionDatabase openWithCompletionHandler:^(BOOL success) {
			if (success) {
				[self setupFetchedResultsController];
				JSON *myJSON = [[JSON alloc] init];
				myJSON.delegate = self;
				[myJSON getJSONDataFromURL:kURL intoDocument:self.questionDatabase];
			} else {
				NSLog(@"打开失败 at Path : %@", [self.questionDatabase.fileURL path]);
			}
            
        }];
    } else if (self.questionDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self setupFetchedResultsController];
    }
}

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"questionID" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // no predicate because we want ALL the Photographers
	
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[NSManagedObjectContext MR_contextForCurrentThread]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self setupFetchedResultsController];
	
	if (!self.questionDatabase) {  // for demo purposes, we'll create a default database if none is set
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Question Database"];
//        // url is now "<Documents Directory>/Default Photo Database"
        //self.questionDatabase = [[UIManagedDocument alloc] initWithFileURL:url]; // setter will create this for us on disk
    }
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(documentStateChanged:) 
												 name:UIDocumentStateChangedNotification 
											   object:self.questionDatabase];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.debug = YES;
}

- (void)documentStateChanged:(NSNotification *)notification
{
	NSLog(@"document state changed!");
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

- (void)viewDidUnload {
	[super viewDidUnload]; 
}

#pragma mark - JSON delegate
- (void)fetchJSONFailed
{
	NSLog(@"path:%@, context:%@", [self.questionDatabase.fileURL path], self.questionDatabase.managedObjectContext);
	NSLog(@"failed");
	NSLog(@"%@", [self.fetchedResultsController description]);
}

- (void)fetchJSONDidFinished
{
	NSLog(@"success");
	NSLog(@"%@", [self.fetchedResultsController description]);
}


@end
