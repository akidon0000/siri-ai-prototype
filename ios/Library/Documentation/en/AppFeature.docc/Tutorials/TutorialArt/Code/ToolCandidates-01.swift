import AppIntents

// ○ Make a tool: can be asked for in one sentence that fills in the parameters
// "Make the milk memo high priority" has both memo and priority in one sentence
@AppIntent(.tool)
struct SetMemoPriorityIntent: AppIntent { /* built in the next section */ }
