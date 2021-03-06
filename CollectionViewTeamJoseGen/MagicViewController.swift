//
//  ViewController.swift
//  CollectionViewTeamJoseGen
//
//  Created by Genesis Mosquera on 1/9/19.
//  Copyright © 2019 Genesis Mosquera. All rights reserved.
//

import UIKit

class MagicViewController: UIViewController {
    var magicImages = [Card]() {
        didSet {
            DispatchQueue.main.async {
                self.magicCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var magicCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        magicCollectionView.dataSource = self
        magicCollectionView.delegate = self
        upDateCards()
    }
    func upDateCards() {
        MagicAPI.updateMagic { (appError, cards) in
            if let appError = appError {
                print(appError)
            } else if let cards = cards {
                self.magicImages = cards.filter() {$0.imageUrl != nil}
            }
        }
    }
}
    extension MagicViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return magicImages.count
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MagicCell", for: indexPath) as? MagicCell else {return UICollectionViewCell()}
            ImageHelper.shared.fetchImage(urlString: magicImages[indexPath.row].imageUrl!) { (appError, image) in
                if let appError = appError {
                    print(appError.errorMessage())
                } else if let image = image {
                    cell.magicImageView.image = image
                }
            }
            return cell
    }
}
extension MagicViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let magicVC = storyboard.instantiateViewController(withIdentifier: "secondDetail") as? MagicDetailViewController else {return}
        magicVC.modalPresentationStyle = .overCurrentContext
        magicVC.magicImage =  magicImages[indexPath.row]
        present(magicVC, animated: true, completion: nil)
    }
}
