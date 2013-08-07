//
//  KLCircleViewController.h
//  KLCircleViewController
//
//  Created by Kieran Lafferty on 2013-07-23.
//  Copyright (c) 2013 Kieran Lafferty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLCircleViewController, KLContainerViewController;

typedef enum
{
    KLCircleStateCenter    = 1,
    KLCircleStateLeft     = 2,
    KLCircleStateRight  = 3,
    KLCircleStateTop  = 4,      //Currently not used
    KLCircleStateBottom  = 5
} KLCircleState;

typedef enum {
    KLToggleDirectionNone,
    KLToggleDirectionUp,
    KLToggleDirectionDown,
    KLToggleDirectionLeft,
    KLToggleDirectionRight,
} KLToggleDirection;

/**
 *	Block type for handling state transitions
 *
 *	@param	circleViewController    Reference to the controller undergoing the state change
 *	@param	fromState   State of the controller before the state change has occured
 *	@param	toState State of the controller after the state change has occured
*/
typedef void (^stateChangeHandler) (KLCircleViewController* circleViewController,
                                    KLCircleState fromState,
                                    KLCircleState toState);


@interface KLCircleViewController : UIViewController

#pragma mark - Initializers

/**
 *	Static initializer creates an instance of KLCircleViewController with a center view controller only
 *
 *	@param	centerViewController	The initial view controller that is at the center position
 *
 *	@return	KLCircleViewController reference to the newly initialized view controller
 */
+(id) circleViewControllerWithCenterViewController: (UIViewController*) centerViewController;

/**
 *	Static initializer creates an instance of KLCircleViewController with a center, left, right, bottom view controllers
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
                              bottomViewController: (UIViewController*) bottomViewController;

/**
 *	Initializer creates an instance of KLCircleViewController with a center view controller only
 *
 *	@param	centerViewController	The initial view controller that is at the center position
 *
 *	@return	KLCircleViewController reference to the newly initialized view controller
 */
-(id) initWithCenterViewController: (UIViewController*) centerViewController;

/**
 *	Initializer creates an instance of KLCircleViewController with a center, left, right, bottom view controllers
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
              bottomViewController: (UIViewController*) bottomViewController;

#pragma mark - State modifiers

/**
 *	Programatically trigger a state transition. State transitions can will only occur as per the rules defined in shouldTransitionToState method in the class extension in implementation file
 *
 *	@param	state	State to transition to
 *	@param	animated	Set YES if you want the transition to be animated, NO otherwise
 */
-(void) setState: (KLCircleState) state
        animated: (BOOL) animated;

/**
 *	Programatically trigger a state transition. State transitions can will only occur as per the rules defined in shouldTransitionToState method in the class extension in implementation file
 *
 *	@param	state	State to transition to
 *	@param	animated	Set YES if you want the transition to be animated, NO otherwise
 *	@param	duration	Duration of the animation
 *	@param	completion	Completion block which is fired at the end of the animation
 */
-(void) setState: (KLCircleState) state
        animated: (BOOL) animated
        duration: (NSTimeInterval) duration
      completion: (stateChangeHandler) completion;

/**
 *	Returns the current state of the control
 *
 *	@return	KLCircleState enum that corresponds to the current state of the control
 */
-(KLCircleState) state;

#pragma mark - Convenience methods

/**
 *	Convenience method that returns the view controller for the provided state or nil if does not exist
 *
 *	@param	state	State to query for the associated view controller
 *
 *	@return	UIViewController The view controller for the provided state
 */
-(UIViewController*) viewControllerForState:(KLCircleState) state;

#pragma mark - Configuration

/**
 *	The main view controller that serves as the root
 */
@property(nonatomic, strong) IBOutlet UIViewController* centerViewController;

/**
 *	The view controller that is exposed by panning to the left from the center
 */
@property(nonatomic, strong) UIViewController* leftViewController;

/**
 *	The view controller that is exposed by panning to the right from the center
 */
@property(nonatomic, strong) UIViewController* rightViewController;

/**
 *	The view controller that is exposed by panning down from the center
 */
@property(nonatomic, strong) UIViewController* bottomViewController;

#pragma mark - Block Handlers

/**
 *	Block called immediately before a state transition occurs
 */
@property(nonatomic, copy) stateChangeHandler willTransitionState;

/**
 *	Block called immediately after a state transition occurs
 */
@property(nonatomic, copy) stateChangeHandler didTransitionState;

#pragma mark - Behavioural Configuration Parameters

/**
 *	Represents the size of the ledge shown while in KLCircleStateLeft
 */
@property(nonatomic, assign) CGFloat leftLedgeSize;

/**
 *	Minimum distance to pan in pixel points using UIPanGestureRecognizer before control will enter KLCircleStateLeft
 */
@property(nonatomic, assign) CGFloat leftMinToggleDistance;

/**
 *	Represents the size of the ledge shown while in KLCircleStateRight
 */
@property(nonatomic, assign) CGFloat rightLedgeSize;

/**
 *	Minimum distance to pan in pixel points using UIPanGestureRecognizer before control will enter KLCircleStateRight
 */
@property(nonatomic, assign) CGFloat rightMinToggleDistance;

/**
 *	Represents the size of the ledge shown while in KLCircleStateBottom
 */
@property(nonatomic, assign) CGFloat bottomLedgeSize;

/**
 *	Minimum distance to pan in pixel points using UIPanGestureRecognizer before control will enter KLCircleStateBottom
 */
@property(nonatomic, assign) CGFloat bottomMinToggleDistance;


/**
 *	Minimum distance to pan using UIPanGestureRecognizer before control will enter KLCircleStateCenter
 */
@property(nonatomic, assign) CGFloat centerMinToggleDistance;

@end

typedef enum {
    KLDirectionPanGestureRecognizerVertical    = 1,
    KLDirectionPanGestureRecognizerHorizontal  = 2
} KLDirectionPanGestureRecognizerDirection;

/**
 *	Custom Pan Gesture Recognizer that locks to either horizontal or vertical directions
 */
@interface KLDirectionPanGestureRecognizer : UIPanGestureRecognizer {
    BOOL _drag;
    int _moveX;
    int _moveY;
    KLDirectionPanGestureRecognizerDirection _direction;
}

@property (nonatomic, assign) KLDirectionPanGestureRecognizerDirection direction;

@end


/**
 *	Associated object that weakly references the circleController for the UIViewController
 */
@interface UIViewController (ContainerControllerItem)

@property(nonatomic, weak) KLCircleViewController *circleController;

@end

@interface KLContainerViewController : UIViewController
-(id) initWithViewController:(UIViewController*) viewController;
@property (nonatomic, strong) UIViewController* viewController;
@end


