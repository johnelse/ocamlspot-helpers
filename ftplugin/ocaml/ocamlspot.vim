if exists("g:loaded_ocamlspot")
    finish
endif
let g:loaded_ocamlspot = 1

python << EOF
import os
import vim
import uuid

# Add ../lib/ to path to get to ocamlspot.py
libpath = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(
    vim.eval("expand('<sfile>:p')")))), 'lib')
sys.path.append(libpath)

import ocamlspot

def get_vim_status():
    buffer_name = vim.current.buffer.name
    (row, col) = vim.current.window.cursor
    return (buffer_name, row, col)

def spot(split = False):
    (buffer_name, row, col) = ocamlspot.spot(*get_vim_status())
    vim_command = "split" if split else "edit"
    vim.command("%s %s" % (vim_command, buffer_name))
    vim.current.window.cursor = (row, col)

def print_type():
    signature = ocamlspot.get_type(*get_vim_status())
    if len(signature) == 0:
        print "Type: not found"
        return -1
    elif len(signature) == 1:
        print signature[0].strip()
    else:
        # TODO: Work out if this is a module or just a function with a long signature.
        # if a module: do some kind of intellisense
        #   - would require either lookup by symbol, or constant compilation
        # if a function: print the signature
        vim.command("rightbelow 10new")
        outputWindow = vim.current.window
        for line in signature:
            outputWindow.buffer.append(line)
        # Save the buffer to /tmp so we don't have to force quit.
        # :silent prevents the annoying save confirmation.
        vim.command("silent write /tmp/typesig_%s.tmp" % uuid.uuid4().hex)
        print "Type signature has %d lines." % len(signature)
    return 0

EOF

function! OCamlSpot()
python << EOF
spot()
EOF
endfunction

function! OCamlSpotSplit()
python << EOF
spot(split = True)
EOF
endfunction

function! OCamlType()
python << EOF
print_type()
EOF
endfunction
