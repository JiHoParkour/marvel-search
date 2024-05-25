//
//  EmptyView.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/24/24.
//

import UIKit

import SnapKit

final class EmptyView: UIView {
    
    private let emptyMessage: String
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.text = self.emptyMessage
        return label
    }()
    
    init(emptyMessage: String) {
        self.emptyMessage = emptyMessage
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubview(emptyLabel)
    }
    
    private func setUpConstraints() {
        emptyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
