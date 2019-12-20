//
//  YLTableViewCell.swift
//  UME
//
//  Created by zlm on 16/8/5.
//  Copyright © 2016年 yealink. All rights reserved.
//

import UIKit

open class YLSDKTableViewCell: UITableViewCell {
    var backgroundColorYL: UIColor = UIColor.clear
    var backgroundHighLightColorYL: UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)

    override open func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCellSelectionStyle.none
        cellDidInit()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none
        cellDidInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cellDidInit()
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted == true {
            backgroundColor = backgroundHighLightColorYL
        } else {
            Timer.scheduledTimerYL(withTimeInterval: 0.1, repeats: false, block: { [weak self] (_) in
                self?.backgroundColor = self?.backgroundColorYL
            })

        }
    }

    func cellDidInit() {
    }

    class func dequque(withTableView tableView: UITableView,
                       indexPath: IndexPath) -> UITableViewCell {
        let className = String(describing: self)

        tableView.register(self,
                           forCellReuseIdentifier: className)

        let cell = tableView.dequeueReusableCell(withIdentifier: className,
                                                 for: indexPath)

        return cell
    }
}
