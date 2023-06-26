//
//  Helpers.swift
//  tvMazeApp
//
//  Created by Alejandro De León on 26/6/23.
//

import Foundation
import UIKit


extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: self){
            return date;
        }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let newDate = dateFormatter.date(from: self)
        return newDate;
    }
    
    
    
    func parseHTMLString(withSize size: CGFloat, withFontName fontName: String) -> NSAttributedString? {
         guard let font = UIFont(name: fontName, size: size) else {
             return nil
         }
         
         let modifiedHTMLString = String(format: "<span style='font-family:%@; font-size: %fpx;'>%@</span>", fontName, size, self)
         
         guard let data = modifiedHTMLString.data(using: .unicode) else {
             return nil
         }
         
         do {
             let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                 .documentType: NSAttributedString.DocumentType.html,
                 .characterEncoding: String.Encoding.utf8.rawValue
             ]
             return try NSAttributedString(data: data, options: options, documentAttributes: nil)
         } catch {
             return nil
         }
     }
}
