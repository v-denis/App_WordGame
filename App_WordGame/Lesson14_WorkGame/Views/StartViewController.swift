//
//  StartViewController.swift
//  Lesson11_WorkGame
//
//  Created by MacBook Air on 22.01.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import RealmSwift

protocol StartViewControllerDelegate {
	func toggleMenu()
}


class StartViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var bigWordTextField: UITextField!
	@IBOutlet weak var user1NameTextField: UITextField!
	@IBOutlet weak var user2NameTextField: UITextField!
	@IBOutlet weak var startButtonOutlet: UIButton!
	
	let startViewModel = StartViewModel()
	var delegate: StartViewControllerDelegate?
	var words: Results<Word>?
	var gestureSwipeForMenu = UISwipeGestureRecognizer()
	var elementPicker = UIPickerView()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		configurateStartVC()
		words = startViewModel.getWordsFromDB()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		addObservers()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
	
	
	
	func configurateStartVC() {
		bigWordTextField.delegate = self
		user1NameTextField.delegate = self
		user2NameTextField.delegate = self
		user1NameTextField.returnKeyType = .next
		user2NameTextField.returnKeyType = .go
		startButtonOutlet.layer.cornerRadius = 10
		hideKeyBoardOnTap()
		checkOneWordInDB()
		checkMaxScoreInDB()
		configurateGestureSwipes()
		choiceUIElement()
		print(Realm.Configuration.defaultConfiguration.fileURL!)
	}
	
	@IBAction func menuAction(_ sender: UIButton) {
		delegate?.toggleMenu()
		words = startViewModel.getWordsFromDB()
		changeSwipeMenuDirection()
	}
	
	
	//Кнопка старта игры, проверяет что все 3 поля заполнены
	@IBAction func startAction(_ sender: UIButton? = nil) {
		guard bigWordTextField.text != "" else {
			self.present(createAlert(message: "Выберите слово"), animated: true, completion: nil)
			return
		}
		
		guard user1NameTextField.text != "" || user2NameTextField.text != "" else {
			self.present(createAlert(message: "Введите имена игроков"), animated: true, completion: nil)
			return
		}
		
		performSegue(withIdentifier: "FromStartToMain", sender: nil)
	}
	
	func createAlert(message: String) -> UIAlertController {
		let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(okAction)
		return alert
	}
	
	private func addObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	func choiceUIElement() {
		elementPicker.delegate = self
		elementPicker.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		bigWordTextField.inputView = startViewModel.checkDataBaseEmptyByWords() ? nil : elementPicker
//		bigWordTextField.inputView = elementPicker
		print(startViewModel.checkDataBaseEmptyByWords())
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "FromStartToMain" {
			let destVC = segue.destination as! GameViewController
			destVC.user1 = startViewModel.createUser(withName: user1NameTextField.text ?? "Игрок 1", andColor: #colorLiteral(red: 0.4745098039, green: 0.7058823529, blue: 0.8509803922, alpha: 1))
			destVC.user2 = startViewModel.createUser(withName: user2NameTextField.text ?? "Игрок 2", andColor: #colorLiteral(red: 0.1058823529, green: 0.7490196078, blue: 0.2666666667, alpha: 1))
			destVC.bigWord = bigWordTextField.text?.lowercased() ?? "cтранности"
		}
	}
}

//MARK: - PickerView Delegate and Data Source methods
extension StartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	
	//Если в момент вызова picker view БД по словам пустая - выставляем 0 компонентов, по умолчанию ставим 1
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		if startViewModel.checkDataBaseEmptyByWords() {
			return 0
		} else {
			return 1
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return words!.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return words![row].word
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		bigWordTextField.text = words![row].word
	}
	
}

//MARK: - Methods for text fields from delegate
extension StartViewController {
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		
		if (textField == user1NameTextField || textField == user2NameTextField) && bigWordTextField.isFirstResponder {
			bigWordTextField.resignFirstResponder()
			dismissKeyboard()
			return true
		}
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		if textField == user1NameTextField {
			user2NameTextField.becomeFirstResponder()
		} else {
			dismissKeyboard()
			startAction()
		}
		return true
	}
	
}



//MARK: - Custom methods and selectors
extension StartViewController {
	
	
	func hideKeyBoardOnTap() {
		let tap = UITapGestureRecognizer(
			target: self,
			action: #selector(dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	
	//Проверяем что в БД есть класс большого слова и он не пустой - создаём если нет
	func checkOneWordInDB() {
		if startViewModel.checkDataBaseEmptyByWords()  {
			startViewModel.addDefaultWordToDataBase("Магнитотерапия")
		}
	}
	
	//Проверяем что в БД есть элемент Max Score и он не пустой - создаём если нет
	func checkMaxScoreInDB() {
		if startViewModel.dataManager.checkMaxScoreEmpty() {
			let score = MaxScore()
			score.maxScore = 50
			startViewModel.dataManager.addObjectToDataBase(score)
		}
	}
	
	//Создание жеста для открытия/закрытия Menu VC по свайпу
	func configurateGestureSwipes() {
		gestureSwipeForMenu = UISwipeGestureRecognizer(target: self, action: #selector(moveStartVC))
		gestureSwipeForMenu.direction = .right
		view.addGestureRecognizer(gestureSwipeForMenu)
	}
	
	//Меняет используемое направление swipe жеста
	func changeSwipeMenuDirection() {
		if gestureSwipeForMenu.direction == .right {
			gestureSwipeForMenu.direction = .left
		} else {
			gestureSwipeForMenu.direction = .right
		}
	}
	
	private func findFirstResponderFromTF() -> UITextField? {
		for tf in [user1NameTextField, user2NameTextField, bigWordTextField] {
			if tf!.isFirstResponder { return tf }
		}
		return nil
	}
	
}


//MARK: - custom selectors

extension StartViewController {
	
	@objc func handleKeyboardWillShow(_ notification: NSNotification) {
		let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
		guard let keyboardHeight = keyboardFrame?.height else { return }
		guard let firstResponder = findFirstResponderFromTF() else { return }
		
		let maxYToView = firstResponder.convert(CGPoint(x: 0, y: firstResponder.bounds.height), to: view).y
		let overlapping = keyboardHeight - (view.frame.height - maxYToView)
		if overlapping >= 0 {
			
			let y = firstResponder.superview!.convert(CGPoint(x: 0, y: firstResponder.superview!.bounds.height), to: self.view).y
			let over = keyboardHeight - (view.frame.height - y)
			
			guard let keyboardShowDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
			UIView.animate(withDuration: keyboardShowDuration) { [weak self] in
//				self?.view.frame.origin.y = -(overlapping + 40)
				self?.view.frame.origin.y = -(over)
			}
		}
	}
	
	@objc func handleKeyboardWillHide(_ notification: NSNotification) {
		if view.frame.origin.y != 0 {
			guard let keyboardShowDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
			UIView.animate(withDuration: keyboardShowDuration) { [weak self] in
				self?.view.frame.origin.y = 0
			}
		}
	}
	
	@objc func dismissKeyboard() {
		self.view.endEditing(true)
	}
	
	//Селектор вызываемый swip'om для открытия/закрытия menu VC
	@objc func moveStartVC() {
		delegate?.toggleMenu()
		words = startViewModel.getWordsFromDB()
		changeSwipeMenuDirection()
	}
}
