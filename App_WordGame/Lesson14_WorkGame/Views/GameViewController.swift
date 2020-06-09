//
//  GameViewController.swift
//  Lesson11_WorkGame
//
//  Created by MacBook Air on 22.01.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {

	var bigWord: String = ""
	var user1 = User(name: "", score: 0, color:#colorLiteral(red: 0.4745098039, green: 0.7058823529, blue: 0.8509803922, alpha: 1))
	var user2 = User(name: "", score: 0, color:#colorLiteral(red: 0.1058823529, green: 0.7490196078, blue: 0.2666666667, alpha: 1))
	var currentUser = User(name: "", score: 0, color: #colorLiteral(red: 0.4745098039, green: 0.7058823529, blue: 0.8509803922, alpha: 1))
	var wordsArray = [String]()
	var colorsArray = [UIColor]()
	var nameArray = [String]()
	var gameViewModel = GameViewModel()
	var currentMaxScore = 0
	
	@IBOutlet weak var bigWordLabel: UILabel!
	@IBOutlet weak var firstScoreLabel: UILabel!
	@IBOutlet weak var secondScoreLabel: UILabel!
	@IBOutlet weak var firstNameLabel: UILabel!
	@IBOutlet weak var secondNameLabel: UILabel!
	@IBOutlet weak var smallWordTextField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var checkWordButton: UIButton!
	@IBOutlet weak var firstPlayerStackView: UIView!
	@IBOutlet weak var secondPlayerStackView: UIView!
	@IBOutlet weak var firstPlayerArrowView: UIImageView!
	@IBOutlet weak var secondPlayerArrowView: UIImageView!
	@IBOutlet weak var maxScoreTextField: UILabel!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configureVC()
		currentUser = user2
    }
	
	func configureVC() {
		currentMaxScore = gameViewModel.getCurrentMaxScore()
		bigWordLabel.text = bigWord.uppercased()
		bigWordLabel.adjustsFontForContentSizeCategory = true
		bigWordLabel.adjustsFontSizeToFitWidth = true
		maxScoreTextField.text = "играем до \(currentMaxScore)"
		firstScoreLabel.text = String(user1.score)
		secondScoreLabel.text = String(user2.score)
		firstNameLabel.text = user1.name
		secondNameLabel.text = user2.name
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		smallWordTextField.delegate = self
		hideKeyBoard()
		checkWordButton.layer.cornerRadius = 10
		firstPlayerStackView.layer.cornerRadius = 20
		secondPlayerStackView.layer.cornerRadius = 20
		firstPlayerStackView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.3921568627, blue: 0.3411764706, alpha: 1)
		secondPlayerStackView.backgroundColor = #colorLiteral(red: 0.8555745228, green: 0.8555745228, blue: 0.8555745228, alpha: 1)
		secondPlayerArrowView.isHidden = true
	}
	
	//MARK: Go back action button
	@IBAction func goBackActionButton(_ sender: UIButton) {
		createAlertWithToActions(withTitle: "Выйти?", andText: "Текущий результат игры будет утерян") { (_) in
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	
	@IBAction func showMaxScoreLabel(_ sender: UIButton) {
		maxScoreTextField.isHidden = !maxScoreTextField.isHidden
	}
	
	
}


//MARK: - Main game process methods
extension GameViewController {
	
	//Button action to save word entered by players (goes through all words check)
	@IBAction func checkWordAction(_ sender: UIButton? = nil) {
		
		currentUser.score += checkSmallWord(checkingWord: smallWordTextField.text ?? "")
		smallWordTextField.text = ""
		
		if currentUser.name == user2.name {
			user2 = currentUser
			secondScoreLabel.text = "\(user2.score)"
			setStackViewForPlayer(nextPlayerStep: user1)
		} else {
			user1 = currentUser
			firstScoreLabel.text = "\(user1.score)"
			setStackViewForPlayer(nextPlayerStep: user2)
		}
		self.tableView.reloadData()
		guard isGameWinner(player: currentUser) else { return }
	}
	
	//Convert word from string to array of characters
	func wordToCharArray(word: String) -> [Character] {
		var charArray = [Character]()
		
		for char in word {
			charArray.append(char)
		}
		return charArray
	}
	
	//Check small word if it possible to publish by game rules
	func checkSmallWord(checkingWord: String) -> Int {
		let checkingWord = checkingWord.lowercased()
		
		guard checkingWord.count > 1 else {
			createAlert(with: "В слове должно быть больше 1й буквы")
			smallWordTextField.text = ""
			return 0
		}
		guard checkingWord != bigWord else {
			createAlert(with: "Слово должно отличаться от исходного")
			smallWordTextField.text = ""
			return 0
		}
		guard !(wordsArray.contains(checkingWord)) else {
			createAlert(with: "Это слово уже было составлено")
			smallWordTextField.text = ""
			return 0
		}
		
		//Смена игроков
		if currentUser.name == user1.name {
			currentUser = user2
		} else {
			currentUser = user1
		}
		
		var bigWordArray = wordToCharArray(word: bigWord)
		let smallWordArray = wordToCharArray(word: checkingWord)
		var smallWord = ""
		
		for char in smallWordArray { //Проверяем есть ли в большом слове составленное маленькое слово
			
			guard bigWordArray.contains(char) else {
				createAlert(with: "Это слово не может быть составлено!")
				return 0
			}
			
			smallWord.append(char)
			
			var i = 0
			while bigWordArray[i] != char {	//Удаляем из массива большого слова символ маленького слова
				i += 1
			}
			bigWordArray.remove(at: i)
		}
		
		guard smallWord == checkingWord else {
			createAlert(with: "Это слово не может быть составлено!")
			return 0
		}
		wordsArray.insert(smallWord, at: 0)
		colorsArray.insert(currentUser.color, at: 0)
		nameArray.insert(currentUser.name, at: 0)

		return checkingWord.count
	}
	
	//Change colours for players stack view and arrow direction
	func setStackViewForPlayer(nextPlayerStep: User) {
		
		switch nextPlayerStep.name {
			case user1.name:
				self.firstPlayerStackView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.3921568627, blue: 0.3411764706, alpha: 1)
				firstPlayerArrowView.isHidden = false
				secondPlayerStackView.backgroundColor = #colorLiteral(red: 0.8555745228, green: 0.8555745228, blue: 0.8555745228, alpha: 1)
				secondPlayerArrowView.isHidden = true
			case user2.name:
				self.secondPlayerStackView.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.3921568627, blue: 0.3411764706, alpha: 1)
				secondPlayerArrowView.isHidden = false
				firstPlayerStackView.backgroundColor = #colorLiteral(red: 0.8555745228, green: 0.8555745228, blue: 0.8555745228, alpha: 1)
				firstPlayerArrowView.isHidden = true
			default:
				firstPlayerStackView.backgroundColor = #colorLiteral(red: 0.8555745228, green: 0.8555745228, blue: 0.8555745228, alpha: 1)
				secondPlayerStackView.backgroundColor = #colorLiteral(red: 0.8555745228, green: 0.8555745228, blue: 0.8555745228, alpha: 1)
				secondPlayerArrowView.isHidden = true
				firstPlayerArrowView.isHidden = true
		}
	}
	
	func isGameWinner(player: User) -> Bool {
		if player.score >= self.currentMaxScore {
			createAlert(withTitle: "\(player.name) поздравляем!", andText: "Ты выйграл(а) набрав \(player.score) очков\nиз \(currentMaxScore) необходимых.") { (_) in
				self.dismiss(animated: true, completion: nil)
			}
			return true
		}
		return false
	}
	
}

