//
//  StartViewModel.swift
//  Lesson14_WorkGame
//
//  Created by MacBook Air on 06.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class StartViewModel {
	
	let dataManager = DataManager()
	var words: Results<Word>?
	
	func getWordsFromDB() -> Results<Word>? {
		
		words = realm.objects(Word.self).sorted(byKeyPath: "id")
		return words
	}
	
	func createUser(withName name: String, andColor color: UIColor) -> User {
		return User(name: name, score: 0, color: color)
	}
	
	func addDefaultWordToDataBase(_ word: String) {
		dataManager.addObjectToDataBase(Word(value: ["id" : 1, "word" : word]))
	}
	
	func checkDataBaseEmptyByWords() -> Bool {
		return dataManager.checkEmptyInWordsDB()
	}
	
}
