//
//  SeriesCollectionViewController.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 24/6/23.
//

import UIKit
import Alamofire
import AlamofireImage
import DropDown

private let reuseIdentifier = "Cell"

class SeriesCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    var seriesArray : [Serie]!
    let searchBar = UISearchBar()
    var collectionViewData: [Serie]!
    let dropDown = DropDown()
    let dividend = 1800
    let divisor = 250
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
        let pagesButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(showDropdown))
           
           // Asignar el botón a la barra de navegación
           
        
        // Crear el botón con el icono de lupa
           let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
           
           
        navigationItem.leftBarButtonItem = pagesButton
        navigationItem.rightBarButtonItem =  searchButton
        navigationItem.titleView = searchBar
        
        setupDropDown()


    }
    
    func setupDropDown(){
        let result = Int(floor(Double(dividend) / Double(divisor)))
        
        var strings: [String] = []
        
        for i in 1...result {
            let numberString = String(i)
            strings.append(numberString)
        }
        dropDown.anchorView = navigationItem.leftBarButtonItem
        dropDown.dataSource = strings
        let defaultSelectedIndex = 0
        dropDown.selectRow(at: defaultSelectedIndex)
        dropDown.selectionAction = { [weak self] (index, item) in
            print("\(item)")
            
            self?.getSeriesWithPage(page:item)
            
        }
    }
    
    
    @objc func showDropdown(_ sender: UIButton) {
        dropDown.show()
    }
    
    @objc func rightButtonTapped() {
        // Implementa la lógica que deseas ejecutar cuando se presione el botón
        
    }
    
    @objc func searchButtonTapped() {
        // Implementa la lógica que deseas ejecutar cuando se presione el botón de búsqueda
        let query = self.searchBar.text
        APIManager.shared.fetchSearch(query: query ?? "") { result in
            switch result {
            case .success(let data):
                
                if(data.count > 0){
                    self.seriesArray = data
                    self.collectionViewData = self.seriesArray
                }
                self.collectionView.reloadData()
            case .failure(let error):
                // Maneja el error
                print(error.localizedDescription)
            }
        }
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
    
    
    
    func getSeriesWithPage(page:String){
        APIManager.shared.fetchSeries(page:page, completion: { result in
            switch result {
            case .success(let data):
                self.seriesArray = data
                self.collectionViewData = self.seriesArray
                
                self.collectionView.reloadData()
            case .failure(let error):
                // Maneja el error
                print(error.localizedDescription)
            }
        })
    }
    
    
    func filterCollectionView(withName name: String) {
           //TODO: Needs to be change to use de endpoint  /search/shows?q=:query
           
           if name.isEmpty {
               // Si el nombre está vacío, muestra todos los elementos originales
               collectionViewData = seriesArray
           } else {
               // Filtra los elementos originales por nombre
               collectionViewData = seriesArray.filter { $0.name.lowercased().contains(name.lowercased()) }
           }
        
        if(self.seriesArray.count == 0){
            self.getSeriesWithPage(page:"1")
        }
           
           // Actualiza el UICollectionView
           collectionView.reloadData()
           
       }
       
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           filterCollectionView(withName: searchText)
       }
    
        

}

