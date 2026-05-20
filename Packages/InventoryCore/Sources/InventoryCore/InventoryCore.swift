// InventoryCore — Module entry point.
//
// This file intentionally contains no top-level type declarations. The
// module name `InventoryCore` is reserved at the SPM target level (see
// Package.swift) and must not be shadowed by a same-named enum/struct/class
// here — doing so makes `InventoryCore.Collection` resolve to a nested
// member lookup against the empty enum instead of the module namespace,
// breaking `FetchDescriptor<InventoryCore.Collection>()` type inference in
// tests.
//
// Domain types (`Item`, `Memory`, `Collection`, `Attachment`) live in
// `Models/`; design tokens in `DesignTokens/`; services in `Services/`.
