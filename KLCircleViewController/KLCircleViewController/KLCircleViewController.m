//
//  KLCircleViewController.m
//  KLCircleViewController
//
//  Created by Kieran Lafferty on 2013-07-23.
//  Copyright (c) 2013 Kieran Lafferty. All rights reserved.
//

#import "KLCircleViewController.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <objc/runtime.h>

#define kDefaultAnimationDuration 0.3
#define kCenterSideLedgeSize 60
#define kDefaultSideOffset CGSizeMake(0,10)
#define kDefaultBottomOffset CGSizeMake(10, 0)

#define kStateMovementThreshold 50.0    //Must move this much to toggle next state

@interface KLCircleViewController()

@property (nonatomic, assign) CGRect panGestureStartFrame;
/**
 *	Container view is used to manage panning between the view controllers
 */
@property (nonatomic, strong) UIScrollView* containerView;

/**
 *	The gesture recognizer responsible for initializing state transitions via sliding
 */
@property (nonatomic, strong) KLDirectionPanGestureRecognizer* panGesture;

/**
 *	The gesture recognizer responsible for initializing state transitions via tapping
 */
@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;

/**
 *	Maintains the current state of the controller.
 */
@property (nonatomic, assign) KLCircleState state;

/**
 *	Determines whether the transition should be allowed to occur. The state transition can only occur from the center to [top, left, bottom, right]. And from [top, left, bottom, right] to center. Will return false if the toState does not have an associated view controller.
 *
 *	@param	toState	The state that the control is attempting to transition to.
 *	@param	fromState	The state that the control is attempting to transition from.
 *
 *	@return	BOOL if the transition can occur
 */
-(BOOL) shouldTransitionToState:(KLCircleState) toState fromState:(KLCircleState) fromState;

/**
 *	Returns true if a view controller exists for the state and false if it does not
 *
 *	@param	state	The state to be checked against
 *
 *	@return	boolean if a view controller exists
 */
-(BOOL) viewControllerExistsForState:(KLCircleState) state;

/**
 *	Called immediately before a state transition occurs
 *
 *	@param	state	The state being transitioned to
 */
-(void) notifyWillTransitionToState:(KLCircleState) toState fromState:(KLCircleState) fromState;

/**
 *	Called immediately after a state transition occurs
 *
 *	@param	state   The state being transitioned to 
 */
-(void) notifyDidTransitionToState:(KLCircleState) toState fromState:(KLCircleState) fromState;

/**
 *	Returns the coordinate for the origin of the view controller view for the specified state. WARNING: Depends on the centerViewController view frame, so the center state must be set for this to be reliable.
 *
 *	@param	state	the state for which to provide the origin for
 *
 *	@return	CGPoint point that contains the location data for state
 */
-(CGPoint) originForState:(KLCircleState) state;

/**
 *	Handles the animation for the pan gesture on the horizontal axis
 *
 *	@param	gesture	Gesture to be handled
 */
-(void) handleHorizontalGesture:(UIPanGestureRecognizer*) gesture;

/**
 *	Handles the animation for the pan gesture on the vertical axis
 *
 *	@param	gesture	Gesture to be handled
 */
-(void) handleVerticalGesture:(UIPanGestureRecognizer*) gesture;

/**
 *	Determines the appropriate content size of the UIScrollView and lays out the views in the correct locations
 */
-(void) layoutSubviewsOfContainer;

/**
 *	Sets up all the default values for the control. Should not be modified directly, if you would like to modify the defaults then set the properties directly from the instantiating class
 */
-(void) configureDefaults;

/**
 *	Performs common actions on the view controller removing it from the control
 *
 *	@param	viewController	UIViewController to process
 */
-(void) removePeripheralViewController:(UIViewController*) viewController;

/**
 *	Performs common actions on the view controller adding it to the control
 *
 *	@param	viewController	UIViewController to process
 */
-(void) addPeripheralViewController:(UIViewController*) viewController;

@end
@implementation KLCircleViewController


