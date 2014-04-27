//
//  InstafriendsCoreTableViewController.m
//  instafriends
//
//  Created by Daniel Camargo on 07/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import "InstafriendsCoreTableViewController.h"
#import "InstafriendsInstagramerCell.h"
#import "InstafriendsConstants.h"

@interface InstafriendsCoreTableViewController()

    @property (nonatomic,strong) NSPredicate* predicateOriginal;

@end

@implementation InstafriendsCoreTableViewController

@synthesize instafriendsDatabase = _instafriendsDatabase;
@synthesize predicate = _predicate;
@synthesize predicateOriginal = _predicateOriginal;

- (void)setupFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Instagramer"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = self.predicate;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.instafriendsDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.instafriendsDatabase.fileURL path]]) {
        // does not exist on disk, so create it
        [self.instafriendsDatabase saveToURL:self.instafriendsDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.instafriendsDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.instafriendsDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.instafriendsDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self setupFetchedResultsController];
    }
}

- (void)setInstafriendsDatabase:(UIManagedDocument *)instafriendsDatabase
{
    if (_instafriendsDatabase != instafriendsDatabase) {
        _instafriendsDatabase = instafriendsDatabase;
        [self useDocument];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.instafriendsDatabase) { 
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:INSTAFRIENDS_DATABASE_NAME];
        self.instafriendsDatabase = [[UIManagedDocument alloc] initWithFileURL:url]; 
    }
    self.predicateOriginal = self.predicate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InstagramerCell";
    InstafriendsInstagramerCell *cell = (InstafriendsInstagramerCell*)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
		NSArray *items = [[NSBundle mainBundle] loadNibNamed:@"InstafriendsInstagramerCell" owner:nil options:nil];
		for (id item in items) {
			if ([item isKindOfClass:[UITableViewCell class]]) {
				cell = (InstafriendsInstagramerCell *)item;
			}
		}
    }
    Instagramer *instagramer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setInstagramer:instagramer];
    [cell setup];
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *leftButtonItem =  [UIButton buttonWithType: UIButtonTypeCustom];
    [leftButtonItem setImage: [UIImage imageNamed: @"buttonBack.png"] forState: UIControlStateNormal];
    [leftButtonItem addTarget: self action: @selector(back) forControlEvents: UIControlEventTouchUpInside];
    [leftButtonItem setFrame: CGRectMake(0, 0, 32, 32)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: leftButtonItem];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated: YES];
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if(searchString.length == 0)
    {
        self.predicate = self.predicateOriginal;
    } else {
        self.predicate = [NSCompoundPredicate andPredicateWithSubpredicates
                         :[NSArray arrayWithObjects : self.predicateOriginal,
                           [NSPredicate predicateWithFormat:@"username CONTAINS[cd] %@",searchString], nil]];
    }
    
    [self setupFetchedResultsController];
    return YES;
}
@end
