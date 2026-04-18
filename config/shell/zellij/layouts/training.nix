{ zjstatus, config }:
''
  pane split_direction="vertical" {
    pane name="code" command="hx" focus=true
    pane name="tools" size="40%" {
      pane name="devenv" command="devenv" size="10%" {
        args "up"
      }
      pane name="ai" command="${config.home.homeDirectory}/.opencode/bin/opencode" start_suspended=true
    }
  }

  pane size="10%" name="term" borderless=true
''
