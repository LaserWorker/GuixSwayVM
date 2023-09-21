;; This is a Guix Configuration for SWAY Guix running via Wayland preferably in a 8GB+ VM
;; Thus such rules apply:
;; This program is free software: you can redistribute it and/or modify it under the terms 
;; of the GNU General Public License as published by the Free Software Foundation, either 
;; version 3 of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
;; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
;; See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License along with this program. 
;; If not, see <https://www.gnu.org/licenses/>.

(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)
(use-package-modules admin)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/Chicago")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "GuixVM")

;; In case you are missing the key group... Don't Forget
 (groups (cons* (user-group (name "seat")) 
		%base-groups))
;; This should be fixxed by seatd-service-type ... if not un-comment
 
;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "name")
                  (comment "AboutMe")
                  (group "users")
                  (home-directory "/home/name")
                  (supplementary-groups '("wheel" "netdev" "audio" "video" "seat")))
                %base-user-accounts))

  ;; Packages installed system-wide.  The user can also install packages
  (packages (append (list 
			(specification->package "nss-certs")
                        (specification->package "dmenu")
                        (specification->package "seatd")
                        (specification->package "eudev")
                        (specification->package "mesa")
                        (specification->package "bash")
                        (specification->package "emacs-ebuild-mode")
                        (specification->package "libinput")
                        (specification->package "libglvnd")
                        (specification->package "libseat")
                        (specification->package "ckb-next")
                        (specification->package "glibc-locales")
                        (specification->package "wayland")
                        (specification->package "wlr-randr")
                        (specification->package "sway")
                        (specification->package "egl-wayland")
                        (specification->package "eglexternalplatform")
                        (specification->package "elogind")
                        (specification->package "midori")

;; Packages you might want later
;;                      (specification->package "ungoogled-chromium-wayland")
;;                      (specification->package "sddm")
;;                      (specification->package "i3-wm")
;;                      (specification->package "thunar")
;;                      (specification->package "grub")
;;                      (specification->package "xdisorg")
;;                      (specification->package "xorg")

			)
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list 
		(service dhcp-client-service-type)
;;This is a VM ... so ... ^that^ by itself will not do, if you are running in bare metal
;; You may require a WPA suplicant and network manager of other kinds 
                 (service ntp-service-type)
                 (service gpm-service-type)
                 (service seatd-service-type) 
	)

;; This is the default list of services we are appending to.
           %base-services))

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
               ;; Pay attention to your boot config, may not be like this for your setup
                (targets (list "/dev/sda"))
                (keyboard-layout keyboard-layout)))
;; I assume and encrypted setup that requires mapping and
;; Double checks you know the unlock password for LUKS encrypted drive.
;; If you want to encrypt outside the VM use instructions below.
  (mapped-devices (list (mapped-device
                          (source (uuid
                                   "[your root partition UUID]"))
                          (target "cryptroot")
                          (type luks-device-mapping))))
;; In order to not use LUKS in VM encryption remove the "mapped-devices" config above this line. 
;; Remove (dependencies mapped-devices) from (file-system ... )
;; Replace "/dev/mapper/cryptroot" using the /dev/sda# or (uuid ...) for your root directory's partition.
;; These are the file systems that get "mounted".  The unique file system identifiers 
;; ("UUIDs") can be obtained by running 'blkid' in a terminal.
  (file-systems (cons* 
			(file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices)
			 ) 
		%base-file-systems)))
       
