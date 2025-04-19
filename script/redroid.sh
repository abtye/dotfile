docker run -itd --rm --privileged \
    -v ~/data12:/data \
    -p 5555:5555 \
    fcdcb40d52a0 \
    androidboot.use_memfd=true \
    androidboot.redroid_gpu_mode=host \
    androidboot.redroid_width=1920 \
    androidboot.redroid_height=1080 \
    androidboot.redroid_fps=60 \
    androidboot.redroid_dpi=200 \
    androidboot.redroid_net_ndns=223.5.5.5 \
    ro.dalvik.vm.isa.arm64=x86_64 \
    ro.dalvik.vm.isa.arm = x86 \
    ro.dalvik.vm.native.bridge=libhoudini.so \
    ro.enable.native.bridge.exec=1 \
    ro.enable.native.bridge.exec64=1 \
    ro.product.cpu.abilist32=x86,armeabi-v7a,armeabi \
    ro.product.cpu.abilist64=x86_64,arm64-v8a \
    ro.product.cpu.abilist=x86_64,arm64-v8a,x86,armeabi-v7a,armeabi \
    ro.secure=0
