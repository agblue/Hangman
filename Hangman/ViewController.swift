//
//  ViewController.swift
//  Hangman
//
//  Created by Danny Tsang on 7/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    var skyView: UIView!
    var skyTint: UIView!
    var grassView: UIView!
    var groundView: UIView!
    var sunView:UIView!
    
    var titleLabel: UILabel!
    var strikesLabel:UILabel!
    var manTextView: UITextView!
    var displayWordLabel:UILabel!
    var buttonsView: UIView!
    var letterButtons = [UIButton]()
    
    var gameWords = [String]()
    var currentWord:String = ""
    var strikes:Int = 0
    let maxStrikes = 7
    var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var guessedLetters = [String]()
    
    var buttonHeight = 60
    var buttonWidth = 60
    
    var highScoreLabel: UILabel!
    var highScore = 0 {
        didSet {
            highScoreLabel.text = "Highscore: \(highScore)"
        }
    }
    var streakLabel: UILabel!
    var streak = 0 {
        didSet {
            streakLabel.text = "Streak: \(streak)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        skyView = UIView()
        skyView.translatesAutoresizingMaskIntoConstraints = false
        skyView.backgroundColor = .cyan
        view.addSubview(skyView)
        
        skyTint = UIView()
        skyTint.translatesAutoresizingMaskIntoConstraints = false
        skyTint.backgroundColor = .orange
        skyTint.layer.opacity = 0.0
        view.addSubview(skyTint)
        
        sunView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        sunView.translatesAutoresizingMaskIntoConstraints = false
        sunView.backgroundColor = .yellow
        sunView.layer.cornerRadius = sunView.frame.width/2
        view.addSubview(sunView)

        grassView = UIView()
        grassView.translatesAutoresizingMaskIntoConstraints = false
        grassView.backgroundColor = .green
        view.addSubview(grassView)

        groundView = UIView()
        groundView.translatesAutoresizingMaskIntoConstraints = false
        groundView.backgroundColor = .brown
        view.addSubview(groundView)

        highScoreLabel = UILabel()
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highScoreLabel.text = "High Score: 0"
        highScoreLabel.textAlignment = .right
        highScoreLabel.font = UIFont.systemFont(ofSize: 20)
        highScoreLabel.sizeToFit()
        view.addSubview(highScoreLabel)

        streakLabel = UILabel()
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        streakLabel.text = "Streak: 0"
        streakLabel.textAlignment = .right
        streakLabel.font = UIFont.systemFont(ofSize: 20)
        streakLabel.sizeToFit()
        view.addSubview(streakLabel)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "H A N G M A N"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 46)
        view.addSubview(titleLabel)
        
        strikesLabel = UILabel()
        strikesLabel.translatesAutoresizingMaskIntoConstraints = false
        strikesLabel.text = "STRIKES:"
        strikesLabel.textAlignment = .center
        strikesLabel.font = UIFont.systemFont(ofSize: 36)
        strikesLabel.isHidden = true
        view.addSubview(strikesLabel)
        
        manTextView = UITextView()
        manTextView.translatesAutoresizingMaskIntoConstraints = false
        manTextView.textAlignment = .left
        manTextView.font = UIFont.monospacedSystemFont(ofSize: 30, weight: .bold)
        manTextView.sizeToFit()
        manTextView.backgroundColor = .clear
        manTextView.isEditable = false
        drawHangman()
        view.addSubview(manTextView)

        displayWordLabel = UILabel()
        displayWordLabel.translatesAutoresizingMaskIntoConstraints = false
        displayWordLabel.text = ""
        displayWordLabel.textAlignment = .center
        displayWordLabel.font = UIFont.systemFont(ofSize: 44)
        view.addSubview(displayWordLabel)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)

        let size = CGSize(width: view.frame.width, height: view.frame.height)
        resizeButtons(to: size)

        for (index, letter) in alphabet.enumerated() {
            let row = index / 13
            let col = index % 13

            let button = UIButton(frame: CGRect(x: col * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight))
                
            button.setTitle("\(letter)", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.backgroundColor = UIColor.white.cgColor
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            letterButtons.append(button)
            buttonsView.addSubview(button)
        }
        
        // Activate a set of constraints
        NSLayoutConstraint.activate([

            // Add Background Constraints
            skyView.topAnchor.constraint(equalTo: view.topAnchor),
            skyView.widthAnchor.constraint(equalTo: view.widthAnchor),
            skyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skyView.bottomAnchor.constraint(equalTo: manTextView.bottomAnchor, constant: -80),
 
            skyTint.topAnchor.constraint(equalTo: view.topAnchor),
            skyTint.widthAnchor.constraint(equalTo: view.widthAnchor),
            skyTint.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skyTint.bottomAnchor.constraint(equalTo: manTextView.bottomAnchor, constant: -80),
            
            grassView.topAnchor.constraint(equalTo: skyView.bottomAnchor),
            grassView.widthAnchor.constraint(equalTo: view.widthAnchor),
            grassView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            grassView.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -25),

            groundView.topAnchor.constraint(equalTo: grassView.bottomAnchor),
            groundView.widthAnchor.constraint(equalTo: view.widthAnchor),
            groundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Add Label Constraints
            highScoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            highScoreLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),

            streakLabel.topAnchor.constraint(equalTo: highScoreLabel.bottomAnchor, constant: 5),
            streakLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            titleLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            strikesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            strikesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            strikesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            manTextView.topAnchor.constraint(equalTo: strikesLabel.bottomAnchor, constant: 50),
            manTextView.widthAnchor.constraint(equalToConstant: 235),
            manTextView.heightAnchor.constraint(equalToConstant: 280),
            manTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            displayWordLabel.topAnchor.constraint(equalTo: manTextView.bottomAnchor, constant: 50),
            displayWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            displayWordLabel.widthAnchor.constraint(equalTo:view.layoutMarginsGuide.widthAnchor),
            
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.centerYAnchor.constraint(equalTo: groundView.centerYAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth * 13)),
            buttonsView.heightAnchor.constraint(equalToConstant: CGFloat(buttonHeight * 2))
            

        ])
