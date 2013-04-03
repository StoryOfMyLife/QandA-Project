//
//  AddingTagViewController.m
//  Q&A
//
//  Created by 刘廷勇 on 13-3-5.
//  Copyright (c) 2013年 刘廷勇. All rights reserved.
//

#import "AddingTagViewController.h"
#import "Defines.h"
#import "Account.h"

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

- (NSMutableArray *)selectedTags
{
	if (!_selectedTags) {
		_selectedTags = [NSMutableArray array];
	}
	return _selectedTags;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	Account *account = [Account sharedAcount];
	self.tags = account.tags;
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
