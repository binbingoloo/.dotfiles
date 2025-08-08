# Add fzf to PATH
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Default command using ripgrep
_FZF_DEFAULT_SEARCH_CMD='rg --files --hidden --glob "!.git/*" --glob "!node_modules/*" --glob "!.DS_Store"'
export FZF_DEFAULT_COMMAND="$_FZF_DEFAULT_SEARCH_CMD"
export FZF_CTRL_T_COMMAND="$_FZF_DEFAULT_SEARCH_CMD"

# Main fzf configuration with light white theme
export FZF_DEFAULT_OPTS='
  --style=full
  --layout=default
  --border=rounded
  --border-label=" fzf "
  --border-label-pos=2
  --pointer="▶" --marker="✓"
  --preview="fzf-preview.sh {}"
  --preview-window="right:50%:wrap:rounded"
  --bind="focus:transform-preview-label:[[ -n {} ]] && printf \" [%s] \" {}"
  --bind="focus:+transform-header:file --brief {} || echo \"No file selected\""
  --bind="result:transform-list-label:
    if [[ -z $FZF_QUERY ]]; then
      echo \" $FZF_MATCH_COUNT items \"
    else
      echo \" $FZF_MATCH_COUNT matches for [$FZF_QUERY] \"
    fi"
  --bind="ctrl-j:down,ctrl-k:up"
  --bind="ctrl-u:preview-page-up,ctrl-d:preview-page-down"
  --bind="ctrl-r:change-list-label( Reloading... )+reload(sleep 0.5; rg --files --hidden --glob \"!.git/*\" --glob \"!node_modules/*\" --glob \"!.DS_Store\")"
  --bind="ctrl-f:toggle-preview"
  --bind="ctrl-e:change-preview-window(down|hidden|)"
  --bind="alt-enter:select-all+accept"
  --bind="ctrl-s:toggle-sort"
  --bind="ctrl-/:toggle-search"
  --color="fg:#c6d0f5,bg:-1,hl:#8caaee"
  --color="fg+:#e5c890,bg+:#51576d,hl+:#99d1db"
  --color="info:#949cbb,prompt:#ca9ee6,pointer:#f4b8e4"
  --color="border:#626880,label:#babbf1,query:#c6d0f5"
  --color="disabled:#737994"
  --color="preview-fg:#c6d0f5,preview-bg:-1"
  --color="preview-border:#51576d,preview-label:#85c1dc"
  --color="preview-scrollbar:#414559"
  --color="header:#81c8be,spinner:#eebebe,marker:#a6d189"
  --color="gutter:-1"
  --color="selected-fg:#ef9f76,selected-bg:#414559"
  --color="current-fg:#e5c890,current-bg:#51576d"
'

# History search (CTRL-R)
export FZF_CTRL_R_OPTS="
  --preview='echo {2..}'
  --preview-window='down:3:hidden:wrap:border-rounded'
  --layout=reverse
  --border-label=' fzf - Command History '
  --bind='ctrl-f:toggle-preview'
  --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --bind='focus:+transform-header:echo -n {2..} || echo \"\"'
  --no-multi
  --height 60%
"

# File search with preview (CTRL-T)
export FZF_CTRL_T_OPTS="
  --preview='fzf-preview.sh {}'
  --preview-window='right:50%:rounded'
  --border-label=' fzf - ENTER: Select │ TAB: Multi-select │ CTRL-O: Open File'
  --bind='ctrl-f:toggle-preview'
  --bind='ctrl-o:execute(nvim {})+abort'
  --multi --reverse
"

# Directory navigation (ALT-C)
export FZF_ALT_C_OPTS="
  --preview='lsd -la --color=always --blocks=permission,user,group,size,date,name {} 2>/dev/null || ls -la {}'
  --preview-window='right:60%'
  --border-label=' fzf - ENTER: Change Directory'
  --bind='ctrl-f:toggle-preview'
  --bind='focus:transform-header:true'
  --height=70%
"

# Find and edit files (fze)
fze() {
  local files
  files=($(fzf --query="$1" --multi --reverse \
    --preview='fzf-preview.sh {}' \
    --preview-window='right:50%:rounded' \
    --border-label=' fzf - ENTER: Select │ TAB: Multi-select │ CTRL-O: Open File' \
    --bind='ctrl-f:toggle-preview' \
    --bind='ctrl-o:execute(nvim {})+abort'))
  [[ -n "$files" ]] && nvim "${files[@]}"
}

source <(fzf --zsh)
