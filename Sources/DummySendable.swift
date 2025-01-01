import Foundation


#if swift(>=5.5)
public protocol GHALogger_Sendable : Sendable {}
#else
public protocol GHALogger_Sendable {}
#endif
