# Guix Sway Virtual Machine
#### Real Life connections require a digital OS to access online resources, this configuration makes a small but quickly expandable OS for online resource access and use. 
 

 
 
 --- If you already use Guix the config.scm is almost all you need, but in the case people need help I'll walk through this step by step.




### Use a virtual machine to build this
 --- As noted in the config.scm this does not include sufficent network drivers. I'll try to get a Guix Sway going for the Desktop, but two key things to consider if I do; It won't be smaller that 10GB and It won't work on all desktops (you will need to consider things like hardware, processor and BIOS boot structure).
 --- Run your VM on a ramdisk with commands like this: 
```Bash
mkdir ~/ramdisk
mount -o size=12G -t tmpfs none ~/ramdisk -o user=username
```
 




### If you have never used Guix before well ...
First things first Download the image from: guix.gnu.org/en/download/
For the sake of using the Guix install I'm getting the "GNU Guix System 1.4.0" x86_64 Desktop Installer image.
You could download the "GNU Guix 1.4.0 QEMU Image" to skip some steps.



Second make a virtual drive with "qemu-img create" like this:  
```Bash
qemu-img create -f qcow2 newdriveimage.img 20G
```


that is:


"-f" for format type (qcow2 being the latest for qemu use)


name and location of drive image to be created


the size of the drive ... in this case a little 20GB will do.


And, YES we will be using a bash or other terminal A LOT for this GuixSwayVM.


### Use the required QEMU options and arguments
Use the "qemu-system-x86_64" command with arguments like this:
```Bash
qemu-system-x86_64 -m 8192 -smp 1 -enable-kvm -vga virtio\
      -boot menu=on,order=d -nic user,model=virtio-net-pci \
      -drive media=disk,index=0,file=/Directory/of/newdriveimage.img \
      -drive media=cdrom,file=/Directory/of/guix-system-install-1.4.0.x86_64-linux.iso \
      -virtfs local,path="/Directory/to/share",security_model=none,mount_tag="TAGkeepidfortracking"
```

that is: Build a 64bit system with 8GB of ram and one cpu core and use the host's virtual tools...


use the boot menu with "d" order, apply a network interface card for the user that is a "virtio-net-pci" model.


have a drive avalible for mount "/dev/sda" file that is the virtual drive or read only iso


have a drive avalible for mount "/dev/cdrom" to load the install iso when running the first time.


Only use the virtfs to quickly load files into the VM don't use that option frequently.



### Use the guided install provided by Guix minimizing software selection 
Do the general install as provided by Guix, but when it comes to the GUI/compositor/WM selection part make sure none are selected.
Then after reboot you can login as root and change the systems' /etc/config.scm to the one provided in this repository. And run:
```Bash
guix system reconfigure /etc/config.scm
```
But Hold Up! If you don't know what ^this does let me walk you through it all more theroughly.
