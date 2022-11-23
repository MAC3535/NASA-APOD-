//
//  FullPictureViewController.swift
//  NASAapp
//
//  Created by Studio.C on 8/29/22.
//

import UIKit

class FullPictureViewController: UIViewController {
    
    
    @IBOutlet var selectedDescription: UITextView!
    @IBOutlet var selectedImage: UIImageView!
    
    var userImageDescription = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        userImageDescription = chosenDescription
        
        selectedDescription.text = userImageDescription
        selectedImage.image = chosenImage
        
        selectedImage.layer.cornerRadius = 40.0
        selectedImage.layer.masksToBounds = true
        
        navigationController?.hidesBarsOnTap = true
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = chosenDate
        
        
    }


}
