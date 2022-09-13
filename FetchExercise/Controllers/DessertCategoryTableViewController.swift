//
//  DessertCategoryTableViewController.swift
//  FetchExercise
//
//  Created by Aries Lam on 9/9/22.
//

import UIKit
import SDWebImage

class DessertCategoryTableViewController: UITableViewController {

    var dessertArr = [DessertData]()
    var img: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDessert()
    }
    
    func loadDessert(){
        DessertManager.shared.getDessert { [self] desserts, error in
            if let _ = error{
                print("Cannot get Dessert data.")
            }
            guard let desserts = desserts else{return}
            DispatchQueue.main.async {
                dessertArr = desserts.meals
                tableView.reloadData()
            }
        }        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dessertArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dessertCell", for: indexPath)
        cell.textLabel?.text = dessertArr[indexPath.row].strMeal
        
        let imageUrl = dessertArr[indexPath.row].strMealThumb
        cell.imageView?.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(systemName: "photo"), options:.continueInBackground, completed: nil)
        
        return cell
    }
    
    // segue to MealDetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segToMealVC"{
            guard let destination = segue.destination as? MealDetailViewController
            else{return}
            guard let idx = tableView.indexPathForSelectedRow else {
                return
            }
            destination.mealId = dessertArr[idx.row].idMeal
            }
        }
}



