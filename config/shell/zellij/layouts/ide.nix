{ zjstatus }:
''
  pane split_direction="vertical" {
    pane name="code" focus=true
    pane name="tools" size="35%" stacked=true {
      pane name="ai"
      pane name="git" command="lazygit" {
        args "-sm" "full"
      }
    }
  }

  pane size="10%" name="term"
''
