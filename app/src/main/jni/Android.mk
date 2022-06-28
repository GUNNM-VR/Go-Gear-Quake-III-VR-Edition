LOCAL_PATH		:= $(call my-dir)
Q3QUEST_PATH	:= $(LOCAL_PATH)
CODE_PATH		:= $(call my-dir)/../../../../../Quake3e-master\code

include $(Q3QUEST_PATH)/rendv.mk
include $(Q3QUEST_PATH)/botlib.mk

$(call import-module, Quake3eVR)

