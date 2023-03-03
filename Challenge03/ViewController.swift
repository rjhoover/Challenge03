//
//  ViewController.swift
//  Challenge03
//
//  Created by Robert Hoover on 2023-02-23.
//

import UIKit

class ViewController: UIViewController {
    
    var alphabet: [String] {
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }
    }
    
    var maxWrongLettersAllowed = 6
    var allWords = [String]()
    
    var currentWord = ""
    var displayWord = ""
    var letterGuessed: String = ""
    var usedLettersCount: Int = 0
    var usedLetters: [Character] = []
    var wrongLetters: [Character] = []
    
    var currentWordLabel: UILabel!
    
    var displayWordLabel: UILabel!
    var displayWordLabelLabel: UILabel!
    
    var usedLettersLabel: UILabel!
    var usedLettersLabelLabel: UILabel!
    var usedLettersCountLabel: UILabel!
    
    var wrongLettersLabel: UILabel!
    var wrongLettersLabelLabel: UILabel!
    var wrongLettersMaxLabel: UILabel!
    
    var letterButtons = [UIButton]()
    var restartButton: UIButton!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemGray4
        
        allWords = loadWords(for: "words8char.txt")
//        newGame()
        
        // MARK: - UI definitions
        
        // currentWordLabel is just for testing
        // so i know what the word is without having to
        // scroll through the warnings in the console.
        currentWordLabel = UILabel()
        currentWordLabel.translatesAutoresizingMaskIntoConstraints = false
        currentWordLabel.text = currentWord
        currentWordLabel.font = UIFont.systemFont(ofSize: 24)
        currentWordLabel.textColor = UIColor.systemGray
        currentWordLabel.isHidden = true  // comment for testing
        view.addSubview(currentWordLabel)
        
        usedLettersLabelLabel = UILabel()
        usedLettersLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        usedLettersLabelLabel.textAlignment = .right
        usedLettersLabelLabel.text = "Used Letters: "
        usedLettersLabelLabel.font = UIFont.systemFont(ofSize: 24)
        usedLettersLabelLabel.textColor = UIColor.black
        view.addSubview(usedLettersLabelLabel)
        
        usedLettersLabel = UILabel()
        usedLettersLabel.translatesAutoresizingMaskIntoConstraints = false
        usedLettersLabel.textAlignment = .left
        usedLettersLabel.text = ""
        usedLettersLabel.font = UIFont.systemFont(ofSize: 24)
        usedLettersLabel.textColor = UIColor.black
        view.addSubview(usedLettersLabel)
        
        usedLettersCountLabel = UILabel()
        usedLettersCountLabel.translatesAutoresizingMaskIntoConstraints = false
        usedLettersCountLabel.textAlignment = .left
        usedLettersCountLabel.text = "0"
        usedLettersCountLabel.font = UIFont.systemFont(ofSize: 24)
        usedLettersCountLabel.textColor = UIColor.black
        view.addSubview(usedLettersCountLabel)

        wrongLettersLabelLabel = UILabel()
        wrongLettersLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongLettersLabelLabel.textAlignment = .right
        wrongLettersLabelLabel.text = "Wrong Letters Count: "
        wrongLettersLabelLabel.font = UIFont.systemFont(ofSize: 24)
        wrongLettersLabelLabel.textColor = UIColor.black
        view.addSubview(wrongLettersLabelLabel)
        
        wrongLettersLabel = UILabel()
        wrongLettersLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongLettersLabel.textAlignment = .left
        wrongLettersLabel.text = "0"
        wrongLettersLabel.font = UIFont.systemFont(ofSize: 24)
        wrongLettersLabel.textColor = UIColor.red
        view.addSubview(wrongLettersLabel)
        
        wrongLettersMaxLabel = UILabel()
        wrongLettersMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongLettersMaxLabel.textAlignment = .left
        wrongLettersMaxLabel.text = "out of \(maxWrongLettersAllowed)"
        wrongLettersMaxLabel.font = UIFont.systemFont(ofSize: 24)
        wrongLettersMaxLabel.textColor = UIColor.black
        view.addSubview(wrongLettersMaxLabel)
        
        displayWordLabelLabel = UILabel()
        displayWordLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        displayWordLabelLabel.textAlignment = .right
        displayWordLabelLabel.text = "Correct Letters: "
        displayWordLabelLabel.font = UIFont.systemFont(ofSize: 24)
        displayWordLabelLabel.textColor = UIColor.black
        view.addSubview(displayWordLabelLabel)
        
        displayWordLabel = UILabel()
        displayWordLabel.translatesAutoresizingMaskIntoConstraints = false
        displayWordLabel.textAlignment = .left
        displayWordLabel.text = displayWord
        displayWordLabel.font = UIFont.systemFont(ofSize: 24)
        displayWordLabel.textColor = UIColor.black
        view.addSubview(displayWordLabel)
        
        restartButton = UIButton(type: .system)
        // i don't know how to center a view
        let frame = CGRect(x: 285, y: 32, width: 256, height: 64)
        restartButton.frame = frame
        restartButton.layer.borderWidth = 3
        restartButton.layer.borderColor = UIColor.black.cgColor
        restartButton.layer.cornerRadius = frame.height / 2
        restartButton.backgroundColor = UIColor.systemMint
        restartButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        restartButton.tintColor = UIColor.black
        restartButton.setTitle("New Game", for: .normal)
        restartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        view.addSubview(restartButton)
        
        // MARK: - letter buttons
        
        // for complicated layouts it's a good idea to wrap things
        // into a container view. here, we'll create one container
        // view that will house all the buttons, then add constraints
        // to the container view.
        let buttonsView = UIView()  // create container using a plain UIView
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        let letterButtonWidth = 80
        let letterButtonHeight = letterButtonWidth  // make them square
        
        // create 26 buttons in a 3x9 grid
        for row in 0..<3 {
            for col in 0..<9 {
                // hack to avoid creating an extra button
                if row == 2 && col == 8 { break }
                
                let letterButton = UIButton(type: .system)
                let frame = CGRect(x: col * letterButtonWidth, y: row * letterButtonHeight,
                                   width: letterButtonWidth, height: letterButtonHeight)
                letterButton.frame = frame
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.black.cgColor
                letterButton.backgroundColor = UIColor.systemCyan
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 52)
                letterButton.setTitleColor(.blue, for: .normal)
                letterButton.setTitleColor(.red, for: .disabled)
                letterButton.isHidden = false
                letterButton.isEnabled = true
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
            }
        }
        
        // add each alphabet letter to each button
        for i in 0..<letterButtons.count {
            letterButtons[i].setTitle(alphabet[i], for: .normal)
        }
        
        view.addSubview(buttonsView)
        
        // MARK: - constraints
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            // layoutMarginsGuide will make the views indented a little on each edge.
            
            // currentWordLabel is just so i can see the word to guess for testing
            currentWordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            currentWordLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            currentWordLabel.widthAnchor.constraint(equalToConstant: 128),
            currentWordLabel.heightAnchor.constraint(equalToConstant: 64),
            
            // it doesn't seem to matter if i have these constraints for
            // restartButton or not, iff you comment out all the rows for
            // restartButton, it will still display where its supposed to.
            restartButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: padding),
            restartButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            restartButton.widthAnchor.constraint(equalToConstant: 256),
            restartButton.heightAnchor.constraint(equalToConstant: 64),
            
            usedLettersLabelLabel.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: padding),
            usedLettersLabelLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            usedLettersLabelLabel.widthAnchor.constraint(equalToConstant: 256),
            usedLettersLabelLabel.heightAnchor.constraint(equalToConstant: 64),
            
            usedLettersLabel.topAnchor.constraint(equalTo: usedLettersLabelLabel.topAnchor),
            usedLettersLabel.leadingAnchor.constraint(equalTo: usedLettersLabelLabel.trailingAnchor, constant: 8),
            usedLettersLabel.widthAnchor.constraint(equalToConstant: 222),
            usedLettersLabel.heightAnchor.constraint(equalTo: usedLettersLabelLabel.heightAnchor),
            
            usedLettersCountLabel.topAnchor.constraint(equalTo: usedLettersLabelLabel.topAnchor),
            usedLettersCountLabel.leadingAnchor.constraint(equalTo: usedLettersLabel.trailingAnchor),
            usedLettersCountLabel.widthAnchor.constraint(equalToConstant: 32),
            usedLettersCountLabel.heightAnchor.constraint(equalTo: usedLettersLabelLabel.heightAnchor),
            
            wrongLettersLabelLabel.topAnchor.constraint(equalTo: usedLettersLabelLabel.bottomAnchor, constant: padding),
            wrongLettersLabelLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            wrongLettersLabelLabel.widthAnchor.constraint(equalToConstant: 256),
            wrongLettersLabelLabel.heightAnchor.constraint(equalTo: usedLettersLabelLabel.heightAnchor),
            
            wrongLettersLabel.topAnchor.constraint(equalTo: wrongLettersLabelLabel.topAnchor),
            wrongLettersLabel.leadingAnchor.constraint(equalTo: wrongLettersLabelLabel.trailingAnchor, constant: 16),
            wrongLettersLabel.widthAnchor.constraint(equalToConstant: 16),
            wrongLettersLabel.heightAnchor.constraint(equalTo: usedLettersLabelLabel.heightAnchor),
            
            wrongLettersMaxLabel.topAnchor.constraint(equalTo: wrongLettersLabel.topAnchor),
            wrongLettersMaxLabel.leadingAnchor.constraint(equalTo: wrongLettersLabel.trailingAnchor, constant: 8),
            wrongLettersMaxLabel.widthAnchor.constraint(equalToConstant: 256),
            wrongLettersMaxLabel.heightAnchor.constraint(equalTo: usedLettersLabelLabel.heightAnchor),
            
            displayWordLabelLabel.topAnchor.constraint(equalTo: wrongLettersLabelLabel.bottomAnchor, constant: padding),
            displayWordLabelLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            displayWordLabelLabel.widthAnchor.constraint(equalToConstant: 256),
            displayWordLabelLabel.heightAnchor.constraint(equalTo: usedLettersLabelLabel.heightAnchor),
            
            displayWordLabel.topAnchor.constraint(equalTo: wrongLettersLabelLabel.bottomAnchor, constant: padding),
            displayWordLabel.leadingAnchor.constraint(equalTo: displayWordLabelLabel.trailingAnchor, constant: 8),
            displayWordLabel.widthAnchor.constraint(equalToConstant: 256),
            displayWordLabel.heightAnchor.constraint(equalTo: usedLettersLabelLabel.heightAnchor),
            
            buttonsView.topAnchor.constraint(equalTo: displayWordLabel.bottomAnchor, constant: padding),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            buttonsView.widthAnchor.constraint(equalToConstant: 824),
            buttonsView.heightAnchor.constraint(equalToConstant: 64),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ])

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newGame()
    }
    
    // MARK: - newGame
    func newGame() {
        print("***** starting new game *****")
        currentWord = getRandomWord(from: allWords)
        print("word to guess = \(currentWord)")
        displayWord = getStartingDisplayWord()

        DispatchQueue.main.async {
            self.currentWordLabel?.text = self.currentWord
            self.displayWordLabel?.text = self.addSpaces(to: self.displayWord)
            self.usedLettersCountLabel?.text = "0"
            self.wrongLettersLabel?.text = "\(self.wrongLetters.count)"
            self.usedLettersLabel?.text = ""
        }
    }
    
    // MARK: - restartGame
    @objc func restartGame() {
        currentWord = ""
        displayWord = ""
        usedLettersCount = 0
        usedLetters.removeAll()
        wrongLetters.removeAll()
        resetAllLetterButtons()
        newGame()
    }
        
    // MARK: - change letter buttons
    func resetAllLetterButtons() {
        DispatchQueue.main.async {
            for i in 0..<self.letterButtons.count {
                // change color of button text back to blue
                // and enable the buttons so they can be pressed again
                self.letterButtons[i].setTitleColor(.blue, for: .normal)
                self.letterButtons[i].isEnabled = true
            }
        }
    }
    
    func disableAllLetterButtons() {
        DispatchQueue.main.async {
            for i in 0..<self.letterButtons.count {
                self.letterButtons[i].isEnabled = false
            }
        }
    }
    
    // MARK: - gameWon
    func gameWon() {
        displayAlert(title: "Winner", message: "Do you want to play again?")
    }
    
    // MARK: - gameLost
    func gameLost() {
        displayAlert(title: "Sorry, the word was \(currentWord).", message: "Do you want to play again?")
    }
    
    // MARK: - displayAlert
    func displayAlert(title: String, message: String) {
        DispatchQueue.main.async {
            // seems like this should be one function
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default) { _ in
                self.restartGame()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.disableAllLetterButtons()
            })
            self.present(ac, animated: true)
        }
    }
    
    // MARK: - letterTapped()
    @objc @IBAction func letterTapped(_ sender: UIButton) {
        guard let letterGuessed = sender.titleLabel?.text else { return }
        
        // add letterGuessed to usedLetters array
        usedLetters.append(Character(letterGuessed))
        usedLettersCount = usedLetters.count

        // check to see if letterGuessed exists in currentWord
        // by getting an array of indices where letterGuessed
        // was found in currentWord. it returns an array of each
        // place in currentWord the letter was found.
        let displayIndices = currentWord.uppercased().indices(for: letterGuessed.uppercased())
        
        // if the displayIndices has count > 0
        // it means that the letterGuessed was found.
        if displayIndices.count > 0 {
            // MARK: - replace letters
            // letterGuessed was found so replace what's there
            // at those indices with letterGuessed
            displayWord = replaceFoundLetters(at: displayIndices)
            // displayWord will be used to set the value of the label
            // it will be a string of compressed letters (no spaces).
            // need to convert string to array which includes spaces
            // between each character and will set the display label to it.
        } else {
            // letterGuessed was not found in currentWord
            // so add it to the array of wrongLetters
            wrongLetters.append(Character(letterGuessed))
        }
        
        // MARK: - check if won
        if !displayWord.uppercased().contains("?") {
            gameWon()
        }

        if wrongLetters.count >= maxWrongLettersAllowed {
            print("****** Game Over ******")
            gameLost()
        }
        
        // set usedLetterLabel and wrongLettersLabel
        DispatchQueue.main.async {
            // add letterGuessed to label of used letters
            self.usedLettersLabel.text = self.usedLettersLabel.text?.appending(letterGuessed)
            self.usedLettersCountLabel?.text = "\(self.usedLetters.count)"
            self.wrongLettersLabel.text = String(self.wrongLetters.count)
            // change color of button text
            // and disable the button so it can't be pressed anymore
            sender.setTitleColor(.systemGray3, for: .normal)
            sender.isEnabled = false
            
            // add spaces between characters in displayWord for the label
            self.displayWordLabel.text = self.addSpaces(to: self.displayWord)
        }
    }
    
    // MARK: - replaceFoundLetters
    func replaceFoundLetters(at foundIndices: [Int]) -> String {
        guard !foundIndices.isEmpty else { return displayWord }

        // convert to an array so we can use it in the loop
        var displayWordArray = displayWord.uppercased().map { String($0) }
        
        for i in foundIndices {
            // check if the letter is not the right letter and if the letter is not a space
            if displayWordArray[i] != letterGuessed.uppercased() && displayWordArray[i] != " " {
                // convert string to array for indexing
                let currentWordArray = currentWord.uppercased().map { String($0) }
                // replace the correct letter in the displayWord
                displayWordArray[i] = currentWordArray[i].uppercased()
            } else {
                print("\(letterGuessed) is already in the list of used letters")
            }
        }
        
        // convert array back to string
        return displayWordArray.joined()
    }
    
    // MARK: - addSpaces
    func addSpaces(to string: String) -> String {
        // convert displayWord to an array (should be same length as currentWord)
        let displayArray = displayWord.uppercased().map { String($0) }

        // convert array back to a string putting space between letters
        return displayArray.joined(separator: " ")
    }
    
    // MARK: - getStartingDisplayWord
    func getStartingDisplayWord() -> String {
        // change word to guess to be question marks
        return Array(repeating: "?", count: currentWord.count).joined()
    }
    
    // MARK: - getRandomWord
    func getRandomWord(from array: [String]) -> String {
        guard array.isEmpty == false else { return "I HAVE NO WORDS" }
        
        if let randomWord = array.randomElement() {
            return randomWord
        } else {
            return "Failed to get a random word."
        }
    }

    // MARK: - loadWords
    func loadWords(for filename: String) -> [String] {
        var words: [String]

        let filename = filename.trimmingCharacters(in: .whitespacesAndNewlines)
        // split the filename into the basename and extension
        let parts = filename.components(separatedBy: ".")
        let basename = parts[0]
        let extnsn = parts[1]
        
        if let fileURL = Bundle.main.url(forResource: basename, withExtension: extnsn) {
            if let wordList = try? String(contentsOf: fileURL) {
                // list has line returns after each word
                words = wordList.components(separatedBy: "\n")
            } else {
                words = []
            }
        } else {
            words = []
        }
        print("loaded \(words.count) words from file")
        
        return words
    }

}

// MARK: - extensions
extension String {
    func indices(for letter: String) -> [Int] {
        guard !letter.isEmpty else { return [] }
        
        let stringArray = self.map { String($0) }  // convert string to array of string
        var positionsArray = [Int]()
        
        for i in 0..<stringArray.count {
            if letter == stringArray[i] {
                positionsArray.append(i)
            } else {
                continue
            }
        }
        
        return positionsArray
    }
}
