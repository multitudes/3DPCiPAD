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
         print(urlPath)
         
         let videoURL = URL(fileURLWithPath: urlPath)
         //let videoURL = "https://192.168.178.20:8080/videos/Amie1.0.mp4"
         //let url = URL(string: videoURL)!
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
        modelImageView.image = UIImage(named: model.image + "L" + ".jpg")
        // Dynamic Type for the content. iOS offers the option to enhance the legibility of text by increasing font weight and setting the preferred font size for apps. The user can open the Settings app and navigate to General ▸ Accessibility ▸ Larger Text to access Dynamic Type text sizes and make te contents bigger
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
    }
}
