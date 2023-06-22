//
//  MenuScene.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
//

import SpriteKit
import UIKit


class MenuScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 15/255, green: 33/255, blue: 46/255, alpha: 1.0)
        layoutScene()
        playbuttonFunc()
        blackjackpng()
        
        //for family: String in UIFont.familyNames{
        //    print(family)
        //}
    }

    var playRec : SKShapeNode!
    var playbutton : SKLabelNode!
    var CoinsValue = 500
    let fadeAction = SKAction.fadeAlpha(to: 0.1, duration: 0.2)
    let pressedAction = SKAction.scale(to: 0.7, duration: 0.3)
    let RectPressedAction = SKAction.scale(to: CGSize(width: 95, height: 45), duration: 0.3)
    func UserCoins(){
        UserDefaults.standard.setValue(CoinsValue, forKey: "UserCoins")

    }
    
    func layoutScene(){
        //var backgroundsTextures : [SKTexture] = []
        //for i in 1...6 {
        //    backgroundsTextures.append(SKTexture(imageNamed:"background\(i)"))
        //}
        //let backgroundAnimation = SKAction.animate(with: backgroundsTextures,timePerFrame: 0.08)
        //let background = SKSpriteNode(imageNamed: "background1")
        //background.size = CGSize(width: frame.maxX, height: frame.maxY)
        //let backgroundInfinite = SKAction.repeatForever(backgroundAnimation)
        //background.position = CGPoint(x : frame.midX,y: frame.midY)
        //background.run(backgroundInfinite)
        
        let rect = SKShapeNode(rectOf: CGSize(width: frame.maxX, height: frame.midY))
        rect.position = CGPoint(x: frame.midX, y: frame.minY)
        rect.fillColor = UIColor(red: 33/255, green: 55/255, blue: 67/255, alpha: 1.0)
        rect.strokeColor = UIColor(red: 33/255, green: 55/255, blue: 67/255, alpha: 1.0)
        addChild(rect)
    }
    
    func playbuttonFunc(){
        
        let Playpos = CGPoint(x:frame.midX, y: frame.midY - 100)
        
        playbutton = SKLabelNode(fontNamed:"TextaW00-Heavy")
        playRec = SKShapeNode(rect: CGRect(x: frame.midX-52.5, y: frame.midY-112, width: 105, height: 50),cornerRadius: 5)
        playRec.name = "rectbutton" 
        playRec.fillColor = UIColor(red: 4/255, green: 123/255, blue: 251/255, alpha: 1.0)
        playRec.strokeColor = UIColor(red: 4/255, green: 123/255, blue: 251/255, alpha: 1.0)
        playRec.name = "playrectangle"
        playbutton.text = "PLAY"
        playbutton.name = "playbutton"
        playbutton.position = Playpos
        playbutton.zPosition = 1
        playbutton.fontSize = 32
        //let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.6)
        //let scaleDownAction = SKAction.scale(to: 1, duration: 0.6)
        //let waitAction = SKAction.wait(forDuration: 0.2)
        //let scaleActionSequence = SKAction.sequence([scaleUpAction, scaleDownAction, waitAction])
        //let repeatAction = SKAction.repeatForever(scaleActionSequence)
        //playbutton.run(repeatAction)
        addChild(playbutton)
        addChild(playRec)
    }
    
    func playerCoins(){
        //let coins = SKLabelNode(fontNamed:"Rust")
        //var CoinsText = UserDefaults.value(forKey: "UserCoins")
        //coins.text = CoinsText
    }
    func blackjackpng(){
        let blackjackText = SKLabelNode(fontNamed:"TextaW00-Heavy")
        blackjackText.xScale = 0.65
        blackjackText.yScale = 0.65
        blackjackText.text = "BLACKJACK.IO"
        blackjackText.position = CGPoint(x:frame.midX, y: frame.midY + 155)
        blackjackText.zPosition = 1
        let fade = SKAction.fadeAlpha(to: 0.1, duration: 0)
        let fadein = SKAction.fadeIn(withDuration: 1.2)
        let scaleup = SKAction.scale(to: 1, duration: 1.2)
        addChild(blackjackText)
        blackjackText.run(scaleup)
        blackjackText.run(SKAction.sequence([fade,fadein]))
    }
    
    func startgame(){
        let gameScene = GameScene(size: view!.bounds.size)
        let reveal = SKTransition.reveal(with: .left, duration: 0.1)
        gameScene.scaleMode = .aspectFill
        view!.presentScene(gameScene,transition: reveal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        let fadeOut = SKAction.sequence([  SKAction.run{(self.playRec.run(self.fadeAction))},SKAction.run {
            (self.playRec.run(self.RectPressedAction))
        },  SKAction.run{(self.playbutton.run(self.fadeAction))}, SKAction.run{(self.playbutton.run(self.pressedAction))} ])
        let waitAnimation = SKAction.wait(forDuration: 0.2)
        let SwitchScene = SKAction.run{(self.startgame())}
        let PressedbuttoN = SKAction.sequence([fadeOut,waitAnimation,SwitchScene])
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "playrectangle"{
                    node.run(PressedbuttoN)
                }
            }
        }
    }
}
