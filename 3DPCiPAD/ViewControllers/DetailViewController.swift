//
//  DetailViewController.swift
//  3DPCiPAD
//
//  Created by Laurent B on 18/09/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//

import UIKit
import AVKit

class DetailViewController: UIViewController {

    // This is the variable which gets allocated in the prepare for segue method of the previous viewcontroller
    var model: Model!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var modelImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBAction func playVideo(_ sender: UIButton) {
         let urlPath = Bundle.main.path(forResource: model.image, ofType: "mp4")!
         let videoURL = URL(fileURLWithPath: urlPath)
         let player = AVPlayer(url: videoURL)
         let vc = AVPlayerViewController()
         vc.player = player
         present(vc, animated: true) {
             vc.player?.play()
         }
     }
    

    // MARK:- Actions
    @IBAction func close() {
        // this is the right way to dismiss the view controller. The presenting vc is dismissing it not the presented, as explained by Hegarty of Sanford!
            presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {

    }
    func updateUI() {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        textView.text = model.contentText
        modelImageView.image = UIImage(named: "Placeholder")
        // the name of the large images have L appended to the name
        modelImageView.image = UIImage(named: model.image + "L" + ".jpg")
        // Dynamic Type for the content. iOS offers the option to enhance the legibility of text by increasing font weight and setting the preferred font size for apps. The user can open the Settings app and navigate to General ▸ Accessibility ▸ Larger Text to access Dynamic Type text sizes and make te contents bigger
        textView.font = .preferredFont(forTextStyle: .body)
        //when the user returns from changing the text size settings, the app should refresh the screen without needing an app restart. You can do this by reloading the table view when the app receives a UIContentSizeCategoryDidChange notification
        textView.adjustsFontForContentSizeCategory = true
    }
}
