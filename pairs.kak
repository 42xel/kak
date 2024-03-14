### An opiniated manual pairing to make it easier to surround selection with parenthesis and such.
# Limited smartness
#
# Compared to auto-pairs :
# - no hook, no dynamic remapping
# - no remapping of default keys. Along with the previous point, it makes it works nicer with other functionalities hopefully, like `.` for a start.
# - you can surround the selection

# TODO params
# TODO completion
# TODO register ? count ?

# TODO tester multi selection and autopair. I got a hunch it doesn't work well together.
# Heck even VSCode's multi selection and auto autopair don't work well together.

# yet another advantage of manual over auto is that an option is less of a neccessity
# Interstingly, braces are parsed before comments, with unintended consequences
# IDEA : \K in <a-k> should regex modify the selection. That's kind of what s does except not really.
declare-option -docstring "list of surrounding pairs" str-list pairs ()b

define-command -docstring \
"surround <left_symbol> [<right_symbol>]" -params 2 surround %{
  execute-keys -draft "i%arg{1}<esc>a%arg{2}<esc>"
}

# define-command -params 1 surround %{
#   execute-keys -draft "i%arg{1}<esc>a%arg{1}<esc>"
# }
# define-command surround %{
#   surround %reg{dquote}
# }

define-command -docstring "pair" -hidden -params 2 insert-pair %{
  execute-keys -draft ";i%arg{1}%arg{2}"

  # somehow doesn't work with -itersel. So we got to do a pure kakoune solution.
  # evaluate-commands -itersel %sh{
  #   (
  #     echo 'execute-keys "' ;
  #     if [ $kak_selection_length = 1 ]; then
  #       echo h
  #     else
  #       echo H
  #    fi ;
  #     echo '"'
  #   ) > $kak_command_fifo
  # }

  evaluate-commands -save-regs '^' %{
    try %{
      execute-keys -draft -save-regs '' "<a-k>..<ret>HZ"
      try %{
        execute-keys "<a-K>..<ret>h<a-z>a"
      } catch %{
        execute-keys "z"
      }
    } catch %{
      execute-keys "h"
    }
  }
}

define-command -docstring "add-pair-mappings add commands to add a pair mapping." add-pair-mappings %{

}

## mode surround from global
# TODO register to automatically fill the mode, and count to be locked in it
# TODO enter ? semi-colon ?
# TODO custom surround
# TODO on-key
declare-user-mode surround
map -docstring "surround mode" global user s ": enter-user-mode surround<ret>"
map -docstring "surround mode" global user S ": enter-user-mode -lock surround<ret>"

## map for global
map -docstring "insert a pair of parentheses at cursor location" global surround ) "<esc>: insert-pair ( )<ret>"
map -docstring "surround with parentheses" global surround ( "<esc>: surround ( )<ret>"

## map for insert
map -docstring "surround with parentheses" global insert <a-(> "<a-;>: surround ( )<ret>"
map -docstring "insert a pair of parentheses at cursor location" global insert <a-)> "<esc>: insert-pair ( )<ret>"



