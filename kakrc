set-option global ui_options terminal_assistant=cat
# colorscheme red-phoenix

add-highlighter global/ number-lines -hlcursor -min-digits 3
add-highlighter global/ show-matching
# add-highlighter global/wrap wrap

add-highlighter global/show-whitespaces show-whitespaces -spc " "
set-option global tabstop 4
# kak
hook global WinSetOption filetype=kak %{
  # set-option window makecmd "source...?"
  set-option window tabstop 2
  set-option window indentwidth %opt{tabstop}
}

# yanking into clipboard (requires xsel install, and X11 forwarding)
map global normal <c-y> "<a-|> xsel -ib<ret>"
map global normal <c-p> "!xsel -bo<ret>"
map global normal <c-v> "<a-!>xsel -bo<ret>"
map global insert <c-y> "<a-;><a-|> xsel -ib<ret>"
map global insert <ins> <c-v>
map global insert <c-v> "<a-;><a-!> xsel -bo<ret>"
map global insert <c-b> "<a-;>! xsel -bo<ret>"
# map global insert <c-b> <c-p>

# comment line
# TODO use a different shortcut in qwerty
map global normal <a-lt> ":comment-line<ret>"
map global insert <a-lt> "<a-;>:comment-line<ret>"

# plugging in the plugin manager
source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload

# ## TODO test and make better
# # autopairs
# plug "alexherbo2/auto-pairs.kak" config %{
#   enable-auto-pairs
# }

## TODO: learn to use
# fzf
plug "andreyorst/fzf.kak" config %{
  require-module fzf
  require-module fzf-grep
  require-module fzf-file
} defer fzf %{
  set-option global fzf_highlight_command "lat -r {}"
} defer fzf-file %{
  set-option global fzf_file_command "fd . --no-ignore-vcs"
} defer fzf-grep %{
  set-option global fzf_grep_command "fd"
}
map -docstring "fzf" global user z ": fzf-mode<ret>"

## TODO see if still useful after fzf and harpoon/pokemon
define-command -docstring "scratch fd-find" -params 0.. fd %{
  edit -scratch *fd*
  execute-keys "gg! fd %arg{@}<ret><a-o>"
}

plug "andreyorst/powerline.kak" defer kakoune-themes %{
  powerline-theme pastel
} defer powerline %{
  powerline-format global "session git lsp bufname filetype mode_info lsp line_column position"
  set-option global powerline_separator_thin ""
  set-option global powerline_separator ""
} config %{
  powerline-start
}

plug "gustavo-hms/luar" %{
  require-module luar
}

plug "kak-lsp/kak-lsp" do %{
  cargo install --locked --force --path .
  # optional: if you want to use specific language servers
  # mkdir -p ~/.config/kak-lsp
  # cp -n kak-lsp.toml ~/.config/kak-lsp/
}
map -docstring "lsp mode" global user l ": enter-user-mode lsp<ret>"
# map -docstring "open lsp" normal user <square> ": enter-user-mode lsp<ret>"
map -docstring "goto next mistake" global normal <F8> ": lsp-find-error --include-warnings<ret>: lsp-hover<ret>"
map -docstring "lsp hover" global normal <F1> ": lsp-hover<ret>"
# TODO : use %val{register} if provided and free <s-F2>
map -docstring "rename" global normal <F2> ": lsp-rename-prompt<ret>"
map -docstring "rename" global normal <s-F2> ": lsp-rename %%reg{dquote}<ret>"
map -docstring "open lsp" global normal <F3> ": enter-user-mode lsp<ret>a<ret>"
# TODO previous error and insert.
map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'

# # eval %sh{kak-lsp --kakoune -s $kak_session} # Not needed if you load it with plug.kak
# hook global WinSetOption filetype=rust %{
#   lsp-enable-window
#   lsp-inlay-diagnostics-enable global

# echo -debug toto
#   set-option buffer makecmd "cargo build"
# echo -debug titi
# }
#   set-option global makecmd "cargo build"

# rust
hook global WinSetOption filetype=rust %{
  lsp-enable-window
  # doesn't work, wrong argument count. see ~/.config/kak/plugins/kak-lsp/rc/lsp.kak:2209:5
  # lsp-inlay-diagnostics-enable "global"

  set-option window makecmd "cargo build"

  hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
  hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
  hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
  hook -once -always window WinSetOption filetype=.* %{
    remove-hooks window semantic-tokens
  }
}

# auto save on exit insert mode
hook global ModeChange pop:insert:.* %{
  try %{
    write
    echo "file saved at %sh{date}"
  }
}

source ~/.config/kak/arrow_keys.kak
source ~/.config/kak/pairs.kak
source ~/.config/kak/better-gf.kak
