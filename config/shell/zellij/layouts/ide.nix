{ zjstatus, config }:
''
  pane split_direction="vertical" {
    pane name="code" command="hx" focus=true
    pane name="tools" size="35%" stacked=true {
      pane name="ai" command="${config.home.homeDirectory}/.opencode/bin/opencode" start_suspended=true
      pane name="git" command="lazygit" {
        args "-sm" "full"
      }
    }
  }

  pane size="10%" name="term" borderless=true
''
