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
#import "Defines.h"

@interface FirstDetailTableViewController ()

@property (nonatomic, strong) MPMoviePlayerViewController *movieView;

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *videoID;
	if (indexPath.row == 0) {
		videoID = self.question.questionVideo.videoID;
	} else {
		NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
		Answer *answer = [self.fetchedResultsController objectAtIndexPath:index];
		videoID = answer.answerVideo.videoID;
	}
	[self playVideoWithID:videoID];	
}
#warning 此处视频无法在线播放
- (void)playVideoWithID:(NSString *)videoID
{
	NSString *videoURL = [kGetVideoURL stringByAppendingString:videoID];
	self.movieView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:videoURL]];
	[self presentMoviePlayerViewControllerAnimated:self.movieView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(movieDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:self.movieView.moviePlayer];
}

- (void)movieDidFinish:(NSNotification *)aNotification
{
    NSLog(@"finish!");   
    MPMoviePlayerController *moviePlayer = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
                                                  object:moviePlayer];
    [moviePlayer stop];
    [self dismissMoviePlayerViewControllerAnimated];
}

@end
