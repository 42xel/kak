### An opiniated manual pairing to make it easier to surround selection with parenthesis and such.
#
# Compared to auto-pairs :
# - no hook, no dynamic remapping
# - no remapping of default keys. Along with the previous point, it makes it works nicer with other functionalities hopefully, like `.` for a start.
# - you can surround the selection

# TODO TODO

# TODO params
# TODO completion
# TODO register ? count ?
define-command -docstring "surround" surround %{
  execute-keys -draft "i(<esc>a)<esc>"
}

define-command -docstring "pair" -hidden insert-pair %{
}
