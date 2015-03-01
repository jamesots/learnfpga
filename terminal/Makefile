## -*- Makefile -*-
##
## User: james
## Time: 03-Jan-2015 14:59:45
## Makefile created by Oracle Solaris Studio.
##
## This file is generated automatically.
##


#### Compiler and tool definitions shared by all build targets #####
CC = gcc
BASICOPTS = -g -m64
CFLAGS = $(BASICOPTS)


# Define the target directories.
TARGETDIR_termfpga=dist


all: $(TARGETDIR_termfpga)/termfpga $(TARGETDIR_termfpga)/termfpgaout


## Target: termfpga
OBJS_termfpga =  \
	$(TARGETDIR_termfpga)/termfpga.o
USERLIBS_termfpga = -lftdi -lncurses $(SYSLIBS_termfpga) 
DEPLIBS_termfpga =   
LDLIBS_termfpga = $(USERLIBS_termfpga)

OBJS_termfpgaout =  \
	$(TARGETDIR_termfpga)/termfpgaout.o
USERLIBS_termfpgaout = -lftdi -lncurses $(SYSLIBS_termfpgaout) 
DEPLIBS_termfpgaout =   
LDLIBS_termfpgaout = $(USERLIBS_termfpgaout)


# Link or archive
$(TARGETDIR_termfpga)/termfpga: $(TARGETDIR_termfpga) $(OBJS_termfpga) $(DEPLIBS_termfpga)
	$(LINK.c) $(CFLAGS_termfpga) $(CPPFLAGS_termfpga) -o $@ $(OBJS_termfpga) $(LDLIBS_termfpga)
$(TARGETDIR_termfpga)/termfpgaout: $(TARGETDIR_termfpgaout) $(OBJS_termfpgaout) $(DEPLIBS_termfpgaout)
	$(LINK.c) $(CFLAGS_termfpgaout) $(CPPFLAGS_termfpgaout) -o $@ $(OBJS_termfpgaout) $(LDLIBS_termfpgaout)


# Compile source files into .o files
$(TARGETDIR_termfpga)/termfpga.o: $(TARGETDIR_termfpga) termfpga.c
	$(COMPILE.c) $(CFLAGS_termfpga) $(CPPFLAGS_termfpga) -o $@ termfpga.c
$(TARGETDIR_termfpga)/termfpgaout.o: $(TARGETDIR_termfpgaout) termfpgaout.c
	$(COMPILE.c) $(CFLAGS_termfpgaout) $(CPPFLAGS_termfpgaout) -o $@ termfpgaout.c


#### Clean target deletes all generated files ####
clean:
	rm -f \
		$(TARGETDIR_termfpga)/termfpga \
		$(TARGETDIR_termfpga)/termfpga.o \
		$(TARGETDIR_termfpga)/termfpgaout \
		$(TARGETDIR_termfpga)/termfpgaout.o
	rm -f -r $(TARGETDIR_termfpga)


# Create the target directory (if needed)
$(TARGETDIR_termfpga):
	mkdir -p $(TARGETDIR_termfpga)

# Enable dependency checking
.KEEP_STATE:
.KEEP_STATE_FILE:.make.state.GNU-amd64-Linux

