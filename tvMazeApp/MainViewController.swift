//
//  ViewController.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 23/6/23.
//

import UIKit
import Alamofire
class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemMint
        APIManager.shared.fetchSeries(page: "1", completion: { result in
            switch result {
                case .success(let data):
                    // Procesa los datos recibidos

                let viewController = SeriesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()) // Crea tu controlador de vista principal
                
                viewController.seriesArray = data

                self.navigationController?.pushViewController(viewController, animated: true)
                case .failure(let error):
                    // Maneja el error
                    print(error.localizedDescription)
                }
        })
    }


}

