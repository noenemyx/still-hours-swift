// LookupError.swift — InventoryCore/Lookups
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.2 BookMetadataLookup
// Created: 2026-05-21
// LINT-IGNORE: Privacy — no external URL in this file

import Foundation

// MARK: - LookupError

/// Typed errors propagated from ``BookMetadataLookup``.
///
/// All cases are `Sendable` — safe to cross actor boundaries and capture
/// in `async throws` call sites. Localised descriptions mirror the pattern
/// established by `ServiceError`.
public enum LookupError: Error, LocalizedError, Sendable {

    /// The supplied ISBN string is not a valid ISBN-10 or ISBN-13.
    case invalidISBN(String)

    /// A network-level failure prevented the request from completing.
    case networkUnavailable

    /// The API returned a well-formed response but contained no matching entry.
    case notFound(String)

    /// The API returned HTTP 429 or an equivalent rate-limit signal.
    case rateLimited

    /// The API returned data that could not be decoded into expected shapes.
    case malformedResponse(LookupSource)

    /// A constructed URL pointed at a host outside the allowed whitelist.
    case unauthorizedHost(URL)

    // MARK: LocalizedError

    public var errorDescription: String? {
        switch self {
        case .invalidISBN(let isbn):
            return String(
                format: NSLocalizedString(
                    "lookup.error.invalidISBN",
                    value: "The ISBN \"%@\" is not a valid ISBN-10 or ISBN-13.",
                    comment: "LookupError.invalidISBN — %@ is the supplied ISBN string"
                ),
                isbn
            )
        case .networkUnavailable:
            return NSLocalizedString(
                "lookup.error.networkUnavailable",
                value: "A network error occurred. Please check your connection and try again.",
                comment: "LookupError.networkUnavailable"
            )
        case .notFound(let isbn):
            return String(
                format: NSLocalizedString(
                    "lookup.error.notFound",
                    value: "No book was found for ISBN \"%@\".",
                    comment: "LookupError.notFound — %@ is the ISBN that was searched"
                ),
                isbn
            )
        case .rateLimited:
            return NSLocalizedString(
                "lookup.error.rateLimited",
                value: "The lookup service is temporarily unavailable. Please try again later.",
                comment: "LookupError.rateLimited"
            )
        case .malformedResponse(let source):
            return String(
                format: NSLocalizedString(
                    "lookup.error.malformedResponse",
                    value: "The response from %@ could not be read.",
                    comment: "LookupError.malformedResponse — %@ is the API source name"
                ),
                source.rawValue
            )
        case .unauthorizedHost(let url):
            return String(
                format: NSLocalizedString(
                    "lookup.error.unauthorizedHost",
                    value: "The host \"%@\" is not on the approved lookup whitelist.",
                    comment: "LookupError.unauthorizedHost — %@ is the disallowed URL"
                ),
                url.absoluteString
            )
        }
    }
}
