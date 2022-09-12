//
//  ErrorMsg.swift
//  FetchExercise
//
//  Created by Aries Lam on 9/7/22.
//

import Foundation

enum ErrorMsg: String, Error{
    case invalidMeal = "There is no meal"
    case invalidDessert = "There is no dessert"
    case unableToComplete = "Unable to complete your request. Please check your connection "
    case invalidResponse = "Invalid response from the server. Please try again!"
    case invalidData = "The data received from the server was invalid. Please try again!"
}
