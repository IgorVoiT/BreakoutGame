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
    private var ball : UIView = UIView()
    
    private var blockSize: CGSize {
        let size = bounds.size.width / CGFloat(maxBlocksPerRow)
        return CGSize(width: size, height: size)
    }
    
    let overallBehavior = GameObjectsBehavior()
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
    var MoveTimer : Timer? = nil
    
    var blocks = [Int : UIView]()
    
    private let totalBlocks = 35
    private let maxBlocksPerRow = 14
    private let spaceForBlock = CGFloat(4)
    
    func addBlocks() {
        
        let startingSpaceForX = CGFloat((Double(bounds.size.width) - (Double(maxBlocksPerRow - 2) * Double(blockSize.width))) - Double(maxBlocksPerRow - 2))/2
        var xPositionCounter: CGFloat = startingSpaceForX
        var yPositionCounter: CGFloat = 0
        var rowCounter: CGFloat = 1
        var blocksCounter = totalBlocks
        
        while blocksCounter > 0 {
            if xPositionCounter >= bounds.size.width - startingSpaceForX - rowCounter * blockSize.width {
                yPositionCounter = (blockSize.height * rowCounter) + spaceForBlock * rowCounter
                xPositionCounter = blockSize.width * rowCounter + startingSpaceForX + rowCounter
                rowCounter += 1
            }
            
            var blockFrame = CGRect(origin: .zero, size: blockSize)
            blockFrame.origin.x = xPositionCounter
            blockFrame.origin.y = yPositionCounter
            xPositionCounter += blockSize.width + spaceForBlock
            
            let block = UIView()
            block.frame = blockFrame
            block.backgroundColor = UIColor.black
            
            blocks.updateValue(block, forKey: blocksCounter)
            overallBehavior.addBoundary(boundary: UIBezierPath(rect: block.frame), name: String(blocksCounter))
            
            addSubview(block)
            
            blocksCounter -= 1
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
        let ballSize = CGSize(width: 14, height: 14)
        let ballOrigin = CGPoint(x: bounds.width/2 - ballSize.width/2, y: bounds.height - (4 * ballSize.height))
        ball.frame = CGRect(origin: ballOrigin, size: ballSize)
        ball.layer.cornerRadius = 7
        ball.backgroundColor = UIColor.darkGray
        
        
        overallBehavior.addBallBehavior(item: ball)
        addSubview(ball)
    }
    
    func pushBall(magnitude: CGFloat, angle: CGFloat) {
        if !ballIsLaunched {
            overallBehavior.launchBall(ball: ball, magnitude: 0.2, angle: 1)
        }
    }
    
    func addRacket()  {
        
        let size = CGSize(width: blockSize.width * 5, height: blockSize.height)
        let origin = CGPoint(x: bounds.width/2 - size.width/2, y: bounds.height - size.height - 20)
        let boundary = UIBezierPath(rect: CGRect(origin: origin, size: size))
        
        racket.frame = CGRect(origin: origin, size: size)
        racket.backgroundColor = UIColor.brown
        overallBehavior.addBoundary(boundary: boundary, name: "racket")
        
        addSubview(racket)
    }
    
    func moveRacketLeft() {
        MoveTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            if (self.racket.frame.origin.x >= 0) {
                self.racket.frame.origin = CGPoint(x: self.racket.frame.origin.x - 5, y: self.racket.frame.origin.y)
                self.overallBehavior.addBoundary(boundary: UIBezierPath.init(rect: self.racket.frame), name: "racket")
            }
        })
        
    }
    
    func moveRacketRight() {
        MoveTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer: Timer) in
            if (self.racket.frame.origin.x + self.racket.frame.size.width <= self.bounds.width) {
                self.racket.frame.origin = CGPoint(x: self.racket.frame.origin.x + 5, y: self.racket.frame.origin.y)
                self.overallBehavior.addBoundary(boundary: UIBezierPath.init(rect: self.racket.frame), name: "racket")
            }
        })
    }
    
}