#pragma mark - Initializers
-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder: aDecoder]) {
        [self commonInitialization];
    }
    return self;
}
- (void)commonInitialization
{
    /**
     *      Layout of UIScrollView
     *
     *      |       |       |
     *              |
     */
    [self configureDefaults];
    
    _containerView = [[UIScrollView alloc] initWithFrame: self.view.bounds];
    [_containerView setBackgroundColor: [UIColor blackColor]];
    [_containerView setScrollEnabled: NO];
    
    //Initialize attributes of scroll view
    [self.view addSubview: _containerView];
    
    //Initialize the gesture recognizers
    _panGesture = [[KLDirectionPanGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(didPerformPanGesture:)];
    
    [_panGesture reset];
    [_containerView addGestureRecognizer: _panGesture];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(didPerformTapGesture:)];
}

/**
 *	Sets the local view controller property and adds it as a child view controller to the control
 *
 *	@param	centerViewController	The initial view controller that is at the center position
 *	@param	leftViewController	The initial view controller that is at the left position
 *	@param	rightViewController	The initial view controller that is at the right position
 *	@param	bottomViewController	The initial view controller that is at the bottom position
 *
 *	@return	KLCircleViewController reference to the newly initialized view controller
 */
-(id) initWithCenterViewController: (UIViewController*) centerViewController
                leftViewController: (UIViewController*) leftViewController
               rightViewController: (UIViewController*) rightViewController
              bottomViewController: (UIViewController*) bottomViewController {
    if (self = [self init]) {
        
        [self commonInitialization];

        //Set the center view and add it to the scrollview
        [self setCenterViewController: centerViewController];
        
        //Add and configure the right view
        [self setRightViewController: rightViewController];
        
        //Add and configure the left view
        [self setLeftViewController: leftViewController];
        
        //Add and configure the bottom view
        [self setBottomViewController: bottomViewController];
        
        [self setState: KLCircleStateCenter];
    }
    return self;
}

/**
 *	Sets the local view controller property and adds it as a child view controller to the control
 *
 *	@param	centerViewController	The initial view controller that is at the center position
 *	@param	leftViewController	The initial view controller that is at the left position
 *	@param	rightViewController	The initial view controller that is at the right position
 *	@param	bottomViewController	The initial view controller that is at the bottom position
 *
 *	@return	KLCircleViewController reference to the newly initialized view controller
 */
+(id) circleViewControllerWithCenterViewController: (UIViewController*) centerViewController
                                leftViewController: (UIViewController*) leftViewController
                               rightViewController: (UIViewController*) rightViewController
                              bottomViewController: (UIViewController*) bottomViewController {
    
    return [[KLCircleViewController alloc] initWithCenterViewController: centerViewController
                                                     leftViewController: leftViewController
                                                    rightViewController: rightViewController
                                                   bottomViewController: bottomViewController];
}

/**
 *	Sets the local view controller property and adds it as a child view controller to the control
 *
 *	@param	centerViewController	view controller to set as the center view controller
 *
 *	@return	reference to the newly intialized control
 */
-(id) initWithCenterViewController: (UIViewController*) centerViewController {
    if (self = [self initWithCenterViewController: centerViewController
                               leftViewController: nil
                              rightViewController: nil
                             bottomViewController: nil]) {
    }
    return self;
}

/**
 *	Sets the local view controller property and adds it as a child view controller to the control
 *
 *	@param	centerViewController	view controller to set as the center view controller
 *
 *	@return	reference to the newly intialized control
 */
+(id) circleViewControllerWithCenterViewController: (UIViewController*) centerViewController {
    return [[KLCircleViewController alloc] initWithCenterViewController: centerViewController];
}


-(void) configureDefaults {
    //Ledges
    self.leftLedgeSize = kCenterSideLedgeSize;
    self.rightLedgeSize = kCenterSideLedgeSize;
    self.bottomLedgeSize = kCenterSideLedgeSize;
    
    //Toggle Distance
    self.leftMinToggleDistance = kStateMovementThreshold;
    self.rightMinToggleDistance = kStateMovementThreshold;
    self.bottomMinToggleDistance = kStateMovementThreshold;
    self.centerMinToggleDistance = kStateMovementThreshold;
}

#pragma mark - Setters

