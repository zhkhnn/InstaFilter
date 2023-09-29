//
//  ContentView.swift
//  InstaFilter
//
//  Created by Aruzhan Zhakhan on 29.09.2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    
    @State private var input: UIImage?
    @State private var result: UIImage?
    @State private var showingImagePicker = false
    
    @State private var showingFilterSheet = false
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap to select a picture")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                HStack{
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity){
                            _ in applyProcessing()
                        }
                }
                .padding(.vertical)
                
                HStack{
                    Button("Change Filter"){
                        showingFilterSheet = true
                    }
                    Spacer()
                    Button("Save", action: save)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Insta Filter")
            .onChange(of: image){_ in loadImage()
            }
            .sheet(isPresented: $showingImagePicker){
                ImagePicker(image: $input)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet){
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
            
        }
    }
    
    func loadImage(){
        guard let input = input else { return }
        let beginImage = CIImage(image: input)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing(){
        let inputKeys = currentFilter.inputKeys
        
        if(inputKeys.contains(kCIInputIntensityKey)){
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if(inputKeys.contains(kCIInputRadiusKey)){
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
        }
        if(inputKeys.contains(kCIInputScaleKey)){
            currentFilter.setValue(filterIntensity, forKey: kCIInputScaleKey)
        }
        
        guard let output = currentFilter.outputImage else { return }
                
                if let cgimg = context.createCGImage(output, from: output.extent){
                    let uiImage = UIImage(cgImage: cgimg)
                    image = Image(uiImage: uiImage)
                    result = uiImage
                }
    }
    
    func setFilter(_ filter: CIFilter){
        currentFilter = filter
        loadImage()
    }
    
    func save(){
        guard let result = result else { return }
        
        let imageSaver = ImageSaver()
        imageSaver.successHandler = {
            print("Success")
        }
        imageSaver.errorHandler = {
            print("error \($0.localizedDescription)")
        }
        
        imageSaver.writeToAlbum(image: result)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
