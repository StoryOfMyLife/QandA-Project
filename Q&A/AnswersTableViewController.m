//
//  FirstDetailTableViewController.m
//  问答系统
//
//  Created by 刘廷勇 on 12-12-17.
//  Copyright (c) 2012年 刘廷勇. All rights reserved.
//

#import "AnswersTableViewController.h"
#import "AnswerCell.h"
#import "QuestionDetailCell.h"
#import "Answer+Insert.h"
#import "Video+Insert.h"
#import "Defines.h"
#import "AFHTTPRequestOperation.h"

@interface AnswersTableViewController ()

@property (nonatomic, strong) MPMoviePlayerViewController *movieView;

@property (nonatomic, weak) UIActivityIndicatorView *downloadingIndicator;

@end

@implementation AnswersTableViewController

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
	//若在此之前进行setup，则会改变navigationItem的title
	[self setupFetchedResultsController];

    UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableView_bg"]];
	[self.tableView setBackgroundView:tableBackgroundView];
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

- (IBAction)swipeBack:(id)sender
{
//	NSLog(@"%@", self.navigationController);
//	NSLog(@"%@", [self.navigationController.viewControllers description]);
	[self.navigationController popViewControllerAnimated:YES];
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
	[self.tableView setAllowsSelection:NO];
	NSString *videoID;
	if (indexPath.row == 0) {
		QuestionDetailCell *cell = (QuestionDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
		self.downloadingIndicator = cell.loadingIndicator;
		[self.downloadingIndicator startAnimating];
		videoID = self.question.questionVideo.videoID;
	} else {
		AnswerCell *cell = (AnswerCell *)[tableView cellForRowAtIndexPath:indexPath];
		self.downloadingIndicator = cell.loadingIndicator;
		[self.downloadingIndicator startAnimating];
		NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
		Answer *answer = [self.fetchedResultsController objectAtIndexPath:index];
		videoID = answer.answerVideo.videoID;
	}
	
	[self playVideoWithVideoID:videoID];
}
#pragma mark - 视频下载以及播放
#warning 此处视频无法在线播放,只能暂时用先下载,在本地播放的方式,后续需要改进
- (void)playVideoFromPath:(NSString *)videoPath
{
	self.movieView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]];
	self.movieView.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(movieDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:self.movieView.moviePlayer];
	[self presentMoviePlayerViewControllerAnimated:self.movieView];
}
//对已经下载过的视频则直接播放，不重复下载
- (void)playVideoWithVideoID:(NSString *)videoID
{
	NSString *fileName = [videoID stringByAppendingString:@".mp4"];
	NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];	
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSLog(@"此视频下载过了！");
		[self playVideoFromPath:path];
	} else {
		[self downLoadVideoWithVideoID:videoID];
	}
}
//视频播放结束处理
- (void)movieDidFinish:(NSNotification *)aNotification
{
	[self.downloadingIndicator stopAnimating];
	[self.tableView setAllowsSelection:YES];
    NSLog(@"播放结束!");   
    MPMoviePlayerController *moviePlayer = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMoviePlayerPlaybackDidFinishNotification 
                                                  object:moviePlayer];
    [moviePlayer stop];
    [self dismissMoviePlayerViewControllerAnimated];
}
//将视频下载至temp目录，下载完成后开始播放
- (void)downLoadVideoWithVideoID:(NSString *)videoID
{
	NSString *videoURL = [kGetVideoURL stringByAppendingString:videoID];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:videoURL]];
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	
	NSString *fileName = [videoID stringByAppendingString:@".mp4"];
	NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];	
	operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
	
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"成功下载视频至目录：%@", path);
		[self playVideoFromPath:path];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"视频下载出错: %@", error);
	}];
	
	[operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
		NSLog(@"视频下载进度：%1.0f%%", (double)totalBytesRead / (double)totalBytesExpectedToRead * 100);
	}];
	
	[operation start];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}
@end
