//
//  AcceptPermissionViewController.swift
//  Pilican
//
//  Created by kairzhan on 2/24/21.
//

import UIKit
import RxSwift

class AcceptPermissionViewController: ViewController, AcceptPermissionModule {
    
    private let viewModel: AcceptPermissionViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: AcceptPermissionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AcceptPermissionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
