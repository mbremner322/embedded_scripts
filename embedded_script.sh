# here are some functions to make our lives much nicer!
# put something like this in your bashrc!

#DIRECTORY="embedded_scripts"
#cd
#if [ ! -d "$DIRECTORY" ]; then
#    git clone https://github.com/mbremner322/embedded_scripts.git
#fi
#cd "$DIRECTORY"
#git pull (optional)
#source embedded_script.sh
#cd


# everything you need to make kernel / any user app
user_setup()
{
    echo "setting up..."
    unset CROSS_COMPILE
    unset ARCH
    cur_dir="$(pwd)"
    echo "going into busybox-1.21.0..."
    cd ~/busybox-1.21.0
    echo "sourcing busybox-configure..."
    source busybox-configure.bash
    echo "making busybox..."
    colormake
    echo "exprting CROSS_COMPILE and ARCH env variables..."
    export CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm
    echo "installing headers"
    cd ~/kernel
    colormake headers_install
    cd "$cur_dir"
   echo "Done!"
}

# everything you need for modules to make
kernel_setup()
{
    export CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm
    cur_dir="$(pwd)"
    adb reboot-bootloader
    cd ~/kernel
    RAMDISK=~/nakasi-jdq39/boot-img/boot.img-ramdisk-root.gz
    fastboot boot arch/arm/boot/zImage $RAMDISK
    cd "$cur_dir"
}

# pass in the module name as an argument
# makes the module and pushes onto the tablet
module_make()
{
    cur_dir="$(pwd)"
    cd ~/kernel/rtes/modules/$1
    rm *.ko
    cd ~/kernel
    colormake M=rtes/modules/$1
    adb push rtes/modules/$1/$1.ko data
    cd "$cur_dir"
}

kernel_make()
{
    cur_dir="$(pwd)"
    cd ~/kernel/rtes/kernel
    rm *.o
    export CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm
    cd ~/kernel
    colormake
    cd "$cur_dir"
}

user_make()
{
    cur_dir="$(pwd)"
    cd ~/kernel
    make headers_install
    cd ~/kernel/rtes/apps/$1
    colormake clean
    colormake
    adb push $1 data
    cd "$cur_dir"
}

new_kernel_repo()
{
    cd ~/kernel
    adb pull /proc/config.gz
    gunzip config.gz
    mv config .config
    export CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm
    make oldconfig
    make
    file arch/arm/boot/compressed/vmlinux
}

update_scripts()
{
    cur_dir="$(pwd)"
    DIRECTORY="embedded_scripts"
    cd
    if [ ! -d "$DIRECTORY" ]; then
        git clone https://github.com/mbremner322/embedded_scripts.git
    fi
    cd "$DIRECTORY"
    git pull
    source embedded_script.sh
    cd "$cur_dir"
}

alias shello='adb shell'
alias ks='kernel_setup'
alias km='kernel_make'
