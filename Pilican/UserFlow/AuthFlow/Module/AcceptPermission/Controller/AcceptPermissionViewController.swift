//
//  AcceptPermissionViewController.swift
//  Pilican
//
//  Created by kairzhan on 2/24/21.
//

import UIKit
import RxSwift

class AcceptPermissionViewController: ViewController, AcceptPermissionModule, ViewHolder {
    
    typealias RootViewType = AcceptPermissionView
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = AcceptPermissionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
