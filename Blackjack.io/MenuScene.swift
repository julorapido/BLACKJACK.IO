//
//  MenuScene.swift
//  blackjack.io
//
//  Created by Jules on 09/09/2021.
// ID ca-app-pub-4889346564502252~7541718210
// Unit ID: ca-app-pub-4889346564502252/3842146359

import SpriteKit
import UIKit
import Foundation
import AVFoundation
//import GoogleMobileAds
import AudioToolbox


//MAX X IPHONE 8 : 375
// MAX X IPHONE 8 PLUS : 414
class MenuScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        
        defaults.set(false, forKey: "FIRSTEVERLAUNCH")
        var CoinsTexture:[SKTexture] = []
        for i in 1...10 {
            CoinsTexture.append(SKTexture(imageNamed: "COINS\(i)"))
        }
        layoutScene()
        playbuttonFunc()
        blackjackpng()

        AnimateCoins(TimeInterval: 0.1)
        if defaults.bool(forKey: "FirstLaunch") == true {
            AdustNodeApparitions()
        }
        if defaults.bool(forKey: "LastGameVictory?") == true{
            LastGameVictory()
        }
    }
    

        

    public let defaults = UserDefaults.standard

    
    var background : SKSpriteNode!

    var MUSIClaunched = false
    
    var lastgamelevelup = false
    var usexp :      Int!
    var uselvl : Int!
    var UserCoins : Int!
    var MusicPlayer: AVAudioPlayer!
    var inforect : SKShapeNode!
    var infotouched = false
    
    var bruhColors : [String : UIColor] = ["basicblue" :UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1.0),
                                           "red" :UIColor(red: 214/255, green: 37/255, blue: 45/255, alpha: 1.0),
                                           "blue" :UIColor(red: 38/255, green: 35/255, blue: 140/255, alpha: 1.0),
                                           "halloween" :UIColor(red: 127/255, green: 70/255, blue: 253/255, alpha: 1.0),
                                           "christmas" :UIColor(red: 43/255, green: 87/255, blue: 65/255, alpha: 1.0),
                                           "green" :UIColor(red: 25/255, green: 127/255, blue: 44/255, alpha: 1.0),
                                           "black" :UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1.0),
                                           "purple" :UIColor(red: 168/255, green: 18/255, blue: 117/255, alpha: 1.0),
                                           "cloud" :UIColor(red: 125/255, green: 91/255, blue: 186/255, alpha: 1.0),
                                           "sky" :UIColor(red: 119/255, green: 193/255, blue: 254/255, alpha: 1.0)
                                            ]
    
    
    var expNeeded : Int!

    var inte = 0
    func UserData() {

        
        if defaults.integer(forKey: "UserExp") > (defaults.integer(forKey: "UserLvl") * 100){
            LevelUp()
            lastgamelevelup = true
        }
        usexp = defaults.integer(forKey: "UserExp")
        uselvl = defaults.integer(forKey: "UserLvl")
        expNeeded = uselvl * 100
        UserCoins = defaults.integer(forKey: "UserCoins")

    }
    func StatMenu(){
        playRec.isUserInteractionEnabled = false
        statTouched = true
        statrect = SKShapeNode(rectOf: CGSize(width: 4*(frame.maxX/5), height: 2*(frame.maxY/5)), cornerRadius: 10)
        statrect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0.97)
        statrect.zPosition = 15
        statrect.name = "statnode"
        statrect.alpha = CGFloat(0)
        statrect.lineWidth = CGFloat(3)
        statrect.position = CGPoint(x: frame.midX, y: 2*(frame.maxY/3))
        statrect.setScale(0.2)
 
        let gameplayed = SKLabelNode(fontNamed: "TextaW00-Heavy")
        gameplayed.position = CGPoint(x: frame.midX, y: 3.95*(frame.maxY/5))
        gameplayed.name = "statnode"
        gameplayed.text = "\(defaults.integer(forKey: "GamesPlayed")) GAMES PLAYED"
        gameplayed.fontSize = 22
        gameplayed.fontColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0.97)
        gameplayed.zPosition = 17
        gameplayed.alpha = 0
        
        let gamerect = SKShapeNode(rectOf: CGSize(width: 1.7*(frame.maxX/3), height: 35), cornerRadius: 15)
        gamerect.position = CGPoint(x: frame.midX, y: 3.95*(frame.maxY/5) + 8)
        gamerect.fillColor = UIColor(red: 254/255, green: 219/255, blue: 65/255, alpha: 1)
        gamerect.strokeColor = UIColor(red: 254/255, green: 219/255, blue: 65/255, alpha: 1)
        gamerect.zPosition = 16
        gamerect.name = "statnode"
        gamerect.lineWidth = CGFloat(1)
        gamerect.alpha = 0
        
        let victory = SKLabelNode(fontNamed: "TextaW00-Heavy")
        victory.position = CGPoint(x: frame.midX, y: 3.6*(frame.maxY/5))
        victory.name = "statnode"
        victory.text = "GAMES WON : \(defaults.integer(forKey: "GameWon"))"
        victory.fontSize = 20
        victory.zPosition = 17
        victory.alpha = 0
        
        let lost = SKLabelNode(fontNamed: "TextaW00-Heavy")
        lost.position = CGPoint(x: frame.midX, y: 3.3*(frame.maxY/5))
        lost.name = "statnode"
        lost.text = "LOST GAMES : \(defaults.integer(forKey: "GameLost"))"
        lost.fontSize = 20
        lost.zPosition = 17
        lost.alpha = 0
        
        let blackjack = SKLabelNode(fontNamed: "TextaW00-Heavy")
        blackjack.position = CGPoint(x: frame.midX, y: 3*(frame.maxY/5))
        blackjack.name = "statnode"
        blackjack.text = "BLACKJACKS : \(defaults.integer(forKey: "Blackjacks"))"
        blackjack.fontSize = 20
        blackjack.zPosition = 17
        blackjack.alpha = 0
        

        
        let winrate = SKLabelNode(fontNamed: "TextaW00-Heavy")
        winrate.position = CGPoint(x: frame.midX, y: 2.6*(frame.maxY/5))
        winrate.name = "statnode"
        
        
        if defaults.integer(forKey: "GamesPlayed") == 0 {
            winrate.text = "WINRATE 0 %"
        }else {
            let vic = defaults.double(forKey: "GameWon") + defaults.double(forKey: "Blackjacks")
            let joue = defaults.double(forKey: "GamesPlayed")
            let rt = ( ((vic/joue) * 100 ) )
            inte = Int(rt)
            winrate.text = "WINRATE \(inte) %"
        }
        winrate.fontSize = 22
        winrate.zPosition = 17
        winrate.alpha = 0
        winrate.fontColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0.97)
        
        let winraterect = SKShapeNode(rectOf: CGSize(width: 1.5*(frame.maxX/3), height: 35), cornerRadius: 15)
        winraterect.position = CGPoint(x: frame.midX, y: 2.6*(frame.maxY/5) + 6)
        winraterect.fillColor = UIColor(red: 254/255, green: 219/255, blue: 65/255, alpha: 1)
        winraterect.strokeColor = UIColor(red: 254/255, green: 219/255, blue: 65/255, alpha: 1)
        winraterect.zPosition = 16
        winraterect.name = "statnode"
        winraterect.lineWidth = CGFloat(1)
        winraterect.alpha = 0
        if inte <=  20{
            winraterect.fillColor = UIColor(red: 254/255, green: 60/255, blue: 60/255, alpha: 1)
            winraterect.strokeColor = UIColor(red: 254/255, green: 60/255, blue: 60/255, alpha: 1)
        }else if inte > 20 && inte <= 40 {
            winraterect.fillColor = UIColor(red: 254/255, green: 131/255, blue: 34/255, alpha: 1)
            winraterect.strokeColor = UIColor(red: 254/255, green: 131/255, blue: 34/255, alpha: 1)
        }else if inte > 40 && inte <= 45 {
            winraterect.fillColor = UIColor(red: 254/255, green: 218/255, blue: 63/255, alpha: 1)
            winraterect.strokeColor = UIColor(red: 254/255, green: 218/255, blue: 63/255, alpha: 1)
        }else if inte > 45 && inte <= 50 {
            winraterect.fillColor = UIColor(red: 255/255, green: 238/255, blue: 63/255, alpha: 1)
            winraterect.strokeColor = UIColor(red: 254/255, green: 218/255, blue: 63/255, alpha: 1)
        }else if inte > 50 && inte <= 55 {
            winraterect.fillColor = UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1.0)
            winraterect.strokeColor = UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1.0)
        }else if inte > 55 && inte <= 65 {
            winraterect.fillColor = UIColor(red: 1/255, green: 200/255, blue: 255/255, alpha: 1.0)
            winraterect.strokeColor = UIColor(red: 1/255, green: 200/255, blue: 255/255, alpha: 1.0)
        }else if inte > 65 {
            winraterect.fillColor = UIColor(red: 1/255, green: 230/255, blue: 255/255, alpha: 1.0)
            winraterect.strokeColor = UIColor(red: 1/255, green: 230/255, blue: 255/255, alpha: 1.0)
        }
        addChild(gamerect)
        addChild(gameplayed)
        addChild(winraterect)
        addChild(winrate)
        addChild(blackjack)
        addChild(lost)
        addChild(victory)
        addChild(statrect)
        statrect.run(SKAction.sequence([SKAction.scaleX(to: 1, duration: 0.15),SKAction.wait(forDuration: 0.01),SKAction.scaleY(to: 1, duration: 0.19)]))
        statrect.run(SKAction.fadeIn(withDuration: 0.3))
        lost.run(SKAction.fadeIn(withDuration: 0.45))
        victory.run(SKAction.fadeIn(withDuration: 0.45))
        blackjack.run(SKAction.fadeIn(withDuration: 0.45))
        winrate.run(SKAction.fadeIn(withDuration: 0.45))
        gameplayed.run(SKAction.fadeIn(withDuration: 0.45))
        winraterect.run(SKAction.fadeIn(withDuration: 0.45))
        gameplayed.run(SKAction.fadeIn(withDuration: 0.45))
        gamerect.run(SKAction.fadeIn(withDuration: 0.45))
    }
    func DisplayInfo() {
        
        
        playRec.isUserInteractionEnabled = false
        infotouched = true
        inforect = SKShapeNode(rectOf: CGSize(width: 4*(frame.maxX/5), height: 3.4*(frame.maxY/5)), cornerRadius: 10)
        inforect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0.97)
        inforect.zPosition = 15
        inforect.name = "infonode"
        inforect.alpha = CGFloat(0)
        inforect.lineWidth = CGFloat(3)
        inforect.position = CGPoint(x: frame.midX, y: frame.midY)
        inforect.setScale(0.3)
        let experiencerect = SKShapeNode(rectOf: CGSize(width: 1.5*(frame.maxX/3), height: 32), cornerRadius: 15)
        experiencerect.position = CGPoint(x: frame.midX, y: 4*(frame.maxY/5))
        experiencerect.fillColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        experiencerect.strokeColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        experiencerect.zPosition = 16
        experiencerect.name = "infonode"
        experiencerect.lineWidth = CGFloat(3.5)
        
        let experiencetext = SKLabelNode(fontNamed: "TextaW00-Heavy")
        experiencetext.position = CGPoint(x: frame.midX - 15, y: 3.9575*(frame.maxY/5))
        experiencetext.name = "infonode"
        experiencetext.text = "EXPERIENCE"
        experiencetext.fontSize = 22
        experiencetext.fontColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        experiencetext.zPosition = 17

        let experiencenode = SKSpriteNode(texture: SKTexture(imageNamed: "exp"))
        experiencenode.position = CGPoint(x: frame.midX + 64, y: 4*(frame.maxY/5))
        experiencenode.name = "infonode"
        experiencenode.zPosition = 16
        experiencenode.xScale = 0.1
        experiencenode.yScale = 0.1
        experiencenode.alpha = 0

        let dealerbust = SKLabelNode(fontNamed: "TextaW00-Heavy")
        dealerbust.position = CGPoint(x: frame.midX, y: 3.2*(frame.maxY/5))
        dealerbust.name = "infonode"
        dealerbust.text = "DEALER BUSTS + 35exp"
        dealerbust.fontSize = 17
        dealerbust.zPosition = 17
        dealerbust.alpha = 0
        
        let playerlost = SKLabelNode(fontNamed: "TextaW00-Heavy")
        playerlost.position = CGPoint(x: frame.midX , y: 3*(frame.maxY/5))
        playerlost.name = "infonode"
        playerlost.text = "YOU BUST - 15exp"
        playerlost.fontSize = 17
        playerlost.zPosition = 17
        playerlost.alpha = 0

        let playerwin = SKLabelNode(fontNamed: "TextaW00-Heavy")
        playerwin.position = CGPoint(x: frame.midX, y: 3.4*(frame.maxY/5))
        playerwin.name = "infonode"
        playerwin.text = "YOU WIN + 45exp"
        playerwin.fontSize = 17
        playerwin.zPosition = 17
        playerwin.alpha = 0

        let dealerwin = SKLabelNode(fontNamed: "TextaW00-Heavy")
        dealerwin.position = CGPoint(x: frame.midX, y: 2.8*(frame.maxY/5))
        dealerwin.name = "infonode"
        dealerwin.text = "DEALER WINS -20exp"
        dealerwin.fontSize = 17
        dealerwin.zPosition = 17
        dealerwin.alpha = 0

        let blackjack = SKLabelNode(fontNamed: "TextaW00-Heavy")
        blackjack.position = CGPoint(x: frame.midX , y: 3.6*(frame.maxY/5))
        blackjack.name = "infonode"
        blackjack.text = "BLACKJACK + 80exp"
        blackjack.fontSize = 17
        blackjack.zPosition = 17
        blackjack.alpha = 0

        
        
        
        
        
        
        let coinrect = SKShapeNode(rectOf: CGSize(width: 1.1*(frame.maxX/3), height: 33), cornerRadius: 15)
        coinrect.position = CGPoint(x: frame.midX, y: 2.4*(frame.maxY/5))
        coinrect.fillColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        coinrect.strokeColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        coinrect.zPosition = 16
        coinrect.name = "infonode"
        coinrect.lineWidth = CGFloat(3.5)
        coinrect.alpha = 0

        let cointext = SKLabelNode(fontNamed: "TextaW00-Heavy")
        cointext.position = CGPoint(x: frame.midX - 15, y: 2.35*(frame.maxY/5))
        cointext.name = "infonode"
        cointext.text = "COINS"
        cointext.fontSize = 22
        cointext.zPosition = 17
        cointext.fontColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0.97)
        cointext.alpha = 0

        
        let coinsnode = SKSpriteNode(texture: SKTexture(imageNamed: "coinz"))
        coinsnode.position = CGPoint(x: frame.midX + 37, y: 2.4*(frame.maxY/5))
        coinsnode.name = "infonode"
        coinsnode.zPosition = 16
        coinsnode.xScale = 0.1
        coinsnode.yScale = 0.1
        coinsnode.alpha = 0

        let wincoin = SKLabelNode(fontNamed: "TextaW00-Heavy")
        wincoin.position = CGPoint(x: frame.midX , y: 1.95*(frame.maxY/5))
        wincoin.name = "infonode"
        wincoin.text = "+2 COINS PER WIN"
        wincoin.fontSize = 18
        wincoin.zPosition = 17
        wincoin.alpha = 0

        let bjcoin = SKLabelNode(fontNamed: "TextaW00-Heavy")
        bjcoin.position = CGPoint(x: frame.midX , y: 1.75*(frame.maxY/5))
        bjcoin.name = "infonode"
        bjcoin.text = "+3 COINS FOR BLACKJACK"
        bjcoin.fontSize = 18
        bjcoin.zPosition = 17
        bjcoin.alpha = 0

        let coininfo1  = SKLabelNode(fontNamed: "TextaW00-Heavy")
        coininfo1.position = CGPoint(x: frame.midX, y: 1.475*(frame.maxY/5))
        coininfo1.name = "infonode"
        coininfo1.text = "EACH 5 LEVEL REACHED YOU GET"
        coininfo1.fontSize = 17
        coininfo1.zPosition = 17
        coininfo1.alpha = 0

        
        let coininfo2 = SKLabelNode(fontNamed: "TextaW00-Heavy")
        coininfo2.position = CGPoint(x: frame.midX, y: 1.35*(frame.maxY/5))
        coininfo2.name = "infonode"
        coininfo2.text = "1 MORE COIN PER WIN"
        coininfo2.fontSize = 17
        coininfo2.zPosition = 17
        coininfo2.alpha = 0

        let actualbonus = SKLabelNode(fontNamed: "TextaW00-Heavy")
        actualbonus.position = CGPoint(x: frame.midX, y: 1.062*(frame.maxY/5))
        actualbonus.name = "infonode"
        actualbonus.text = "ACTUAL COIN BONUS : \(defaults.integer(forKey: "CoinsBonus"))"
        actualbonus.fontSize = 18
        actualbonus.fontColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        actualbonus.zPosition = 17
        actualbonus.alpha = 0

        let bonusrect = SKShapeNode(rectOf: CGSize(width: 2.05*(frame.maxX/3), height: 35), cornerRadius: 15)
        bonusrect.position = CGPoint(x: frame.midX, y: 1.1*(frame.maxY/5))
        bonusrect.fillColor = UIColor(red: 254/255, green: 219/255, blue: 65/255, alpha: 1)
        bonusrect.strokeColor = UIColor(red: 254/255, green: 219/255, blue: 65/255, alpha: 1)
        bonusrect.zPosition = 16
        bonusrect.name = "infonode"
        bonusrect.lineWidth = CGFloat(1)
        bonusrect.alpha = 0

        
        addChild(bonusrect)
        addChild(actualbonus)
        addChild(coininfo2)
        addChild(coininfo1)
        addChild(bjcoin)
        addChild(wincoin)
        addChild(coinrect)
        addChild(cointext)
        addChild(coinsnode)
        addChild(blackjack)
        addChild(dealerwin)
        addChild(playerwin)
        addChild(playerlost)
        addChild(dealerbust)
        addChild(experiencenode)
        addChild(experiencetext)
        addChild(experiencerect)
        addChild(inforect)
        experiencerect.run(SKAction.fadeIn(withDuration: 0.45))
        experiencetext.run(SKAction.fadeIn(withDuration: 0.45))
        experiencenode.run(SKAction.fadeIn(withDuration: 0.45))
        dealerbust.run(SKAction.fadeIn(withDuration: 0.45))
        dealerwin.run(SKAction.fadeIn(withDuration: 0.45))
        playerwin.run(SKAction.fadeIn(withDuration: 0.45))
        playerlost.run(SKAction.fadeIn(withDuration: 0.45))
        blackjack.run(SKAction.fadeIn(withDuration: 0.45))
        coinrect.run(SKAction.fadeIn(withDuration: 0.45))
        cointext.run(SKAction.fadeIn(withDuration: 0.45))
        coininfo2.run(SKAction.fadeIn(withDuration: 0.45))
        coininfo1.run(SKAction.fadeIn(withDuration: 0.45))
        coinsnode.run(SKAction.fadeIn(withDuration: 0.45))
        actualbonus.run(SKAction.fadeIn(withDuration: 0.45))
        bonusrect.run(SKAction.fadeIn(withDuration: 0.45))
        wincoin.run(SKAction.fadeIn(withDuration: 0.45))
        bjcoin.run(SKAction.fadeIn(withDuration: 0.45))
        inforect.run(SKAction.fadeIn(withDuration: 0.3))
        inforect.run(SKAction.scale(to: 1, duration: 0.3))
        
    }
    func spawncoins( ) {

        let vector = SKAction.move(to: (Coins.position), duration: 0.5)
        
        let fadeout = SKAction.fadeOut(withDuration: 0.15)
        let Coins = SKSpriteNode(texture: SKTexture(imageNamed: "COINS1"))
        Coins.xScale = 0.35
        Coins.yScale = 0.35
        Coins.zPosition = 40
        let wait = SKAction.wait(forDuration: 0.09)
        let Animation = SKAction.sequence([
            (SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS2")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS3")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS4")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS5")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS6")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS7")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS8")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS9")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS10")}),wait,(SKAction.run{Coins.texture = SKTexture(imageNamed: "COINS1")})])
        
        let remove = SKAction.run {
            Coins.removeFromParent()
        }
        let loop = SKAction.sequence([Animation])
        let final = SKAction.repeatForever(loop)
        addChild(Coins)
            Coins.run(SKAction.rotate(toAngle: M_PI/2,duration: 0.0001))
            Coins.position = CGPoint(x: 0.8*(self.frame.maxX/4), y: 0.3*(self.frame.maxY/9))
            Coins.run(final)
            Coins.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),fadeout,remove]))
            Coins.run(vector)
            let CoinSound = SKAction.playSoundFileNamed("gamecoin.wav", waitForCompletion: false)
            if self.defaults.bool(forKey: "soundon") == true{
                self.run(SKAction.sequence([CoinSound]))
            }
      
 
    }
    
    func ExpSound (count : Int) {
        let ExpSound = SKAction.playSoundFileNamed("trigger.wav", waitForCompletion: true)

        if defaults.bool(forKey: "soundon") == true {
            run(ExpSound)
        }
    }
    func LastGameVictory(){
        let ApparitionRect = SKShapeNode(rectOf: CGSize(width: 105, height: 32.5), cornerRadius: 10)
        ApparitionRect.position = CGPoint(x: 3.25*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        ApparitionRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        ApparitionRect.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        ApparitionRect.zPosition = 2
        ApparitionRect.lineWidth = CGFloat(2.5)

        ApparitionRect.run(SKAction.sequence([SKAction.wait(forDuration: 1.5),SKAction.fadeOut(withDuration: 0.5)]))

        
        var AppearCoinsRect = SKShapeNode(rectOf: CGSize(width: 85, height: 40), cornerRadius: 10)
        
        if defaults.integer(forKey: "UserCoins") >= 1000 {
            AppearCoinsRect = SKShapeNode(rectOf: CGSize(width: 115, height: 42), cornerRadius: 10)
        }
        AppearCoinsRect.position = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
        AppearCoinsRect.fillColor = UIColor(red: 254/255, green: 207/255, blue: 41/255, alpha: 1)
        AppearCoinsRect.strokeColor = UIColor(red: 254/255, green: 207/255, blue: 41/255, alpha: 1)
        AppearCoinsRect.lineWidth = CGFloat(5)
        AppearCoinsRect.zPosition = 2
        addChild(AppearCoinsRect)
        addChild(ApparitionRect)
        
        CoinsText.text = "\(defaults.integer(forKey: "UserCoins") - defaults.integer(forKey: "LastGameCoins"))"
        AppearCoinsRect.run(SKAction.sequence([SKAction.wait(forDuration: 1.5),SKAction.fadeOut(withDuration: 0.5)]))
        var time = CGFloat(0)
        let previouscoin = defaults.integer(forKey: "UserCoins") - defaults.integer(forKey: "LastGameCoins")
        let entier = defaults.integer(forKey: "LastGameCoins")
        for i in 1...entier {
            run(SKAction.run {
                self.generator.impactOccurred()
            })
            run(SKAction.sequence([SKAction.wait(forDuration: time),
                                   SKAction.run{self.spawncoins()},
                                   SKAction.run{self.CoinsText.text = "\(previouscoin + i)"},
                                   
                                  ]))
            time = time + CGFloat(0.4)
        }
 
        defaults.set(0, forKey: "LastGameCoins")
        
        if lastgamelevelup == false {

          
            
                let previousExp = defaults.integer(forKey: "UserExp")
                let tour = defaults.integer(forKey: "LastGameExp")
                var timing = CGFloat(0)
                defaults.set(previousExp - tour, forKey: "UserExp")
                usexp = defaults.integer(forKey: "UserExp")
                expText.text = "EXP  \(Int(usexp))/\((Int(uselvl)) * 100)"
                for i in 1...tour {
                    
                    run(SKAction.sequence([
                        SKAction.wait(forDuration: timing),
                        SKAction.run {self.ExpSound(count: tour)}
                    
                    
                    ]))
                      
                    run(SKAction.sequence([
                        SKAction.wait(forDuration: timing),
                        SKAction.run{self.expText.text = "EXP \(Int(self.usexp + i))/\((Int(self.uselvl)) * 100)"},
                        SKAction.run{self.defaults.set(self.usexp + i, forKey: "UserExp")}
                    ]))
                    timing = timing + CGFloat(0.02)
                }

          
        }
 
        defaults.set(0, forKey: "LastGameExp")
    }
    
    func Particles(XValue : CGPoint){
        var exodeX = CGFloat(30)
        var exodeY = CGFloat(10)
        let zizou = Int.random(in: 1...2)
        let zizou2 = Int.random(in: 1...2)
        var rotateValue : Double!
        if zizou == 1 {
            exodeX = -(exodeX)
            rotateValue = M_PI/4
        }else if zizou == 2{
            exodeY = -(exodeY)
            rotateValue = -M_PI/4

        }
            
    
        let exodeAction = SKAction.move(by: CGVector(dx: exodeX, dy: exodeY), duration: 2.6)
        let fadeSequence = SKAction.sequence([SKAction.fadeAlpha(to: 0.7, duration: 1.3),SKAction.fadeAlpha(to: 0, duration: 1.3)])
        let square = SKShapeNode(rectOf: CGSize(width: 4, height: 4))
        let rotating = SKAction.rotate(byAngle: rotateValue, duration: 2)
        let scaleSequence = SKAction.sequence([SKAction.scale(by: 1.3, duration: 1),SKAction.scale(by: 0.6, duration: 1)])
        square.fillColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        square.strokeColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0)
        square.alpha = 0.2

        square.zPosition = -99
     
        
        let randomValue = Int.random(in: 1...30)
        let fdp = CGFloat(randomValue)
            square.position = CGPoint(x: XValue.x + fdp, y: XValue.y + fdp)
            addChild(square)
            square.run(exodeAction)
        square.run(fadeSequence)
        square.run(rotating)
        square.run(scaleSequence)
        square.run(SKAction.sequence([SKAction.wait(forDuration: 5),SKAction.run{self.removeFromParent()}]))
        
    }
    func LevelUp(){
        lastgamelevelup = true
        let lvl = SKAction.playSoundFileNamed("lvlup.wav", waitForCompletion: false)
        if self.defaults.bool(forKey: "soundon") == true{
            self.run(SKAction.sequence([lvl]))
        }
        let previousLevel = defaults.integer(forKey: "UserLvl")
        let previousExp = defaults.integer(forKey: "UserExp")
        defaults.set(previousLevel + 1, forKey: "UserLvl")
        defaults.set(previousExp - (previousLevel * 100), forKey: "UserExp")
        generator.impactOccurred()
        
        let lvluptext = SKLabelNode(fontNamed: "TextaW00-Heavy")
        lvluptext.position = CGPoint(x:1.9*(frame.maxX/3), y: (3.7 * (frame.maxY/5)))
        lvluptext.fontSize = 20
        lvluptext.text = "LEVEL UP!"
        lvluptext.zPosition = 4
        addChild(lvluptext)
        lvluptext.run(SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 1.75))
        lvluptext.run(SKAction.fadeOut(withDuration: 1.75))
        
        print("lvl up")
 
        
        if defaults.integer(forKey: "UserLvl") == defaults.integer(forKey: "LevelNeeded") {
            defaults.set( (defaults.integer(forKey:"CoinsBonus") + 1 ) , forKey: "CoinsBonus")
            defaults.set( (defaults.integer(forKey:"LevelNeeded") + 5) , forKey: "LevelNeeded")
        }
    }
    
    func pressedButton (button: SKSpriteNode, time : CGFloat, scale : CGFloat) -> SKAction {
        
        var buttonScaleBackValue = button.xScale
        
        let RectPressedAction1 = SKAction.scaleX(to: scale, duration: time/2)
        let RectPressedAction2 = SKAction.scaleY(to: scale, duration: time/2)
        
     
        let RectPressedAction3 = SKAction.scaleX(to: buttonScaleBackValue, duration: time/2)
        let RectPressedAction4 = SKAction.scaleY(to: buttonScaleBackValue, duration: time/2)
        
        let PressedRect = SKAction.run {
            button.run(RectPressedAction1)
            button.run(RectPressedAction2)
        }
        
        let UnpressedRect = SKAction.run {
            button.run(RectPressedAction3)
            button.run(RectPressedAction4)
        }
        let o = SKAction.wait(forDuration: 0.15)
        let RectPressedAction = SKAction.sequence([PressedRect,o,UnpressedRect])

        
        button.run(RectPressedAction)
        return(RectPressedAction)
    }
    var SkinShopTouched = false
    var mainrect : SKShapeNode!
    var expRect : SKShapeNode!
    var expText : SKLabelNode!
    var CoinsRect : SKShapeNode!
    var CoinsText : SKLabelNode!
    var GiftText : SKLabelNode!
    var GiftImage : SKSpriteNode!
    var CardsSpawned = false
    var soundImage : SKSpriteNode!
    var playRec : SKShapeNode!
    var borderRect : SKShapeNode!
    var playbutton : SKLabelNode!
    var Coins : SKSpriteNode!
    var SkinShop : SKSpriteNode!
    var newNode : SKSpriteNode!
    let fadeAction = SKAction.fadeAlpha(to: 0.95, duration: 0.2)
    let pressedAction = SKAction.scale(to: 0.7, duration: 0.3)
    var info :SKSpriteNode!
    var coinsInt : Int!
    var statsNode : SKSpriteNode!
    var statTouched = false
    var statrect : SKShapeNode!
    func disableUserInter(time :Double){
        let disable = SKAction.run {
            self.isUserInteractionEnabled = false
        }
        let waitTime = SKAction.wait(forDuration: time)
        let enable = SKAction.run {
            self.isUserInteractionEnabled = true
        }
        run(SKAction.sequence([disable,waitTime,enable]))
    }
    
    
    func layerToSKSpritenode(layer : CALayer) -> SKSpriteNode {
        let view = UIView()
        layer.frame = self.frame
        view.layer.addSublayer(layer)
        UIGraphicsBeginImageContext(self.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        newNode = SKSpriteNode(texture: SKTexture(image: bgImage))
        return(newNode)
    }

 
   
    class AddSkinSlot {
        let defo = UserDefaults.standard

        var positionn : CGPoint!
        var SkinTexture : SKTexture!
        var SlotUnlocked : Bool!
        var checkbox : SKSpriteNode!
        var LockState : Bool!
        var OuterRectangle = SKShapeNode(rectOf: CGSize(width: 75, height: 90), cornerRadius: 7.5)
        
        var SlotNumberValue : Int!
        var PriceBanner : SKShapeNode!
        var PriceText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        var CoinsImage : SKSpriteNode!

        var CoinsPrice = 0
        
        var SkinSelec : SKSpriteNode!
        
        var CheckedBool : Bool!
        //ar checkbox : SKSpriteNode!
        
        init(Position : CGPoint, SkinTexture : SKTexture, LockedState : Bool, SlotNumber : Int, CheckedState : Bool, SlotPrice : Int){
        
            
            checkbox = SKSpriteNode(texture: SKTexture(imageNamed: "locked"))
            OuterRectangle.zPosition = 16
            OuterRectangle.lineWidth = CGFloat(3)
            positionn = Position
            OuterRectangle.fillColor = UIColor(red: 40/255, green: 70/255, blue: 110/255, alpha: 1)
            OuterRectangle.strokeColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0)
            OuterRectangle.position = CGPoint(x: Position.x, y: Position.y + 65)
            SlotNumberValue = SlotNumber
            LockState = LockedState
            CheckedBool = CheckedState
            SkinSelec = SKSpriteNode(imageNamed: "back basicblue")
            SkinSelec.position = CGPoint(x: Position.x, y: Position.y + 65)
            CoinsPrice = SlotPrice
            SkinSelec.zPosition = 30
            SkinSelec.xScale = 0.29
            SkinSelec.yScale = 0.235
    
            
            if SlotNumber == 2 {
                SkinSelec.texture = SKTexture(imageNamed: "back red")
            }else if SlotNumber == 3 {
                SkinSelec.texture = SKTexture(imageNamed: "back blue")
            }else if SlotNumber == 4 {
                SkinSelec.texture = SKTexture(imageNamed: "back black")
            }else if SlotNumber == 5 {
                SkinSelec.texture = SKTexture(imageNamed: "back christmas")
            }else if SlotNumber == 6 {
                SkinSelec.texture = SKTexture(imageNamed: "back halloween")
            }else if SlotNumber == 7 {
                SkinSelec.texture = SKTexture(imageNamed: "back purple")
            }else if SlotNumber == 8 {
                SkinSelec.texture = SKTexture(imageNamed: "back cloud")
            }else if SlotNumber == 9 {
                SkinSelec.texture = SKTexture(imageNamed: "back sky")
            }
            
            
            if LockState == true{
                checkbox = SKSpriteNode(texture: SKTexture(imageNamed: "locked"))
              
                PriceBanner = SKShapeNode(rectOf: CGSize(width: 80, height: 26), cornerRadius: 0)
                PriceBanner.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
                PriceBanner.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 0)

                CoinsImage = SKSpriteNode(texture: SKTexture(imageNamed: "COINS1"))
                CoinsImage.xScale = 0.3
                CoinsImage.yScale = 0.3
                PriceText.text = "\(CoinsPrice)"
                PriceText.fontSize = 17
            
                PriceBanner.position = CGPoint(x: Position.x, y: Position.y + 65)
                CoinsImage.position = CGPoint(x: Position.x + 13, y: Position.y + 66)
                PriceText.position = CGPoint(x: Position.x - 13, y: Position.y + 59)
                
                
                CoinsImage.zPosition = 41
                PriceBanner.zPosition = 39
                PriceText.zPosition = 40
                PriceText.name = "shopnode"
                CoinsImage.name = "shopnode"
                PriceBanner.name = "shopnode"

            }else if LockState == false{
                let bruh = String(SlotNumber)
                let str = "Slot\(bruh)"
                PriceBanner = SKShapeNode()
                CoinsImage = SKSpriteNode()
                
                if defo.string(forKey: "SlotChecked") == str {
                    checkbox = SKSpriteNode(texture: SKTexture(imageNamed: "checked"))
                
                    OuterRectangle.strokeColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 0)
                }else {
                    checkbox = SKSpriteNode(texture: SKTexture(imageNamed: "unchecked"))
              
                    OuterRectangle.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)

                }
        
                
            }
            checkbox.xScale = 0.042
            checkbox.yScale = 0.042
            checkbox.alpha = 1
            OuterRectangle.alpha = 1
            checkbox.zPosition = 16
            checkbox.run(SKAction.fadeIn(withDuration: 0.3))
            OuterRectangle.run(SKAction.fadeIn(withDuration: 0.3))
            checkbox.position = CGPoint(x: positionn.x, y: positionn.y - 3)
            OuterRectangle.name = "shopnode"
            SkinSelec.name = "shopnode"
            checkbox.name = "shopnode"
        }
        

    }
    let generator = UIImpactFeedbackGenerator(style: .medium)

    var cardshop : SKSpriteNode!
    var lvltext : SKLabelNode!
    var lvlrect : SKShapeNode!
    var CoinsAdaptivePos : CGPoint!
    
    var slot9 : AddSkinSlot!
    var slot8 : AddSkinSlot!
    var slot7 : AddSkinSlot!
    var slot6 : AddSkinSlot!
    var slot5 : AddSkinSlot!
    var slot4 : AddSkinSlot!
    var slot3 : AddSkinSlot!
    var slot2 : AddSkinSlot!
    var slot1 : AddSkinSlot!
    var location : CGPoint!
    var skinshoptxt : SKLabelNode!
    var skinshoprect : SKShapeNode!
    
    let gouttesound = SKAction.playSoundFileNamed("goutte.wav", waitForCompletion: true)
    let playsound = SKAction.playSoundFileNamed("playsound.wav", waitForCompletion: true)

    func SkinShopFunc(){
        
        
        playRec.isUserInteractionEnabled = true
        SkinShopTouched = true
        mainrect = SKShapeNode(rectOf: CGSize(width: 4.5*(frame.maxX/5), height: 3.4*(frame.maxY/5)), cornerRadius: 10)
        mainrect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        mainrect.zPosition = 15
        mainrect.name = "shopnode"
        mainrect.alpha = CGFloat(0)
        mainrect.lineWidth = CGFloat(3)
        mainrect.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(mainrect)
        mainrect.run(SKAction.fadeIn(withDuration: 0.3))
        
        skinshoprect = SKShapeNode(rectOf: CGSize(width: 4.25*(frame.maxX/5), height: 1*(frame.maxY/12)), cornerRadius: 10)
        skinshoprect.position = CGPoint(x: frame.minX - 50, y: 8.3*(frame.maxY/9))
        skinshoprect.zPosition = 14
        skinshoprect.fillColor = UIColor(red: 19/255, green: 28/255, blue: 47/255, alpha: 1)
        skinshoprect.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        skinshoprect.lineWidth = CGFloat(3.75   )
        skinshoprect.alpha = 0

        cardshop = SKSpriteNode(imageNamed: "cardshop")
        cardshop.position = CGPoint(x: frame.minX - 50, y: 8*(frame.maxY/9))
        cardshop.zPosition = 15
        cardshop.alpha = 0
        cardshop.xScale = 0.25
        cardshop.yScale = 0.25
        
        skinshoptxt = SKLabelNode(fontNamed: "TextaW00-Heavy")
        skinshoptxt.zPosition = 15
        skinshoptxt.text = "DECK SHOP"
        skinshoptxt.fontSize = 30
        skinshoptxt.position = CGPoint(x: frame.minX - 50, y: 7.93*(frame.maxY/9))
        skinshoptxt.alpha = 0

        
        skinshoprect.name = "shopnode"
        skinshoptxt.name = "shopnode"
        cardshop.name = "shopnode"

        skinshoptxt.run(SKAction.fadeIn(withDuration: 0.35))
        skinshoprect.run(SKAction.fadeIn(withDuration: 0.35))
        cardshop.run(SKAction.fadeIn(withDuration: 0.35))

        skinshoprect.run(SKAction.move(to: CGPoint(x: frame.midX, y: 8.05*(frame.maxY/9)), duration: 0.4))
        skinshoptxt.run(SKAction.move(to: CGPoint(x: frame.midX, y: 7.9*(frame.maxY/9)), duration: 0.4))
        cardshop.run(SKAction.move(to: CGPoint(x: 2.45*(frame.maxX/3), y: 8.05*(frame.maxY/9)), duration: 0.4))

        addChild(skinshoprect)
        addChild(skinshoptxt)
        addChild(cardshop)
        
        slot9 = AddSkinSlot.init(Position: CGPoint(x: 1.3*(frame.maxX/6), y: 1.2*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot9LockState"), SlotNumber: 9,CheckedState: defaults.bool(forKey: "Slot9Checked"),SlotPrice: 300)
        slot8 = AddSkinSlot.init(Position: CGPoint(x: 3*(frame.maxX/6), y: 1.2*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot8LockState"), SlotNumber: 8,CheckedState: defaults.bool(forKey: "Slot8Checked"),SlotPrice: 250)
        slot7 = AddSkinSlot.init(Position: CGPoint(x: 4.7*(frame.maxX/6), y: 1.2*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot7LockState"), SlotNumber: 7,CheckedState: defaults.bool(forKey: "Slot7Checked"),SlotPrice: 250)
        
        slot6 = AddSkinSlot.init(Position: CGPoint(x: 1.3*(frame.maxX/6), y: 2.6*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot6LockState"), SlotNumber: 6,CheckedState: defaults.bool(forKey: "Slot6Checked"),SlotPrice: 150)
        slot5 = AddSkinSlot.init(Position: CGPoint(x: 3*(frame.maxX/6), y: 2.6*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot5LockState"), SlotNumber: 5,CheckedState: defaults.bool(forKey: "Slot5Checked"),SlotPrice: 100)
        slot4 = AddSkinSlot.init(Position: CGPoint(x: 4.7*(frame.maxX/6), y: 2.6*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot4LockState"), SlotNumber: 4,CheckedState: defaults.bool(forKey: "Slot4Checked"),SlotPrice: 100)

        slot1 = AddSkinSlot.init(Position: CGPoint(x: 1.3*(frame.maxX/6), y: 3.9*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot1LockState"), SlotNumber: 1,CheckedState: defaults.bool(forKey: "Slot1Checked"),SlotPrice: 0)
        slot2 = AddSkinSlot.init(Position: CGPoint(x: 3*(frame.maxX/6), y: 3.9*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot2LockState"), SlotNumber: 2,CheckedState: defaults.bool(forKey: "Slot2Checked"),SlotPrice: 50)
        slot3 = AddSkinSlot.init(Position: CGPoint(x: 4.7*(frame.maxX/6), y: 3.9*(frame.maxY/6)), SkinTexture: SKTexture(), LockedState: defaults.bool(forKey: "Slot3LockState"), SlotNumber: 3,CheckedState: defaults.bool(forKey: "Slot3Checked"),SlotPrice: 75)
   
        addChild(slot9!.OuterRectangle); addChild(slot8!.OuterRectangle); addChild(slot7!.OuterRectangle); addChild(slot6!.OuterRectangle); addChild(slot5!.OuterRectangle); addChild(slot4!.OuterRectangle); addChild(slot3!.OuterRectangle); addChild(slot2!.OuterRectangle); addChild(slot1!.OuterRectangle)
        
        addChild(slot9!.CoinsImage); addChild(slot8!.CoinsImage); addChild(slot7!.CoinsImage); addChild(slot6!.CoinsImage); addChild(slot5!.CoinsImage); addChild(slot4!.CoinsImage); addChild(slot3!.CoinsImage); addChild(slot2!.CoinsImage); addChild(slot1!.CoinsImage)
        
        addChild(slot9!.SkinSelec); addChild(slot8!.SkinSelec); addChild(slot7!.SkinSelec); addChild(slot6!.SkinSelec); addChild(slot5!.SkinSelec); addChild(slot4!.SkinSelec); addChild(slot3!.SkinSelec); addChild(slot2!.SkinSelec); addChild(slot1!.SkinSelec)
        
        addChild(slot9!.checkbox); addChild(slot8!.checkbox); addChild(slot7!.checkbox); addChild(slot6!.checkbox); addChild(slot5!.checkbox); addChild(slot4!.checkbox); addChild(slot3!.checkbox); addChild(slot2!.checkbox); addChild(slot1!.checkbox)
        
        addChild(slot9!.PriceText); addChild(slot8!.PriceText); addChild(slot7!.PriceText); addChild(slot6!.PriceText); addChild(slot5!.PriceText); addChild(slot4!.PriceText); addChild(slot3!.PriceText); addChild(slot2!.PriceText); addChild(slot1!.PriceText)
        
        addChild(slot9!.PriceBanner); addChild(slot8!.PriceBanner); addChild(slot7!.PriceBanner) ;addChild(slot6!.PriceBanner) ;addChild(slot5!.PriceBanner) ;addChild(slot4!.PriceBanner) ;addChild(slot3!.PriceBanner) ;addChild(slot2!.PriceBanner) ;addChild(slot1!.PriceBanner)
    }
    
    func Unlock(Slot : AddSkinSlot){
        let unlocksound = SKAction.playSoundFileNamed("unlock.wav", waitForCompletion: false)
        if self.defaults.bool(forKey: "soundon") == true{
            self.run(SKAction.sequence([unlocksound]))
        }
        generator.impactOccurred()
        let previousCoinValue = defaults.integer(forKey: "UserCoins")
        Slot.PriceText.run(SKAction.fadeOut(withDuration: 0.5))
        Slot.CoinsImage.run(SKAction.fadeOut(withDuration: 0.5))
        Slot.PriceBanner.run(SKAction.fadeOut(withDuration: 0.5))
        Slot.checkbox.run(SKAction.fadeOut(withDuration: 0.5))
        Slot.checkbox.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.run{Slot.checkbox.texture = SKTexture(imageNamed: "unchecked")}, SKAction.fadeIn(withDuration: 0.3)]))
        defaults.set(previousCoinValue - Slot.CoinsPrice, forKey: "UserCoins")
        Slot.LockState = false
        coinsInt = defaults.integer(forKey: "UserCoins")
        CoinsText.text = "\(coinsInt!)"
        let a = String(Slot.SlotNumberValue)
        let stringg = "Slot\(a)LockState"
        print(stringg)
        defaults.set(false, forKey: stringg)
        
        print(defaults.bool(forKey: stringg))
        
    }
    
    func CheckIn(Slot : AddSkinSlot){
        let selectsound = SKAction.playSoundFileNamed("select.wav", waitForCompletion: false)
        if self.defaults.bool(forKey: "soundon") == true{
            self.run(SKAction.sequence([selectsound]))
        }
        generator.impactOccurred()
        let slotarray = [slot1,slot2,slot3,slot4,slot5,slot6,slot7,slot8,slot9]
        let str1 = defaults.string(forKey: "SlotChecked")
        for (_, element) in slotarray.enumerated(){
            if "Slot\(String(element!.SlotNumberValue))" == str1 {
                let slot = element!
                slot.checkbox.texture = SKTexture(imageNamed: "unchecked")
                slot.OuterRectangle.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0)
            }
        }
        Slot.checkbox.texture = SKTexture(imageNamed: "checked")
        Slot.OuterRectangle.strokeColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
        let a = String(Slot.SlotNumberValue)
        let stringg = "Slot\(a)"
        let FadeRect = SKShapeNode(rectOf: CGSize(width: 82, height: 91), cornerRadius: 7)
        let daPoint = Slot.OuterRectangle.position
        FadeRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 0)
        FadeRect.strokeColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        FadeRect.position = daPoint
        FadeRect.zPosition = 100
        FadeRect.lineWidth = CGFloat(2.5)
        addChild(FadeRect)
        FadeRect.run(SKAction.sequence([SKAction.wait(forDuration: 0.35),SKAction.fadeOut(withDuration: 0.15)]))
        FadeRect.run(SKAction.scaleX(to: 1.05, duration: 0.4))
        FadeRect.run(SKAction.scaleY(to: 1.1, duration: 0.4))
        bottomCard.texture = SKTexture(imageNamed: defaults.string(forKey: "SkinSelected")!)
        defaults.set(stringg, forKey: "SlotChecked")
        
        var ae : UIColor!
        for (key, value) in bruhColors{
            let name = defaults.string(forKey: "SkinSelected")
            let comp =  name!.split{ !$0.isLetter}
            let aree = comp[1]
            if key == aree {
    
                defaults.set(aree, forKey: "PlayColor")
            }
        }
        
        playRec.fillColor = bruhColors[defaults.string(forKey: "PlayColor")!]!
        
    }
    func MakeCGcolor(RED : CGFloat, GREEN : CGFloat,BLUE : CGFloat) -> CGColor {
        return(CGColor(red: RED/255, green: GREEN/255, blue: BLUE/255, alpha: 1.0))
    }

    var upperCard : SKSpriteNode!
    var bottomCard : SKSpriteNode!
    
    func layoutScene(){
        UserData()

        let a = MakeCGcolor(RED: 0, GREEN: 14, BLUE: 29)
        let b = MakeCGcolor(RED: 0, GREEN: 23, BLUE: 45)
        let c = MakeCGcolor(RED: 0, GREEN: 38 , BLUE: 77)



        let gradient = CAGradientLayer()
            gradient.type = .axial
            
            gradient.colors = [
                a,
                b,
                c
                
            ]
        gradient.removeFromSuperlayer()
        gradient.frame = self.view!.bounds


         background = layerToSKSpritenode(layer: gradient)
        

        
        soundImage = SKSpriteNode(imageNamed: "sound on")
        if defaults.bool(forKey: "soundon") == true {
            soundImage.texture = SKTexture(imageNamed: "sound on")
        }else if defaults.bool(forKey: "soundon") == false {
            soundImage.texture = SKTexture(imageNamed: "sound off")
        }
        soundImage.position = CGPoint(x: frame.minX + 55, y: 14.75*(frame.maxY/20))
        soundImage.yScale = 0.085
        soundImage.xScale = 0.085
        soundImage.name = "sound_image"
        
        info = SKSpriteNode(imageNamed: "info")

        info.xScale = 0.085
        info.yScale = 0.085
        info.name = "info"
        
        SkinShop = SKSpriteNode(imageNamed: "shop")
        SkinShop.xScale = 0.085
        SkinShop.yScale = 0.085
        SkinShop.name = "skinshop_image"
        
        statsNode = SKSpriteNode(imageNamed: "stats")
        statsNode.xScale = 0.076
        statsNode.yScale = 0.078
        statsNode.name = "stats"
        
        lvltext = SKLabelNode(fontNamed: "TextaW00-Heavy")
        lvltext.position = CGPoint(x:frame.midX, y: (3.9 * (frame.maxY/5)))
        lvltext.fontSize = 20
        lvltext.text = "LEVEL \(defaults.integer(forKey: "UserLvl"))"
        lvltext.zPosition = 4
        
        lvlrect = SKShapeNode(rectOf: CGSize(width: 100, height: 30), cornerRadius: 10)
        lvlrect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        lvlrect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        lvlrect.position = CGPoint(x:frame.midX, y: (3.95 * (frame.maxY/5)))
        lvlrect.zPosition = 3

        
        expText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        expText.position = CGPoint(x: 3.25*(frame.maxX/4), y: 0.85*(frame.maxY/9))
        
        
        if defaults.bool(forKey: "LastGameVictory?") == false{
            expText.text = "EXP  \(Int(usexp))/\((Int(uselvl)) * 100)"
        }else if lastgamelevelup == true {
            expText.text = "EXP  \(Int(usexp))/\((Int(uselvl)) * 100)"
        }
        expText.fontSize = 15
        expText.zPosition = 5
        
        expRect = SKShapeNode(rectOf: CGSize(width: 100, height: 30), cornerRadius: 10)
        expRect.position = CGPoint(x: 3.25*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        expRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        expRect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        expRect.zPosition = 4
        
        
        
        info.position = CGPoint(x: frame.minX + 55, y: 13.75*(frame.maxY/20))
        statsNode.position = CGPoint(x: frame.maxX - 40, y: 14.3*(frame.maxY/20))
        SkinShop.position = CGPoint(x: frame.minX + 55, y: 12.75*(frame.maxY/20))
        soundImage.position = CGPoint(x: frame.minX + 55, y: 11.75*(frame.maxY/20))
        
                
            //let backgroundTexture = SKTexture(imageNamed: "pen")
            /////////////////////let background = SKSpriteNode(texture: backgroundTexture)
        background.zPosition = -100
            background.position = CGPoint(x: frame.width/2, y: frame.height/2)
            addChild(background)
        
        
            
        coinsInt = defaults.integer(forKey: "UserCoins")
        CoinsText = SKLabelNode(fontNamed: "TextaW00-Heavy")
        CoinsText.position = CGPoint(x: 0.575*(frame.maxX/4), y: 0.81*(frame.maxY/9))
        if defaults.bool(forKey: "LastGameVictory?") == false{
            CoinsText.text = "\(coinsInt!)"
        }
        CoinsText.fontSize = 20
        CoinsText.zPosition = 5
        CoinsRect = SKShapeNode(rectOf: CGSize(width: 80, height: 35), cornerRadius: 10)
        CoinsRect.position = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
        CoinsRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        CoinsRect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
        CoinsRect.zPosition = 4
        Coins = SKSpriteNode(texture: SKTexture(imageNamed: "COINS1"))
        Coins.zPosition = 20
        Coins.xScale = 0.35
        Coins.yScale = 0.35
        Coins.run(SKAction.rotate(toAngle: M_PI/2,duration: 0.01))
        Coins.position = CGPoint(x: 0.85*(frame.maxX/4), y: 0.91*(frame.maxY/9))

        if defaults.integer(forKey: "UserCoins") < 1000 {
            CoinsRect = SKShapeNode(rectOf: CGSize(width: 80, height: 35), cornerRadius: 10)
            CoinsRect.position = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
            CoinsRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
            CoinsRect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
            Coins.position = CGPoint(x: 0.9*(frame.maxX/4), y: 0.91*(frame.maxY/9))
            CoinsRect.zPosition = 4
            print("caca")

        }
        
        if defaults.integer(forKey: "UserCoins") >= 1000 {
            CoinsRect = SKShapeNode(rectOf: CGSize(width: 105, height: 35), cornerRadius: 10)
            CoinsRect.position = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
            CoinsRect.fillColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
            CoinsRect.strokeColor = UIColor(red: 26/255, green: 36/255, blue: 63/255, alpha: 1)
            Coins.position = CGPoint(x: 1*(frame.maxX/4), y: 0.91*(frame.maxY/9))
            print("prout")
            CoinsRect.zPosition = 4

        }
     

        addChild(Coins)
        addChild(CoinsText)
        addChild(CoinsRect)
        addChild(lvlrect)
        
        
        func MenuCards(){
            var randInt = Int.random(in: 2...14)
            let family = ["TREFLE", "CARREAU", "COEUR", "PIC"]
            let randFamily = Int.random(in: 0...3)
            let RandomCardTexture = SKTexture(imageNamed: "\(randInt) \(family[randFamily])")
             upperCard = SKSpriteNode(imageNamed: defaults.string(forKey: "SkinSelected")!)
             bottomCard = SKSpriteNode(texture: RandomCardTexture)
            //upperCard.size = CGSize(width: frame.maxX/4.15, height: frame.maxY/6.5)//
            //bottomCard.size = CGSize(width: frame.maxX/4.25, height: frame.maxY/6.25)
            upperCard.xScale = 0.15
            upperCard.yScale = 0.13
            bottomCard.xScale = 0.15
            bottomCard.yScale = 0.13
            let yValue = 3*((frame.maxY / 1000)/4)
            var AdaptiveValue : CGFloat!
            if (frame.maxY) <= CGFloat(580){///////////////// IPOD
                AdaptiveValue = CGFloat(0.45)
                
            }else if (frame.maxY) > CGFloat(600) && (frame.maxY) <= CGFloat(736){///////////////// IPHONE 7 8
                AdaptiveValue = CGFloat(0.52)
                info.position = CGPoint(x: frame.minX + 55, y: 14.4*(frame.maxY/20))
                SkinShop.position = CGPoint(x: frame.minX + 53, y: 12.7*(frame.maxY/20))
                soundImage.position = CGPoint(x: frame.minX + 55, y: 11.1*(frame.maxY/20))
                
                CoinsAdaptivePos = CGPoint(x: 0.575*(frame.maxX/4), y: 0.81*(frame.maxY/9))
                CoinsText.position = CGPoint(x: 0.575*(frame.maxX/4), y: 0.81*(frame.maxY/9))

            }else if (frame.maxY) > CGFloat(736) && (frame.maxY) < CGFloat(900){////////////////// IPHONE XR 11 12 13
                AdaptiveValue = CGFloat(0.55)
                info.position = CGPoint(x: frame.minX + 55, y: 14.2*(frame.maxY/20))
                SkinShop.position = CGPoint(x: frame.minX + 53, y: 12.7*(frame.maxY/20))
                soundImage.position = CGPoint(x: frame.minX + 55, y: 11.3*(frame.maxY/20))
                lvlrect = SKShapeNode(rectOf: CGSize(width: 100, height: 40), cornerRadius: 10)

                CoinsAdaptivePos = CGPoint(x: 0.575*(frame.maxX/4), y: 0.83*(frame.maxY/9))
                CoinsText.position = CGPoint(x: 0.575*(frame.maxX/4), y: 0.83*(frame.maxY/9))
            }else if (frame.maxY) > CGFloat(900){///////////// IPHONE MAX 13 MAX 12 MAX
                AdaptiveValue = CGFloat(0.585)
                info.position = CGPoint(x: frame.minX + 55, y: 14.1*(frame.maxY/20))
                SkinShop.position = CGPoint(x: frame.minX + 53, y: 12.7*(frame.maxY/20))
                soundImage.position = CGPoint(x: frame.minX + 55, y: 11.4*(frame.maxY/20))
                lvlrect = SKShapeNode(rectOf: CGSize(width: 100, height: 40), cornerRadius: 10)

                CoinsAdaptivePos = CGPoint(x: 0.575*(frame.maxX/4), y: 0.845*(frame.maxY/9))
                CoinsText.position = CGPoint(x: 0.575*(frame.maxX/4), y: 0.845*(frame.maxY/9))

            }
            upperCard.alpha = CGFloat(0.6)
            bottomCard.alpha = CGFloat(0.6)
            func swapCardSide(node: SKSpriteNode, texture : SKTexture){
                let swapCardSide = SKAction.run {
                    node.run(SKAction.scaleX(to: 0.2, duration: 0.26));///// REDUIT UN PEU LA CARTE
                    node.texture = texture;
                    node.run(SKAction.scaleX(to: -0.36, duration: 0))////////////// SPAWN CARTE EN MIROIR
                    node.run(SKAction.scaleX(to: -0.06, duration: 0.26))//////// RETOURNEMENT 1/2
                    node.run(SKAction.scaleX(to: 0.06, duration: 0))//////////// MIROIR LA CARTE (taille reduite)
                    node.run(SKAction.scaleX(to: AdaptiveValue, duration: 0.26))////////////// REMET A TAILLE NORMALE
                    
                }
                run(swapCardSide)
            }


            
            
            if CardsSpawned == false {

                bottomCard.position = CGPoint(x: frame.minX - 30, y: frame.midY - 50)
                upperCard.position = CGPoint(x: frame.maxX + 30, y: frame.midY + 50)
                bottomCard.zPosition = 3
                upperCard.zPosition = 2
                addChild(upperCard)
                addChild(bottomCard)
                let upperMove = SKAction.move(to: CGPoint(x: frame.midX - 50, y: frame.midY + 53), duration: 0.15)
                let upperMoveBack = SKAction.move(to: CGPoint(x: frame.midX + 16 + (frame.maxX/10), y: frame.midY + 58), duration: 0.15)
                let xValue = frame.maxX / 1000

                
                
                let bottomMove = SKAction.move(to: CGPoint(x: frame.midX + 50, y: frame.midY - 53), duration: 0.15)
                let bottomMoveBack = SKAction.move(to: CGPoint(x: frame.midX - 16 - (frame.maxX/10), y: frame.midY - 58), duration: 0.15)
                
                let waitMove = SKAction.wait(forDuration: 0.22)
                                
                let Scaleup = SKAction.sequence([SKAction.scaleY(to: 1.2*(xValue)    , duration: 0.2)])
                let AlphaBack = SKAction.fadeAlpha(to: 1 , duration: 1)

                let aa = SKAction.run {
                    self.run(SKAction.run {
                        self.upperCard.run(upperMove)
                    })
                }
                let bb = SKAction.run {
                    self.run(SKAction.run {
                        self.upperCard.run(upperMoveBack)
                    })
                }
                let wait1 = SKAction.wait(forDuration: 0.2)
                
                let cc = SKAction.run{
                    self.run(SKAction.run {
                        self.bottomCard.run(bottomMove)
                    })
                }
                let dd = SKAction.run{
                    self.run(SKAction.run {
                        self.bottomCard.run(bottomMoveBack)
                    })
                }
                
                let BottomSequence = SKAction.sequence([SKAction.run {
                    self.bottomCard.run(AlphaBack)
                },cc,SKAction.run {
                    self.bottomCard.run(Scaleup)
                } ,waitMove,SKAction.run {
                    swapCardSide(node: self.bottomCard, texture: SKTexture(imageNamed: self.defaults.string(forKey: "SkinSelected")!))
                },waitMove,dd])
                
                let UpperSequence = SKAction.sequence([aa,SKAction.run {
                    self.upperCard.run(Scaleup)
                },waitMove,SKAction.run {
                    self.upperCard.run(AlphaBack)
                } ,SKAction.run {
                    swapCardSide(node: self.upperCard, texture: SKTexture(imageNamed: "\(Int.random(in: 2...14)) \(family[Int.random(in: 0...3)])"))
                },waitMove,bb])
                
        
                run(SKAction.sequence([BottomSequence,wait1,UpperSequence]))
            }
            
        }
        MenuCards()
        //oins()
        addChild(expRect)
        addChild(expText)
        addChild(lvltext)
        
        let wait4 = SKAction.wait(forDuration: 4.25)
        let wait5 = SKAction.wait(forDuration: 3.9)
        let wait3 = SKAction.wait(forDuration: 3.2)
        let e = SKAction.run{self.Particles(XValue: CGPoint(x: self.frame.midX, y: self.frame.midY))}
        let f = SKAction.run{self.Particles(XValue: CGPoint(x: 2*(self.frame.maxX/5), y: 4*(self.frame.maxY/5)))}
        let t = SKAction.run{self.Particles(XValue: CGPoint(x: 1*(self.frame.maxX/5), y: 4.6*(self.frame.maxY/5)))}
        let y = SKAction.run{self.Particles(XValue: CGPoint(x: 3.4*(self.frame.maxX/5), y: 3.5*(self.frame.maxY/5)))}
        let p = SKAction.run{self.Particles(XValue: CGPoint(x: 0.7*(self.frame.maxX/5), y: 4*(self.frame.maxY/5)))}
        let pp = SKAction.run{self.Particles(XValue: CGPoint(x: 0.4*(self.frame.maxX/5), y: 1.6*(self.frame.maxY/5)))}

        
        let o = SKAction.run{self.Particles(XValue: CGPoint(x: 1*(self.frame.maxX/5), y: 4*(self.frame.maxY/10)))}
        let oo = SKAction.run{self.Particles(XValue: CGPoint(x: 3.5*(self.frame.maxX/5), y: 4*(self.frame.maxY/10)))}

        let i = SKAction.run{self.Particles(XValue: CGPoint(x: 1.5*(self.frame.maxX/5), y: 1*(self.frame.maxY/10)))}
        let ii = SKAction.run{self.Particles(XValue: CGPoint(x: 3.25*(self.frame.maxX/5), y: 1*(self.frame.maxY/10)))}
        
        let pd = SKAction.run{self.Particles(XValue: CGPoint(x: 2.1*(self.frame.maxX/5), y: 3.7*(self.frame.maxY/10)))}
        
        let z = SKAction.run{self.Particles(XValue: CGPoint(x: 4.4*(self.frame.maxX/5), y: 9*(self.frame.maxY/10)))}
        run(SKAction.repeatForever(SKAction.sequence([wait4,e])))
        run(SKAction.repeatForever(SKAction.sequence([wait3,f])))
        run(SKAction.repeatForever(SKAction.sequence([t,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([wait3,y])))
        run(SKAction.repeatForever(SKAction.sequence([i,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([wait3,ii])))
        run(SKAction.repeatForever(SKAction.sequence([o,wait4])))
        run(SKAction.repeatForever(SKAction.sequence([oo,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([p,wait4])))
        run(SKAction.repeatForever(SKAction.sequence([pp,wait5])))
        run(SKAction.repeatForever(SKAction.sequence([z,wait3])))
        run(SKAction.repeatForever(SKAction.sequence([pd,wait3])))

        addChild(soundImage)
        addChild(info)
        addChild(SkinShop)
        addChild(statsNode)
    }
    var bruh : UIColor!

    func playbuttonFunc(){
        
        
        playbutton = SKLabelNode(fontNamed:"TextaW00-Heavy")
        playbutton.text = "PLAY"
        playbutton.name = "playbutton"
        playbutton.position = CGPoint(x: frame.midX, y: ((frame.maxY/5) - 12))
        playbutton.zPosition = 3
        playbutton.fontSize = 35
        
        playRec = SKShapeNode(rectOf: CGSize(width: 140, height: 50),cornerRadius: 10)
        playRec.name = "rectbutton"
        playRec.fillColor = bruhColors[defaults.string(forKey: "PlayColor")!]!
        playRec.strokeColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        playRec.lineWidth = CGFloat(3)
        playRec.zPosition = 2
        playRec.position = CGPoint(x: frame.midX, y: (frame.maxY/5))
        playRec.name = "playrectangle"
        
        borderRect = SKShapeNode(rectOf: CGSize(width: 140, height: 50),cornerRadius: 10)
        borderRect.name = "rectbutton"
        borderRect.fillColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        borderRect.strokeColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        borderRect.lineWidth = CGFloat(5)
        borderRect.zPosition = 1
        borderRect.position = CGPoint(x: frame.midX, y: (frame.maxY/5))
     

        let fadeDown = SKAction.fadeAlpha(to: 0.5, duration: 0.72)
        let fadeUp = SKAction.fadeAlpha(to: 1, duration: 0.72)
        let fadeeActionSequence = SKAction.sequence([fadeDown,fadeUp])
        let repeatAction = SKAction.repeatForever(fadeeActionSequence)
        borderRect.run(repeatAction)
        addChild(playbutton)
        addChild(playRec)
        addChild(borderRect)
    }

    func  AdustNodeApparitions() {
        
        
        
        CoinsRect.position = CGPoint(x: frame.minX - 60, y: 0.9*(frame.maxY/9))
        CoinsText.position = CGPoint(x: frame.minX - 60, y: 0.81*(frame.maxY/9))
        Coins.position = CGPoint(x: frame.minX - 60, y: 0.91*(frame.maxY/9))
        Coins.alpha = CGFloat(0.1)
        CoinsText.alpha = CGFloat(0.1)
        CoinsRect.alpha = CGFloat(0.1)
        
        let text = CoinsAdaptivePos
        let rect = CGPoint(x: 0.725*(frame.maxX/4), y: 0.9*(frame.maxY/9))
        var coin : CGPoint!
        if defaults.integer(forKey: "UserCoins") < 1000 {
             coin = CGPoint(x: 0.9*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        }else if defaults.integer(forKey: "UserCoins") >= 1000 {
             coin = CGPoint(x: 1*(frame.maxX/4), y: 0.91*(frame.maxY/9))

        }
        let moveAction1 = SKAction.move(to: text!, duration: 0.75)
        let moveAction2 = SKAction.move(to: rect, duration: 0.75)
        let moveAction3 = SKAction.move(to: coin, duration: 0.75)
        let fadeAction = SKAction.fadeAlpha(to: 1, duration: 1.5)
        CoinsRect.run(moveAction2)
        CoinsText.run(moveAction1)
        Coins.run(moveAction3)
        CoinsRect.run(fadeAction)
        CoinsText.run(fadeAction)
        Coins.run(fadeAction)
        
        
        
        expText.position = CGPoint(x: frame.maxX + 40, y: 0.85*(frame.maxY/9))
        expRect.position = CGPoint(x: frame.maxX + 40, y: 0.91*(frame.maxY/9))
        expRect.alpha = CGFloat(0.1)
        expText.alpha = CGFloat(0.1)
        let exprectt = CGPoint(x: 3.25*(frame.maxX/4), y: 0.91*(frame.maxY/9))
        let expTextt = CGPoint(x: 3.25*(frame.maxX/4), y: 0.85*(frame.maxY/9))
        let moveActionn1 = SKAction.move(to: exprectt, duration: 0.8)
        let moveActionn2 = SKAction.move(to: expTextt, duration: 0.8)
        expText.run(moveActionn2)
        expRect.run(moveActionn1)
        expText.run(fadeAction)
        expRect.run(fadeAction)
        
        playbutton.alpha = CGFloat(0)
        playRec.alpha = CGFloat(0)
        borderRect.alpha = CGFloat(0)
        let fadeAction2 = SKAction.fadeAlpha(to: 1, duration: 1)
        playbutton.run(fadeAction2)
        playRec.run(fadeAction2)
        borderRect.run(fadeAction2)
    }

    func blackjackpng(){
  
        
        let blackjackText = SKLabelNode(fontNamed:"TextaW00-Heavy")
        blackjackText.xScale = 0.9
        blackjackText.yScale = 0.9
        blackjackText.text = "BLACKJACK.IO"
        blackjackText.position = CGPoint(x:frame.midX, y: (4.25 * (frame.maxY/5)))
        blackjackText.zPosition = 1
        let fade = SKAction.fadeAlpha(to: 0.1, duration: 0)
        let fadein = SKAction.fadeIn(withDuration: 1)
        let scaleup = SKAction.scale(to: 1.2, duration: 1)
        addChild(blackjackText)
        blackjackText.run(scaleup)
        blackjackText.run(SKAction.sequence([fade,fadein]))
        
        
    }
    func AnimateCoins(TimeInterval : CGFloat){
        let wait = SKAction.wait(forDuration: TimeInterval)
        let Animation = SKAction.sequence([
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS2")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS3")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS4")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS5")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS6")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS7")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS8")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS9")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS10")}),
            wait,
            (SKAction.run{self.Coins.texture = SKTexture(imageNamed: "COINS1")})
        

        
        ])
        let loop = SKAction.sequence([Animation])
        let final = SKAction.repeatForever(loop)
        Coins.run(final)
        
    }
    
    func startgame(){
        let gameScene = GameScene(size: view!.bounds.size)
        let reveal = SKTransition.reveal(with: .left, duration: 0.1)
        let reveal2 = SKTransition.doorway(withDuration: 1)
        gameScene.scaleMode = .aspectFill
        view!.presentScene(gameScene,transition: reveal)
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {

        
        for touch in touches {
            location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                if node.name == "playrectangle"{
                    if SkinShopTouched == false && infotouched == false {
                            generator.impactOccurred()
                            if defaults.bool(forKey: "soundon") == true{
                                run(playsound)
                            }
                            let waitAnimation = SKAction.wait(forDuration: 0.35)
                            let SwitchScene = SKAction.run{(self.startgame())}
                            let PressedbuttoN = SKAction.sequence([waitAnimation,SwitchScene])
                            run(PressedbuttoN)
                            borderRect.run(SKAction.scaleX(to: 0.8, duration: 0.5))
                            borderRect.run(SKAction.scaleY(to: 0.8, duration: 0.5))
                            playbutton.run(SKAction.scaleX(to: 0.93, duration: 0.43))
                            playbutton.run(SKAction.scaleY(to: 0.93, duration: 0.43))
                    }
                }else if node.name == "sound_image"{
                    if SkinShopTouched == false && infotouched == false && statTouched == false {
                    generator.impactOccurred()
                    if defaults.bool(forKey: "soundon") == true{
                        run(gouttesound)
                    }
                    disableUserInter(time: 1)
                    if defaults.bool(forKey: "soundon") == true {
                        defaults.set(false, forKey: "soundon")
                        soundImage.texture = SKTexture(imageNamed: "sound off")
                    }else if defaults.bool(forKey: "soundon") == false {
                        defaults.set(true, forKey: "soundon")
                        soundImage.texture = SKTexture(imageNamed: "sound on")
                        }
                    }
                }else if node.name == "skinshop_image"{
                    if SkinShopTouched == false {
                        if statTouched == false {
                            if infotouched == false {
                                generator.impactOccurred()
                                if defaults.bool(forKey: "soundon") == true{
                                    run(gouttesound)
                                }
                                disableUserInter(time: 1)
                                SkinShopFunc()
                            }
                        }
                }
                }else if node.name == "info" {
                    if infotouched == false {
                        if statTouched == false {
                        if SkinShopTouched == false {
                            if defaults.bool(forKey: "soundon") == true{
                                run(gouttesound)
                            }
                            generator.impactOccurred()
                            DisplayInfo()
                        }
                    }
                    }
                }else if infotouched == true {
                        if inforect.frame.contains(location){
                            for child in self.children {
                                if child.name == "infonode"{
                                    child.run(SKAction.fadeOut(withDuration: 0.2))
                                    child.run(SKAction.sequence([SKAction.wait(forDuration: 0.25),SKAction.run{child.removeFromParent()},SKAction.run{self.infotouched = false}]))
                                }
                            }
                        }else {/////////// SORT DU INFO
                        }
                }else if node.name == "stats" {
                    if statTouched == false {
                        if SkinShopTouched == false{
                            if infotouched == false {
                                if defaults.bool(forKey: "soundon") == true{
                                    run(gouttesound)
                                }
                                generator.impactOccurred()
                                StatMenu()
                            }
                        }
                    }
                    
                }else if statTouched == true {
                    if statrect.frame.contains(location){
                        for child in self.children {
                            if child.name == "statnode"{
                                child.run(SKAction.fadeOut(withDuration: 0.2))
                                child.run(SKAction.sequence([SKAction.wait(forDuration: 0.25),SKAction.run{child.removeFromParent()},SKAction.run{self.statTouched = false}]))
                            }
                        }
                    }
                }
                    
            }
            if SkinShopTouched == true {
                if SkinShopTouched == true {
                    if mainrect.frame.contains(location){
                        if slot1!.OuterRectangle.contains(location){
                            if slot1!.LockState == false{
                                if "Slot1" != defaults.string(forKey: "SlotChecked"){
                                    defaults.set("back basicblue", forKey: "SkinSelected")
                                    defaults.set("deck", forKey: "DeckSelected")
                                    CheckIn(Slot: slot1!)
                                }
                            }
                        }else if slot2!.OuterRectangle.contains(location){
                            if slot2!.LockState == true {
                                if defaults.integer(forKey: "UserCoins") >= 50 {
                                    Unlock(Slot: slot2!)
                                }
                            }else if slot2!.LockState == false{
                                if "Slot2" != defaults.string(forKey: "SlotChecked"){
                                    defaults.set("back red", forKey: "SkinSelected")
                                    defaults.set("deckred", forKey: "DeckSelected")
                                    CheckIn(Slot: slot2!)

                                }
                            }
                        }else if slot3!.OuterRectangle.contains(location){
                            if slot3!.LockState == true {
                                if defaults.integer(forKey: "UserCoins") >= 75 {
                                    Unlock(Slot: slot3!)
                                }
                            }else if slot3!.LockState == false{
                                if "Slot3" != defaults.string(forKey: "SlotChecked"){
                                    defaults.set("back blue", forKey: "SkinSelected")
                                    defaults.set("deckblue", forKey: "DeckSelected")
                                    CheckIn(Slot: slot3!)

                                }
                            }
                        }else if slot4!.OuterRectangle.contains(location){
                            if slot4!.LockState == true {
                                if defaults.integer(forKey: "UserCoins") >= 100 {
                                    Unlock(Slot: slot4!)
                                }
                            }else if slot4!.LockState == false{
                                if "Slot4" != defaults.string(forKey: "SlotChecked"){
                                    defaults.set("back black", forKey: "SkinSelected")
                                    defaults.set("deckblack", forKey: "DeckSelected")
                                    CheckIn(Slot: slot4!)

                                }
                            }
                        }else if slot5!.OuterRectangle.contains(location){
                            if slot5!.LockState == true {
                                if defaults.integer(forKey: "UserCoins") >= 100 {
                                    Unlock(Slot: slot5!)
                                }
                            }else if slot5!.LockState == false{
                                if "Slot5" != defaults.string(forKey: "SlotChecked"){
                                    defaults.set("back christmas", forKey: "SkinSelected")
                                    defaults.set("deckchristmas", forKey: "DeckSelected")
                                    CheckIn(Slot: slot5!)

                                }
                            }
                        }else if slot6!.OuterRectangle.contains(location){
                            if slot6!.LockState == true {
                                if defaults.integer(forKey: "UserCoins") >= 150 {
                                    Unlock(Slot: slot6!)
                                }
                            }else if slot6!.LockState == false{
                                if "Slot6" != defaults.string(forKey: "SlotChecked"){
                                    defaults.set("back halloween", forKey: "SkinSelected")
                                    defaults.set("deckhalloween", forKey: "DeckSelected")
                                    CheckIn(Slot: slot6!)

                                }
                            }
                        }else if slot7!.OuterRectangle.contains(location){
                            if slot7!.LockState == true {
                                if defaults.integer(forKey: "UserCoins") >= 250 {
                                    Unlock(Slot: slot7!)
                                }
                            }else if slot7!.LockState == false{
                                if "Slot7" != defaults.string(forKey: "SlotChecked"){
                                    defaults.set("back purple", forKey: "SkinSelected")
                                    defaults.set("deckpurple", forKey: "DeckSelected")
                                    CheckIn(Slot: slot7!)

                                }
                            }
                        }else if slot8!.OuterRectangle.contains(location){
                            if slot8!.LockState == true {
                                if defaults.integer(forKey: "UserCoins") >= 250 {
                                    Unlock(Slot: slot8!)
                                }
                            }else if slot8!.LockState == false{
                                if "Slot8" != defaults.string(forKey: "SlotChecked"){
                                    defaults.set("back cloud", forKey: "SkinSelected")
                                    defaults.set("deckcloud", forKey: "DeckSelected")
                                    CheckIn(Slot: slot8!)

                                }
                            }
                        }else if slot9!.OuterRectangle.contains(location){
                            if slot9!.LockState == true {
                                if defaults.integer(forKey: "UserCoins") >= 300 {
                                    Unlock(Slot: slot9!)
                                }
                            }else if slot9!.LockState == false{
                                if "Slot9" != defaults.string(forKey: "SlotChecked"){
                                    defaults.set("back sky", forKey: "SkinSelected")
                                    defaults.set("decksky", forKey: "DeckSelected")
                                    CheckIn(Slot: slot9!)

                                }
                            }
                        }

                        } else{//////////////////////////// SORT DU SHOP
                            for child in self.children {
                                SkinShopTouched = false
                                playRec.isUserInteractionEnabled = true
                                if child.name == "shopnode"{
                                    child.run(SKAction.fadeOut(withDuration: 0.2))
                                    child.run(SKAction.sequence([SKAction.wait(forDuration: 0.25),SKAction.run{child.removeFromParent()}]))
                                }
                            }
                        }
            
                }
            }

        }
    }
}
