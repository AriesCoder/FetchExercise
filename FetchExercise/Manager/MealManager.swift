//
//  MealManager.swift
//  FetchExercise
//
//  Created by Aries Lam on 9/7/22.
//

import Foundation

class MealManager{
    static let shared = MealManager()
    let baseURL = "https://www.themealdb.com/"
    
    func getMeal(_ mealId: String, completed: @escaping (MealDetails?, ErrorMsg?) -> Void){
        let urlString = baseURL + "api/json/v1/1/lookup.php?i=\(mealId)"
        
        guard let url = URL(string: urlString) else{
            completed(nil, .invalidMeal)
            return}

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completed(nil, .unableToComplete)
            }
            
            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
            else {
                completed(nil, .invalidResponse)
                return
            }
            
            guard let safeData = data else{
                completed(nil, .invalidData)
                return
            }
            do{
                let decoder = JSONDecoder()
                let decodedMeal = try decoder.decode(Meal.self, from: safeData)
                
                guard let mealName = decodedMeal.meals[0].strMeal,
                      let instruction = decodedMeal.meals[0].strInstructions
                else{
                    completed(nil, .invalidData)
                    return
                }
                
                //convert decodedMeal Object to a dictionary
                let dictData = decodedMeal.meals[0].dictionary
                
                //convert the valued of srtIngredients and srtMeasures into arrays of String
                let ingredients = dictData.filter{$0.key.contains("strIngredient")}.array
                let measures = dictData.filter{$0.key.contains("strMeasure")}.array
                
                let mealDetail = MealDetails(strMeal: mealName, strInstructions: instruction, strIngredient: ingredients, strMeasure: measures)
                completed(mealDetail, nil)
//                self.delegate?.didGetMeal(meal: mealDetail)
            }catch{
                completed(nil, .invalidData)
            }
        }
        task.resume()
    }
}
extension Encodable {
    var dictionary: [String: String] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: String] ?? [:]
    }
    var array: [String] {
        return dictionary
            .map { ($1) }    //convert values array
            .filter{ $0 != ""}  //filter out empty and nill values
    }
}


