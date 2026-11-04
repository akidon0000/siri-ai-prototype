---
source_url: https://developer.apple.com/documentation/sirievaluations/siriexpectationevaluator
title: SiriExpectationEvaluator
category: apple-intelligence
kind: tool
fetched_at: 2026-11-04T00:00:00Z
---

Siri Evaluations
Structure
SiriExpectationEvaluator
An evaluator that grades a scenario against its expectations.
iOS 27.3+
Beta
iPadOS 27.3+
Beta
macOS 27.3+
Beta
visionOS 27.3+
Beta
struct SiriExpectationEvaluator
Overview

It reports the metrics of each kind of expectation — Calls, Finds, OnScreen, SiriResponse and Loads; a Loads(.preferred) is shown in the report but never graded. Return it from your evaluation’s evaluators, alone or with graders of your own, and call computeSiriMetrics(into:) from aggregateMetrics(using:) to show its metrics as the report’s summary cards.

Topics
Creating an evaluator
init()
Creates an evaluator that grades a scenario against its expectations.
Grading a scenario
func metrics(subject: SiriScenarioSubject, input: SiriScenario) async throws -> [Metric]
Returns the metrics from grading the scenario’s expectations against its transcript.
Relationships
Conforms To
EvaluatorProtocol
Sendable
SendableMetatype
See also
Evaluations
enum SiriService
A service that runs a scenario through Siri and records what Siri does.
Beta

Beta Software

This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

Learn more about using Apple's beta software
