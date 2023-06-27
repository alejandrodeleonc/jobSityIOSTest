//
//  GuestCollectionViewCell.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 26/6/23.
//

import UIKit

class GuestCollectionViewCell: UICollectionViewCell {
    static let identifier = "GuestCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let detailView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    private let detailLabel: UILabel  = {
        let detail: UILabel = UILabel()
        
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.numberOfLines = 0
        detail.lineBreakMode = .byWordWrapping
        detail.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return detail
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        contentView.addSubview(detailView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        detailView.frame = contentView.bounds
        self.detailView.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            detailLabel.trailingAnchor.constraint(equalTo: self.detailView.trailingAnchor, constant: -10),
            detailLabel.leadingAnchor.constraint(equalTo: self.detailView.leadingAnchor, constant: 10),
            detailLabel.topAnchor.constraint(equalTo: self.detailView.topAnchor, constant: 20),
                ])
    }
    
    
    public func configure(guest:Guest) {
        
        guard let url = URL(string: guest.person.image?.original ?? "") else {
            return
        }
        
        
        posterImageView.sd_setImage(with: url, completed: nil)
        setupDetailView(guest: guest)
    }
    
    public func setupDetailView(guest: Guest){
        self.detailView.isHidden = true
        let personName = guest.person.name.parseHTMLString(withSize: 8, withFontName: "Helvetica")?.string ?? ""
        let characterName = guest.character.name.parseHTMLString(withSize: 8, withFontName: "Helvetica")?.string ?? ""
        
        let description = "<strong>\(personName)</strong><br>the one who played the character named:<br><strong>\(characterName)</strong>"
        
        detailLabel.attributedText = description.parseHTMLString(withSize: 14, withFontName: "Helvetica")

    }
    
    
    func flipViews(){
        
        let flipSide: UIView.AnimationOptions = self.detailView.isHidden ? .transitionFlipFromLeft : .transitionFlipFromRight
               UIView.transition(with: self.contentView, duration: 0.3, options: flipSide, animations: { [weak self]  () -> Void in
                   self?.posterImageView.isHidden = !(self?.posterImageView.isHidden ?? false)
                   self?.detailView.isHidden = !(self?.detailView.isHidden ?? true)
               }, completion: nil)
    }
}
