---
source_url: https://developer.apple.com/documentation/appintents/appintent(_:schema:)
title: AppIntent(_:schema:)
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
Macro
AppIntent(_:schema:)
Makes an app intent that conforms to a schema available to Siri as a tool.
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
@attached(memberAttribute) @attached(extension, conformances: ToolIntent, AppIntent, AssistantSchemaIntent, ShowInAppSearchResultsIntent, OpenIntent, DeleteIntent, AudioPlaybackIntent, AudioRecordingIntent, LiveActivityIntent, URLRepresentableIntent, names: named(__appSchemaIntent)) macro AppIntent<T>(
    _ traits: AppIntentTraits,
    schema: T
) where T : AppSchemaIntent
Parameters
traits

The intent’s roles, such as .tool or [.tool].

schema

The schema the intent conforms to.

Overview

Use this macro in place of @AppIntent(schema:). It adds everything @AppIntent(schema:) adds, plus a ToolIntent conformance:

@AppIntent(.tool, schema: .journal.createEntry)
struct CreateEntryIntent {
    var title: String?
    var message: AttributedString
    // ...
}

Only schemas available exclusively in Shortcuts are supported. Schemas in primary domains, such as .messages.sendMessage, are already handled by Siri, and using one here is an error.

See also
Tool support
macro AppIntent(AppIntentTraits)
Makes an existing app intent available to Siri as a tool.
struct AppIntentTraits
The roles an app intent takes on, passed to @AppIntent.
struct IntentVisibility
A value that configures how a property is available to system features, such as Siri and Shortcuts, if at all.
protocol ToolIntent
A protocol that identifies an app intent that Siri can call while handling a person’s request.

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
