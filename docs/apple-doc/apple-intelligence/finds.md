---
source_url: https://developer.apple.com/documentation/sirievaluations/finds
title: Finds
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

Siri Evaluations
Structure
Finds
An expectation that Siri surfaces specific app entities by search or resolution.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
struct Finds
Overview

Use Finds to name the app entities Siri finds when it searches or resolves entities in your app for a request. The expectation holds when Siri finds an entity that matches, including its type. A bare entity definition matches any entity of that type, and you can add constraints on its properties with expect.

Finds checks entities Siri finds by searching. To check entities that are visible onscreen, use OnScreen. The two are separate because the entities reach Siri by different paths. One doesn’t stand in for the other. A found entity doesn’t always carry the details Siri tells the person. Use SiriResponse for facts that only the reply contains.

Topics
Creating a find expectation
init(() -> [any AppEntityExpectationProviding])
Creates an expectation that Siri surfaces each entity in the block by search or resolution.
enum EntityFindExpectationBuilder
A result builder that collects the entities a finds expectation requires.
Relationships
Conforms To
Decodable
Encodable
Sendable
SendableMetatype
See also
Expectations
struct Calls
An expectation that Siri calls, or doesn’t call, a set of intents during a turn or scenario.
Beta
struct Loads
An expectation that Siri loads specific app skills.
Beta
struct OnScreen
An expectation that specific app entities are onscreen.
Beta
struct SiriResponse
An expectation that the reply Siri gives contains specific text.
Beta

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
