---
source_url: https://developer.apple.com/documentation/appintents/appintent(_:)
title: AppIntent(_:)
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
Macro
AppIntent(_:)
Makes an existing app intent available to Siri as a tool.
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
@attached(extension, conformances: ToolIntent) macro AppIntent(_ traits: AppIntentTraits)
Parameters
traits

The intent’s roles, such as .tool or [.tool].

Overview

Apply this macro to a structure or class that conforms to AppIntent. It adds a ToolIntent conformance, using the availability declared on the type, or the availability of ToolIntent when the type declares none.

@AppIntent(.tool)
struct SearchFlights { ... }

See also
Tool support
macro AppIntent<T>(AppIntentTraits, schema: T)
Makes an app intent that conforms to a schema available to Siri as a tool.
struct AppIntentTraits
The roles an app intent takes on, passed to @AppIntent.
struct IntentVisibility
A value that configures how a property is available to system features, such as Siri and Shortcuts, if at all.
protocol ToolIntent
A protocol that identifies an app intent that Siri can call while handling a person’s request.

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
