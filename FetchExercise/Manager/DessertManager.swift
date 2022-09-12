//
//  DessertManager.swift
//  FetchExercise
//
//  Created by Aries Lam on 9/8/22.
//

import Foundation
import UIKit

class DessertManager{
    static let shared = DessertManager()

    func getDessert(completed: @escaping (Dessert?, ErrorMsg?) -> Void){
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert"

        guard let url = URL(string: urlString) else{
            completed(nil, .invalidDessert)
            return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error{
                completed(nil, .unableToComplete)
            }

            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200
            else {
                completed(nil, .invalidResponse)
                print("response err")
                return
            }

            guard let safeData = data else{
                completed(nil, .invalidData)
                return
            }
            do{
                let decoder = JSONDecoder()
                let decodedDessert = try decoder.decode(Dessert.self, from: safeData)
                completed(decodedDessert, nil)

            }catch{
                completed(nil, .invalidData)
            }
        }  
        task.resume()
    }

}
