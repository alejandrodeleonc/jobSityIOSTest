//
//  SerieDetailViewController.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 25/6/23.
//

import UIKit

class SerieDetailViewController: UIViewController {
    
    
    private var headerView: HeroHeaderUIView?
    private let tableView: UITableView =  UITableView(frame: .zero, style: .grouped)
    var serie: Serie!
        

    // Inicializador personalizado que acepta una instancia de Serie
    init(serie: Serie) {
        super.init(nibName: nil, bundle: nil) 
        self.serie = serie

    }
    
    // Implementación del inicializador requerido
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let navHeight = -(navigationController?.navigationBar.frame.height ?? 75.0)
       
        NSLayoutConstraint.activate([
        
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.topAnchor.constraint(equalTo:  view.topAnchor, constant:navHeight ),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]) 
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        headerView?.configure(serie: serie)
        tableView.tableHeaderView = headerView
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     */
    
    private func configureNavbar() {
        var image = UIImage(named: "AppIcon")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }

}
