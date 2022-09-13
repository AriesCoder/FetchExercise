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
                
                //filter out the ingredient and measure into seperated dictionaries
                let ingredientDict = dictData.filter{$0.key.contains("strIngredient")}
                let measureDict = dictData.filter{$0.key.contains("strMeasure")}
                
                //create object index
                let strIngredient = "strIngredientxx"
                let idxIngredient = strIngredient.index(strIngredient.startIndex, offsetBy: 13)
                let strMeasure = "strMeasurexx"
                let idxMeasure = strMeasure.index(strMeasure.startIndex, offsetBy: 10)
                
                //sort value of ingredient/measure dictionary into an array
                let ingredientArr = ingredientDict.sorted(by: {
                    Int($0.0[idxIngredient...])! < Int($1.0[idxIngredient...])!
                }).map({$0.1}).filter({$0 != "" && $0.first != " "})
                let measureArr = measureDict.sorted(by: {
                    Int($0.0[idxMeasure...])! < Int($1.0[idxMeasure...])!
                }).map({$0.1}).filter({$0 != "" && $0.first != " "})
                
                //create mealDetail Object
                let mealDetail = MealDetails(strMeal: mealName, strInstructions: instruction, strIngredient: ingredientArr, strMeasure: measureArr)
                completed(mealDetail, nil)
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
}


