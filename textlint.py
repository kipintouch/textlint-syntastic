#!/usr/bin/env python
# encoding: utf-8

import sys, os
# from subprocess import Popen
from subprocess import Popen, PIPE
# from subprocess import call

def print_exc_plus():
    """
     * Print the usual traceback information, followed by a listing of all the
     * local variables in each frame.
    """
    tb = sys.exc_info()[2]
    while 1:
        if not tb.tb_next:
            break
        tb = tb.tb_next
    stack = []
    f = tb.tb_frame
    while f:
        stack.append(f)
        f = f.f_back
    stack.reverse()
    # traceback.print_exc()
    out_text = "\nLocals by frame, innermost last\n"
    for frame in stack:
        out_text += "Frame %s in %s at line %s\n" % (frame.f_code.co_name,
                                                     frame.f_code.co_filename,
                                                     frame.f_lineno)
        for key, value in frame.f_locals.items():
            #We have to be careful not to cause a new error in our error
            #printer! Calling str() on an unknown object could cause an
            #error we don't want.
            try:
                # print value
                out_text += "\t%20s = %s\n" %(key, str(value))
            except:
                out_text += "\t%20s = %s\n" \
                            %(key, "<ERROR_WHILE_PRINTING_VALUES>")
        out_text += "\n"
    print "%s"% out_text

def _setup(fname, _os):
    """
    Setup some functionality for textlint.
    Writes a file textlint.log and textlint.st in temp.
        fname:   File to be checked.
        os:      System OS (Win, Unix)
    """
    stfile = 'textlint.st'
    logfile = 'textlint.log'
    if _os == 'unix':
        stfile = '/tmp/' + stfile
        logfile = '/tmp/' + logfile
    else:
        stfile = '/tmp/' + stfile
        logfile = '/tmp/' + logfile
    fhand = open(stfile, 'w')
    fhand.write("TLConsole checkFileNamed: '"  + fname       + "'"  +  \
                " andOutputToFileNamed: '"     + logfile     + "'"  +  \
                " withinDirectory: '"          + os.getcwd() + "/'" +  \
                "\n\n" )
    fhand.close()
    return stfile, logfile

def tex_compile(headpath):
    """
    Compiles the code and return errors
    """
    if len(sys.argv) != 3:
        return ''
    _fname = sys.argv[1]    # File To be checked
    _os = sys.argv[2]       # System OS (win, unix)
    stfile, logfile = _setup(_fname, _os)
    _pharo = headpath
    if _os == 'unix':
        _pharo += 'textlint/Linux32/pharo'
    else:
        _pharo += 'textlint/Windows32/pharo.exe'
    _image = headpath + 'textlint/TextLint.tmbundle/Support/TextLint.image'
    proc = Popen([_pharo, '-headless', _image, stfile], stdout=PIPE)
    proc.wait()
    fhand = open(logfile, 'r')
    ret_val = fhand.readlines()
    fhand.close()
    ret_val = "".join(ret_val)
    print ret_val

if __name__ == '__main__':
    ppath = os.path.realpath(__file__)
    ppath = os.sep.join(ppath.split(os.sep)[:-1]) + '/'
    tex_compile(ppath)
    # Useful for Debugging
    # try:
    #     tex_compile(ppath)
    # except:
    #     print_exc_plus()
