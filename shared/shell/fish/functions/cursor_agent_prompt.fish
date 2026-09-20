function cursor_agent_prompt --description "Insert cursor-agent prompt template"
    commandline --replace 'cursor-agent -f -p ""'
    commandline --cursor (math (commandline | string length) - 1)
end
