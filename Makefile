#
# Copyright (c) 2000-2002 by Solar Designer. See LICENSE.
#

CC = gcc
LD = ld
RM = rm -f
MKDIR = mkdir -p
INSTALL = install
CFLAGS = -c -Wall -fPIC -O2
LDFLAGS = -s --shared -lpam -lcrypt
LDFLAGS_SUN = -s -G -lpam -lcrypt
LDFLAGS_HP = -s -b -lpam -lcrypt

# Uncomment these to use HP's ANSI C compiler instead of gcc.
#CC = cc
#CFLAGS = -c -Aa -D_HPUX_SOURCE +z +O2

# Comment these out when building on non-tsconvert'ed HP-UX.
CFLAGS += -DHAVE_SHADOW
LDFLAGS_HP += -lsec

TITLE = pam_passwdqc
LIBSHARED = $(TITLE).so
SHLIBMODE = 755
MAN8 = $(TITLE).8
MANMODE = 644
SECUREDIR = /lib/security
MANDIR = /usr/share/man
FAKEROOT =

PROJ = $(LIBSHARED)
OBJS = pam_passwdqc.o passwdqc_check.o passwdqc_random.o wordset_4k.o

all:
	if [ "`uname -s`" = "SunOS" ]; then \
		make LDFLAGS="$(LDFLAGS_SUN)" $(PROJ); \
	elif [ "`uname -s`" = "HP-UX" ]; then \
		make LDFLAGS="$(LDFLAGS_HP)" $(PROJ); \
	else \
		make $(PROJ); \
	fi

$(LIBSHARED): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(LIBSHARED)

.c.o:
	$(CC) $(CFLAGS) $*.c

pam_passwdqc.o: passwdqc.h pam_macros.h
passwdqc_check.o: passwdqc.h
passwdqc_random.o: passwdqc.h

install:
	$(MKDIR) $(FAKEROOT)$(SECUREDIR)
	$(INSTALL) -m $(SHLIBMODE) $(LIBSHARED) $(FAKEROOT)$(SECUREDIR)
	$(MKDIR) $(FAKEROOT)$(MANDIR)/man8
	$(INSTALL) -m $(MANMODE) $(MAN8) $(FAKEROOT)$(MANDIR)/man8/

remove:
	$(RM) $(FAKEROOT)$(SECUREDIR)/$(LIBSHARED)
	$(RM) $(FAKEROOT)$(MANDIR)/man8/$(MAN8)

clean:
	$(RM) $(PROJ) *.o
