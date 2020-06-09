//
//  MyWordsTableViewModel.swift
//  Lesson14_WorkGame
//
//  Created by MacBook Air on 07.02.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MyWordsTableViewModel {
	
	let dataManager = DataManager()
	var wordsSortedByID = realm.objects(Word.self).sorted(byKeyPath: "id")
	var wordsNotSorted = realm.objects(Word.self)
	var currentMaxScore = realm.objects(MaxScore.self)  //Считываем из базы все объекты в массив типа MaxScore
	
	func removeWordFromDataBase(atIndex index: Int) {
		dataManager.removeFromDataBase(object: wordsNotSorted[index])
		
//		self.dataManager.removeFromDataBase(object: self.myWordsTableViewModel.wordsNotSorted[indexPath.row])
	}
	
}
