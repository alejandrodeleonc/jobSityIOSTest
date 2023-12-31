//
//  ExpandableTableViewCell.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 26/6/23.
//

import UIKit
import Alamofire
import AlamofireImage

class ExpandableTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ExpandableTableViewCell"
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        return stackView
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = #colorLiteral(red: 0.1404079861, green: 0.1404079861, blue: 0.1404079861, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.1404079861, green: 0.1404079861, blue: 0.1404079861, alpha: 1)
        label.setContentHuggingPriority(.init(rawValue: 200), for: .horizontal)
        return label
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 0.3382260101, green: 0.3382260101, blue: 0.3382260101, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let expandableView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.3197798296, green: 0.3197798296, blue: 0.3197798296, alpha: 1)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        contentView.addSubview(stackView)
        [mainStackView, expandableView].forEach { stackView.addArrangedSubview($0) }
        [iconImageView, titleLabel, chevronImageView].forEach { mainStackView.addArrangedSubview($0) }
        expandableView.addSubview(descriptionLabel)
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),
            chevronImageView.widthAnchor.constraint(equalToConstant: 18),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18),
            descriptionLabel.topAnchor.constraint(equalTo: expandableView.topAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: expandableView.leadingAnchor, constant: 0),
            descriptionLabel.bottomAnchor.constraint(equalTo: expandableView.bottomAnchor, constant: -8),
            descriptionLabel.trailingAnchor.constraint(equalTo: expandableView.trailingAnchor, constant: -16)
        ])
    }
    
    func set(title: String, description:String, expanded:Bool) {
        iconImageView.image = UIImage(named: "logoIcon")!
        titleLabel.text = title
        descriptionLabel.attributedText = description.parseHTMLString(withSize: 14, withFontName: "Helvetica")
        expandableView.isHidden = !expanded
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleExpandable))
        chevronImageView.addGestureRecognizer(tapGesture)
        chevronImageView.image = (expanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down"))?.withRenderingMode(.alwaysTemplate)
    }
    
    
    @objc func toggleExpandable(){
        expandableView.isHidden = !expandableView.isHidden
        chevronImageView.image = (!expandableView.isHidden ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down"))?.withRenderingMode(.alwaysTemplate)
        self.layoutSubviews()
    }
    
    
    func getCellImage(imageUrl: String){
        var image: UIImage =  UIImage(named: "logoIcon")!
        AF.request(imageUrl, method: .get).response{ response in
            
            switch response.result {
                case .success(let responseData):
                image = UIImage(data: responseData!, scale:1) ?? UIImage(named: "")!
                self.iconImageView.image = image
                case .failure(let error):
                    print("error--->",error)
                }
                
            }
    }
}
