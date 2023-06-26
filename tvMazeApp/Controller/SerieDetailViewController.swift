//
//  SerieDetailViewController.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 25/6/23.
//

import UIKit

enum Rows: Int {
    case summaryCell = 0
    case seasonCell = 1
    case episodesCell = 2
    case castCell = 3
}

class SerieDetailViewController: UIViewController {
    
    
    private var headerView: HeroHeaderUIView?
    private let tableView: UITableView =  UITableView(frame: .zero, style: .grouped)
    var serie: Serie!
    private var seasons:[Season] = []
    let button = UIButton()

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
        
        APIManager.shared.fetchSeasons(serieId: serie.id) { result in
            switch result {
                case .success(let data):
                self.seasons = data
                case .failure(let error):
                    // Maneja el error
                    print(error.localizedDescription)
                }
        }
        
        configureNavbar()
        tableView.delegate = self
        tableView.dataSource = self
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        headerView?.configure(serie: serie)
        tableView.tableHeaderView = headerView
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        tableView.register(UINib(nibName: "ExpandableTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpandableCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "logoIcon")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .systemMint
    }

}

extension SerieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row == Rows.summaryCell.rawValue{
            
            return UITableView.automaticDimension
        }else{
            return 50
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        let row = indexPath.row
        
        if row == Rows.summaryCell.rawValue{
            setupSummaryCell(cell:cell)
        }else if(row == Rows.seasonCell.rawValue){
            setupSeasonCell(cell: cell)
        }
        
        
        return cell
    }
    
    
    
    func setupSummaryCell(cell: UITableViewCell){
        let nameLabel : UILabel = UILabel()
        let summaryLabel : UILabel = UILabel()
        let genresLabel : UILabel = UILabel()
        
        cell.isUserInteractionEnabled = false
        
        
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.text = "\(self.serie.name) (\(getYearFromADate(dateString:self.serie.premiered)))"
        cell.addSubview(nameLabel)
        
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.numberOfLines = 0
        summaryLabel.attributedText = serie.summary.parseHTMLString(withSize: 16.0, withFontName: "Helvetica")
        summaryLabel.textAlignment = .justified
        cell.addSubview(summaryLabel)
        
        
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.attributedText = "<b>Genres:</b> \(self.serie.genres.joined(separator: ", "))".parseHTMLString(withSize: 16.0, withFontName: "Helvetica")
        cell.addSubview(genresLabel)
        
        let leftPadding = 15.0
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant:20),
            nameLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant:leftPadding),
            summaryLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant:leftPadding),
            summaryLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant:-leftPadding),
            summaryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant:10),
            
            genresLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor),
            genresLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant:leftPadding),
            genresLabel.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant:-10),
            
        ])
        
    }
    
    
    func setupSeasonCell(cell:UITableViewCell){
        // Configurar el botón
        let button = UIButton()
        button.setTitle("Seleccionar opción", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 4.0
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        cell.contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                button.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            ])
            

//            let dropDown = DropDown()
//            dropDown.anchorView = button
//            dropDown.dataSource = ["Opción 1", "Opción 2", "Opción 3"]
//            dropDown.selectionAction = { [weak self] (index, item) in
//                print("Opción seleccionada: \(item)")
//            }
//
//            button.addTarget(self, action: #selector(showDropdown(_:)), for: .touchUpInside)
    }
    
    @objc func showDropdown() {
//        dropDown.show()
    }

    
    func getYearFromADate(dateString:String) -> String{
        var yearString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            yearString = String(year)
        }
                
        return yearString
    }
}

