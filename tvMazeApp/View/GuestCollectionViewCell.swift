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
        
        let detail: UILabel = UILabel()
        
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.numberOfLines = 0
        detail.lineBreakMode = .byWordWrapping
        detail.font = UIFont.systemFont(ofSize: 14, weight: .light)
        let detailText = "\(guest.person.name.parseHTMLString(withSize: 8, withFontName: "Helvetica")?.string ?? "")<br>\(guest.character.name.parseHTMLString(withSize: 8, withFontName: "Helvetica")?.string ?? "" )".parseHTMLString(withSize: 8, withFontName: "Helvetica")
        
        detail.attributedText = detailText
    
        
        
        self.detailView.addSubview(detail)
        
        NSLayoutConstraint.activate([
            detail.trailingAnchor.constraint(equalTo: self.detailView.trailingAnchor, constant: -10),
            detail.leadingAnchor.constraint(equalTo: self.detailView.leadingAnchor, constant: 10),
            detail.topAnchor.constraint(equalTo: self.detailView.topAnchor, constant: 20),
            detail.bottomAnchor.constraint(equalTo: self.detailView.bottomAnchor, constant: -20),
                ])
        
    
    }
    
    
    func flipViews(){
        
        let flipSide: UIView.AnimationOptions = self.detailView.isHidden ? .transitionFlipFromLeft : .transitionFlipFromRight
               UIView.transition(with: self.contentView, duration: 0.3, options: flipSide, animations: { [weak self]  () -> Void in
                   self?.posterImageView.isHidden = !(self?.posterImageView.isHidden ?? false)
                   self?.detailView.isHidden = !(self?.detailView.isHidden ?? true)
               }, completion: nil)
    }
}
