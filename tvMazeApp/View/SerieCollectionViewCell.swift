//
//  SerieCollectionViewCell.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 24/6/23.
//

import UIKit
import Alamofire
import AlamofireImage

class SerieCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let detailView: UIView = UIView()
    let serieNameLabel: UILabel = UILabel()
    private let premierDateLabel: UILabel = UILabel()
    private let imageView: UIImageView = UIImageView()
    private let ratingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    private let ratingLabel: UILabel = UILabel()
    private var serie: Serie?
    
    
    // MARK: - Initializers and Setters
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupSerie(serie:Serie) {
        self.serie = serie
        serieNameLabel.text = serie.name
        premierDateLabel.text = getYearFromADate(dateString: serie.premiered ?? "N/A")
        
        if let ratingAverage = serie.rating.average {
            ratingLabel.text = String(ratingAverage)
        } else {
            ratingLabel.text = "N/A"
        }

        getCellImage()
    }
    
    
    // MARK: - View setup
    func setupView(){
        setupActivityIndicator()
        setupSerieImageView()
        setupDetailView()
        setupSerieNameLabel()
        setupPremierDateLabel()
        setupRatingView()
        setupRatingLabel()
        setupConstraints()
        
    }
    
    
    private func setupActivityIndicator() {
        activityIndicator.color = .systemMint
        activityIndicator.center = contentView.center
        contentView.addSubview(activityIndicator)
    }
    
    func setupSerieImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    func setupDetailView(){
        detailView.backgroundColor = .systemGray2
        detailView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailView)
    }
    
    func setupSerieNameLabel() {
        serieNameLabel.translatesAutoresizingMaskIntoConstraints =  false
        serieNameLabel.numberOfLines = 1
        serieNameLabel.lineBreakMode = .byTruncatingTail
        serieNameLabel.text =  serie?.name ?? ""
        serieNameLabel.textColor = .white
        serieNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        detailView.addSubview(serieNameLabel)
        
    }
    
    func setupPremierDateLabel() {
        premierDateLabel.translatesAutoresizingMaskIntoConstraints =  false
        premierDateLabel.text =  serie?.premiered ?? ""
        premierDateLabel.textColor = .white
        premierDateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        detailView.addSubview(premierDateLabel)
    }
    
    func setupRatingView() {
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        ratingView.layer.cornerRadius = ratingView.frame.width / 2
        ratingView.backgroundColor = .white
        detailView.addSubview(ratingView)
    }
    
    func setupRatingLabel() {
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        if let ratingAverage = serie?.rating.average {
            ratingLabel.text = String(ratingAverage)
        } else {
            ratingLabel.text = "N/A"
        }
        ratingLabel.textColor = .systemMint
        ratingLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)

        ratingView.addSubview(ratingLabel)
    }
    
    
    
    // MARK: - Constraints
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            //ImageView constraints
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            
            //DetailView constraints
            detailView.heightAnchor.constraint(equalToConstant: 60),
            detailView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            //serieNameLabel constraints
            serieNameLabel.widthAnchor.constraint(equalToConstant: 130),
            serieNameLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            serieNameLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 10),
            
            //premierDateLabel constraints
            premierDateLabel.topAnchor.constraint(equalTo: serieNameLabel.bottomAnchor, constant: 5),
            premierDateLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 10),
            
            //ratingView (circle View) constraints
            ratingView.heightAnchor.constraint(equalToConstant: 30),
            ratingView.widthAnchor.constraint(equalToConstant: 30),
            ratingView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -5),
            ratingView.centerYAnchor.constraint(equalTo: detailView.centerYAnchor),
            
            
            ratingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
        ])
    }
    

    // MARK: - Loading Animation
    func startLoadingAnimation() {
        activityIndicator.startAnimating()
    }
    
    func stopLoadingAnimation() {
        activityIndicator.stopAnimating()
    }
    
    
    // MARK: - Utils
    
    
    // Function to get the cell image
    func getCellImage() {
        let defaultImage: UIImage = UIImage(named: "AppIcon")!
        
        // Start the loading animation
        startLoadingAnimation()
        
        // Request the image using Alamofire
        AF.request(serie?.image.original ?? "").responseImage { response in
            
            // Stop the loading animation
            self.stopLoadingAnimation()
            
            if case .success(let image) = response.result {
                // The image was successfully loaded
                
                // Set the loaded image to the imageView
                self.imageView.image = image
            } else {
                // An error occurred while loading the image
                
                // Set a default image in case of error
                self.imageView.image = defaultImage
                
                // Print the error description
                print("Error loading image: \(response.error?.localizedDescription ?? "")")
            }
        }
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
