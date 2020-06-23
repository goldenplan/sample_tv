//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 6/23/20.
//

import Foundation

struct APIHelpers {
    
    static var root = "https://file.ilook.su/SampleTV/api/"
    
    static var jsonDecoder: JSONDecoder{
        let jsonDecoder = JSONDecoder()
        
        return jsonDecoder
    }
    
}

