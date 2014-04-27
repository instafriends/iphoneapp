//
//  InstafriendInstagramersTableViewController.m
//  instafriends
//
//  Created by Daniel Camargo on 04/10/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendInstagramersTableViewController.h"
#import "InstafriendsInstagramerCell.h"
#import "InstafriendsCell.h"

@interface InstafriendInstagramersTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UITableView *searchBar;

@end

@implementation InstafriendInstagramersTableViewController

@synthesize list = _list;
@synthesize listSearch = _listSearch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.listSearch = [NSMutableArray arrayWithArray:self.list];
    UIButton *leftButtonItem =  [UIButton buttonWithType: UIButtonTypeCustom];
    [leftButtonItem setImage: [UIImage imageNamed: @"buttonBack.png"] forState: UIControlStateNormal];
    [leftButtonItem addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    [leftButtonItem setFrame: CGRectMake(0, 0, 32, 32)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: leftButtonItem];
    UIImage *background = [UIImage imageNamed:@"background.png"];
    UIView *tableviewBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    [tableviewBackground setBackgroundColor:[UIColor colorWithPatternImage:background]];
    //theSearchBar.backgroundImage = baseSearchImage;
    self.tableview.backgroundView = tableviewBackground;
     self.searchBar.backgroundColor = [UIColor colorWithPatternImage:background];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listSearch count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InstagramerCell";
    InstafriendsCell *cell = (InstafriendsCell*)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
		NSArray *items = [[NSBundle mainBundle] loadNibNamed:@"InstafriendsInstagramerCell" owner:nil options:nil];
		for (id item in items) {
			if ([item isKindOfClass:[UITableViewCell class]]) {
				cell = (InstafriendsCell *)item;
			}
		}
    }
    [cell setUser:[self.listSearch objectAtIndex:indexPath.row]];
    [cell setup];
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if( [searchText length] == 0 ){
        [self.listSearch removeAllObjects];
        self.listSearch = [NSMutableArray arrayWithArray:self.list];
    } else {
        [self.listSearch removeAllObjects];
        for( NSDictionary *user in self.list ){
            NSRange range = [[user objectForKey:@"username" ] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if( range.location != NSNotFound ){
                [self.listSearch addObject:user];
            }
        }
    }
    [self.tableview reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
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
    [self setTableview:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}
@end
