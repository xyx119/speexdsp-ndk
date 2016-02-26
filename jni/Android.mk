LOCAL_PATH := $(call my-dir)
 
include $(CLEAR_VARS)
 
LOCAL_MODULE    := libspeexdsp
LOCAL_CFLAGS = -DFIXED_POINT -DUSE_KISS_FFT -DEXPORT="" -DHAVE_STDINT_H -UHAVE_CONFIG_H 
LOCAL_C_INCLUDES := $(LOCAL_PATH)/speexdsp-1.2rc3/include
LOCAL_LDLIBS := -llog

LOCAL_SRC_FILES :=  \
./speexdsp-1.2rc3/libspeexdsp/buffer.c \
./speexdsp-1.2rc3/libspeexdsp/fftwrap.c \
./speexdsp-1.2rc3/libspeexdsp/filterbank.c \
./speexdsp-1.2rc3/libspeexdsp/jitter.c \
./speexdsp-1.2rc3/libspeexdsp/kiss_fft.c \
./speexdsp-1.2rc3/libspeexdsp/kiss_fftr.c \
./speexdsp-1.2rc3/libspeexdsp/mdf.c \
./speexdsp-1.2rc3/libspeexdsp/preprocess.c \
./speexdsp-1.2rc3/libspeexdsp/resample.c \
./speexdsp-1.2rc3/libspeexdsp/scal.c \
./speexdsp-1.2rc3/libspeexdsp/smallft.c

#include $(BUILD_SHARED_LIBRARY)
include $(BUILD_STATIC_LIBRARY)
