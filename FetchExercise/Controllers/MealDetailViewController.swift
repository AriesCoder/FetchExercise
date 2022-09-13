//
//  ViewController.swift
//  FetchExercise
//
//  Created by Aries Lam on 9/7/22.
//

import UIKit

class MealDetailViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var ingredientTV: UITextView!
    @IBOutlet weak var measureTV: UITextView!
    
    var mealId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMeal(mealId)
        }
    
    func loadMeal(_ mealId: String?){
        guard let id = mealId else {
            return
        }
        MealManager.shared.getMeal(id) { [self] meal, error in
            if let _ = error {
                print("Cannot get meal data.")
                return
            }
            guard let meal = meal else{return}
            DispatchQueue.main.async {
                textView.text = meal.strInstructions
                mealName.text = meal.strMeal
                ingredientTV.text = meal.strIngredient.joined(separator: "\n")
                measureTV.text = meal.strMeasure.joined(separator: "\n")
            }
        }
    
    }

}


