//
//  ViewController.swift
//  UIViewAnimationPropertyDemo
//
//  Created by Thomas Kalhøj Clemensen on 25/08/2017.
//  Copyright © 2017 Trifork A/S. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rocket: UILabel!
    @IBOutlet weak var rocketBottomConstraint: NSLayoutConstraint!
    
    private var tap: UITapGestureRecognizer?
    private var pan: UIPanGestureRecognizer?
    
    private var launchingAnimator: UIViewPropertyAnimator?
    private var vibratingAnimator: UIViewPropertyAnimator?
    
    private var didSetupLayout: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(_:)))
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.pan(_:)))
        self.rocket.addGestureRecognizer(tap)
        self.rocket.addGestureRecognizer(pan)
        self.rocket.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4.0)
        self.tap = tap
        self.pan = pan
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.didSetupLayout {
            self.didSetupLayout = true
            
            let gradientLayer: CAGradientLayer = CAGradientLayer()
            gradientLayer.frame = self.view.bounds
            gradientLayer.colors = [UIColor.black.cgColor, UIColor.blue.cgColor, UIColor.green.cgColor]
            gradientLayer.locations = [0.3, 0.8, 1.0]
            self.view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func tap(_ sender: UITapGestureRecognizer) {
        
        if self.launchingAnimator == nil {
            self.launchingAnimator = UIViewPropertyAnimator(duration: 3.0, curve: .easeIn, animations: {
                self.rocketBottomConstraint.constant = self.view.bounds.height
                self.view.layoutIfNeeded()
            })
            self.launchingAnimator?.startAnimation()
        }
    }

    func pan(_ sender: UIPanGestureRecognizer) {
        let point: CGPoint = sender.location(in: self.view)
        switch sender.state {
        case .began:
            self.launchingAnimator?.pauseAnimation()
            self.vibratingAnimator?.startAnimation()
        case .changed:
            self.launchingAnimator?.fractionComplete = ((self.view.bounds.height - point.y - self.rocket.bounds.height/2.0) / self.view.bounds.height)
        case .ended, .cancelled:
            self.launchingAnimator?.startAnimation()
            self.vibratingAnimator?.pauseAnimation()
        default:
            break
        }
    }
}

