//
//  Reachability.swift
//  MJNotes
//
//  Created by Mike Jones on 8/4/20.
//  Copyright © 2020 Michael Jones. All rights reserved.
//

import Reachability

class Reachable {

    let reachability = try! Reachability()

    func setupReachability() {
        
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                switch reachability.connection {
                case .wifi:
                    print("Reachable via WiFi")
                case .cellular:
                    print("Reachable via Cellular")
                case .unavailable:
                    print("Unreachable")
                case .none:
                    print("No internet connection")
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                print("Not reachable")
            }
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
