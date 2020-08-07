//
//  CreateNoteViewController.swift
//  MJNotes
//
//  Created by Mike Jones on 7/25/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController {
    
    lazy var captionText = UITextField()
    lazy var thumbImageView = UIImageView()
    lazy var selectImageBtn = UIButton()
    
    private var viewModel: CreateNoteViewModel!
    
    convenience init(viewModel: CreateNoteViewModel) {
        self.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
        self.title = "Create Note"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(captionText)
        self.view.addSubview(thumbImageView)
        self.view.addSubview(selectImageBtn)
        self.view.backgroundColor = .white
        
        captionText.text = "Enter caption here"
        captionText.backgroundColor = .white
        
        thumbImageView.image = UIImage(named: "placeholder")
        thumbImageView.backgroundColor = UIColor.ButtonGray
        
        selectImageBtn.backgroundColor = UIColor.ButtonGray
        selectImageBtn.setTitle("Select Image", for: .normal)
        selectImageBtn.setTitleColor(.black, for: .normal)
        selectImageBtn.addTarget(self, action: #selector(selectImageBtnTapped), for: .touchUpInside)
        
        captionText.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top).offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(120)
        }
        thumbImageView.snp.makeConstraints {
            $0.top.equalTo(captionText.snp.bottom).offset(20)
            $0.height.width.equalTo(100)
            $0.centerX.equalTo(captionText.snp.centerX)
        }
        selectImageBtn.snp.makeConstraints {
            $0.top.equalTo(thumbImageView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(45)
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnTapped))
        
        bindViewToViewModel()
    }
    
    @objc func cancelBtnTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneBtnTapped(_ sender: UIBarButtonItem) {
        if let image = thumbImageView.image, let cap = captionText.text {
            self.viewModel.storeNoteLocally(caption: cap, image: image)
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func selectImageBtnTapped(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    
    func bindViewToViewModel() {
        viewModel?.thumbImage.valueChanged = { [weak self] (image) in
            self?.thumbImageView.image = image
        }
    }
    
    func unbindViewToViewModel() {
        viewModel?.thumbImage.valueChanged = nil
    }
}


extension CreateNoteViewController: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            print("No image selected")
            return
        }
        self.viewModel.thumbImage.value = image
    }
}

extension CreateNoteViewController: UINavigationControllerDelegate {

}
