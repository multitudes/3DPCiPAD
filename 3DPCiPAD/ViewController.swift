//
//  ViewController.swift
//  3DPCiPAD
//
//  Created by Laurent B on 14/10/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchControllerDelegate{

    // initialize variables
    var isLoading = false
    var models = [Model]()
    var filteredModels = [Model]()
    var hasSearched = 0
    // I create a new UISearchController to add searching to my view controller.
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    //Using a constant for table cell identifier as used in the extensions: a new struct, TableView, containing a secondary struct named CellIdentifiers which contains a constant for the name of the cell nib
    struct TableView {
        struct CellIdentifiers {
            static let ModelCell = "ModelCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pushing Boundaries"
        // add a large title to the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // add a search controller to the navigation bar
        createSearchController()
        
        // load the data from the network
        getData()
        
        // register the cell nibs
        registerNibs()
        
        
    }

    private func registerNibs() {
        // register the cell nibs
        // this is my cell nib
        var cellNib = UINib(nibName: TableView.CellIdentifiers.ModelCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
            TableView.CellIdentifiers.ModelCell)
        // this nib will be shown when nothing has been found
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
            TableView.CellIdentifiers.nothingFoundCell)
        // this nib will be shown when the network is slow and still loading
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
            TableView.CellIdentifiers.loadingCell)
    }
    private func createSearchController() {
        // The search controller actually belongs as a property of the navigation item of the view controller, which automatically places it inside my navigation bar when the view controller is displayed
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Type something here to search"
        searchController.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        //searchController.isActive = true
        
        // very important. Without this line would not work! A Boolean value that indicates whether this view controller's view is covered when the view controller or one of its descendants presents a view controller.
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
    }
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
    

    func filterModels(for searchText: String) {
        filteredModels = models.filter { model in
            return model.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
}

// the extension allows for the table view delegates
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        }
        if searchController.isActive && filteredModels.count == 0 && searchController.searchBar.text != ""{
            return 1
        }
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredModels.count
        } else {
            return models.count
        }
    }
    
    // Will return a cell to populate the table. The number of cells is defined above in numberOfRowsInSection
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // this will return my nib cell saying nothing found
        if searchController.isActive && filteredModels.count == 0 && searchController.searchBar.text != ""
        {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        }
        // this will return my result cells
        let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.ModelCell, for: indexPath) as! ModelCell
        let model: Model
        if searchController.isActive && searchController.searchBar.text != "" {
            model = filteredModels[indexPath.row]
        } else {
            model = models[indexPath.row]
        }
        cell.configure(for: model)
        return cell
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
    
    // This will deselect the row after it has been selected and will perform the segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if models.count == 0 || isLoading {
            print("NIL!")
            return nil
        }
        if searchController.isActive && filteredModels.count == 0 && searchController.searchBar.text != "" {
            return nil
        } else  {
            return indexPath
        }
    }
}

// Add a conformance to UISearchResultsUpdating.
extension ViewController: UISearchResultsUpdating {
    // This method is required by the UISearchResultsUpdating protocoll and gets called every time the user types anything into the search bar, so I can use the new text to filter my data however I want:
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        hasSearched = 1
        if text == "" {
            filteredModels = models
            tableView.reloadData()
        } else {
            print(text) // for debugging
            // this is
            filterModels(for: text)
        }
    }
}
