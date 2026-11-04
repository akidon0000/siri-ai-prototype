---
source_url: https://developer.apple.com/documentation/appintents/appentitytraits
title: AppEntityTraits
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

App Intents
Structure
AppEntityTraits
The roles an app entity takes on, passed to @AppEntity.
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
struct AppEntityTraits
Overview

Pass a single trait, such as .generable, or a list, such as [.generable]. The macro reads the traits as written, so they have to be listed directly rather than computed.

A set holds each trait at most once. Traits that take a value are compared by trait alone, so two values of the same trait are the same member.

Topics
Type Properties
static let generable: AppEntityTraits
The model can generate values of the entity on its own.
Relationships
Conforms To
Equatable
ExpressibleByArrayLiteral
Sendable
SendableMetatype
SetAlgebra
See also
Entity support
protocol GenerableEntity
An interface that tells a model it can create an entity and fill in its properties directly.
macro AppEntity(AppEntityTraits)
Marks a transient entity whose values the model can generate on its own.
macro AppEntity<T>(AppEntityTraits, schema: T)
Marks a transient entity that conforms to a schema as one whose values the model can generate on its own.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?, customIndexingKey: CSCustomAttributeKey)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
macro ComputedProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?, indexingKey: PartialKeyPath<CSSearchableItemAttributeSet>)
A macro that adds a computed app entity property with a get accessor and an optional set accessor.
macro DeferredProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?)
A macro that adds an asynchronous app entity property with an asynchronous get accessor.
macro DeferredProperty(title: LocalizedStringResource?, description: LocalizedStringResource?, authenticationPolicy: IntentAuthenticationPolicy?, visibility: IntentVisibility?, indexingKey: PartialKeyPath<CSSearchableItemAttributeSet>)
A macro that adds an asynchronous app entity property with an asynchronous get accessor.

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
