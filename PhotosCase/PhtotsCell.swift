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
    let button : UIButton = UIButton(type: .custom)
    
    var didSelctAddButton : ((_ button : UIButton) -> Void)?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        button.addTarget(self, action: #selector(didSelectAddAction), for: .touchUpInside)
        button.setTitle("Add Phtots", for: .normal)
        addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 100, height: 45))
        }
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.red
        selectionStyle = .none
        img.contentMode = .redraw
        addSubview(img)
        img.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
//        img.contentMode = .scaleAspectFit
    }
    
    @objc func didSelectAddAction(button : UIButton) {
        didSelctAddButton?(button)
    }
    
    func congureCell(indexPath : IndexPath, image : UIImage?){
        if indexPath.section == 0{
            self.img.isHidden = true
            self.button.isHidden = false
            
        }
        else{
            self.img.isHidden = false;
            self.button.isHidden = true
            self.img.image = image
        }
        
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
