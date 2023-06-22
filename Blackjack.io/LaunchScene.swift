//
//  LaunchScene.swift
//  Blackjack.io
//
//  Created by Jules Sainthorant on 08/01/2022.
//
import UIKit
import Foundation
import SpriteKit
import AVFoundation
class LaunchScreen: SKScene{
    override func didMove(to view: SKView) {
        defaults.register(defaults: [
            "FIRSTEVERLAUNCH" : true,
            "UserCoins" : 0,
            "Slot1LockState" : false,
            "Slot2LockState"  : true,
            "Slot3LockState"  : true,
            "Slot4LockState"  : true,
            "Slot5LockState"  : true,
            "Slot6LockState"  : true,
            "Slot7LockState"  : true,
            "Slot8LockState"  : true,
            "Slot9LockState"  : true,
            
            "SlotChecked" : "Slot1",
            "Slot1Checked" : true,
            "Slot2Checked" : false,
            "Slot3Checked" : false,
            "Slot4Checked" : false,
            "Slot5Checked" : false,
            "Slot6Checked" : false,
            "Slot7Checked" : false,
            "Slot8Checked" : false,
            "Slot9Checked" : false,
            "SkinSelected" : "back basicblue",
            "DeckSelected" : "deck",
            "PlayColor" : "basicblue",
            "LevelNeeded" : 5,
            "CoinsBonus" : 0,
            
            "GamesPlayed" : 0,
            "LastGameCoins" : 0,
            "LastGameExp" : 0,
            "GameWon" : 0,
            "GameLost" : 0,
            "Blackjacks" : 0
            
        ])
        defaults.set(false, forKey: "MUSICEVERLAUNCHED")
        print("MAX Y \(frame.maxY)" )
        defaults.set(true, forKey: "FirstLaunch")
        LaunchNodes()
        Loading()
        if defaults.bool(forKey: "FIRSTEVERLAUNCH") == true {
            StartPlayerData()
        }
        defaults.set(false, forKey: "LastGameVictory?")

    }
    
    func startgame(){
        let Menuscene = MenuScene(size: view!.bounds.size)
        let f = SKTransition.moveIn(with: SKTransitionDirection.down, duration: 0.6)
        Menuscene.scaleMode = .aspectFill
        let switche = SKAction.run{self.view!.presentScene(Menuscene,transition: f)}
        run(SKAction.sequence([SKAction.wait(forDuration: 1.8),switche]))
    }
    
    
    var LoadingState = 0
    var outerRect : SKShapeNode!
    var rect : SKShapeNode!
    public let defaults = UserDefaults.standard


    func LaunchNodes(){
  
        
        backgroundColor = UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1.0)
        

        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        let title = SKLabelNode(fontNamed: "TextaW00-Heavy")
        title.text = "BLACKJACK.IO"
        title.fontSize = 45
        title.position = CGPoint(x: frame.midX, y: 1.95*(frame.maxY/3))
        title.zPosition = 4
        
        let title2 = SKLabelNode(fontNamed: "ElanorFreePersonalUse-ExBdIt")
        title2.text = "JULORAPIDO"
        title2.fontSize = 45
        title2.position = CGPoint(x: frame.midX, y: 1.25*(frame.maxY/3))
        title.zPosition = 4
 
        let gameover = SKSpriteNode(texture: SKTexture(imageNamed: "gameover"))
        gameover.position = CGPoint(x: frame.midX, y: 0.85*(frame.maxY/3))
        gameover.yScale = 0.22
        gameover.xScale = 0.22
        
        addChild(gameover)
        addChild(title)
        addChild(title2)

    }
    
    
    
    
    
    
    
    func Loading(){
        var leftnumber = 0
        var multiplicator = 1
        var familyList = ["CARREAU", "COEUR", "PIC", "TREFLE"]
        var index = 0
        var Renderedlist = [SKTexture]()
        for i in 1...52{
            if i > 4 * multiplicator {
                multiplicator += 1
                index = 0
            }
            Renderedlist.append(SKTexture(imageNamed: "\(multiplicator + 1) \(familyList[index])"))
            index += 1
        }
        Renderedlist.append(SKTexture(imageNamed: "HIT"))
        Renderedlist.append(SKTexture(imageNamed: "STAND"))
        Renderedlist.append(SKTexture(imageNamed: "gift"))


        for i in 1...10{
            Renderedlist.append(SKTexture(imageNamed: "COINS\(i)"))
        }
        var z = 0
        //rect.xScale = 2
        for each in Renderedlist {
            each.preload {
                //print("The texture is ready! \(z)/\(Renderedlist.count)")

            }
            z += 1
            //rect.xScale = CGFloat(z) * ((4*(frame.maxX/5))/62)
        }
        if z == Renderedlist.count {
            startgame()
        }
    }
    
    func  StartPlayerData() {
        defaults.set(true,forKey: "MusicOn?")
        defaults.set(0, forKey: "UserExp")
        defaults.set(1, forKey: "UserLvl")
        defaults.set(true, forKey: "soundon")
            }

}