//        Testing Label borders
//        strikesLabel.backgroundColor = .yellow
//        manTextView.backgroundColor = .cyan
//        displayWordLabel.backgroundColor = .red
//        buttonsView.backgroundColor = .blue
//
        // Load data file of words
        loadDataFile()
        
        // Load High Score
        let defaults = UserDefaults.standard
        highScore = defaults.integer(forKey: "highScore")
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        resizeButtons(to: size)

        buttonsView.updateConstraints()
        // Update the button Sizes using Animation
        UIView.animate(withDuration: 1, animations:{ [weak self] in
            
            if let buttons = self?.letterButtons {
                for (index, button) in buttons.enumerated() {
                    let row = index / 13
                    let col = index % 13
                    
                    button.frame = CGRect(x: col * self!.buttonWidth, y: row * self!.buttonHeight, width: self!.buttonWidth, height: self!.buttonHeight)
                }
            }
        })
    }
    
    func resizeButtons(to size: CGSize) {
        buttonWidth = (Int(size.width) - 40) / 13
        buttonHeight = buttonWidth
    }

    func loadDataFile() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let fileURL = Bundle.main.url(forResource: "start", withExtension: ".txt") {
                if let gameWordString = try? String(contentsOf: fileURL) {
                    self?.gameWords = gameWordString.components(separatedBy: "\n")
                }
            } else {
                // Default to HangMan
                self?.gameWords = ["HANGMAN"]
            }
            self?.gameWords.shuffle()
            self?.loadRandomWord()
        }
    }
    
    func loadRandomWord() {
        // Load the current word.
        DispatchQueue.main.async { [weak self] in
            if let firstWord = self?.gameWords.removeFirst() {
                self?.currentWord = firstWord.uppercased()
                print(self?.currentWord)
            
                self?.displayWordLabel.text? = ""
                for _ in firstWord {
                    self?.displayWordLabel.text? += "_ "
                }
            }
        }
    }
        
    @objc func buttonTapped(sender: UIButton) {
        sender.isHidden = true
        if let letter = sender.titleLabel?.text{
            if currentWord.contains(letter) {
                guessedLetters.append(letter)
                var displayText = ""
                for (index, character) in currentWord.enumerated() {
                    if guessedLetters.contains(String(character)) {
                        displayText += "\(character) "
                    } else {
                        displayText += "_ "
                    }
                }
                displayWordLabel.text = displayText
            } else {
                addStrike()
            }
            checkGameOver()
        }
    }

    func addStrike() {
        strikes += 1
        strikesLabel.text? += " *"
        drawHangman()
        animateSun()
    }
    
    func resetAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.sunView.frame.origin.x = 100
            self?.sunView.frame.origin.y = 100
            
            self?.skyTint.layer.opacity = 0.0
            self?.skyView.layer.opacity = 1.0
        }, completion: nil)
    }

    func animateSun() {
        //Calculate new sun X position based on number of strikes + 100
        let intervalWidth = (view.frame.width - 300) / 7
        let intervalHeight = (skyView.frame.height - 100) / 10
        
        let xPosition = (intervalWidth * CGFloat(strikes)) + 100
        let yPosition = (intervalHeight * CGFloat(strikes)) + 100 + CGFloat(strikes * 5)
        let opacity = Float((100 / 7) * Float(strikes)/100)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.sunView.frame.origin.x = xPosition
            self?.sunView.frame.origin.y = yPosition
                
            self?.skyTint.layer.opacity = opacity
            self?.skyView.layer.opacity = 1 - opacity
        }, completion: nil)
    }
    
    func drawHangman() {
        var text = ""
        switch strikes {
        case 1:
            text = """
               
               
               
               
               |
               |
            ============
            """
        case 2:
            text = """
               
               
               |
               |
               |
               |
            ============
            """
        case 3:
            text = """
               +
               |
               |
               |
               |
               |
            ============
            """
        case 4:
            text = """
               +--
               |
               |
               |
               |
               |
            ============
            """
        case 5:
            text = """
               +----
               |
               |
               |
               |
               |
            ============
            """
        case 6:
            text = """
               +----+
               |    |
               |
               |
               |
               |
            ============
            """
        case 7:
            text = """
               +----+
               |    |
               |    o
               |   /|\\
               |   / \\
               |
            ============
            """
        default:
            text = """






            ============
            """
            
        }
        manTextView.text = text
    }
    
    func checkGameOver() {
        if strikes == maxStrikes {
            var revealWord = ""
            for character in currentWord {
                revealWord += "\(character) "
            }
            displayWordLabel.text = revealWord
            
            let ac = UIAlertController(title: "Game Over", message: "As the sweat falls from your brow, you contemplate how a simple word could have gotten you out of this mess.", preferredStyle: .alert)
            if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: currentWord) {
                ac.addAction(UIAlertAction(title: "Define", style: .default, handler: lookupWordMeaningAction))
            }
            ac.addAction(UIAlertAction(title: "Dead", style: .destructive, handler: startOverAction))
            present(ac, animated: true)

            
            // Reset streak.
            streak = 0
            
        } else if let displayWord = displayWordLabel.text {
            if !displayWord.contains("_") {
                let ac = UIAlertController(title: "You Win", message: "Our mistake, you're free to go!", preferredStyle: .alert)
                if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: currentWord) {
                    ac.addAction(UIAlertAction(title: "Define", style: .default, handler: lookupWordMeaningAction))
                }
                ac.addAction(UIAlertAction(title: "Woohoo!", style: .default, handler: startOverAction))
                present(ac, animated: true)
                
                // Increase Streak
                streak += 1
                
                // Check for high score
                if streak > highScore {
                    highScore = streak
                    
                    let defaults = UserDefaults.standard
                    defaults.set(highScore, forKey: "highScore")
                }
            }
        }
    }
    
    func startOverAction(action: UIAlertAction) {
        startOver()
    }
    
    func startOver() {
        loadRandomWord()
        
        strikes = 0
        strikesLabel.text = "STRIKES:"
        guessedLetters.removeAll()
//        displayWordLabel.text = ""
//        for _ in currentWord {
//            displayWordLabel.text? += "_ "
//        }
        for button in letterButtons {
            button.isHidden = false
        }
        drawHangman()
        resetAnimation()
    }
    
    func lookupWordMeaningAction(action:UIAlertAction) {
        lookupWordMeaning()
    }
    
    func lookupWordMeaning() {
        if UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: currentWord) {
            let childVC = UIReferenceLibraryViewController(term: currentWord)
            self.present(childVC, animated: true, completion: startOver)
        }
    }
}

