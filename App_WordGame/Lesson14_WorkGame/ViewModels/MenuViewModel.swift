//
//  MenuViewModel.swift
//  Lesson14_WorkGame
//
//  Created by MacBook Air on 07.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MenuViewModel {
	
	let dataManager = DataManager()
	var wordsSortedByID = realm.objects(Word.self).sorted(byKeyPath: "id")
	var wordsNotSorted = realm.objects(Word.self)
	var currentMaxScore = realm.objects(MaxScore.self)  //Считываем из базы все объекты в массив типа MaxScore
	
	func getCurrentMaxScore() -> Int {
		let currentMaxScore = dataManager.getCurrentMaxScore()
		return currentMaxScore ?? 0
	}
	
	func addNewWordToDataDB(fromUserInput word: String) {
		try! realm.write {
//			let newWord = Word(value: ["id": (words.last?.id ?? 0) + 1, "word": word])
			let newWord = Word(value: [((wordsSortedByID.last?.id ?? 0) + 1),word])
			realm.add(newWord)
		}
	}
	
	func addNewScoreToDataBase(newScore: Int) {
		if currentMaxScore.isEmpty == true {
			dataManager.addObjectToDataBase(MaxScore(value: [newScore]))
		} else {
			try! realm.write {
				realm.delete(currentMaxScore)
				realm.add(MaxScore(value: [newScore]))
			}
		}
	}
}
