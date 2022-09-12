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
    @IBOutlet weak var ingredientTF: UITextView!
    
    
    var mealId: String?
//    var testTV: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMeal(mealId)
        
        }
    
    func fetchMeal(_ mealId: String?){
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
                ingredientTF.text = meal.strIngredient.joined(separator: "\n")
            }
        }
    
    }

}


