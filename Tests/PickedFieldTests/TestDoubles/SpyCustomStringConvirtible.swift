import Foundation

final class SpyCustomStringConvirtible: CustomStringConvertible {
    
    let uuid = UUID()

    var invokedDescriptionGetter = false
    var invokedDescriptionGetterCount = 0
    var stubbedDescription: String = ""
    var description: String {
        invokedDescriptionGetter = true
        invokedDescriptionGetterCount += 1
        return stubbedDescription
    }
}

extension SpyCustomStringConvirtible: Equatable {
    
    static func == (
        lhs: SpyCustomStringConvirtible,
        rhs: SpyCustomStringConvirtible) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

extension SpyCustomStringConvirtible: ExpressibleByStringLiteral {
    
    convenience init(stringLiteral value: String) {
        self.init()
        self.stubbedDescription = value
    }
}
