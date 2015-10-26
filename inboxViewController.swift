//
//  inboxViewController.swift
//  MailboxExercise
//
//  Created by Anna Smalley on 10/21/15.
//  Copyright © 2015 Anna Smalley. All rights reserved.
//

import UIKit

class inboxViewController: UIViewController {

    
    @IBOutlet weak var feedScrollView: UIScrollView!
    
    @IBOutlet weak var messageContainerView: UIView!
    
    @IBOutlet weak var messageView: UIImageView!
   
    @IBOutlet weak var leftIconView: UIImageView!
    
    @IBOutlet weak var rightIconView: UIImageView!
    
    @IBOutlet weak var backgroundColorView: UIView!
    
    @IBOutlet weak var rescheduleOverlayView: UIImageView!
    
    @IBOutlet weak var listOverlayView: UIImageView!
    
    @IBOutlet weak var feedImageView: UIImageView!
    
    var initialCenter = CGPoint!()
    
    var messageMovedLeftMoreThan60 = Bool(true)
    
    var backgroundColor = CGFloat!()
    
    var initialRightIconCenter = CGPoint(x: 0, y: 0)
    
    var initialLeftIconCenter = CGPoint (x:0, y:0)
    
    var initialFeedCenter = CGPoint (x:0, y:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedScrollView.contentSize = CGSize (width: 320, height: 1300)
        
        rescheduleOverlayView.alpha = 0
        
        listOverlayView.alpha = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanMessage(sender: UIPanGestureRecognizer) {
        
        let location = sender.locationInView(view)
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {print ("you started panning, so I'm setting the icons to be grayed out, I'm starting the animation to darken them, and I'm setting the initial centers of the message and both icons to be equal to where they were when you started panning.")
        
            leftIconView.alpha = 0.5
            rightIconView.alpha = 0.5
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.leftIconView.alpha = 1
            self.rightIconView.alpha = 1
                
            }, completion: { (Bool) -> Void in print("you completed animation")
            })
            
            initialCenter = messageView.center
            initialRightIconCenter = rightIconView.center
            initialLeftIconCenter = leftIconView.center
            initialFeedCenter = feedImageView.center
            
        }
        
        else if sender.state == UIGestureRecognizerState.Changed {print("You didn't stop panning, so I'm now going to be moving the center of the Message along with your finger. Also, whenever the location of your finger is far left enough, I'm going to change the color to yellow and make the icon start following you. The location of your finger is now: \(location) and the location of the center of the Message is now: \(messageView.center).")
           
            messageView.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)
            
            if messageView.center.x <= -100 {print("the message center is at or below -100, so I'm going to change the color to BROWN and and change the icon and make the icon start following and set a variable for brown and set a variable saying it was in the go zone.")
                
                leftIconView.alpha = 0
                
                backgroundColorView.backgroundColor = UIColor(red: 204/255, green: 149/255, blue: 97/255, alpha: 1)
                
                rightIconView.image = UIImage(named: "list_icon")
                
                rightIconView.center.x = CGFloat(initialRightIconCenter.x + translation.x + 60)
                
                messageMovedLeftMoreThan60 = Bool(true)
                    
                backgroundColor = 2
    
            }

            else if messageView.center.x <= 100 {print("the message center is between -100 and 100, so I'm going to change the color to YELLOW and make the icon start following and change the icon and set a variable for yellow and set a variable saying it was in the go zone.")
                
                leftIconView.alpha = 0
                
                backgroundColorView.backgroundColor = UIColor(red: 248/255, green: 204/255, blue: 40/255, alpha: 1)
                
                rightIconView.image = UIImage(named: "later_icon")
                
                rightIconView.center.x = CGFloat(initialRightIconCenter.x + translation.x + 60)
                
                messageMovedLeftMoreThan60 = Bool(true)
                
                backgroundColor = 1
        
            }
                
            else if messageView.center.x <= 220 {print("the message center is between 100 and 220, so undo the yellow and brown etc stuff.")
                
                backgroundColorView.backgroundColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
                    
                rightIconView.center.x = CGFloat(initialRightIconCenter.x)
            
                messageMovedLeftMoreThan60 = Bool(false)
                    
            }
            
