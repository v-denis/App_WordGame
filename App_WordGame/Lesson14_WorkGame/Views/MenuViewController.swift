//
//  MenuViewController.swift
//  Lesson11_WorkGame
//
//  Created by MacBook Air on 23.01.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import UIKit
import RealmSwift


class MenuViewController: UIViewController, UITextFieldDelegate {
	
	let menuViewModel = MenuViewModel()
	@IBOutlet weak var newBigWordTextLabel: UITextField!
	@IBOutlet weak var maxScoreTextLabel: UITextField!
	@IBOutlet weak var saveBigWordButton: UIButton!
	@IBOutlet weak var saveNewMaxScoreButtonOutlet: UIButton!
	@IBOutlet weak var myWordsTableButtonOutlet: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
        configurateMenuVC()
    }
	
	//MARK: В данном методе конфигурируем VC и запускаем методы созданные ниже
	func configurateMenuVC() {
		
		saveBigWordButton.layer.cornerRadius = 10
		myWordsTableButtonOutlet.layer.cornerRadius = 10
		saveNewMaxScoreButtonOutlet.layer.cornerRadius = 10
		
		let _ = menuViewModel.wordsSortedByID 				//Сортируем слова в БД по порядку создания - по id
		let currentMaxScore = menuViewModel.getCurrentMaxScore()
		maxScoreTextLabel.text = String(currentMaxScore)	//Передаём в textLabel текущее значение макс счёта
		
		newBigWordTextLabel.delegate = self
		maxScoreTextLabel.delegate = self
		
		hideKeyBoardByScreenTap()
	}
	
	//MARK: Сохраняем новое большое слово
	@IBAction func saveAction(_ sender: Any) {
		
		newBigWordTextLabel.resignFirstResponder()
		guard newBigWordTextLabel.text != "" else {
			newBigWordTextLabel.becomeFirstResponder()
			presentSaveAction(incomeTitle: "Внимание!", incomeMessage: "Введите новое большое слово")
			return
		}
		
		let text: String = newBigWordTextLabel.text!
		menuViewModel.addNewWordToDataDB(fromUserInput: text)
		presentSaveAction(incomeTitle: "Готово", incomeMessage: "Слово сохранено")
		newBigWordTextLabel.text = ""
	}
	
	//MARK: Сохраняем новый счёт игры
	@IBAction func saveNewMaxScoreAction(_ sender: UIButton) {
		
		maxScoreTextLabel.resignFirstResponder()
		guard restoreMaxScore(withEntered: Int(maxScoreTextLabel.text!)) else { return }
		let newNumber: Int = Int(maxScoreTextLabel.text!)!
		menuViewModel.addNewScoreToDataBase(newScore: newNumber)
		presentSaveAction(incomeTitle: "Сохранено", incomeMessage: "Теперь играем до \(newNumber) очков")
		
	}
	
	//MARK: Осуществляем переход на TableVC с таблицей наших текущих слов
	@IBAction func myWordsAction(_ sender: UIButton) {
		performSegue(withIdentifier: "FromMenuToMyWords", sender: nil)
	}
	
}


//MARK: - Custom methods and selectors
extension MenuViewController {
	
	//MARK: Метод для сворачивание клавиатуры по тапу - жест
	func hideKeyBoardByScreenTap() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		self.view.addGestureRecognizer(tap)
	}
	
	//MARK: - Метод-селектор сворачивания клавиатуры
	@objc func dismissKeyboard() {
		self.view.endEditing(true)
	}
	
	//MARK: Действия по нажатию на кнопку "return": сохранить вводимый текст или свернуть клавиатуру
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == newBigWordTextLabel {
			if newBigWordTextLabel.text != "" {
				saveAction(saveBigWordButton as Any)
			} else {
				self.newBigWordTextLabel.resignFirstResponder()
			}
		} else if textField == maxScoreTextLabel {
			if maxScoreTextLabel.text != "" {
				saveNewMaxScoreAction(saveNewMaxScoreButtonOutlet)
			} else {
				self.maxScoreTextLabel.resignFirstResponder()
			}
		}
		return true
	}
	
	//MARK: Метод для создания и отображения алертов с указанным заголовком и сообщением
	func presentSaveAction(incomeTitle: String, incomeMessage: String) {
		let saveWordAction = UIAlertController(title: incomeTitle, message: incomeMessage, preferredStyle: .alert)
		let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
		saveWordAction.addAction(okButton)
		self.present(saveWordAction, animated: true, completion: nil)
	}
	
	//MARK: Метод для восстановления Max Score и вызова метода создания алертов при некорректном вводе нового значения
	func restoreMaxScore(withEntered score: Int?) -> Bool {
		
		if score == nil {
			maxScoreTextLabel.becomeFirstResponder()
			presentSaveAction(incomeTitle: "Внимание!", incomeMessage: "Счёт для игры должен быть числом")
			maxScoreTextLabel.text = String(menuViewModel.getCurrentMaxScore())
			return false
		} else if score! < 20 {
			maxScoreTextLabel.becomeFirstResponder()
			menuViewModel.addNewScoreToDataBase(newScore: 20)
			maxScoreTextLabel.text = "20"
			presentSaveAction(incomeTitle: "Внимание!", incomeMessage: "Минимум 20 очков")
			return false
		} else if score! > 250 {
			maxScoreTextLabel.becomeFirstResponder()
			menuViewModel.addNewScoreToDataBase(newScore: 250)
			maxScoreTextLabel.text = "250"
			presentSaveAction(incomeTitle: "Это будет слишком долго", incomeMessage: "Максимум до 250 очков")
			return false
		}
		return true
	}
	
}







//ДЗ: Перенести функционал присвоения ID новому большому слову в метод  dataManager.addToDataBase(object: word)
//Привести MenuViewController к парадигме MVVVM
//MyWordsTableVC так же привести к парадигме MVVM

//Постараться - gameViewController так же привести к MVVM
