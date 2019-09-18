//
//  ViewController.swift
//  3DPCiPAD
//
//  Created by Laurent B on 14/10/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchControllerDelegate{

    // initialize variables
    var models = [Model]()
    var filteredModels = [Model]()

    
    
    // I create a new UISearchController to add searching to my view controller.
    let searchController = UISearchController(searchResultsController: nil)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pushing Boundaries"
        // add a large title to the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // add a search controller to the navigation bar
        createSearchController()
        
        // load the data
        getData()
        
        // My custom nothing found cell!
        let cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:"NothingFoundCell")
    }

 
    private func createSearchController() {
        // The search controller actually belongs as a property of the navigation item of the view controller, which automatically places it inside my navigation bar when the view controller is displayed. // Aktualisierung der Suchergebnisse via UISearchResultsUpdating-Protokoll
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type something here to search"
        // very important. Without this line would not work! A Boolean value that indicates whether this view controller's view is covered when the view controller or one of its descendants presents a view controller.
        searchController.definesPresentationContext = true
        //searchController.isActive = false
        
        // UISearchController abhängig von der iOS-Version registrieren
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        } else {
            self.tableView.tableHeaderView = self.searchController.searchBar
        }
    }
    
    // MARK:- DATA
    func getData(){
       if let path = Bundle.main.path(forResource: "models", ofType: "json") {
            print(path)
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                parse(json: data)
            } catch {
                print("error")
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonModels = try? decoder.decode(Models.self, from: json) {
            models = jsonModels.models
            models.sort(by: <)
        }
    }
    
// MARK:- TableViews

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if nothing has been found
        if searchController.isActive && filteredModels.count == 0 && searchController.searchBar.text != ""{
            return 1
        }
        // if i need to display the results of the search
        if searchController.isActive && searchController.searchBar.text != "" {
            print(filteredModels.count)
            return filteredModels.count
        } else { //all other cases display the whole array of models
            return models.count
        }
    }
    
    // Will return a cell to populate the table. The number of cells is defined above in numberOfRowsInSection
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // this will return my  cell saying nothing found. if there are no results, the method returns 1, for the row with the text “(Nothing Found)" distinguish between “not searched yet” and “nothing found”.
        if searchController.isActive && filteredModels.count == 0 && searchController.searchBar.text != "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NothingFoundCell", for: indexPath)
//            cell.titleLabel?.text = ""
//            cell.subtitleLabel?.text = "nothing found!"
//            cell.modelCellImage?.image = nil
            return cell
        }
        
        // this will return my result cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModelCell", for: indexPath) as! ModelCell
        let model: Model
        if searchController.isActive && searchController.searchBar.text != "" {
            model = filteredModels[indexPath.row]
        } else {
            model = models[indexPath.row]
        }
        cell.titleLabel?.text = model.title
        cell.subtitleLabel?.text = model.subtitle
        //print(modelTitle.text!)
        //This tells the UIImageView to load the image from the link and to place it in the cell’s image view
        
        print(model.title)
        // make rounded corner.
        cell.modelCellImage?.image = UIImage(named: model.image)
        cell.modelCellImage?.layer.cornerRadius = 15
        cell.modelCellImage?.clipsToBounds = true
        return cell
    }
    // This will deselect the row after it has been selected and will perform the segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchController.resignFirstResponder()
        if view.window!.rootViewController!.traitCollection
            .horizontalSizeClass == .compact {
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "ShowDetail",
                         sender: indexPath)
        } else {
           // splitViewDetail?.model = models[indexPath.row]
        }
        //performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    // This will disable the selection of a cell when the results are nil
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchController.isActive && filteredModels.count == 0 && searchController.searchBar.text != "" {
            return nil
        } else  {
            return indexPath
        }
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
           // let detailViewController = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            var model: Model
            if searchController.isActive && filteredModels.count != 0 && searchController.searchBar.text != "" {
                model = filteredModels[indexPath.row]
                print(indexPath.row)
                print(model.title)
            } else {
                model = models[indexPath.row]
                print(indexPath.row)
                print(model.title)
            }
           // detailViewController.model = model
        }
    }
}

// Add a conformance to UISearchResultsUpdating. This is for my UIViewController
extension ViewController: UISearchResultsUpdating {
    // This method is required by the UISearchResultsUpdating protocoll and gets called every time the user types anything into the search bar, so I can use the new text to filter my data however I want:
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            print(text) // for debugging
            // this is
            //filterModels(for: text)
            filteredModels = models.filter { model in
                model.title.localizedCaseInsensitiveContains(text)
            }
        } else {
            filteredModels = models
            print(filteredModels.count)
        }
        tableView.reloadData()
    }
}
// sorting functions
func < (lhs: Model, rhs: Model) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
}

func > (lhs: Model, rhs: Model) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedDescending
}
