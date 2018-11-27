import Foundation

public class LedProfile: GATTProfile {
    
    public static let services: [GATTProfileService.Type] = [
        LedService.self
    ]
}
