//
//  TableViewBindingHelper.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa


@objc protocol ReactiveView {
  func bindViewModel(_ viewModel: Any)
}

// a helper that makes it easier to bind to UITableView instances
// see: http://www.scottlogic.com/blog/2014/05/11/reactivecocoa-tableview-binding.html
class TableViewBindingHelper: NSObject, UITableViewDataSource, UITableViewDelegate {
  
  //MARK: Properties
  
  var delegate: UITableViewDelegate?
  
  fileprivate let tableView: UITableView
  fileprivate let templateCell: UITableViewCell
  fileprivate let selectionCommand: RACCommand?
  fileprivate var data: [Any]

  //MARK: Public API
  
  init(tableView: UITableView, sourceSignal: RACSignal, nibName: String, selectionCommand: RACCommand? = nil) {
    self.tableView = tableView
    self.data = []
    self.selectionCommand = selectionCommand
    
    let nib = UINib(nibName: nibName, bundle: nil)

    // create an instance of the template cell and register with the table view
    templateCell = nib.instantiate(withOwner: nil, options: nil)[0] as! UITableViewCell
    tableView.register(nib, forCellReuseIdentifier: templateCell.reuseIdentifier!)
    
    super.init()
    
    sourceSignal.subscribeNext {
      (d:Any!) -> () in
      self.data = d as! [Any]
      self.tableView.reloadData()
    }
    
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  //MARK: Private
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item: Any = data[indexPath.row]
    guard let cell = tableView.dequeueReusableCell(withIdentifier: templateCell.reuseIdentifier!) else {
        fatalError()
    }
    
    if let reactiveView = cell as? ReactiveView {
      reactiveView.bindViewModel(item)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return templateCell.frame.size.height
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if selectionCommand != nil {
      _ = selectionCommand?.execute(data[indexPath.row])
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if self.delegate?.responds(to: .scrollViewDidScroll) == true {
      self.delegate?.scrollViewDidScroll?(scrollView);
    }
  }
}

private extension Selector {
    static let scrollViewDidScroll = #selector(UITableViewDelegate.scrollViewDidScroll(_:))
}
