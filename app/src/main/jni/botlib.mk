LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

DO_BOT_CC  = $(wildcard $(CODE_PATH)/botlib/*.c)
#DO_BOT_CC += $(wildcard $(CODE_PATH)/android/ifaddrs/*.c)

LOCAL_MODULE 	:= botlib
LOCAL_SRC_FILES := $(DO_BOT_CC)
LOCAL_CFLAGS	:= -DBOTLIB -D__ANDROID__
LOCAL_CFLAGS	+= -DOCULUSGO

# Release flags:
LOCAL_CFLAGS			+= -DNDEBUG

# Debug flags:
# for Android Studio Logcat
#LOCAL_CFLAGS			+= -D__ANDROID_LOG__
# debug flag is the visual studio one
#LOCAL_CFLAGS			+= -D_DEBUG

include $(BUILD_STATIC_LIBRARY)

