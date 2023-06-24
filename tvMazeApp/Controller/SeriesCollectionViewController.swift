//
//  SeriesCollectionViewController.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 24/6/23.
//

import UIKit
import Alamofire
import AlamofireImage
private let reuseIdentifier = "Cell"

class SeriesCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    var seriesArray : [Serie]!
    let searchBar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // Configurar el diseño de la colección
        let layout = UICollectionViewFlowLayout()
        let desiredWidth: CGFloat = 180 // Anchura deseada
        let aspectRatio: CGFloat = 194.0 / 334.0 // Ratio de aspecto (Ancho / Alto)
        
        let width = desiredWidth
        let height = width / aspectRatio
             
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = layout
        
        // Registra la clase de celda personalizada
        collectionView.register(SerieCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Otros ajustes de la colección
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return seriesArray.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SerieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SerieCollectionViewCell
        
        cell.setupSerie(serie: seriesArray[indexPath.row])

        return cell
    }
    
    func getCellImage(serie: Serie) -> UIImage{
        var image: UIImage =  UIImage(named: "AppIcon")!
        AF.request(serie.image.original, method: .get).response{ response in
            
            switch response.result {
                case .success(let responseData):
                image = UIImage(data: responseData!, scale:1) ?? UIImage(named: "")!

                case .failure(let error):
                    print("error--->",error)
                }
                
            }
        return image
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

