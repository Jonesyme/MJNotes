//
//  ListNotesTableViewCell.swift
//  MJNotes
//
//  Created by Mike Jones on 8/2/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import UIKit
import SDWebImage

class NoteCell: UITableViewCell {

    static let identifier: String = "ListNotesCell"
    static let rowHeight: CGFloat = 100.0
    
    lazy var thumbImageView = UIImageView()
    lazy var captionLabel = UILabel()
    lazy var uploadIndicator = UIImageView()
    
    private var viewModel: NoteCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        unbindViewToViewModel()
    }
    
    func setupView() {
        self.contentView.addSubview(thumbImageView)
        self.contentView.addSubview(captionLabel)
        self.contentView.addSubview(uploadIndicator)
        self.backgroundColor = UIColor.NotesGray
        
        thumbImageView.contentMode = .scaleToFill
        uploadIndicator.contentMode = .scaleToFill
        
        thumbImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(self.contentView.snp.height)
        }
        captionLabel.snp.makeConstraints {
            $0.left.equalTo(thumbImageView.snp.right).offset(8)
            $0.right.equalTo(uploadIndicator.snp.left).offset(-8)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        uploadIndicator.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(self.contentView.snp.height)
        }
    }
    
    func configureCell(viewModel: NoteCellViewModel) {
        self.viewModel = viewModel
        bindViewToViewModel()
    }
    
    func bindViewToViewModel() {
        viewModel?.caption.valueChanged = { [weak self] (caption) in
            self?.captionLabel.text = caption
        }
        viewModel?.synced.valueChanged = { [weak self] (synced) in
            if synced {
                self?.uploadIndicator.image = UIImage(named: "uploadGreen")
            } else {
                self?.uploadIndicator.image = UIImage(named: "uploadRed")
            }
        }
        viewModel?.imageURL.valueChanged = { [weak self] (imageURL) in
            self?.thumbImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    func unbindViewToViewModel() {
        viewModel?.caption.valueChanged = nil
        viewModel?.synced.valueChanged = nil
        viewModel?.imageURL.valueChanged = nil
    }
}
