LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

DO_CC  = $(wildcard $(CODE_PATH)/client/*.c)
DO_CC += $(filter-out $(CODE_PATH)/server/sv_rankings.c, $(wildcard $(CODE_PATH)/server/*.c) )
DO_CC += $(filter-out $(wildcard $(CODE_PATH)/qcommon/vm_*.c), $(wildcard $(CODE_PATH)/qcommon/*.c) )
DO_CC += $(wildcard $(CODE_PATH)/libjpeg/*.c)
DO_CC += $(wildcard $(CODE_PATH)/vrmod/*.c)
DO_CC += $(wildcard $(CODE_PATH)/vrmod/VRAPI/*.c)
DO_CC += $(wildcard $(CODE_PATH)/android/*.c)
DO_CC += $(CODE_PATH)/unix/unix_shared.c
DO_CC += $(CODE_PATH)/unix/linux_joystick.c

#specific architecture compilation parameters
ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
	DO_CC += $(CODE_PATH)/qcommon/vm_aarch64.c
endif

ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
	DO_CC += $(CODE_PATH)/qcommon/vm_armv7l.c
endif

ifeq ($(TARGET_ARCH_ABI), x86_64)
	DO_CC += $(CODE_PATH)/qcommon/vm_x86.c
endif

ifeq ($(TARGET_ARCH_ABI), x86)
	DO_CC += $(CODE_PATH)/qcommon/vm_x86.c
endif

LOCAL_MODULE 			:= Quake3eVR
LOCAL_SRC_FILES 		= $(DO_CC)

# -landroid is for android/looper.h/ALooper_pollAll() & ANativeWindow_getWidth ...
LOCAL_LDLIBS 			:= -llog -landroid -lOpenSLES
LOCAL_SHARED_LIBRARIES	:= vrapi

LOCAL_STATIC_LIBRARIES	:= rendv botlib
LOCAL_CFLAGS			:= -Werror -D__ANDROID__ -DUSE_VULKAN_API

#LOCAL_CFLAGS			+= -std=c99 // unused?
#ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
#	LOCAL_CFLAGS += -DHAVE_NEON=1
#endif

# for Oculus VRApi
LOCAL_CFLAGS			+= -DUSE_VRAPI
LOCAL_CFLAGS			+= -DUSE_VRMOD
LOCAL_CFLAGS			+= -DUSE_VIRTUAL_MENU
LOCAL_CFLAGS			+= -DUSE_NEOHUD
#LOCAL_CFLAGS			+= -DUSE_SCREENMAP

# ==== Release flags: ====
LOCAL_CFLAGS			+= -DNDEBUG

# ==== Debug flags: ====
# for Android Studio Logcat
#LOCAL_CFLAGS			+= -D__ANDROID_LOG__
# visual studio debug cflag
#LOCAL_CFLAGS			+= -D_DEBUG
# LOCAL_CFLAGS			+= -DOVR_DEBUG

# Builds a dylib
include $(BUILD_SHARED_LIBRARY)

$(call import-add-path, $(LOCAL_PATH))
$(call import-module, android/native_app_glue)

$(call import-module, VrApi/Projects/AndroidPrebuilt/jni)

