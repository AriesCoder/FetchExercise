//
//  Dessert.swift
//  FetchExercise
//
//  Created by Aries Lam on 9/9/22.
//

import Foundation
struct Dessert: Codable{
    var meals: [DessertData]
}

struct DessertData: Codable{
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}
