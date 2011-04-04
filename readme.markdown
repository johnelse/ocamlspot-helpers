OCamlSpotter helper library
===========================

This library enables ocamlspotter to be easily used from any editor which supports python scripting. To install, simply put ocamlspot.py anywhere in your python path. You can find the folders included in your python path by running the following from a python shell:

    import sys
    sys.path

The library also requires:

* the ocaml compiler to be patched to produce .spit and .spot files.
* the ocamlspot binary to be in your path.

For more information see [OCamlSpotter](http://jun.furuse.info/hacks/ocamlspotter).

The library provides two functions:

* spot(buffer_name, row, col)

This returns, as a tuple, the filename, row and column number of the definition of the symbol at the specified position in the specified file.

* get_type(buffer_name, row, col)

This returns, as a list of strings, the type signature of the symbol at the specified position in the specified file.

OCamlSpotter plugin for VIM
===========================

This is a plugin for the VIM text editor. It requires VIM to be compiled with python scripting support.

To install:

* Put ocamlspot.vim in ~/.vim/plugin

An example set of keybindings to use with the plugin are as follows - add them to ~/.vim/ftplugin/ocaml.vim:

    map <C-]> :call OCamlSpot()<CR>
    map <C-t> <C-o>
    map <C-w> :call OCamlSpotSplit()<CR>
    map <C-k> :call OCamlType()<CR>
