//
//  PhtotsCell.swift
//  Photos
//
//  Created by KiddieBao on 2018/3/30.
//  Copyright © 2018年 Kiddie. All rights reserved.
//

import UIKit
import SnapKit
class PhtotsCell: UITableViewCell {
    let img: UIImageView = UIImageView()
    
    var didSelctAddButton : ((_ button : UIButton) -> Void)?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        selectionStyle = .none
        img.contentMode = .scaleAspectFit
        addSubview(img)
        img.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    @objc func didSelectAddAction(button : UIButton) {
        didSelctAddButton?(button)
    }
    
    func configureCell( image : UIImage?){
        self.img.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
