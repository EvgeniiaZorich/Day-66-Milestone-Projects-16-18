


import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var forksLabel: SKLabelNode!
    var eatHealthy: SKLabelNode!
    
    let possibleEnemies = ["beetroot", "carrot", "cucumber", "cupcake", "free", "hamburger", "pumpkin", "cabbage", "tomato", "icecream", "cake", "fork"]
    
    let decode = ["beetroot": 10, "carrot": 20, "cucumber": 50, "cupcake": -20, "free": -20, "hamburger": -50, "pumpkin": 10, "cabbage": 10, "tomato": 20, "icecream": -30, "cake": -50]
    
    var isGameOver = false
    
    var timer: Timer?
    var timeLeft = 59 {
        didSet {
            timerLabel.text = "00 : \(timeLeft)"
        }
    }
    
    var gameTimer1: Timer?
//    var gameTimer2: Timer?
//    var gameTimer3: Timer?

    var yPosition = [128, 640]
    var yPositonLeft = 384
    var direction = 0
    var dxArray = [-500, -1000, 500, 1000, -300, 300]
    var speedSrite = 0
    var x = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score : \(score)"
        }
    }
    
    var forks = 6 {
        didSet {
            forksLabel.text = "Left forks: \(forks)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0
        
        forksLabel = SKLabelNode(fontNamed: "Chalkduster")
        forksLabel.position = CGPoint(x: 950, y: 730)
        forksLabel.horizontalAlignmentMode = .right
        addChild(forksLabel)
        
        forks = 6
        
        eatHealthy = SKLabelNode(fontNamed: "Chalkduster")
        eatHealthy.position = CGPoint(x: 512, y: 16)
        eatHealthy.text = "EAT HEALTHY!"
        eatHealthy.horizontalAlignmentMode = .center
        addChild(eatHealthy)
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.position = CGPoint(x: 512, y: 740)
        timerLabel.horizontalAlignmentMode = .center
        addChild(timerLabel)
        
        timeLeft = 59
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer1 = Timer.scheduledTimer(timeInterval: 0.55, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        
    }
    
    @objc func onTimerFires() {
        timeLeft -= 1
        timerLabel.text = "00: \(timeLeft)"
     
        if timeLeft <= 0 {
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            timer?.invalidate()
            timer = nil
            gameTimer1?.invalidate()
            isGameOver = true
        }
    }
    
    @objc func createEnemy() {
        speedSrite = dxArray.randomElement()!

        if speedSrite < 0 {
            direction = yPosition.randomElement()!
            x = 1200

        } else {
            direction = yPositonLeft
            x = -1200
        }
        guard let enemy = possibleEnemies.randomElement() else { return }
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.size.height /= 2
        sprite.size.width /= 2
        
        sprite.position = CGPoint(x: x, y: direction)
        sprite.name = enemy
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 0
        sprite.physicsBody?.velocity = CGVector(dx: speedSrite, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        //      var nodeTapped = false
        //
        for node in tappedNodes {
            if node.zPosition < 0 {
                return
            }
            
            
            guard let nodeName = node.name else { return }
            if nodeName == "fork" {
                forks = 7
            } else {
                score += decode[nodeName]!}
            
            if forks <= 0 { return }
            forks -= 1
            let explosion = SKEmitterNode(fileNamed: "explosion")!
            explosion.position = location
            addChild(explosion)
            node.removeFromParent()
            }
        }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
                if node.position.x < -1300 || node.position.x > 1300 {
                    node.removeFromParent()
                }
            }
    }
 
}
