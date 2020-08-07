//
//  WebSession.swift
//  MJNotes
//
//  Created by Mike Jones on 7/26/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import Foundation


//
// MARK: - WebService session
//
final public class WebSession {

    public enum RequestMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }

    public enum RequestScheme: String {
        case HTTP
        case HTTPS
    }

    public enum RequestType: String {
        case BASIC
        case MULTIPART
    }
    
    public enum Response<T: Decodable> {
        case success(T)
        case error(WSError)
    }
    
    public enum WSError: Error {
        case urlCreationError
        case unknownError
        case badResponse(Int)
        case networkError(Error)
        case parseError(Error)
        
        var localizedDescription: String {
            switch self {
            case .urlCreationError: return "Unable to generate request"
            case .unknownError: return "Unknown networking error"
            case .badResponse(let code): return "Bad response: \(code)"
            case .networkError(let error): return "Network error: " + error.localizedDescription
            case .parseError(let error): return "Parsing error: \(error)"
            }
        }
    }
    
    public typealias CompletionHandler<T:Decodable> = (WebSession.Response<T>) -> Void
    
    lazy var session: URLSession = {
        var configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        let session = URLSession(configuration: configuration)
        return session
    }()
}

//
// MARK: Public Functions
//
extension WebSession {
    
    @discardableResult public func request<T:Decodable>(_ endpoint: WSEndpointProtocol, responseType: T.Type, callback: @escaping WebSession.CompletionHandler<T>) -> URLSessionDataTask? {
        var task: URLSessionDataTask? = nil
        
        guard let request = generateRequest(endpoint) else {
            callback(.error(WSError.urlCreationError))
            return task
        }
        
        task = session.dataTask(with: request) { data, response, error in
            
            // error check - no error code
            if let errorMessage = error {
                DispatchQueue.main.async {
                    callback(.error(WSError.networkError(errorMessage)))
                }
                return
            }
            // error check - valid response
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    callback(.error(WSError.badResponse(-1)))
                }
                return
            }
            // error check - valid status code
            guard httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    callback(.error(WSError.badResponse(httpResponse.statusCode)))
                }
                return
            }
            // error check - valid payload
            guard let data = data else {
                DispatchQueue.main.async {
                    callback(.error(WSError.unknownError))
                }
                return
            }
            
            let decoded = WebSession.decode(with: data, decodingType: T.self)

            DispatchQueue.main.async {
                switch decoded {
                case .success(let result):
                    callback(.success(result))
                case .error(let error):
                    callback(.error(WSError.parseError(error)))
                }
            }
        }
        task?.resume()
        
        return task // allows caller to cancel request via task handle
    }
    
    
    public static func decode<T:Decodable>(with data: Data, decodingType: T.Type) -> WebSession.Response<T> {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            return .error(WSError.parseError(error))
        }
    }
}

//
// MARK: Private functions
//
extension WebSession {
    
    private func generateRequest(_ endpoint: WSEndpointProtocol) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme.rawValue
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.params
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.requestMethod.rawValue
        
        // multipart form handling
        if endpoint.requestType == .MULTIPART {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            let httpBody = NSMutableData()
            if let formData = endpoint.formData {
                for (key, value) in formData {
                    httpBody.appendString(convertFormField(name: key, value: value, boundary: boundary))
                }
            }
            if let fileData = endpoint.fileData {
                httpBody.append(self.convertFileData(fileData: fileData, boundary: boundary))
            }
            httpBody.appendString("--\(boundary)--")
            request.httpBody = httpBody as Data

        }
        return request
    }
    
    private func convertFileData(fileData: Data, boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"file.jpg\"\r\n")
        data.appendString("Content-Type: image/jpg\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
    
    private func convertFormField(name: String, value: String, boundary: String) -> String {
        var result = "--\(boundary)\r\n"
        result += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        result += "\r\n"
        result += "\(value)\r\n"
        return result
    }
}