//MARK: - Methods for alert creating
extension GameViewController {
	
	func createAlert(withTitle customTitle: String, andText customText: String, action: ((UIAlertAction) -> Void)? ) {
		let alert = UIAlertController(title: customTitle, message: customText, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: action)
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func createAlert(with customText: String) {
		createAlert(withTitle: "Внимание", andText: customText, action: nil)
	}
	
	func createAlertWithToActions(withTitle customTitle: String, andText customText: String, action: ((UIAlertAction) -> Void)? ) {
		let alert = UIAlertController(title: customTitle, message: customText, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Выйти", style: .destructive, handler: action)
		let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
		alert.addAction(cancelAction)
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	
}


//MARK: - Table view Delegate and Data Source methods
extension GameViewController: UITableViewDelegate, UITableViewDataSource {
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		wordsArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "WorkCell")
		let playerName = nameArray[indexPath.row]
		let cellColor = nameArray[indexPath.row] == user1.name ? user1.color : user2.color

		cell?.backgroundColor = cellColor
		cell?.textLabel?.text = playerName + ":    " + wordsArray[indexPath.row]
		cell?.detailTextLabel?.text = "+ \(wordsArray[indexPath.row].count)"

		return cell!
	}
	
}


//MARK: - Extension for keyboard hide
extension GameViewController {
	
	func hideKeyBoard() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		self.view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		self.view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		checkWordAction()
		return true
	}
	
}
