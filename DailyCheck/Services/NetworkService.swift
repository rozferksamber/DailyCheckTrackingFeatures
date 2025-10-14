//
//  NetworkService.swift
//  DailyCheck
//
//  Created on 2025-10-12.
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case noData
}

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func checkServerRequest() async throws -> (token: String?, link: String?) {
        let system = getSystem()
        let deviceModel = getModel()
        let country = getCountry()
        let languageSystem = getLanguage()
        let requestString = "https://wallen-eatery.space/ios-vdm-5/server.php?p=Bs2675kDjkb5Ga&os=\(system)&lng=\(languageSystem)&devicemodel=\(deviceModel)&country=\(country)"
        
        guard let requestPath = URL(string: requestString) else {
            throw NetworkError.invalidRequest
        }
        
        let (data, response) = try await URLSession.shared.data(from: requestPath)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw NetworkError.noData
        }
        
        if responseString.contains("#") {
            let components = responseString.components(separatedBy: "#")
            if components.count >= 2 {
                let token = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let link = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                return (token, link)
            }
        }
        
        return (nil, nil)
    }
    
    func getModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return  identifier
    }
    
    func getCountry() -> String {
        return (Locale.current.region?.identifier) ?? "RU"
    }
    
    func getLanguage() -> String {
        return Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? "ru"
    }
    
    func getSystem() -> String {
        return UIDevice.current.systemVersion
    }
}


