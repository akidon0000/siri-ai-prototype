---
source_url: https://developer.apple.com/documentation/appintents/appintenttraits
title: AppIntentTraits
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
Structure
AppIntentTraits
The roles an app intent takes on, passed to @AppIntent.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
Mac Catalyst 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
struct AppIntentTraits
Overview

Pass a single trait, such as .tool, or a list, such as [.tool]. The macro reads the traits as written, so they have to be listed directly rather than computed.

A set holds each trait at most once. Traits that take a value are compared by trait alone, so two values of the same trait are the same member.

Topics
Type Properties
static let tool: AppIntentTraits
Siri can call the intent as a tool.
Relationships
Conforms To
Equatable
ExpressibleByArrayLiteral
Sendable
SendableMetatype
SetAlgebra
See also
Tool support
macro AppIntent(AppIntentTraits)
Makes an existing app intent available to Siri as a tool.
macro AppIntent<T>(AppIntentTraits, schema: T)
Makes an app intent that conforms to a schema available to Siri as a tool.
struct IntentVisibility
A value that configures how a property is available to system features, such as Siri and Shortcuts, if at all.
protocol ToolIntent
A protocol that identifies an app intent that Siri can call while handling a person’s request.

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