-(void) setCenterViewController:(UIViewController *)centerViewController {
    NSAssert(centerViewController, @"Must provide a center view controller");

    if (_centerViewController) {
        [self removePeripheralViewController: _centerViewController];
    }
    
    _centerViewController = centerViewController;
    [_centerViewController setCircleController: self];

    [_centerViewController.view addGestureRecognizer: _tapGesture];
    
    [self addChildViewController: _centerViewController];

    [_containerView addSubview: _centerViewController.view];
    
    [self layoutSubviewsOfContainer];
}
-(void) setLeftViewController:(UIViewController *)leftViewController {
    
    if (_leftViewController) {
        [self removePeripheralViewController: _leftViewController];
    }
    
    _leftViewController = [[KLContainerViewController alloc] initWithViewController: leftViewController];
    
    if (leftViewController) {
        [self addPeripheralViewController: _leftViewController];
    }
    [self layoutSubviewsOfContainer];
}

-(void) setRightViewController:(UIViewController *)rightViewController {
    
    if (_rightViewController) {
        [self removePeripheralViewController: _rightViewController];
    }
    
    _rightViewController = [[KLContainerViewController alloc] initWithViewController: rightViewController];
    
    if (rightViewController) {
        [self addPeripheralViewController: _rightViewController];
    }
    [self layoutSubviewsOfContainer];
}

-(void) setBottomViewController:(UIViewController *)bottomViewController {
    
    if (_bottomViewController) {
        [self removePeripheralViewController: _bottomViewController];
    }
    
    _bottomViewController = [[KLContainerViewController alloc] initWithViewController: bottomViewController];
    
    if (bottomViewController) {
        [self addPeripheralViewController:_bottomViewController];
    }
    [self layoutSubviewsOfContainer];
}

-(BOOL) shouldAutomaticallyForwardAppearanceMethods {
    return YES;
}

#pragma mark - Helpers

-(void) removePeripheralViewController:(UIViewController*) viewController {
    [viewController willMoveToParentViewController:nil];
    [viewController setCircleController: nil];
    [viewController removeFromParentViewController];
    [viewController.view removeFromSuperview];
}
-(void) addPeripheralViewController:(UIViewController*) viewController {
    [viewController setCircleController: self];
    [self addChildViewController: viewController];
    [_containerView insertSubview: viewController.view
                     belowSubview: self.centerViewController.view];
    [viewController didMoveToParentViewController: self];
}
-(void) layoutSubviewsOfContainer {
    //Add the content inset if necessary
    [self.containerView setContentInset: UIEdgeInsetsMake(0, self.leftViewController ? self.leftLedgeSize : 0 , self.bottomViewController ? self.bottomLedgeSize : 0 , self.rightViewController ? self.rightLedgeSize : 0)];
    
    [_centerViewController.view setFrame: [self frameForState: KLCircleStateCenter]];
    [_leftViewController.view setFrame: [self frameForState: KLCircleStateLeft]];
    [_rightViewController.view setFrame: [self frameForState: KLCircleStateRight]];
    [_bottomViewController.view setFrame: [self frameForState: KLCircleStateBottom]];
    
    //Set the containerviews content size to just fit the subviews
    [self.containerView setContentSize: [self contentSizeToFit]];
    
    [self setState: self.state];
}

-(CGSize) contentSizeToFit {
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.containerView.subviews)
        contentRect = CGRectUnion(contentRect, view.frame);
    return contentRect.size;
}
-(CGSize) offsetTravelledByLastPan {
    //Determine x offset
    CGRect newFrame = [self.view convertRect: self.view.frame
                                      toView: self.containerView];
    
    //Create a CGsize by getting the difference between the saved frame and the new one. Negative values indicate backwards movement.
    return CGSizeMake(newFrame.origin.x - self.panGestureStartFrame.origin.x, newFrame.origin.y - self.panGestureStartFrame.origin.y);
}

