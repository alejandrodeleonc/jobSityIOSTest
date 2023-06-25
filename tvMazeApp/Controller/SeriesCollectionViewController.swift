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
    var collectionViewData: [Serie]!
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
        collectionViewData = seriesArray
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
        return collectionViewData.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SerieCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SerieCollectionViewCell
        
        cell.setupSerie(serie: collectionViewData[indexPath.row])

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           if(collectionViewData.count > 0){
               let vc = SerieDetailViewController(serie:collectionViewData[indexPath.row] )
           
               self.navigationController?.pushViewController(vc, animated: true)
           }
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
    
}

