//
//  filtersCourse1.swift
//  Filtered
//
//  Created by Osmar Rodríguez on 7/23/16.
//  Copyright © 2016 Osmar Rodríguez. All rights reserved.
//

import Foundation
import UIKit

class Filter{
    var rgba = [UInt8](count:7, repeatedValue: 0)
}

// 5 filters
var redFilter: Filter = Filter()
var greenFilter: Filter = Filter()
var blueFilter: Filter = Filter()
var alphaFilter: Filter = Filter()
var grayFilter: Filter = Filter()
var contrastFilter: Filter = Filter()



class ImageProcessor{
    
    var filterSequenceList: [String] = []
    var filterList: [String] = []
    
    
    func applyFilters(image: UIImage, colorRed: UInt8, colorGreen: UInt8, colorBlue: UInt8, colorAlpha: UInt8, colorGray: UInt8, colorContrast: UInt8) -> (UIImage){
        
        var filters: [Filter] = []
        var filtro: [String] = []
        
        //List of Filters
        redFilter.rgba[0] = colorRed
        greenFilter.rgba[1] = colorGreen
        blueFilter.rgba[2] = colorBlue
        alphaFilter.rgba[3] = colorAlpha
        grayFilter.rgba[4] = colorGray
        contrastFilter.rgba[5] = colorContrast
        
        //When a filter is summon the variable filtro will store what filter was used and the filter is attached to an another to apply that filter in the loop
        if(Int(colorRed) != 0){
            filters.append(redFilter)
            filtro.append("redFilter")
        }
        if(Int(colorGreen) != 0){
            filters.append(greenFilter)
            filtro.append("greenFilter")
        }
        if(Int(colorBlue) != 0){
            filters.append(blueFilter)
            filtro.append("blueFilter")
        }
        if(Int(colorAlpha) != 0){
            filters.append(alphaFilter)
            filtro.append("alphaFilter")
        }
        if(Int(colorGray) != 0){
            filters.append(grayFilter)
            filtro.append("grayFilter")
        }
        if(Int(colorContrast) != 0){
            filters.append(contrastFilter)
            filtro.append("contrastFilter")
        }
        
        var rgbaImage = RGBAImage(image: image)!
        
        // Loop through each pixel
        for y in 0..<rgbaImage.height{
            for x in 0..<rgbaImage.width{
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                // Loop through each filter
                for filter in filters{
                    for value in 0...6 {
                        
                        // At least and value equal to 1 is required to apply a filter
                        if(filter.rgba[value] != 0 ){
                            
                            switch value{
                                
                            case 0:
                                pixel.red = filter.rgba[value]
                                rgbaImage.pixels[index] = pixel
                                
                            case 1:
                                pixel.green = filter.rgba[value]
                                rgbaImage.pixels[index] = pixel
                                
                            case 2:
                                pixel.blue = filter.rgba[value]
                                rgbaImage.pixels[index] = pixel
                                
                            case 3:
                                pixel.alpha = filter.rgba[value]
                                rgbaImage.pixels[index] = pixel
                                
                            case 4:
                                //Algorithim from: The MIT License Copyright © 2015 Sungcheol Kim, https://github.com/skyfe79/SwiftImageProcessing
                                
                                let redc = Double(pixel.red)
                                let greenc = Double(pixel.green)
                                let bluec = Double(pixel.blue)
                                
                                let result = sqrt(pow(redc, 2) + pow(greenc, 2) + pow(bluec, 2))/sqrt(Double(filter.rgba[value]))
                                pixel.red = UInt8(result)
                                pixel.green = UInt8(result)
                                pixel.blue = UInt8(result)
                                rgbaImage.pixels[index] = pixel
                                
                            case 5:
                                //Algorithim from: The MIT License Copyright © 2015 Sungcheol Kim, https://github.com/skyfe79/SwiftImageProcessing
                                
                                let pixelCount = rgbaImage.width * rgbaImage.height
                                let avgR = Int(pixel.red) / pixelCount
                                let avgG = Int(pixel.green) / pixelCount
                                let avgB = Int(pixel.blue) / pixelCount
                                
                                let deltaR = Int(pixel.red) - avgR
                                let deltaG = Int(pixel.green) - avgG
                                let deltaB = Int(pixel.blue) - avgB
                                pixel.red = UInt8(max(min(255, avgR + Int(filter.rgba[value]) * deltaR), 0)) //clamp
                                pixel.green = UInt8(max(min(255, avgG + Int(filter.rgba[value]) * deltaG), 0))
                                pixel.blue = UInt8(max(min(255, avgB + Int(filter.rgba[value]) * deltaB), 0))
                                
                                rgbaImage.pixels[index] = pixel
                                
                            default:
                                
                                print("No filter applied")
                                
                                
                            }
                        }
                    }
                }
            }
        }
        let newImage = rgbaImage.toUIImage()!
        return (newImage)
    }
}

var processor: ImageProcessor = ImageProcessor()