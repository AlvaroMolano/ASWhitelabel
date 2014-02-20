//
//  ASWhitelabelViewController.h
//  
//
//  Created by Daniel Bowden on 20/02/2014.
//
//

#import <UIKit/UIKit.h>

@protocol ASWhitelabelDelegate;

@interface ASWhitelabelViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>

- (id)initWithVenueID:(NSInteger)venueID delegate:(id<ASWhitelabelDelegate>)delegate;

@end

@protocol ASWhitelabelDelegate <NSObject>

@required
- (void)ASWhitelabelViewControllerDidRequestExit:(ASWhitelabelViewController *)viewController;

@end
