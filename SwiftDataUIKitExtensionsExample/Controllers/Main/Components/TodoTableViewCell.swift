//
//  TodoTableViewCell.swift
//  SwiftDataUIKitExtensionsExample
//
//  Created by Leo Ho on 2023/12/17.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lbTaskName: UILabel!
    
    // MARK: - Variables
    
    static let identifier = "TodoTableViewCell"
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Settings
    
    func setInit(name: String) {
        setupLabel(name: name)
    }
    
    fileprivate func setupLabel(name: String) {
        lbTaskName.text = name
    }
    
    // MARK: - IBAction
    
}

// MARK: - Extensions



// MARK: - Protocol


