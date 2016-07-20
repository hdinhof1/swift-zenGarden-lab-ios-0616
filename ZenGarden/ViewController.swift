//
//  ViewController.swift
//  ZenGarden
//
//  Created by Flatiron School on 6/30/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageViews: [UIImageView]!
        @IBOutlet weak var rakeImage: UIImageView!
        @IBOutlet weak var rockImage: UIImageView!
        @IBOutlet weak var shrubImage: UIImageView!
        @IBOutlet weak var swordImage: UIImageView!
    
    
    var currentTouchLocation : CGPoint?
    
    var rakeLeftConstraint: NSLayoutConstraint?
    var rakeTopConstraint: NSLayoutConstraint?
    
    var rockLeftConstraint: NSLayoutConstraint?  // <---
    var rockTopConstraint: NSLayoutConstraint?
    
    var shrubLeftConstraint: NSLayoutConstraint?
    var shrubTopConstraint: NSLayoutConstraint?
    
    var swordLeftConstraint: NSLayoutConstraint?
    var swordTopConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.removeConstraints(self.view.constraints)
        setConstraints()
        
       


        let dragRakeRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(draggingRake))
        self.rakeImage.addGestureRecognizer(dragRakeRecognizer)
        
        let dragRock = UIPanGestureRecognizer.init(target:self , action: #selector(draggingRock))
        self.rockImage.addGestureRecognizer(dragRock)

        let dragShrubRecognizer = UIPanGestureRecognizer.init(target:self, action: #selector(draggingShrub))
        self.shrubImage.addGestureRecognizer(dragShrubRecognizer)
        
        let dragSwordRecognizer = UIPanGestureRecognizer.init(target:self, action: #selector(draggingSword))
        self.swordImage.addGestureRecognizer(dragSwordRecognizer)
        
       print(self.rockImage.gestureRecognizers)
    }
    func draggingRake(recognizer: UIPanGestureRecognizer) {
        
        
        draggingImage(image          : self.rakeImage,
                      topConstraint  : rakeTopConstraint,
                      leftConstraint : rakeLeftConstraint,
                      recognizer     : recognizer)
    }
    
    
    func draggingRock(recognizer:UIPanGestureRecognizer) {
        draggingImage(image: self.rockImage, topConstraint: rockTopConstraint, leftConstraint: rockLeftConstraint, recognizer: recognizer)
    }
    func draggingShrub(recognizer:UIPanGestureRecognizer) {
        draggingImage(image: self.shrubImage, topConstraint: shrubTopConstraint, leftConstraint: shrubLeftConstraint, recognizer: recognizer)
    }
    func draggingSword(recognzier:UIPanGestureRecognizer) {
        draggingImage(image: self.swordImage, topConstraint: swordTopConstraint, leftConstraint: swordLeftConstraint, recognizer: recognzier)
    }
    
    func draggingImage(image image:UIImageView, topConstraint: NSLayoutConstraint?, leftConstraint: NSLayoutConstraint?, recognizer:UIPanGestureRecognizer) {
        print("registering drag")
        let coordinates = recognizer.translationInView(image)       //also .translationInView(self.view) works
        print(coordinates)
        
        if recognizer.state == .Began {
//            print("Beginning")
            self.currentTouchLocation = coordinates
        } else {
//            print("Did end")
            if let currentTouchLocation = self.currentTouchLocation {
                let diffY = coordinates.y - currentTouchLocation.y
                let diffX = coordinates.x - currentTouchLocation.x
                
                topConstraint?.constant += diffY
                leftConstraint?.constant += diffX
                self.currentTouchLocation = coordinates
                
//                print(topConstraint?.constant)
//                print(coordinates)
//                
                // Compute width and height of the area to contain the image's center
                // xwidth = xValuesWithinRangeOfScreenSoWontGoOutOfBounds
                //        let xwidth = viewWidth - image.frame.width
                //        let yheight = viewHeight - image.frame.height

                
                checkSolution(image)
            }
        }

    } 
    func checkSolution(image: UIImageView) {
        var swordGood = false
        var nearEachother = false
        var opposingHalves = false
        
        
        let viewWidth = UIScreen.mainScreen().bounds.width
        let viewHeight = UIScreen.mainScreen().bounds.height
        
        
        let centerX = viewWidth / 2
        let centerY = viewHeight / 2
        
        
        
        //sword should be in top left or bottom left
        //top left or bottom left = left half of screen
        if self.swordImage.center.x < centerX {
            print("Sword is good")
            swordGood = true
        }
        
        //shrub and rake should be near each other
        //Check if shrub and rake are overlapping
        if let overlap = detectOverlap(image) {
            print ("\(image.accessibilityIdentifier!) overlaps with the \(overlap.accessibilityIdentifier!)!")
            nearEachother = true
        }
        
        
        
        //rock needs to be on a different North/South half of the screen as King Arthur's sword
        //rock top, sword bottom
        if self.rockImage.center.y < centerY {
            if self.swordImage.center.y > centerY {
                print("Rock top, sword bottom")
                opposingHalves = true
            }
        }
        
        //rock bottom, sword top
        if self.rockImage.center.y > centerY {
            if self.swordImage.center.y < centerY {
                print("Rock bottom, sword top")
                opposingHalves = true
            }
        }
        
        if swordGood && nearEachother && opposingHalves {
            let alertController = UIAlertController(title: "ZenGarden", message: "You won the zen garden!", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
                print("YOU DID IT!")
//                self.scatterItems()
            }
            
            alertController.addAction(dismissAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    //func detectOverlap(imageMoving: UIImageView) -> (Bool, UIImageView?) {
//        var detected : (isOverlapping: Bool, overlappingFrame:UIImageView?) = (false, nil)
//        for image in self.imageViews {
//            if(CGRectIntersectsRect(imageMoving.frame, image.frame)) {
//                
//                detected = (true, image)
//            }
//        }
//    }
    
    
    func setConstraints() {
        
        for image in self.imageViews {
            image.removeConstraints(image.constraints)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.userInteractionEnabled = true
            image.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier:0.25).active = true
            image.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.25).active = true
            
        }
        
        self.rakeTopConstraint = self.rakeImage.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 50)
        self.rakeTopConstraint?.active = true
        self.rakeLeftConstraint = self.rakeImage.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor, constant: 40)
        self.rakeLeftConstraint?.active = true
        
        
        self.rockTopConstraint =  self.rockImage.topAnchor.constraintEqualToAnchor(self.view.centerYAnchor)
        self.rockTopConstraint?.active = true
        self.rockLeftConstraint = self.rockImage.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor, constant: 50)
        self.rockLeftConstraint?.active=true
        
        
        self.shrubLeftConstraint = self.shrubImage.leftAnchor.constraintEqualToAnchor(self.view.rightAnchor, constant: -150)
        self.shrubLeftConstraint?.active = true
        self.shrubTopConstraint = self.shrubImage.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 50)
        self.shrubTopConstraint?.active = true
        
        
        self.swordLeftConstraint = self.swordImage.leftAnchor.constraintEqualToAnchor(self.view.rightAnchor, constant: -150)
        self.swordLeftConstraint?.active = true
        self.swordTopConstraint = self.swordImage.topAnchor.constraintEqualToAnchor(self.view.centerYAnchor)
        self.swordTopConstraint?.active = true
        
        self.rockImage.accessibilityIdentifier = "rockImage"
        self.rakeImage.accessibilityIdentifier = "rakeImage"
        self.shrubImage.accessibilityIdentifier = "shrubImage"
        self.swordImage.accessibilityIdentifier = "swordImage"
    }
    
    func detectOverlap(imageMoving: UIImageView) -> UIImageView? {
        var detected : UIImageView? = nil
        for image in self.imageViews {
            if image.accessibilityIdentifier == imageMoving.accessibilityIdentifier {
                continue
            }
            
            if CGRectIntersectsRect(imageMoving.frame, image.frame) {
                if imageMoving.accessibilityIdentifier == "shrubImage" || imageMoving.accessibilityIdentifier == "rakeImage" {
                    if image.accessibilityIdentifier  == "shrubImage" || image.accessibilityIdentifier == "rakeImage" {
                        detected = image
                    }
                }
            }
        }
        return detected
    }
}