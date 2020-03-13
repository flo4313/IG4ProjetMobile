//
//  config.swift
//  mobile_IG4
//
//  Created by etud on 10/03/2020.
//  Copyright © 2020 user165108. All rights reserved.
//

import Foundation
import CommonCrypto
import SwiftUI

class Config {
    
    func postbarColor() -> Color{
        return Color(red: 187.0/255.0, green: 220.0/255.0, blue: 242.0/255.0, opacity: 1.0)
    }
    
    func answerColor() -> Color{
           return Color(red: 235.0/255.0, green: 235.0/255.0, blue: 236.0/255.0, opacity: 1.0)
       }
    
    func postColor() -> Color{
        return Color(red: 215.0/255.0, green: 217.0/255.0, blue: 215.0/255.0, opacity: 1.0)
    }
    
    func convertImageToBase64(_ image: UIImage) -> String {
        let imageData: NSData = image.jpegData(compressionQuality: 0.4)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    
    func sha256(str: String) -> String {
     
        if let strData = str.data(using: String.Encoding.utf8) {
            /// #define CC_SHA256_DIGEST_LENGTH     32
            /// Creates an array of unsigned 8 bit integers that contains 32 zeros
            var digest = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
     
            /// CC_SHA256 performs digest calculation and places the result in the caller-supplied buffer for digest (md)
            /// Takes the strData referenced value (const unsigned char *d) and hashes it into a reference to the digest parameter.
            strData.withUnsafeBytes {
                // CommonCrypto
                // extern unsigned char *CC_SHA256(const void *data, CC_LONG len, unsigned char *md)  -|
                // OpenSSL                                                                             |
                // unsigned char *SHA256(const unsigned char *d, size_t n, unsigned char *md)        <-|
                CC_SHA256($0.baseAddress, UInt32(strData.count), &digest)
            }
     
            var sha256String = ""
            /// Unpack each byte in the digest array and add them to the sha256String
            for byte in digest {
                sha256String += String(format:"%02x", UInt8(byte))
            }
     
            if sha256String.uppercased() == "E8721A6EBEA3B23768D943D075035C7819662B581E487456FDB1A7129C769188" {
                print("Matching sha256 hash: E8721A6EBEA3B23768D943D075035C7819662B581E487456FDB1A7129C769188")
            } else {
                print("sha256 hash does not match: \(sha256String)")
            }
            return sha256String
        }
        return ""
    }
    
   
}
