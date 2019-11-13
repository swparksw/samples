#LIBS       = -L/usr/lib -lcgc
LIBS       = -L/usr/lib ../../libcgc/libcgc.o -lm -lc
#LDFLAGS    = -nostdlib -static
LDFLAGS    = -m elf_i386

CC			= clang-7
LD			= ld
CXX			= clang++-7
OBJCOPY			= objcopy

SHELL		:= $(SHELL) -e
BIN_DIR		= bin
BUILD_DIR	= build
CGC_CFLAGS	= -m32 -nostdlib -fno-builtin -nostdinc -nodefaultlibs -Iinclude -Ilib -I../../libcgc $(CFLAGS)

EXE		= $(AUTHOR_ID)_$(SERVICE_ID)
BINS		= $(wildcard cb_*)
SRCS		= $(wildcard src/*.c src/*.cc lib/*.c lib/*.cc)
CXX_SRCS 	= $(filter %.cc, $(SRCS))

OBJS_		= $(SRCS:.c=.o)
OBJS		= $(OBJS_:.cc=.o)
ELF_OBJS	= $(OBJS:.o=.elf)

RELEASE_CFLAGS  = $(CGC_CFLAGS)
RELEASE_DIR     = release
RELEASE_EXE	= $(EXE)
RELEASE_PATH    = $(BIN_DIR)/$(RELEASE_EXE)
RELEASE_OBJS    = $(addprefix $(BUILD_DIR)/$(RELEASE_DIR)/, $(OBJS))
RELEASE_DEBUG_PATH = $(BUILD_DIR)/$(RELEASE_DIR)/$(BIN_DIR)/$(EXE)

all: build test

prep:
	@mkdir -p $(BUILD_DIR)/$(RELEASE_DIR)/lib $(BUILD_DIR)/$(RELEASE_DIR)/src $(BUILD_DIR)/$(RELEASE_DIR)/$(BIN_DIR)
	@mkdir -p $(BIN_DIR)

$(BUILD_DIR)/%.o: %.c
	$(CC) -c $(POV_CFLAGS) -o $@ $^

$(BINS): cb_%:
	( cd $@; make -f ../Makefile build SERVICE_ID=$(SERVICE_ID)_$*)
	cp $@/$(BIN_DIR)/* $(BIN_DIR)

build-binaries: $(BINS)

clean-binaries: ; $(foreach dir, $(BINS), (cd $(dir) && make -f ../Makefile clean) &&) : 

# Release rules
release: prep $(RELEASE_PATH)

$(RELEASE_PATH): $(RELEASE_OBJS)
	$(LD) $(LDFLAGS) -o $(RELEASE_PATH) -I$(BUILD_DIR)/$(RELEASE_DIR)/lib $^ $(LIBS)

$(BUILD_DIR)/$(RELEASE_DIR)/%.o: %.c
	$(CC) -c $(RELEASE_CFLAGS) -o $@ $<

$(BUILD_DIR)/$(RELEASE_DIR)/%.o: %.cc
	$(CXX) -c $(RELEASE_CFLAGS) $(CXXFLAGS) -o $@ $<

clean: clean-binaries
	-rm -rf $(BUILD_DIR) $(BIN_DIR) $(PCAP_DIR)
	-rm -f test.log 

ifeq ($(strip $(BINS)),)
build: prep release 
else
build: prep build-binaries
endif

.PHONY: install all clean clean-test patched prep release remake test build-partial $(BINS)
