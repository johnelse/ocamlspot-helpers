import re
from subprocess import Popen, PIPE

def make_ocamlspot_command(buffer_name, row, col):
    return "ocamlspot %s:l%dc%d 2>&1" % (buffer_name, row, col)

def parse_loc(str):
    kv = re.match("^l([0-9]+)c([0-9]+)b[0-9]+$", str)
    if kv: 
        return (int(kv.group(1)), int(kv.group(2)))
    else:
        return None

def spot(buffer_name, row, col):
    command = make_ocamlspot_command(buffer_name, row, col)

    for line in Popen(command, stdout=PIPE, shell=True).stdout:
        matches = re.match("^Spot: <(.*):(l[0-9]+c[0-9]+b[0-9]+):(l[0-9]+c[0-9]+b[0-9]+)>$", line)
        if matches:
            (l1,c1) = parse_loc(matches.group(2))
            (l2,c2) = parse_loc(matches.group(3))
            return (matches.group(1), l1, c1)

def get_type_signature(pipe):
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

def get_type(buffer_name, row, col):
    command = make_ocamlspot_command(buffer_name, row, col)
    pipe = Popen(command, stdout=PIPE, shell=True).stdout
    signature = get_type_signature(pipe)
    return signature
