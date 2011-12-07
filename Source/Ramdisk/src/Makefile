SDKVER = 4.3
PLATFORM = /Developer-3.2.6/Platforms/iPhoneOS.platform
SDK = $(PLATFORM)/Developer/SDKs/iPhoneOS$(SDKVER).sdk
CC = $(PLATFORM)/Developer/usr/bin/gcc-4.2
STRIP = $(PLATFORM)/Developer/usr/bin/strip
LDID = /usr/local/bin/ldid

TARGETS = $(LAUNCHD_TARGET)

# Setupp objects for launchd
LAUNCHD_TARGET = launchd
LAUNCHD_OBJECTS = launchd.o utils.o ld_error.o ld_debug.o syscalls.o
LAUNCHD_CFLAGS = -arch armv6 -isysroot=$(SDK) -I$(SDK)/usr/include -static -nostartfiles -nodefaultlibs -nostdlib -Wl,-e,_main
LAUNCHD_LDFLAGS = 

PWD = $(shell pwd)

%.o: %.S
	$(CC) -c $(<) -o $(@) $(LAUNCHD_CFLAGS)

%.o: %.c
	$(CC) -c $(<) -o $(@) $(LAUNCHD_CFLAGS) 

all: $(TARGETS)

launchd: $(LAUNCHD_OBJECTS)
	$(CC) -o $(LAUNCHD_TARGET) $(LAUNCHD_OBJECTS) $(LAUNCHD_CFLAGS) $(LAUNCHD_LDFLAGS)
	$(STRIP) $(LAUNCHD_TARGET)
	ldid -S $(LAUNCHD_TARGET)
	
clean:
	rm -rf *.o launchd


