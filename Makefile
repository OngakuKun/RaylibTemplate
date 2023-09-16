.PHONY: all clean

PROJECT_NAME           ?=app
RAYLIB_VERSION         ?=4.5.0
RAYLIB_PATH            ?=C:/raylib/raylib
COMPILER_PATH          ?=C:/raylib/w64devkit/bin
BUILD_MODE             ?=DEBUG
EXT                    ?=.exe
PLATFORM               ?=PLATFORM_DESKTOP

DESTDIR                ?=/usr/local
RAYLIB_INSTALL_PATH    ?=$(DESTDIR)/lib
RAYLIB_H_INSTALL_PATH  ?=$(DESTDIR)/include
RAYLIB_LIBTYPE         ?=STATIC
USE_EXTERNAL_GLFW      ?=FALSE
USE_WAYLAND_DISPLAY    ?=FALSE

RAYLIB_RELEASE_PATH    ?=$(RAYLIB_PATH)/src
EXAMPLE_RUNTIME_PATH   ?=$(RAYLIB_RELEASE_PATH)

ifeq ($(PLATFORM),PLATFORM_DESKTOP)
	ifeq ($(OS),Windows_NT)
		PLATFORM_OS=WINDOWS
		export PATH := $(COMPILER_PATH):$(PATH)

		CC             =gcc
		MAKE           =make

		CFLAGS        +=-Wall -std=c99 -D_DEFAULT_SOURCE -Wno-missing-braces

		LDFLAGS        =-L. -L$(RAYLIB_RELEASE_PATH) -L$(RAYLIB_PATH)/src
		LDFLAGS       +=$(RAYLIB_PATH)/src/raylib.rc.data

		ifeq ($(BUILD_MODE),RELEASE)
			# -Wl,--subsystem,windows hides the console window
			LDFLAGS   +=-Wl,--subsystem,windows
		endif

		ifeq ($(BUILD_MODE),DEBUG)
			CFLAGS    += -g -O0
		else
			CFLAGS    += -s -O1
		endif

		LDLIBS = -lraylib -lopengl32 -lgdi32 -lwinmm

		INCLUDE_PATHS  = -I./src -I$(RAYLIB_PATH)/src -I$(RAYLIB_PATH)/src/external
	else
		UNAMEOS=$(shell uname)
		ifeq ($(UNAMEOS),Linux)
			PLATFORM_OS          =LINUX

			RAYLIB_PREFIX ?= ..
			RAYLIB_PATH    = $(realpath $(RAYLIB_PREFIX))

			CC                   =gcc
			MAKE                 =make
			EXT                  =

			CFLAGS              +=-Wall -std=c99 -D_DEFAULT_SOURCE -Wno-missing-braces
			
			LDFLAGS              = -L. -L/usr/local/lib
			LDFLAGS = -L. -L$(RAYLIB_INSTALL_PATH) -L$(RAYLIB_RELEASE_PATH)

			ifeq ($(BUILD_MODE),DEBUG)
				CFLAGS          += -g -O0
			else
				CFLAGS          += -s -O1
			endif

			LDLIBS               = -lraylib -lGL -lm -lpthread -ldl -lrt -lX11

			INCLUDE_PATHS        =-I./src -I/usr/local/include/raylib

		endif
	endif
endif

SRC_DIR = src src/app
OBJ_DIR = bin/obj

SRC = $(wildcard *.c $(foreach fd, $(SRC_DIR), $(fd)/*.c))
OBJS = $(subst src/, $(OBJ_DIR)/,$(SRC:c=o))

ifeq ($(PLATFORM),PLATFORM_ANDROID)
	MAKEFILE_PARAMS =-f Makefile.Android
	export PROJECT_NAME
	export SRC_DIR
else
	MAKEFILE_PARAMS =$(PROJECT_NAME)
endif

all:
	$(MAKE) $(MAKEFILE_PARAMS)

$(PROJECT_NAME): $(OBJS)
	$(CC) -o bin/$(PROJECT_NAME)$(EXT) $(OBJS) $(CFLAGS) $(INCLUDE_PATHS) $(LDFLAGS) $(LDLIBS) -D$(BUILD_MODE) -D$(PLATFORM) 

#	SRC/APP
$(OBJ_DIR)/app/app.o: src/app/app.c src/app/app.h src/defines.h
	mkdir -p $(@D)
	$(CC) -o $@ $(CFLAGS) -c $< $(INCLUDE_PATHS) -D$(BUILD_MODE) -D$(PLATFORM)

$(OBJ_DIR)/main.o: src/main.c src/defines.h src/app/app.h
	mkdir -p $(@D)
	$(CC) -o $@ $(CFLAGS) -c $< $(INCLUDE_PATHS) -D$(BUILD_MODE) -D$(PLATFORM)

clean:
	$(RM) -r bin/$(PROJECT_NAME)$(EXT) $(OBJS) bin/
	@echo Cleaning done
