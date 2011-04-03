OCamlSpotter plugin for VIM
===========================

This is an [OCamlSpotter](http://jun.furuse.info/hacks/ocamlspotter) plugin for the VIM text editor. It requires:

* VIM to be compiled with python scripting support.
* the ocaml compiler to be patched to produce .spit and .spot files.
* the ocamlspot binary to be in your path.

By default, the key bindings provided are:

* F2 - Jump to the definition of the symbol under the cursor, opening the definition in the current window.
* F3 - Jump to definition, opening the definition in a split window.
* F4 - Print the type signature of the symbol under the cursor, opening a split window if the definition takes up more than one line.

To install:

* Put ocamlspot.vim in ~/.vim/plugin
* Put ocamlspot.py anywhere in your python path - you can list the suitable folders by running the following from a python shell:
> import sys
>
> sys.path
