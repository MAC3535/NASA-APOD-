//
//  DisplayController.swift
//  NASAapp
//
//  Created by Studio.C on 8/2/22.
//

import UIKit

var chosenImage = UIImage()
var chosenDescription = ""
var chosenDate = ""

class DisplayController: UICollectionViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answerDate.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? DisplayCell else {
            fatalError("Problem with cell")
        }
        let imageUrl = URL(string: answerUrl[indexPath.row])
        let data = try? Data(contentsOf: imageUrl!)
        
        
        cell.imageLabel.text = answerDate[indexPath.row]
        cell.image.image = UIImage(data: data!)
        
        cell.layer.cornerRadius = 40.0
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chosenDescription = answerExplanation[indexPath.row]
        chosenDate = answerDate[indexPath.row]
        
        let imageUrl = URL(string: answerUrl[indexPath.row])
        let data = try? Data(contentsOf: imageUrl!)
        chosenImage = UIImage(data: data!)!
        
        print(indexPath.row)
        performSegue(withIdentifier: "fullPictureSegue", sender: self)
    }
}
