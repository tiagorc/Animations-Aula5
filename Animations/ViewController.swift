//
//  ViewController.swift
//  Animations
//
//  Created by Euler Carvalho on 31/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            animator = UIDynamicAnimator(referenceView: containerView)
            
            behaviour = CustomBehaviour()
            
            guard let behaviour = behaviour else { return }
            animator?.addBehavior(behaviour)
        }
    }
    @IBOutlet weak var countDownLabel: UILabel!
    
    private var squares: [UIView] = []
    private var animator: UIDynamicAnimator?
    private var behaviour: CustomBehaviour?
    
    private let interval: Int = 30
    private var timerCount: Int = 30 {
        didSet {
            countDownLabel.text = "\(timerCount) seconds remaining..."
        }
    }
    
    weak var timer: Timer?
    
    func randomColor() -> UIColor {
        let red = CGFloat(arc4random() % 255) / 255
        let green = CGFloat(arc4random() % 255) / 255
        let blue = CGFloat(arc4random() % 255) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTapGesture()
        setupTimer()
    }
    
    fileprivate func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnContainer(_:)))
        containerView.addGestureRecognizer(tap)
    }
    
    fileprivate func setupTimer() {
        countDownLabel.text = ""
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownTimer), userInfo: nil, repeats: true)
        
        guard let timer = timer else { return }
        
        RunLoop.main.add(timer, forMode: .default)
        
        timer.fire()
    }
    
    @objc func updateCountdownTimer() {
        timerCount -= 1
        
        if timerCount <= 0 {
            explodeItAll()
        }
    }
    
    @objc func tapOnContainer(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: containerView)
        generateSquare(origin: touchPoint, mustRespectX: true)
    }

    @IBAction func explodeAction(_ sender: Any) {
        explodeItAll()
    }
    
    @IBAction func squareAction(_ sender: Any) {
        generateSquare()
    }

    func generateSquare(origin: CGPoint = .zero, mustRespectX: Bool = false) {
        let side: CGFloat = 20.0
        var frame = CGRect(x: origin.x, y: origin.y, width: side, height: side)
        
        if !mustRespectX {
            let originX = arc4random() % UInt32(containerView.bounds.size.width)
            frame.origin.x = CGFloat(originX)
        }
        
        let square = UIView(frame: frame)
        square.backgroundColor = randomColor()
        containerView.addSubview(square)
        
        squares.append(square)
        
        behaviour?.add(square)
    }
    
    private func explodeItAll() {
        guard !squares.isEmpty else { return }
        
        timerCount = interval
        
        squares.forEach({behaviour?.remove($0)})
        
        for square in self.squares {
            UIView.animate(withDuration: 0.001) {
                square.frame.origin.x = self.containerView.center.x
                square.frame.origin.y = self.containerView.bounds.height - square.frame.height
            } completion: { (_) in
                UIView.animate(withDuration: 0.5) {
                    for square in self.squares {
                        square.frame.origin.x = self.containerView.center.x
                        let x = arc4random() % UInt32(self.containerView.bounds.size.width * 5) % UInt32(self.containerView.bounds.size.width)
                        let y = self.containerView.bounds.size.height
                        square.center = CGPoint(x: CGFloat(x), y: -y)
                    }
                } completion: { _ in
                    self.squares.forEach({$0.removeFromSuperview()})
                    self.squares.removeAll()
                }
            }
        }
    }
}
