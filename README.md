<img src="https://raw.github.com/KieranLafferty/KLCircleViewController/master/KLCircleViewControllerDemo/Demo.gif" width="50%"/>

KLCircleViewController
=======

A control that allows panning between view controllers as inspired by the Circle app.

Note: KLCircleViewController is intended for use with portrait orientation on iPhone/iPod Touch/iPad.

Requires ARC

[Check out the Demo](https://www.youtube.com/watch?v=2F1nQRvExZs) *Excuse the graphics glitches and lag due to my slow computer.*


## Installation ##

	1. Drag the KLCircleViewController.xcodeproj to your existing project
	2. Under Build Phases on your project's Xcode Project file add 'KLCircleViewController(KLCircleViewController)' to your Target Dependancies
	3. Under Build on your Xcode Project file add 'libKLCircleViewController' & QuartzCore.framework under Link Binary With Libraries
	4. Include #import <KLCircleViewController/KLCircleViewController.h> in any file you wish to use

Install via Cocoapods by adding the following line to your podfile

		pod 'KLCircleViewController'
## Usage ##

Import the header file and declare your controller to subclass KLScrollViewController

	#import <KLCircleViewController/KLCircleViewController.h>
	...
	[[KLCircleViewController alloc] initWithCenterViewController: center
	                                          leftViewController: left
	                                    	 rightViewController: right
	                                        bottomViewController: bottom];

To omit a view controller, pass in nill as follows:

	[[KLCircleViewController alloc] initWithCenterViewController: center
	                                          leftViewController: left
	                                    	 rightViewController: nil
	                                        bottomViewController: nil];										

Note: Center view controller can never be nil as it is 	default

To invalidate/remove a view controller after instantiation set the property to nil

	[self.circleViewController setLeftViewController: nil];		

Note: As mentioned above, this can not be done for the center view controller as it is required.


## Reference to KLCircleViewController from child View Controllers ##
A category has been added to UIViewController that allows any UIViewController to access the KLCircleViewController from within the child. This reference will only exist for the span of time that the child is truly contained within the KLCircleViewController instance. If the KLCircleViewController removes the UIViewController then it can no longer be referenced and will return nil.

	#import <KLCircleViewController/KLCircleViewController.h>
	...
	KLCircleViewController* circleController = self.circleController;
	//Do whatever useful things you may need to do with this reference here

## Registering for callbacks ##

Callbacks are all handled by blocks. 

	[self.circleVC setWillTransitionState: ^(KLCircleViewController* circleViewController, KLCircleState fromState,
	                                        KLCircleState toState) {
												//Do something useful here
	}];
	[self.circleVC setDidTransitionState:^(KLCircleViewController* circleViewController, KLCircleState fromState,
	                                      KLCircleState toState) {
											  //Do something useful here
	}];
	
	
## Documentation ##

Use Doxygen (http://www.stack.nl/~dimitri/doxygen/download.html) to generate the documentation using the doxygen file in the root of the repository.

## Contact ##

* [@kieran_lafferty](https://twitter.com/kieran_lafferty) on Twitter
* [@kieranlafferty](https://github.com/kieranlafferty) on Github
* <a href="mailTo:kieran.lafferty@gmail.com">kieran.lafferty [at] gmail [dot] com</a>

## License ##

Copyright 2013 Kieran Lafferty

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