            else if messageView.center.x <= 420 {print ("the message center is between 220 and 420, so so I'm going to change the color to GREEN and make the icon start following and set a variable for green and set a variable saying it was in the go zone.")
                
                rightIconView.alpha = 0
                
                backgroundColorView.backgroundColor = UIColor(red: 98/255, green: 213/255, blue: 80/255, alpha: 1)
                
                leftIconView.image = UIImage(named: "archive_icon")
                
                leftIconView.center.x = CGFloat(initialLeftIconCenter.x + translation.x - 60)
                
                messageMovedLeftMoreThan60 = Bool(true)
            
                backgroundColor = 3
                
            }
        
            
            else if messageView.center.x > 420 {print ("the message center is between 220 and 420, so so I'm going to change the color to RED 237 83 41 and make the icon start following and set a variable for red and set a variable saying it was in the go zone.")
            
                rightIconView.alpha = 0
                
                backgroundColorView.backgroundColor = UIColor(red: 237/255, green: 83/255, blue: 41/255, alpha: 1)
            
                leftIconView.image = UIImage(named: "delete_icon")
            
                leftIconView.center.x = CGFloat(initialLeftIconCenter.x + translation.x - 60)
            
                messageMovedLeftMoreThan60 = Bool(true)
            
                backgroundColor = 4
            
            }
        }
        
        else if sender.state == UIGestureRecognizerState.Ended {print("You lifted your finger")
            
                if messageMovedLeftMoreThan60 == false {messageView.center = initialCenter}
            
                else if backgroundColor == 1.0 {print("released while yellow so now need to remove the left icon, continue animating the message to the left until it goes off screen, and fade out the right icon, and then fade in the schedule screen")
                
                    self.leftIconView.alpha = 0
                
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageView.center.x = -160
                    self.rightIconView.alpha = 0
                    })
                
                    UIView.animateWithDuration(0.4, delay: 0.4, options: [], animations: { () -> Void in
                    self.rescheduleOverlayView.alpha = 1
                    }, completion: { (Bool) -> Void in []
                    })
                    
                }
                
                else if backgroundColor == 2.0 {print("released while brown so now need to remove the left icon, continue animating the message to the left until it goes off screen, and fade out the right icon, and then fade in the list screen")
                
                    self.leftIconView.alpha = 0
                
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.messageView.center.x = -160
                    self.rightIconView.alpha = 0
                    })
                
                    UIView.animateWithDuration(0.4, delay: 0.4, options: [], animations: { () -> Void in
                    self.listOverlayView.alpha = 1
                    }, completion: { (Bool) -> Void in []
                    })
                
                }
                    
                else if backgroundColor == 3.0 {print ("released while green so now need to remove the right icon, continue animating the message to the right until it goes off screen, and fade out the left icon, and then remove the entire green message")
                    
                    self.rightIconView.alpha = 0
                    
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        self.messageView.center.x = 480
                        self.leftIconView.alpha = 0
                        }) { (Bool)  -> Void in UIView.animateWithDuration(0.4, animations: { () -> Void in
                                    self.feedImageView.center.y = self.initialFeedCenter.y - 85
                        })
                    }
                }
            
                else if backgroundColor == 4.0 {print ("released while red so now need to remove the right icon, continue animating the message to the right until it goes off screen, and fade out the left icon, and then remove the entire red message")
                    
                    self.rightIconView.alpha = 0
                    
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        self.messageView.center.x = 480
                        self.leftIconView.alpha = 0
                        }) { (Bool)  -> Void in
                            
                            UIView.animateWithDuration(0.4, animations: { () -> Void in
                                self.feedImageView.center.y = self.initialFeedCenter.y - 85
                            })
                        }
                    }
            }
    }
    
    @IBAction func onTapRescheduler(sender: UITapGestureRecognizer) {print ("You tapped the origin-yellow rescheduler screen so I'm going to hide the reschedule screen, then animate hiding the message from below, moving the feed up over it, then bringing the message image back to center, and then revealing the container by moving the feed back down below it.")
        
        rescheduleOverlayView.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.feedImageView.center.y = self.initialFeedCenter.y - 85
            }) { (Bool) -> Void in
                [self.messageView.center.x = self.initialCenter.x,
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.feedImageView.center.y = self.initialFeedCenter.y
                })
                ]
            }
    }
    
    @IBAction func onTapListView(sender: UITapGestureRecognizer) {print ("You tapped the origin-brown list screen so I'm going to hide the list screen, then animate hiding the message from below, moving the feed up over it, then bringing the message image back to center, and then revealing the container by moving the feed back down below it.")
        
        listOverlayView.alpha = 0
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.feedImageView.center.y = self.initialFeedCenter.y - 85
            }) { (Bool) -> Void in
                [self.messageView.center.x = self.initialCenter.x,
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.feedImageView.center.y = self.initialFeedCenter.y
                    })
                ]
        }
    }
}

