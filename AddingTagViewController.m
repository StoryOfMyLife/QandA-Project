//
//  AddingTagViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 13-3-5.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "AddingTagViewController.h"

#define kSelectionTagsMax 3

@interface AddingTagViewController ()

@property (nonatomic, strong) NSMutableArray *selectedTags;

@end

@implementation AddingTagViewController

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
	
	NSArray *array = @[@"招生", @"收费", @"学籍", @"选课", @"约考", @"支持服务", @"毕设", @"JAVA", @"大学英语", @"android入门", @"设计模式", @"数据结构", @"教育技术学", @"教育学", @"移动通信", @"通信原理", @"Linux入门", @"数字通信", @"模电", @"射频通信", @"多媒体技术", @"高等数学", @"大学语文", @"信息技术", @"教育心理学", @"操作系统", @"计算机网络", @"美术", @"学与教", @"教育心理学研究方法", @"photoshop", @"3D动画", @"网页设计", @"复变函数", @"模糊数学", @"实变函数", @"日语", @"法语", @"德语", @"矩阵论", @"线性代数", @"电信法", @"毛泽东思想", @"马克思主义哲学", @"经济学", @"机械", @"工程制图", @"会计", @"审计", @"化学"];
//第一种排序
	self.tags = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		if ([obj1 length] > [obj2 length]) {
			return (NSComparisonResult)NSOrderedDescending;
		}
		if ([obj1 length] < [obj2 length]) {
			return (NSComparisonResult)NSOrderedAscending;
		}
		return (NSComparisonResult)NSOrderedSame;
	}];
//第二种排序	
//	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length" ascending:YES];
//										
//	[self.tags sortUsingDescriptors:@[sortDescriptor]];
    [self.tableView setBackgroundView:nil];
	[self.tableView setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.selectedTags = nil;
	self.tags = nil;
}

- (IBAction)cancel:(id)sender 
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)done:(id)sender 
{
	[self.delegate addingTagViewController:self didSelectTags:self.selectedTags];
	[self dismissViewControllerAnimated:YES completion:NULL];
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
    return [self.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tag cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
	cell.textLabel.text = self.tags[indexPath.row];
	if ([self.selectedTags containsObject:cell.textLabel.text]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor = [UIColor grayColor];
		cell.textLabel.alpha = 0.7;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.alpha = 1;
	}
    return cell;
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
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (cell.accessoryType != UITableViewCellAccessoryCheckmark) {
		if ([self.selectedTags count] < kSelectionTagsMax) {
			[self.selectedTags addObject:cell.textLabel.text];
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
			cell.textLabel.textColor = [UIColor grayColor];
			cell.textLabel.alpha = 0.7;
//			[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
		}
	} else {
		[self.selectedTags removeObject:cell.textLabel.text];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.alpha = 1;
//		[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

@end
