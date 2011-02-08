:python << EOF

import vim
import re
import uuid
from subprocess import Popen, PIPE

def parse_loc(str):
    kv = re.match("^l([0-9]+)c([0-9]+)b[0-9]+$", str)
    if kv: 
        return (int(kv.group(1)), int(kv.group(2)))
    else:
        return None

def spot(buffer_name, row, col):
    command = "ocamlspot %s:l%dc%d 2>&1" % (buffer_name, row, col)

    for line in Popen(command, stdout=PIPE, shell=True).stdout:
        kv = re.match("^Spot: (.*):(l[0-9]+c[0-9]+b[0-9]+):(l[0-9]+c[0-9]+b[0-9]+)$", line)
        if kv:
            (l1,c1) = parse_loc(kv.group(2))
            (l2,c2) = parse_loc(kv.group(3))
            vim.command("split %s" % kv.group(1))
            vim.current.window.cursor = (l1, c1)

def get_signature_all(pipe):
    recording = False
    lines = []
    while True:
        line = pipe.readline()
        if not line:
            return lines
        if re.match("^Type: .*$", line):
            recording = True
        elif re.match("^XType: .*$", line):
            return lines
        if recording:
            lines.append(line)

def print_type(buffer_name, row, col):
    command = "ocamlspot -n %s:l%dc%d 2>&1" % (buffer_name, row, col)

    pipe = Popen(command, stdout=PIPE, shell=True).stdout
    signature = get_signature_all(pipe)

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
:python << EOF

(row, col) = vim.current.window.cursor
buffer_name = vim.current.buffer.name
spot(buffer_name, row, col)

EOF

endfunction

function! OCamlType()
:python << EOF

(row, col) = vim.current.window.cursor
buffer_name = vim.current.buffer.name
print_type(buffer_name, row, col)

EOF

endfunction

:map <F3> :call OCamlSpot()<CR>
:map <F4> :call OCamlType()<CR>