-(KLToggleDirection) nextStateDirection:(CGSize) movement {
    //Determine if it was horizontal or vertical movement
    BOOL isHorizontalMovement = abs(movement.width) > abs(movement.height);
    if (isHorizontalMovement) {
        //Horizontal movement
        return movement.width >= 0 ? KLToggleDirectionRight : KLToggleDirectionLeft;
    }
    else {
        //Vertical movement
        return movement.height >= 0 ? KLToggleDirectionDown : KLToggleDirectionUp;
    }
}
-(KLCircleState) stateFromDirection:(KLToggleDirection) direction {
    KLCircleState nextState = self.state;
    
    switch (self.state) {
        case KLCircleStateCenter:
            
            if (direction == KLToggleDirectionLeft) 
                nextState = KLCircleStateLeft;
            else if (direction == KLToggleDirectionRight)
                nextState =  KLCircleStateRight;
            else if (direction == KLToggleDirectionDown)
                nextState = KLCircleStateBottom;
            break;
        case KLCircleStateLeft:
            if (direction == KLToggleDirectionRight)
                nextState =  KLCircleStateCenter;
            break;
        case KLCircleStateRight:
            if (direction == KLToggleDirectionLeft)
                nextState =  KLCircleStateCenter;
            break;

        case KLCircleStateBottom:
            if (direction == KLToggleDirectionUp)
                nextState =  KLCircleStateCenter;
            break;
        default:
            break;
    }
    return  nextState;
}

-(KLCircleState) stateForCurrentView {
    CGSize movementOffset = [self offsetTravelledByLastPan];
    KLCircleState nextState = [self stateFromDirection: [self nextStateDirection:movementOffset]];
    if (nextState == KLCircleStateLeft
        && abs(movementOffset.width) > self.leftMinToggleDistance) {
        return KLCircleStateLeft;
    }
    else if (nextState == KLCircleStateRight
             && abs(movementOffset.width) > self.rightMinToggleDistance) {
        return KLCircleStateRight;
    }
    else if (nextState == KLCircleStateBottom
             && abs(movementOffset.height) > self.bottomMinToggleDistance) {
        return KLCircleStateBottom;
    }
    else if (nextState == KLCircleStateCenter
             && (abs(movementOffset.width) > self.centerMinToggleDistance
                 || abs(movementOffset.height) > self.centerMinToggleDistance)) {
        return KLCircleStateCenter;
    }
    else return self.state;
}

-(CGRect) frameForState: (KLCircleState) state {
    CGPoint origin = [self originForState: state];
    UIViewController* stateViewController = [self viewControllerForState: state];
    return CGRectMake(origin.x, origin.y, stateViewController.view.frame.size.width, stateViewController.view.frame.size.height);
}

-(CGPoint) originForState:(KLCircleState) state {
    CGPoint returnPoint = CGPointMake(0, 0);
    
    CGRect  centerFrame = self.centerViewController.view.frame;
    
    if (state == KLCircleStateCenter) {
        returnPoint.x = self.leftViewController ? self.leftViewController.view.frame.size.width - self.leftLedgeSize : 0;
    }
    else if (state == KLCircleStateLeft) {
        //Do nothing, already at (0,0)
    }
    else if (state == KLCircleStateRight) {
        returnPoint.x = self.leftViewController ? self.leftViewController.view.frame.size.width + self.centerViewController.view.frame.size.width - self.leftLedgeSize - self.rightLedgeSize : self.centerViewController.view.frame.size.width - self.rightLedgeSize;
    }
    else if (state == KLCircleStateBottom) {
        returnPoint.x = centerFrame.origin.x;
        returnPoint.y = centerFrame.origin.y + centerFrame.size.height - self.bottomLedgeSize;
    }
    return returnPoint;
}

-(BOOL) shouldTransitionToState:(KLCircleState) toState fromState:(KLCircleState) fromState {
   
    if (fromState == toState) {
        return YES;
    }
    //Can only transition if either the fromState or toState is the centerViewController. This prevents transitions from leaf view controllers to other leaf view controllers. Can also transition from the left to the right view and vice versa

   return ((toState == KLCircleStateCenter || fromState == KLCircleStateCenter) ||
           (toState == KLCircleStateLeft && fromState == KLCircleStateRight) ||
           (toState == KLCircleStateRight && fromState == KLCircleStateLeft)) &&
          [self viewControllerExistsForState: toState];
}

-(BOOL) viewControllerExistsForState:(KLCircleState) state {
    return [self viewControllerForState: state] != nil;
}

-(UIViewController*) viewControllerForState:(KLCircleState) state {
    switch (state) {
        case KLCircleStateCenter:
            return self.centerViewController;
            break;
        case KLCircleStateLeft:
            return self.leftViewController;
            break;
        case KLCircleStateRight:
            return self.rightViewController;
            break;
//        case KLCircleStateTop:
//            return self.topViewController;
//            break;
        case KLCircleStateBottom:
            return self.bottomViewController;
            break;
        default:
            break;
    }
    return nil;
}



