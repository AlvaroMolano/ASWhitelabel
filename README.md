# ASWhitelabel

## Usage

For an example see Project/demo.
To run the example project; clone the repo, and run `pod install` from the Project directory first.

Showing ASWhiteLabelViewController within your application for your venue (id = 1).
	ASWhitelabelViewController *viewController = [[ASWhitelabelViewController alloc] initWithVenueID:1 delegate:self];
    [self presentViewController:viewController animated:YES completion:nil];
    
When a user is finished using AirService the following delegate will be called
	- (void)ASWhitelabelViewControllerDidRequestExit:(ASWhitelabelViewController *)viewController
	{
		[self dismissViewControllerAnimated:YES completion:nil];
	}

## Installation

ASWhitelabel is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "ASWhitelabel"
    
## Author

danielbowden, www.airservice.com

## License

ASWhitelabel is available under the MIT license. See the LICENSE file for more info.

