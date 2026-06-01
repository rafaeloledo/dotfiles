function prompt {
  "$($executionContext.SessionState.Path.CurrentLocation)$(">" * ($nestedPromptLevel + 1)) ";
}