#pragma mark - State transitions
/**
 *	Only publicly available method for triggering state changes progamatically.
 *
 *	@param	state	state to be transitioned to
 *	@param	animated	boolean which indicates whether the transition should be animated or not
 */
-(void) setState:(KLCircleState)state
        animated:(BOOL)animated {
    [self setState: state
          animated: animated
          duration: kDefaultAnimationDuration
        completion: nil];
}
-(void) setState: (KLCircleState) state
        animated: (BOOL) animated
        duration: (NSTimeInterval) duration
      completion: (stateChangeHandler) completion {
    __block KLCircleState lastState = self.state;
    if (animated) {
        [UIView animateWithDuration: duration
                         animations:^{
                             [self setState: state];
                         }
         completion:^(BOOL finished) {
             if (completion) {
                 completion(self, lastState, state);
             }
         }];
    }
    else {
        [self setState: state];
        if (completion) {
            completion(self, lastState, state);
        }
    }
}
/**
 *	Private method to manage the state property and the final frame properties of the control to move to the specified state.
 *
 *	@param	state	state to be transitioned to
 */
-(void) setState:(KLCircleState)state {
    KLCircleState lastState = self.state;
    if ([self shouldTransitionToState: state
                            fromState: lastState]) {
        [self notifyWillTransitionToState: state fromState:lastState];
        //TODO: Add animation logic here for final state drawing
        CGPoint pointForState = [self originForState: state];
        [self.containerView setContentOffset: pointForState];
        _state = state;
        [self notifyDidTransitionToState: state
                               fromState: lastState];
    }
}

#pragma mark - Notifications

/**
 *	Sends out all notification mechanisms to indicate a transition will occur immediately following execution.
 *
 *	@param	toState	current state of the control before the state change occurs
 *	@param	fromState	state to be transitioned to
 */
-(void) notifyWillTransitionToState:(KLCircleState) toState fromState:(KLCircleState) fromState {
    //Notify the event handler(s)
    if (self.willTransitionState)
        self.willTransitionState(self, toState, fromState);
}

/**
 *	Sends out all notification mechanisms to indicate a transition did occur immediately preceding execution.
 *
 *	@param	toState	current state of the control before the state change occured
 *	@param	fromState	state transitioned to
 */
-(void) notifyDidTransitionToState:(KLCircleState) toState fromState:(KLCircleState) fromState {
    //Notify the event handler(s)
    if (self.didTransitionState)
        self.didTransitionState(self, toState, fromState);
}

#pragma mark - Gesture Recognizers
/**
 *	UITapGestureRecognizer handler.
 *
 *	@param	gesture	UITapGestureRecognizer
 */
-(void) didPerformTapGesture:(UITapGestureRecognizer*) gesture {
    //Determine if it is in a tap sensitive zone
    //Toggle accordingly
    if (self.state == KLCircleStateLeft || self.state == KLCircleStateRight || self.state == KLCircleStateBottom) {
        if (gesture.view == self.centerViewController.view) {
            [self setState: KLCircleStateCenter
                  animated: YES];
        }
    }
}

/**
 *	UISwipeGestureRecognizer handler. Only toggles the center state if the contained in the left/right view controller and the swipe direction is left/right. 
 *
 *	@param	gesture	UITapGestureRecognizer
 */
-(void) didPerformSwipeGesture:(UISwipeGestureRecognizer*) gesture {
    //Swipe gestures are already configured to only recognize the correct direction for the left and right ones
    [self setState: KLCircleStateCenter
              animated: YES];
}

/**
 *	UIPanGestureRecognizer handler.
 *
 *	@param	gesture	UIPanGestureRecognizer
 */
