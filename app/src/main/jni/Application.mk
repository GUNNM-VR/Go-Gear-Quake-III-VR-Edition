APP_PLATFORM 			:= android-19
APP_ALLOW_MISSING_DEPS	:= true
APP_SHORT_COMMANDS 		:= true
APP_CFLAGS 				+= -Wl,--no-undefined

#APP_ABI 				:= x86 x86_64 armeabi armeabi-v7a arm64-v8a
APP_MODULES 			:= Quake3eVR

# Optimisation flags :
APP_CFLAGS 				+= -Ofast -fstrict-aliasing -fprefetch-loop-arrays
#APP_CFLAGS 			+= -O3 -fstrict-aliasing -fprefetch-loop-arrays

#only for OculusGo/Gear
APP_CFLAGS				+= -DOCULUSGO
APP_CFLAGS 				+= -DUSE_JOYSTICK

# ==== Release flags: ====
LOCAL_CFLAGS			+= -DNDEBUG

# ==== Debug flags: ====
# for Android Studio Logcat
#LOCAL_CFLAGS			+= -D__ANDROID_LOG__
# debug flag is the visual studio one
#LOCAL_CFLAGS			+= -D_DEBUG

# == only one of this two at a time :
#APP_CFLAGS				+= -DUSE_NATIVE_HACK
APP_CFLAGS				+= -DUSE_VR_QVM

# == VR options configuration
APP_CFLAGS				+= -DUSE_VR
APP_CFLAGS				+= -DUSE_VIRTUAL_MENU
APP_CFLAGS				+= -DUSE_VIRTUAL_KEYBOARD
APP_CFLAGS				+= -DUSE_WEAPON_WHEEL
APP_CFLAGS				+= -DUSE_LASER_SIGHT

# == Game options configuration
APP_CFLAGS				+= -DUSE_GRAPPLING_HOOK
APP_CFLAGS				+= -DUSE_NEOHUD
APP_CFLAGS				+= -DUSE_ITEM_TIMERS
APP_CFLAGS				+= -DUSE_DEATHCAM
APP_CFLAGS 				+= -DUSE_JOYSTICK

# == Graphic options configuration
# screen map need the pk3 file : z-screen-reflect-q3e.pk3
#APP_CFLAGS				+= -DUSE_SCREENMAP

