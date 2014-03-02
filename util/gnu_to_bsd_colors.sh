# DIR => di
# LINK => li
# SOCKET => so
# PIPE => pi
# EXE => ex
# BLOCK => bd
# CHAR => ch
# UID_EXE => ex
# GID_EXE => ex
# STICKY_WRITE_DIR => di
# NONSTICKY_WRITE_DIR => di

# TODO: Write a mapper to deal with this...

# forergound
        ((char=? x #\a) "30")
        ((char=? x #\b) "31")
        ((char=? x #\c) "32")
        ((char=? x #\d) "33")
        ((char=? x #\e) "34")
        ((char=? x #\f) "35")
        ((char=? x #\g) "36")
        ((char=? x #\h) "37")
 
        ((char=? x #\A) "01;30")
        ((char=? x #\B) "01;31")
        ((char=? x #\C) "01;32")
        ((char=? x #\D) "01;33")
        ((char=? x #\E) "01;34")
        ((char=? x #\F) "01;35")
        ((char=? x #\G) "01;36")
        ((char=? x #\H) "01;37")
        ((char=? x #\x) "39")))
 
# background
        ((char=? x #\a) "40")
        ((char=? x #\b) "41")
        ((char=? x #\c) "42")
        ((char=? x #\d) "43")
        ((char=? x #\e) "44")
        ((char=? x #\f) "45")
        ((char=? x #\g) "46")
        ((char=? x #\h) "47")
 
        ((char=? x #\A) "01;40")
        ((char=? x #\B) "01;41")
        ((char=? x #\C) "01;42")
        ((char=? x #\D) "01;43")
        ((char=? x #\E) "01;44")
        ((char=? x #\F) "01;45")
        ((char=? x #\G) "01;46")
        ((char=? x #\H) "01;47")
        ((char=? x #\x) "49")))
