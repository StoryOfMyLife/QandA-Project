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
#import "CustomizedNavigation.h"
#import "NewQorAViewController.h"
#import "RefreshView.h"
#import "JSON.h"
#import "SVStatusHUD.h"

@interface AnswersTableViewController () <AnswerCellDelegate, QuestionDetailCellDelegate, MyJSONDelegate>

@property (nonatomic, strong) MPMoviePlayerViewController *movieView;

@property (nonatomic, weak) UIActivityIndicatorView *downloadingIndicator;

@property (strong, nonatomic) RefreshView *refreshView;

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

    UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"table_bg"]];
	[self.tableView setBackgroundView:tableBackgroundView];
	
	NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"RefreshView" owner:self options:nil];
    self.refreshView = [nibs objectAtIndex:0];
    [_refreshView setupWithOwner:self.tableView delegate:self];
}

#pragma mark - JSON delegate
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
	[_refreshView startLoading];
	JSON *myJSON = [[JSON alloc] init];
	myJSON.delegate = self;
	[myJSON getJSONDataFromURL:kGetQuestionURL];
}

- (void)refreshFailed
{
	[_refreshView stopLoading];
}

- (void)refreshFinished
{
	[_refreshView finishLoading];
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
	scrollView.showsVerticalScrollIndicator = YES;
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

#pragma mark - --
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"pop to answer"]) {
		CustomizedNavigation *answerViewNavigation = (CustomizedNavigation *)segue.destinationViewController;
		NewQorAViewController *answerView = (NewQorAViewController *)answerViewNavigation.topViewController;
		answerView.isAnswerView = YES;
		answerView.questionID = self.question.questionID;
	}
}

- (IBAction)swipeBack:(id)sender
{
//	NSLog(@"%@", self.navigationController);
//	NSLog(@"%@", [self.navigationController.viewControllers description]);
	[self.navigationController popViewControllerAnimated:YES];
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
		topCell.delegate = self;
		[self configureCell:topCell atIndexPath:indexPath];
		return topCell;
	} else {
		AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		cell.delegate = self;
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
		questionDetailCell.title.text = [@"问题：" stringByAppendingString:self.question.title];
		questionDetailCell.author.text = [@"作者：" stringByAppendingString:self.question.author];
		questionDetailCell.createTime.text = [@"日期：" stringByAppendingString:[dateFormatter stringFromDate:self.question.createTime]];
		questionDetailCell.videoDuration.text = [@"时长：" stringByAppendingString:self.question.questionVideo.duration];
	} else if ([cell isKindOfClass:[AnswerCell class]]) {
		AnswerCell *answerCell = (AnswerCell *)cell;
		NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
		Answer *answer = [self.fetchedResultsController objectAtIndexPath:index];
		answerCell.author.text = [@"作者：" stringByAppendingString:answer.author];

		answerCell.createTime.text = [@"日期：" stringByAppendingString:[dateFormatter stringFromDate:answer.createTime]];
		
		answerCell.videoDuration.text = [@"时长：" stringByAppendingString:answer.answerVideo.duration];
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

#pragma mark - video play delegate
- (void)answerPlayButtonDidPress:(AnswerCell *)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	self.downloadingIndicator = sender.loadingIndicator;
	[self.downloadingIndicator startAnimating];
	NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
	Answer *answer = [self.fetchedResultsController objectAtIndexPath:index];
	NSString *videoID = answer.answerVideo.videoID;
	[self playVideoWithVideoID:videoID];
}

- (void)questionPlayButtonDidPress:(QuestionDetailCell *)sender
{
	self.downloadingIndicator = sender.loadingIndicator;
	[self.downloadingIndicator startAnimating];
	NSString *videoID = self.question.questionVideo.videoID;
	[self playVideoWithVideoID:videoID];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)dealloc
{
//此dealloc的作用：解决save core data(question)时的[AnswersTableVC controllerWillChangeContent:]: message sent to deallocated instance的错误
	self.fetchedResultsController = nil;
	self.fetchedResultsController.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
	NSLog(@"内存警告！");
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	self.movieView = nil;
	self.refreshView = nil;
	self.downloadingIndicator = nil;
	self.fetchedResultsController = nil;
	self.question = nil;
	[super viewDidUnload];
}

@end
