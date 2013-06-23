//
//  MainMenuViewController.h
//  dice3d
//
//  Created by Radif Sharafullin on 6/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
UITableView *mainTableView;
	UIButton *playControlButton;
	UIButton *infoButton;
}

@end
