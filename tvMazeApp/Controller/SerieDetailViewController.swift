//
//  SerieDetailViewController.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 25/6/23.
//

import UIKit
import DropDown

enum Rows: Int {
    case summaryCell = 0
    case seasonCell = 1
    case episodesCell = 2
    case castCell = 3
}
enum Section: Int {
    case information = 0
    case episodes = 1
    case cast = 2
}

class SerieDetailViewController: UIViewController {
    
    
    private var headerView: HeroHeaderUIView?
    private let tableView: UITableView =  UITableView(frame: .zero, style: .grouped)
    var serie: Serie!
    private var seasons:[Season] = []
    let button = UIButton()
    let dropDown = DropDown()
    private var episodes: [Episode] = []
    private var cast: [Guest] = []
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
        getSeasons()
        getCast()
        configureNavbar()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        headerView?.configure(serie: serie)
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
        
        tableView.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "ExpandableCell")
        tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionViewCell")
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "logoIcon")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .systemMint
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    func getSeasons(){
        
        APIManager.shared.fetchSeasons(serieId: serie.id) { result in
            switch result {
                case .success(let data):
                self.seasons = data
                if(self.seasons.count > 0){
                    self.button.setTitle("Season \(self.seasons[0].number)", for: .normal)
                    self.getEpisodesWithSeason(seasonID: data[0].id)
                }else{
                    self.button.isUserInteractionEnabled = false
                    self.button.setTitle("Not availabe", for: .normal)
                }
                case .failure(let error):
                    // Maneja el error
                    print(error.localizedDescription)
                }
        }
    }
    
    func getCast(){
        
        APIManager.shared.fetchCast(serieId: serie.id) { result in
            switch result {
                case .success(let data):
                self.cast = data
                case .failure(let error):
                    // Maneja el error
                    print(error.localizedDescription)
                }
        }
    }

}

extension SerieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.information.rawValue{
            return 2
        }else if (section == Section.episodes.rawValue){
            return self.episodes.count
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section  == Section.cast.rawValue ? 200: UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        let row = indexPath.row
        let section = indexPath.section
        
        if section == Section.information.rawValue{
            if row == Rows.summaryCell.rawValue{
                setupSummaryCell(cell:cell)
            }else if(row == Rows.seasonCell.rawValue){
                setupSeasonCell(cell: cell)
            }
        }else if(section == Section.episodes.rawValue){
            let expcell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableTableViewCell
            
            
            expcell.set(title: episodes[row].name, description:episodes[row].summary, expanded: episodes[row].showInfo)
            
            expcell.getCellImage(imageUrl: episodes[row].image.original)
            cell = expcell
        }else if(section == Section.cast.rawValue){
            let tempcell = CollectionTableViewCell()
            
            tempcell.configure(guest: cast)
            
            cell = tempcell
        }
            
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.text = (section == Section.information.rawValue) ? "" : (section == Section.episodes.rawValue) ? "Episodes (\(self.episodes.count))" : "Cast"
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        if section == Section.information.rawValue{
            
        }else if(section == Section.cast.rawValue){
            
        }else if (section == Section.episodes.rawValue){
            self.episodes[row].showInfo = !self.episodes[row].showInfo
            
            tableView.reloadData()

        }
        
    }
    
    
    func setupSummaryCell(cell: UITableViewCell){
        let nameLabel : UILabel = UILabel()
        let summaryLabel : UILabel = UILabel()
        let genresLabel : UILabel = UILabel()
        
        cell.isUserInteractionEnabled = false
        
        
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.text = "\(self.serie.name) (\(getYearFromADate(dateString:self.serie.premiered ?? "")))"
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
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 4.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
    
        
        cell.contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                button.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            ])
            

            
            dropDown.anchorView = button
        var seasonsNames:[String] = []
            seasons.forEach { element in
                // Código para cada elemento del arreglo
                seasonsNames.append("Season \(element.number)")
                print(element)
            }
        dropDown.dataSource = seasonsNames
        let defaultSelectedIndex = 0
        dropDown.selectRow(at: defaultSelectedIndex)
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.button.setTitle("\(item)", for: .normal)
            self?.getEpisodesWithSeason(seasonID: self?.seasons[index].id ?? 0)

            }

            button.addTarget(self, action: #selector(showDropdown(_:)), for: .touchUpInside)
    }
    
    @objc func showDropdown(_ sender: UIButton) {
        dropDown.show()
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
    
    
    func getEpisodesWithSeason(seasonID: Int){
        APIManager.shared.fetchEpisodes(seasonId: seasonID) { result in
            switch result {
            case .success(let data):
                
                self.episodes = data
                self.tableView.reloadData()
                break
                
            case .failure(let error):
                // Maneja el error
                print(error.localizedDescription)
            }
        }
    }
    
}

