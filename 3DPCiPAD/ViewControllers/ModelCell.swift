//
//  ModelCell.swift
//  3DPCiPAD
//
//  Created by Laurent B on 17/09/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//

import Foundation

import UIKit

class ModelCell: UITableViewCell {
    
    @IBOutlet weak var modelCellImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
 
    // MARK:- Public Methods
    func configure(for model: Model) {
     titleLabel?.text = model.title
     subtitleLabel?.text = model.subtitle
     //print(modelTitle.text!)
     //This tells the UIImageView to load the image from the link and to place it in the cell’s image view
     
     print(model.title)
     // make rounded corner.
     modelCellImage?.image = UIImage(named: model.image)
     modelCellImage?.layer.cornerRadius = 15
     modelCellImage?.clipsToBounds = true
    
    }
}
