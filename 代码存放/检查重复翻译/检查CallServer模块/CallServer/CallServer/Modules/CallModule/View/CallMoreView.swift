//
//  CallMoreView.swift
//  Odin-YMS
//
//  Created by Apple on 27/04/2017.
//  Copyright © 2017 Yealink. All rights reserved.
//

import UIKit

typealias CallMoreClickActionBlock = (_ celldataModel: CallMoreCellDataModel, _ cell: CallMoreSelectCell) -> Void
let moreSelectionCellIdentifier: String = "moreSelectionCell"

class CallMoreView: UIView {

    var cellClickActionFunc: CallMoreClickActionBlock!
    /** 语音聊天背景视图 */
    lazy var bgView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        return view
    }()

    var elementArray: Array <CallMoreCellDataModel>! = []
    var moreSelectTable: UITableView!

    init(frame: CGRect, elements: Array <CallMoreCellDataModel>, block: @escaping CallMoreClickActionBlock) {
        super.init(frame: frame)
        elementArray = elements
        cellClickActionFunc = block
        initSubView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initSubView() {
        initBGView()
        initTable()
    }

    func initBGView() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    func initTable() {
        moreSelectTable =   UITableView(frame: CGRect.zero, style: .plain)
        bgView.addSubview(moreSelectTable)
        moreSelectTable.backgroundColor = UIColor.clear
        moreSelectTable.delegate = self
        moreSelectTable.dataSource = self
        moreSelectTable.separatorStyle = .none
        moreSelectTable?.register(CallMoreSelectCell.self, forCellReuseIdentifier: moreSelectionCellIdentifier)
        moreSelectTable.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.top).offset(0)
            make.bottom.equalTo(bgView.snp.bottom).offset(0)
            make.left.equalTo(bgView.snp.left).offset(0)
            make.right.equalTo(bgView.snp.right).offset(0)
        }
    }

    func updateCellForModelArray(newArray: Array <CallMoreCellDataModel>) {
        moreSelectTable.endUpdates()
        elementArray = newArray
        moreSelectTable.reloadData()
    }
}

extension CallMoreView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CallMoreSelectCell!
        cell = tableView.dequeueReusableCell(withIdentifier: moreSelectionCellIdentifier, for: indexPath) as? CallMoreSelectCell
        if indexPath.row < elementArray.count  {
            let model = elementArray[indexPath.row]
            cell.clean()
            cell.dataModel = model
        }
        if indexPath.row == elementArray.count - 1 {
            cell.separatorLine.isHidden =  true
        }
        if let thisCell = cell {
            return thisCell
        } else {
            return UITableViewCell()
        }
    }
}

extension CallMoreView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let thisblock = cellClickActionFunc  {
            let model = elementArray[indexPath.row]
            if let thisCell = tableView.cellForRow(at: indexPath) as? CallMoreSelectCell {
                thisblock(model, thisCell)
            }
        }
    }
}