-(void) didPerformPanGesture:(KLDirectionPanGestureRecognizer*) gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //TODO: Save the currently visible frame so taht we can figure out offset once completed
        self.panGestureStartFrame = [self.view convertRect: self.view.frame
                                                    toView: self.containerView];
    }
    else if(gesture.state == UIGestureRecognizerStateChanged) {
        if (gesture.direction == KLDirectionPanGestureRecognizerHorizontal) {
            [self handleHorizontalGesture: gesture];
        }
        else if (gesture.direction == KLDirectionPanGestureRecognizerVertical){
            [self handleVerticalGesture: gesture];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded
             || gesture.state == UIGestureRecognizerStateCancelled
             || gesture.state == UIGestureRecognizerStateFailed) {
        [gesture reset];
        
        [self setState: [self stateForCurrentView]
              animated: YES];
    }
}

-(void) handleHorizontalGesture:(UIPanGestureRecognizer*) gesture {
    //Ignore horizontal swipes if not in left center or right
    if (!(self.state == KLCircleStateLeft || self.state == KLCircleStateCenter || self.state == KLCircleStateRight))
        return;
    
    CGPoint translation = [gesture translationInView: self.view];
    
    CGPoint containerOffset = self.containerView.contentOffset;
    containerOffset.x -= translation.x;
    

    //Leftmost side
    if (containerOffset.x < 0) {
        if (self.leftViewController)
            containerOffset = [self originForState: KLCircleStateLeft];
        else
            containerOffset = [self originForState: KLCircleStateCenter];
    }
    //Rightmost side
    else if (fabsf(containerOffset.x + gesture.view.frame.size.width) > self.containerView.contentSize.width) {
        if (self.rightViewController)
            containerOffset = [self originForState: KLCircleStateRight];
        else
            containerOffset = [self originForState: KLCircleStateCenter];
    }
    
    [gesture setTranslation:CGPointZero inView: self.view];

    [self.containerView setContentOffset: containerOffset];
}

-(void) handleVerticalGesture:(UIPanGestureRecognizer*) gesture {
    if (!(self.state == KLCircleStateBottom || self.state == KLCircleStateCenter))
        return;
    //TODO: implementation
    
    CGPoint translation = [gesture translationInView: self.view];
    
    CGPoint containerOffset = self.containerView.contentOffset;
    containerOffset.y -= translation.y;
    
    //Leftmost side
    if (containerOffset.y < 0) {
        containerOffset = [self originForState: KLCircleStateCenter];
    }
    //Rightmost side
    else if (fabsf(containerOffset.y + gesture.view.frame.size.height) > self.containerView.contentSize.height) {
        containerOffset = [self originForState: KLCircleStateBottom];
    }
    
    [gesture setTranslation: CGPointZero
                     inView: self.view];
    
    [self.containerView setContentOffset: containerOffset];
    
}
@end

int const static kDirectionPanThreshold = 5;

@implementation KLDirectionPanGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!_drag) {
        if (abs(_moveX) > abs(_moveY)) {
            if (_direction == KLDirectionPanGestureRecognizerHorizontal) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
                self.direction = KLDirectionPanGestureRecognizerHorizontal;
            }
        }else if (abs(_moveY) > abs(_moveX)) {
            if (_direction == KLDirectionPanGestureRecognizerVertical) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
                self.direction = KLDirectionPanGestureRecognizerVertical;
            }
        }
    }
}

- (void)reset {
    [super reset];
    _drag = NO;
    _direction = 0;
    _moveX = 0;
    _moveY = 0;
}

@end

@implementation UIViewController (ContainerControllerItem)

static const char* circleControllerKey = "CircleController";

-(void) setCircleController:(KLCircleViewController *)containerController {
    objc_setAssociatedObject(self, &circleControllerKey, containerController, OBJC_ASSOCIATION_ASSIGN);
}
-(KLCircleViewController*) circleController {
    return objc_getAssociatedObject(self, &circleControllerKey);
}
@end

@implementation KLContainerViewController
-(id) initWithViewController:(UIViewController*) viewController {
    if (self = [super init]) {
        [self setViewController: viewController];
    }
    return self;
}
-(void) setViewController:(UIViewController *)viewController {
    if (_viewController) {
        [_viewController removeFromParentViewController];
        [_viewController.view removeFromSuperview];
    }
    
    _viewController = viewController;
    
    if (viewController) {
        [self addChildViewController: _viewController];
        [self.view addSubview: _viewController.view];
    }
}
-(void) setCircleController:(KLCircleViewController *)circleController {
    [self.viewController setCircleController: circleController];
}
@end

