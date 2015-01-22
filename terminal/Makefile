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


all: $(TARGETDIR_termfpga)/termfpga


## Target: termfpga
OBJS_termfpga =  \
	$(TARGETDIR_termfpga)/termfpga.o
USERLIBS_termfpga = -lftdi -lncurses $(SYSLIBS_termfpga) 
DEPLIBS_termfpga =   
LDLIBS_termfpga = $(USERLIBS_termfpga)


# Link or archive
$(TARGETDIR_termfpga)/termfpga: $(TARGETDIR_termfpga) $(OBJS_termfpga) $(DEPLIBS_termfpga)
	$(LINK.c) $(CFLAGS_termfpga) $(CPPFLAGS_termfpga) -o $@ $(OBJS_termfpga) $(LDLIBS_termfpga)


# Compile source files into .o files
$(TARGETDIR_termfpga)/termfpga.o: $(TARGETDIR_termfpga) termfpga.c
	$(COMPILE.c) $(CFLAGS_termfpga) $(CPPFLAGS_termfpga) -o $@ termfpga.c


#### Clean target deletes all generated files ####
clean:
	rm -f \
		$(TARGETDIR_termfpga)/termfpga \
		$(TARGETDIR_termfpga)/termfpga.o
	rm -f -r $(TARGETDIR_termfpga)


# Create the target directory (if needed)
$(TARGETDIR_termfpga):
	mkdir -p $(TARGETDIR_termfpga)

# Enable dependency checking
.KEEP_STATE:
.KEEP_STATE_FILE:.make.state.GNU-amd64-Linux

