//
//  Words.swift
//  Lesson14_WorkGame
//
//  Created by MacBook Air on 30.01.2020.
//  Copyright © 2020 Denis Valshchikov. All rights reserved.
//

import Foundation
import RealmSwift

class Word: Object {
	
	@objc dynamic var id: Int = 0
	@objc dynamic var word: String = ""
	
	override class func primaryKey() -> String? {
		return "id"
	}
	
}


