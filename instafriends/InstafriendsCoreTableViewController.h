//
//  InstafriendsCoreTableViewController.h
//  instafriends
//
//  Created by Daniel Camargo on 07/08/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface InstafriendsCoreTableViewController : CoreDataTableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
@property (nonatomic,strong) NSPredicate* predicate;
@property (nonatomic, strong) UIManagedDocument *instafriendsDatabase;
- (void)setInstafriendsDatabase:(UIManagedDocument *)instafriendsDatabase;
@end
