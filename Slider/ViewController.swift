//
//  ViewController.swift
//  Slider
//
//  Created by Wysa on 16/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sliderBackgroundView: UIView!
    @IBOutlet weak var sliderFilledView: UIView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var overlayHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var overlayBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderFilledViewHeight: NSLayoutConstraint!
    
    var prevPointForImageView: CGPoint = .zero
    var currPointForImageView: CGPoint = .zero
    var lastNonZeroValueForImageView: CGFloat = 0
    
    var prevPointForOverlayView: CGPoint = .zero
    var currPointForOverlayView: CGPoint = .zero
    var lastNonZeroValueForOverlayView: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        overlayView.alpha = 0.8
        overlayView.backgroundColor = .black
        
        sliderBackgroundView.alpha = 1
        sliderBackgroundView.isOpaque = true
        sliderBackgroundView.backgroundColor = .white
        
        sliderFilledView.backgroundColor = .blue
        
        sliderFilledViewHeight.constant = 0
        overlayHeightConstraint.constant = UIScreen.main.bounds.height
        overlayBottomConstraint.constant = -overlayHeightConstraint.constant
        
        let imagePanGesture = UIPanGestureRecognizer(target: self, action: #selector(addPanGestureToImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imagePanGesture)
        
        let overlayPanGesture = UIPanGestureRecognizer(target: self, action: #selector(addPanGestureToOverlay))
        overlayView.isUserInteractionEnabled = true
        overlayView.addGestureRecognizer(overlayPanGesture)
        
        let sliderPanGesture = UIPanGestureRecognizer(target: self, action: #selector(addPanGestureToSlider))
        sliderBackgroundView.isUserInteractionEnabled = true
        sliderBackgroundView.addGestureRecognizer(sliderPanGesture)
        
        let sliderTapGesture = UITapGestureRecognizer(target: self, action: #selector(addTapGestureToSlider))
        sliderBackgroundView.isUserInteractionEnabled = true
        sliderBackgroundView.addGestureRecognizer(sliderTapGesture)
        
    }
    
    @objc func addPanGestureToImage(_ sender: UIPanGestureRecognizer) {
        
        let point: CGPoint = sender.location(in: imageView)
        if sender.state == .began {
            prevPointForImageView = point
        }
        currPointForImageView = point
        let diffAlongY = currPointForImageView.y - prevPointForImageView.y
        overlayBottomConstraint.constant -= diffAlongY
        if overlayBottomConstraint.constant > 0 {
            overlayBottomConstraint.constant = 0
        }
        if diffAlongY != 0 {
            lastNonZeroValueForImageView = diffAlongY
        }
        if sender.state == .ended {
            overlayBottomConstraint.constant = lastNonZeroValueForImageView < 0 ? 0 : -overlayHeightConstraint.constant
        }
        prevPointForImageView = point
    }
    
    @objc func addPanGestureToOverlay(_ sender: UIPanGestureRecognizer) {
        
        let point: CGPoint = sender.location(in: imageView)
        if sender.state == .began {
            prevPointForOverlayView = point
        }
        currPointForOverlayView = point
        let diffAlongY = currPointForOverlayView.y - prevPointForOverlayView.y
        print(diffAlongY)
        overlayBottomConstraint.constant -= diffAlongY
        if overlayBottomConstraint.constant > 0 {
            overlayBottomConstraint.constant = 0
        }
        if diffAlongY != 0 {
            lastNonZeroValueForOverlayView = diffAlongY
        }
        if sender.state == .ended {
            overlayBottomConstraint.constant = lastNonZeroValueForOverlayView < 0 ? 0 : -overlayHeightConstraint.constant
        }
        prevPointForOverlayView = point
    }
    
    @objc func addTapGestureToSlider(_ sender: UITapGestureRecognizer) {
        
        let point: CGPoint = sender.location(in: sliderBackgroundView)
        sliderFilledViewHeight.constant = sliderBackgroundView.bounds.height - point.y
        setPercentLabel()
    }
    
    @objc func addPanGestureToSlider(_ sender: UIPanGestureRecognizer) {
        
        let point: CGPoint = sender.location(in: sliderBackgroundView)
        sliderFilledViewHeight.constant = sliderBackgroundView.bounds.height - point.y
        if sliderFilledViewHeight.constant > sliderBackgroundView.bounds.height {
            sliderFilledViewHeight.constant = sliderBackgroundView.bounds.height
        }
        else if sliderFilledViewHeight.constant < 0 {
            sliderFilledViewHeight.constant = 0
        }
        setPercentLabel()
    }
    
    private func setPercentLabel() {
        
        let percentValue = sliderFilledViewHeight.constant * 100.0 / sliderBackgroundView.bounds.height
        let percent = Int(round(percentValue))
        percentageLabel.text = "\(percent) %"
        percentageLabel.layer.zPosition = 2
    }
    
}

