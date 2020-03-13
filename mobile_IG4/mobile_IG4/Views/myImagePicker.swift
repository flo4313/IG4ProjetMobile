//
//  myImagePicker.swift
//  mobile_IG4
//
//  Created by etud on 12/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct MyImagePicker: UIViewControllerRepresentable{
    class Coordinator: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
        let parent: MyImagePicker
        init(_ parent: MyImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage{
                parent.image = uiImage
            }
            let asset = info[.imageURL] as? NSURL
            if (asset?.pathExtension) != nil{
                self.parent.ext = (asset?.pathExtension)!
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var ext: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MyImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<MyImagePicker>) {
    }
}
