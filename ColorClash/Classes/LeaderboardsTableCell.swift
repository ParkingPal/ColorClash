//
//  LeaderboardsTableCell.swift
//  ColorClash
//
//  Created by ParkingPal on 1/19/21.
//

import Foundation
import UIKit

class LeaderboardsTableCell: CustomTableCell {
    var stackView = UIStackView()
    var rankView = UIView()
    var nameView = UIView()
    var scoreView = UIView()
    var rankLabel = UILabel()
    var nameLabel = UILabel()
    var scoreLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rankLabel.frame = rankLabel.frame.inset(by: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0))
        nameLabel.frame = nameLabel.frame.inset(by: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0))
        scoreLabel.frame = scoreLabel.frame.inset(by: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0))
    }
    
    func set(leader: Leader) {
        rankLabel.text = String(leader.rank)
        nameLabel.text = leader.name
        
        if leader.score == floor(leader.score) {
            scoreLabel.text = String(Int(leader.score))
        } else {
            scoreLabel.text = String(((leader.score) * 10).rounded() / 10)
        }
    }
    
    func setupLayout() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        addSubview(stackView)
        
        stackView.addArrangedSubview(rankView)
        stackView.addArrangedSubview(nameView)
        stackView.addArrangedSubview(scoreView)
        
        setupStackView()
        
        setupView(view: rankView, label: rankLabel)
        setupView(view: nameView, label: nameLabel)
        setupView(view: scoreView, label: scoreLabel)
    }
    
    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        nameView.widthAnchor.constraint(equalTo: rankView.widthAnchor, multiplier: 5.0).isActive = true
        nameView.widthAnchor.constraint(equalTo: scoreView.widthAnchor, multiplier: 2.0).isActive = true
    }
    
    func setupView(view: UIView, label: UILabel) {
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        configureLabel(label: label)
        label.textAlignment = .center
        label.textColor = .blue
    }
    
    func configureLabel(label: UILabel) {
        label.numberOfLines = 1
    }
    
    func fontToFitHeight(label: UILabel) -> UIFont {
        var minFontSize: CGFloat = 20
        var maxFontSize: CGFloat = 200
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard label.text?.count ?? 0 > 0 else {
                break
            }
            
            if let labelText: String = label.text as String? {
                let labelHeight = frame.size.height - 20
                
                let testStringHeight = labelText.size(
                    withAttributes: [NSAttributedString.Key.font: label.font.withSize(fontSizeAverage)]
                ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return label.font.withSize(fontSizeAverage - 1)
                    }
                    return label.font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return label.font.withSize(fontSizeAverage)
                }
            }
        }
        return label.font.withSize(fontSizeAverage)
    }
}
