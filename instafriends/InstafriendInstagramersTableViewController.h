//
//  InstafriendInstagramersTableViewController.h
//  instafriends
//
//  Created by Daniel Camargo on 04/10/12.
//  Copyright (c) 2012 Daniel Camargo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstafriendInstagramersTableViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray * list;
@property (nonatomic,retain) NSMutableArray * listSearch;
@end
