import Foundation

final class StubLocalizedError: LocalizedError, Equatable {
    
    static func == (lhs: StubLocalizedError, rhs: StubLocalizedError) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    let uuid = UUID()

    var stubbedErrorDescription: String!

    var errorDescription: String? {
        return stubbedErrorDescription
    }

    var stubbedFailureReason: String!

    var failureReason: String? {
        return stubbedFailureReason
    }

    var stubbedRecoverySuggestion: String!

    var recoverySuggestion: String? {
        return stubbedRecoverySuggestion
    }

    var stubbedHelpAnchor: String!

    var helpAnchor: String? {
        return stubbedHelpAnchor
    }
}
