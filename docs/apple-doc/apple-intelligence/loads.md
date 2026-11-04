---
source_url: https://developer.apple.com/documentation/sirievaluations/loads
title: Loads
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

Siri Evaluations
Structure
Loads
An expectation that Siri loads specific app skills.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
struct Loads
Overview

A skill is the Markdown instructions an app ships for a task, which can reference the app’s intents and chain them to satisfy a request. Use Loads to check whether Siri loads a skill into its planning for a turn.

Loads has no default enforcement, so you write Loads.Enforcement.required or Loads.Enforcement.preferred. Only a required skill counts toward the skillsLoadedPass metric. A turn fails a required Loads if Siri doesn’t load the skill.

A preferred skill appears in the report but never affects the score. Siri sees the app’s intents alongside the skill and might satisfy the request by calling them directly.

To name a skill, write its SkillDefinition in the closure. A skill has no properties to constrain, so the expectation matches by identity and checks only whether Siri loads that skill.

A passing check doesn’t show that Siri follows the skill’s instructions, because Siri doesn’t report which steps it performs in a skill. To verify the outcome, pair Loads with Calls for the intents the skill chains.

For more information about skills, see Orchestrating complex actions with app skills.

Topics
Creating a load expectation
init(Loads.Enforcement, () -> [SkillDefinition])
Creates an expectation that the skills in the block load, graded according to the enforcement.
enum SkillExpectationBuilder
A result builder that collects the skills in a loads expectation.
Configuring enforcement
let enforcement: Loads.Enforcement
Whether a missed skill fails the expectation or only shows in the report.
enum Enforcement
Whether a missed skill fails the expectation or only shows in the report.
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
struct Finds
An expectation that Siri surfaces specific app entities by search or resolution.
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
