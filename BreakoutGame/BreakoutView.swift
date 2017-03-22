//
//  BreakoutView.swift
//  BreakoutGame
//
//  Created by Игорь on 24.12.16.
//  Copyright © 2016 Игорь. All rights reserved.
//

import UIKit

class BreakoutView: UIView {
    
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    private var racket : UIView = UIView()
    var ball : UIView = UIView()
    
    let overallBehavior = GameObjectsBehavior()
    
    var MoveTimer : Timer? = nil
    var blocks = [Int : UIView]()
    var ballIsLaunched: Bool = false
    var animating: Bool  = false {
        didSet {
            if animating {
                animator.addBehavior(overallBehavior)
            } else {
                animator.removeBehavior(overallBehavior)
            }
        }
    }
    
    
    private var blockSize: CGSize {
        let size = (bounds.size.width - (bounds.size.width/10)) / CGFloat(maxBlocksPerRow)
        return CGSize(width: size, height: size)
    }
    private let totalBlocks = 48
    private let maxBlocksPerRow = 12
    private var spaceForBlock: CGFloat {
        return CGFloat((bounds.size.width/10)/CGFloat(maxBlocksPerRow + 1))
    }
    
    func addBlocks() {
        
        var xPositionCounter: CGFloat = spaceForBlock
        var yPositionCounter: CGFloat = spaceForBlock
        var rowCounter: CGFloat = 1
        var blocksCounter = totalBlocks
        
        while blocksCounter > 0 {
            if blocksCounter%maxBlocksPerRow == 0 {
                yPositionCounter = (blockSize.height * rowCounter) + (spaceForBlock * rowCounter)
                xPositionCounter = spaceForBlock
                rowCounter += 1
            }
            
            var blockFrame = CGRect(origin: .zero, size: blockSize)
            blockFrame.origin.x = xPositionCounter
            blockFrame.origin.y = yPositionCounter
            xPositionCounter += blockSize.width + spaceForBlock
            
            let block = UIView()
            block.frame = blockFrame
            block.backgroundColor = UIColor.brown
            
            blocks.updateValue(block, forKey: blocksCounter)
            overallBehavior.addBoundary(boundary: UIBezierPath(rect: block.frame), name: String(blocksCounter))
            addBottomBoundary()
            
            addSubview(block)
            
            blocksCounter -= 1
        }
    }
    
    
    func moveBlocksDown() {
        for block in blocks {
            UIView.animate(withDuration: 0.3, animations: {
                block.value.frame.origin.y = block.value.frame.origin.y + self.blockSize.height
            })
            overallBehavior.addBoundary(boundary: UIBezierPath(rect: block.value.frame), name: String(block.key))
        }
    }
    
    
    func removeBlockFromView(block: UIView) {
        UIView.animate(withDuration: 0.5, animations:{
            block.backgroundColor = UIColor.white
        },
            completion: {(success) in
                if success {
                    block.removeFromSuperview()
                }
        })
    }
    
    
    func removeBlockFromGame(index: Int) {
        overallBehavior.removeBoundary(name: String(index))
        if let block = blocks[index] {
            blocks.removeValue(forKey: index)
            removeBlockFromView(block: block)
        }
    }
    
    func addBall() {
        let ballSize = CGSize(width: 12, height: 12)
        let ballOrigin = CGPoint(x: bounds.width/2 - ballSize.width/2, y: bounds.height - (4 * ballSize.height))
        ball.frame = CGRect(origin: ballOrigin, size: ballSize)
        ball.layer.cornerRadius = 6
        ball.backgroundColor = UIColor.orange
        
        overallBehavior.addBallBehavior(item: ball)
        addSubview(ball)
    }
    
    func pushBall(magnitude: CGFloat, angle: CGFloat) {
        //if !ballIsLaunched {
        overallBehavior.launchBall(ball: ball, magnitude: 0.10, angle: angle)
        //}
    }
    
    func addRacket()  {
        
        let size = CGSize(width: blockSize.width * 5, height: blockSize.height)
        let origin = CGPoint(x: bounds.width/2 - size.width/2, y: bounds.height - size.height - 20)
        let boundary = UIBezierPath(rect: CGRect(origin: origin, size: size))
        
        racket.frame = CGRect(origin: origin, size: size)
        racket.backgroundColor = UIColor.brown
        overallBehavior.addBoundary(boundary: boundary, name: Constants.racketBoundary)
        
        addSubview(racket)
    }
    
    func moveRacketLeft() {
        MoveTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            if (self.racket.frame.origin.x >= 0) {
                self.racket.frame.origin = CGPoint(x: self.racket.frame.origin.x - 5, y: self.racket.frame.origin.y)
                self.overallBehavior.addBoundary(boundary: UIBezierPath.init(rect: self.racket.frame), name: Constants.racketBoundary)
            }
        })
    }
    
    func moveRacketRight() {
        MoveTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            if (self.racket.frame.origin.x + self.racket.frame.size.width <= self.bounds.width) {
                self.racket.frame.origin = CGPoint(x: self.racket.frame.origin.x + 5, y: self.racket.frame.origin.y)
                self.overallBehavior.addBoundary(boundary: UIBezierPath.init(rect: self.racket.frame), name: Constants.racketBoundary)
            }
        })
    }
    
    func addBottomBoundary() {
        overallBehavior.addBoundary(boundary: UIBezierPath.init(rect: CGRect(x: 0, y: self.bounds.maxY, width: self.bounds.width, height: 1)), name: Constants.bottomBoundry)
    }
    
    struct Constants {
        static let bottomBoundry = "Bottom Display Boundary"
        static let racketBoundary = "Racket Boundary "
        
    }
    
}
