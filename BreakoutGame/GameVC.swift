//
//  GameVC.swift
//  BreakoutGame
//
//  Created by Игорь on 24.12.16.
//  Copyright © 2016 Игорь. All rights reserved.
//

import UIKit

class GameVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var gameView: BreakoutView!{
        didSet {
            // let moveGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moveRacket))
            let pushBallGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(launchBall))
            // moveGestureRecognizer.delegate = self
            pushBallGestureRecognizer.delegate = self
            //gameView.addGestureRecognizer(moveGestureRecognizer)
            gameView.addGestureRecognizer(pushBallGestureRecognizer)
            gameView.overallBehavior.hitBlock = self.ballHitBlock
            gameView.overallBehavior.moveBlock = self.moveBlock
        }
    }
    
    
    func moveRacket(recognizer: UILongPressGestureRecognizer) {
        
        
        recognizer.minimumPressDuration = 0
        
        if recognizer.state == .began {
            if recognizer.location(in: gameView).x > gameView.bounds.width/2 {
                gameView.moveRacketRight()
            }
            if recognizer.location(in: gameView).x < gameView.bounds.width/2 {
                gameView.moveRacketLeft()
            }
        }
        if recognizer.state == .ended {
            gameView.MoveTimer?.invalidate()
        }
    }
    
    func launchBall(recognizer: UIPanGestureRecognizer) {
        recognizer.maximumNumberOfTouches = 1
        if recognizer.state == .ended && recognizer.translation(in: gameView).y > 0  {
            let touchPoint = recognizer.location(in: gameView)
            let resultAngle = gameView.ball.frame.origin - touchPoint
            if resultAngle.angle > Constanst.maxLeftAngle && resultAngle.angle < Constanst.maxRightAngle {
                gameView.pushBall(magnitude: 0.2, angle: resultAngle.angle)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameView.addBlocks()
        //  gameView.addRacket()
        gameView.addBall()
        gameView.animating = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameView.animating = false
    }
    
    func ballHitBlock(_ behaviour: UICollisionBehavior, _ ball: UIView, _ blockIndex: Int)
    {
        gameView.removeBlockFromGame(index: blockIndex)
    }
    
    func moveBlock(_ behaviour: UICollisionBehavior) {
        gameView.moveBlocksDown()
    }
    
    struct Constanst {
        static let maxLeftAngle: CGFloat = 0.2
        static let maxRightAngle: CGFloat = 3
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
