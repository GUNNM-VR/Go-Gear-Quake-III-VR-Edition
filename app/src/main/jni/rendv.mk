LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

DO_REND_CC  = $(wildcard $(CODE_PATH)/renderervk/*.c)
DO_REND_CC += $(wildcard $(CODE_PATH)/renderercommon/*.c)
DO_REND_CC += $(wildcard $(CODE_PATH)/qcommon/*.c)

LOCAL_STATIC_LIBRARIES	:= android_native_app_glue

LOCAL_MODULE 			:= rendv
LOCAL_SRC_FILES 		:= $(DO_REND_CC)
LOCAL_SHARED_LIBRARIES	:= vrapi

LOCAL_CFLAGS			:= -D__ANDROID__ -DUSE_VULKAN_API
LOCAL_CFLAGS			+= -DUSE_VRAPI

#----------------------------------
# Release flags:
#----------------------------------
LOCAL_CFLAGS			+= -DNDEBUG

#----------------------------------
# Debug flags:
#----------------------------------
# for Android Studio Logcat
#LOCAL_CFLAGS			+= -D__ANDROID_LOG__
# for Q3e validation layers
#LOCAL_CFLAGS			+= -DUSE_VK_VALIDATION
# debug flag is the visual studio one
#LOCAL_CFLAGS			+= -D_DEBUG

include $(BUILD_STATIC_LIBRARY)

$(call import-add-path, $(LOCAL_PATH))
