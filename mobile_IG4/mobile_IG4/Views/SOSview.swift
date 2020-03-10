//
//  SOSview.swift
//  mobile_IG4
//
//  Created by Thomas Faure on 01/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import SwiftUI

struct SOSview: View {
    
     @State var isShowPicker: Bool = false
     @State var image: Image? = Image("placeholder")

     var body: some View {
         NavigationView {
             ZStack {
                 VStack {
                     image?
                         .resizable()
                         .scaledToFit()
                         .frame(height: 320)
                     Button(action: {
                         withAnimation {
                             self.isShowPicker.toggle()
                         }
                     }) {
                         Image(systemName: "photo")
                             .font(.headline)
                         Text("IMPORT").font(.headline)
                     }.foregroundColor(.black)
                     Spacer()
                 }
             }
             .sheet(isPresented: $isShowPicker) {
                 ImagePicker(image: self.$image)
             }
             .navigationBarTitle("Pick Image")
         }
     }
 }


 struct ImagePicker: UIViewControllerRepresentable {

     @Environment(\.presentationMode)
     var presentationMode

     @Binding var image: Image?

     class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

         @Binding var presentationMode: PresentationMode
         @Binding var image: Image?

         init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
             _presentationMode = presentationMode
             _image = image
         }

         func imagePickerController(_ picker: UIImagePickerController,
                                    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
             let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
             image = Image(uiImage: uiImage)
             presentationMode.dismiss()

         }

         func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
             presentationMode.dismiss()
         }

     }

     func makeCoordinator() -> Coordinator {
         return Coordinator(presentationMode: presentationMode, image: $image)
     }

     func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
         let picker = UIImagePickerController()
         picker.delegate = context.coordinator
         return picker
     }

     func updateUIViewController(_ uiViewController: UIImagePickerController,
                                 context: UIViewControllerRepresentableContext<ImagePicker>) {

     }

 }

