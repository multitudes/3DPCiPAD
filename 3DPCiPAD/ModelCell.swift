//
//  ModelCell.swift
//  PushingBoundaries
//
//  Created by Laurent B on 20/07/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//

import UIKit

class ModelCell: UITableViewCell {
    
    var downloadTask: URLSessionDownloadTask?
    //let serverURL: String = "http://127.0.0.1:8000/"
    
    // These are corresponding to the ModelCell nib
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var modelImageView: UIImageView!
    
    //The awakeFromNib() method is called after the cell object has been loaded from the nib but before the cell is added to the table view
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // adding some color
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 73/255, green: 166/255, blue: 255/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK:- Public Methods
    func configure(for model: Model) {
        title.text = model.title
        subtitle.text = model.subtitle
        
        //This tells the UIImageView to load the image from the link and to place it in the cell’s image view
        modelImageView.image = UIImage(named: model.image + "@3x")

        // make rounded corner. To have a round image make it equal to:
        // modelImageView.layer.bounds.size.width / 2
        modelImageView.layer.cornerRadius = 15;
        
    }
    
    // in case the image download is cancelled and no longer need that image,I cancel the pending download. Table view cells have a special method named prepareForReuse()
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }

}

// sorting functions
func < (lhs: Model, rhs: Model) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
}

func > (lhs: Model, rhs: Model) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedDescending
}
