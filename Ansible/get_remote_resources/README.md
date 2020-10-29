# Ask hosts from inventory for their available CPU cores and RAM mb

To see all available information in JSON format, run:
```bash
ansible localhost -m setup
``` 
Output:
```json
localhost | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "172.17.0.1",
            "192.168.1.108"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::f875:48ff:fef5:fe31",
            "fe80::42:71ff:fe8a:bca5",
            "fe80::77bf:672c:a294:41f8"
        ],
        "ansible_apparmor": {
            "status": "enabled"
        },
        "ansible_architecture": "x86_64",
        "ansible_bios_date": "03/24/2020",
        "ansible_bios_vendor": "American Megatrends Inc.",
        "ansible_bios_version": "FA706IU.304",
        "ansible_board_asset_tag": "ATN12345678901234567",
        "ansible_board_name": "FA706IU",
        "ansible_board_serial": "NA",
        "ansible_board_vendor": "ASUSTeK COMPUTER INC.",
        "ansible_board_version": "1.0",
        "ansible_chassis_asset_tag": "No  Asset  Tag",
        "ansible_chassis_serial": "NA",
        "ansible_chassis_vendor": "ASUSTeK COMPUTER INC.",
        "ansible_chassis_version": "1.0",
        "ansible_cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-5.8-x86_64",
            "apparmor": "1",
            "quiet": true,
            "resume": "UUID=78d180fd-5b45-4aef-9304-ac4e6368bb18",
            "root": "UUID=0c7e5d80-1f7d-4a21-960e-18abb6ccc3a4",
            "rw": true,
            "security": "apparmor",
            "udev.log_priority": "3"
        },
        "ansible_date_time": {
            "date": "2020-10-29",
            "day": "29",
            "epoch": "1603980712",
            "hour": "15",
            "iso8601": "2020-10-29T14:11:52Z",
            "iso8601_basic": "20201029T151152266815",
            "iso8601_basic_short": "20201029T151152",
            "iso8601_micro": "2020-10-29T14:11:52.266815Z",
            "minute": "11",
            "month": "10",
            "second": "52",
            "time": "15:11:52",
            "tz": "CET",
            "tz_offset": "+0100",
            "weekday": "czwartek",
            "weekday_number": "4",
            "weeknumber": "43",
            "year": "2020"
        },
        "ansible_default_ipv4": {
            "address": "192.168.1.108",
            "alias": "wlp3s0",
            "broadcast": "192.168.1.255",
            "gateway": "192.168.1.100",
            "interface": "wlp3s0",
            "macaddress": "70:66:55:5b:36:1b",
            "mtu": 1280,
            "netmask": "255.255.255.0",
            "network": "192.168.1.0",
            "type": "ether"
        },
        "ansible_default_ipv6": {},
        "ansible_device_links": {
            "ids": {
                "nvme0n1": [
                    "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B",
                    "nvme-eui.0000000001000000e4d25c1886c45101"
                ],
                "nvme0n1p1": [
                    "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part1",
                    "nvme-eui.0000000001000000e4d25c1886c45101-part1"
                ],
                "nvme0n1p2": [
                    "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part2",
                    "nvme-eui.0000000001000000e4d25c1886c45101-part2"
                ],
                "nvme0n1p3": [
                    "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part3",
                    "nvme-eui.0000000001000000e4d25c1886c45101-part3"
                ],
                "nvme0n1p4": [
                    "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part4",
                    "nvme-eui.0000000001000000e4d25c1886c45101-part4"
                ],
                "nvme0n1p5": [
                    "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part5",
                    "nvme-eui.0000000001000000e4d25c1886c45101-part5"
                ],
                "nvme0n1p6": [
                    "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part6",
                    "nvme-eui.0000000001000000e4d25c1886c45101-part6"
                ],
                "nvme0n1p7": [
                    "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part7",
                    "nvme-eui.0000000001000000e4d25c1886c45101-part7"
                ]
            },
            "labels": {
                "nvme0n1p1": [
                    "SYSTEM"
                ],
                "nvme0n1p3": [
                    "OS"
                ],
                "nvme0n1p4": [
                    "RECOVERY"
                ],
                "nvme0n1p5": [
                    "RESTORE"
                ]
            },
            "masters": {},
            "uuids": {
                "nvme0n1p1": [
                    "4E4C-AEF5"
                ],
                "nvme0n1p3": [
                    "AED04E91D04E5FA7"
                ],
                "nvme0n1p4": [
                    "04A2B988A2B97EAC"
                ],
                "nvme0n1p5": [
                    "C0CCFFD7CCFFC5A6"
                ],
                "nvme0n1p6": [
                    "78d180fd-5b45-4aef-9304-ac4e6368bb18"
                ],
                "nvme0n1p7": [
                    "0c7e5d80-1f7d-4a21-960e-18abb6ccc3a4"
                ]
            }
        },
        "ansible_devices": {
            "loop0": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "4096",
                "vendor": null,
                "virtual": 1
            },
            "loop1": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "loop2": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "loop3": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "loop4": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "loop5": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "loop6": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "loop7": {
                "holders": [],
                "host": "",
                "links": {
                    "ids": [],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": null,
                "partitions": {},
                "removable": "0",
                "rotational": "1",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "mq-deadline",
                "sectors": "0",
                "sectorsize": "512",
                "size": "0.00 Bytes",
                "support_discard": "0",
                "vendor": null,
                "virtual": 1
            },
            "nvme0n1": {
                "holders": [],
                "host": "Non-Volatile memory controller: Intel Corporation SSD 660P Series (rev 03)",
                "links": {
                    "ids": [
                        "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B",
                        "nvme-eui.0000000001000000e4d25c1886c45101"
                    ],
                    "labels": [],
                    "masters": [],
                    "uuids": []
                },
                "model": "INTEL SSDPEKNW010T8",
                "partitions": {
                    "nvme0n1p1": {
                        "holders": [],
                        "links": {
                            "ids": [
                                "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part1",
                                "nvme-eui.0000000001000000e4d25c1886c45101-part1"
                            ],
                            "labels": [
                                "SYSTEM"
                            ],
                            "masters": [],
                            "uuids": [
                                "4E4C-AEF5"
                            ]
                        },
                        "sectors": "532480",
                        "sectorsize": 512,
                        "size": "260.00 MB",
                        "start": "2048",
                        "uuid": "4E4C-AEF5"
                    },
                    "nvme0n1p2": {
                        "holders": [],
                        "links": {
                            "ids": [
                                "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part2",
                                "nvme-eui.0000000001000000e4d25c1886c45101-part2"
                            ],
                            "labels": [],
                            "masters": [],
                            "uuids": []
                        },
                        "sectors": "32768",
                        "sectorsize": 512,
                        "size": "16.00 MB",
                        "start": "534528",
                        "uuid": null
                    },
                    "nvme0n1p3": {
                        "holders": [],
                        "links": {
                            "ids": [
                                "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part3",
                                "nvme-eui.0000000001000000e4d25c1886c45101-part3"
                            ],
                            "labels": [
                                "OS"
                            ],
                            "masters": [],
                            "uuids": [
                                "AED04E91D04E5FA7"
                            ]
                        },
                        "sectors": "421563255",
                        "sectorsize": 512,
                        "size": "201.02 GB",
                        "start": "567296",
                        "uuid": "AED04E91D04E5FA7"
                    },
                    "nvme0n1p4": {
                        "holders": [],
                        "links": {
                            "ids": [
                                "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part4",
                                "nvme-eui.0000000001000000e4d25c1886c45101-part4"
                            ],
                            "labels": [
                                "RECOVERY"
                            ],
                            "masters": [],
                            "uuids": [
                                "04A2B988A2B97EAC"
                            ]
                        },
                        "sectors": "2662400",
                        "sectorsize": 512,
                        "size": "1.27 GB",
                        "start": "1961046016",
                        "uuid": "04A2B988A2B97EAC"
                    },
                    "nvme0n1p5": {
                        "holders": [],
                        "links": {
                            "ids": [
                                "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part5",
                                "nvme-eui.0000000001000000e4d25c1886c45101-part5"
                            ],
                            "labels": [
                                "RESTORE"
                            ],
                            "masters": [],
                            "uuids": [
                                "C0CCFFD7CCFFC5A6"
                            ]
                        },
                        "sectors": "36700160",
                        "sectorsize": 512,
                        "size": "17.50 GB",
                        "start": "1963708416",
                        "uuid": "C0CCFFD7CCFFC5A6"
                    },
                    "nvme0n1p6": {
                        "holders": [],
                        "links": {
                            "ids": [
                                "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part6",
                                "nvme-eui.0000000001000000e4d25c1886c45101-part6"
                            ],
                            "labels": [],
                            "masters": [],
                            "uuids": [
                                "78d180fd-5b45-4aef-9304-ac4e6368bb18"
                            ]
                        },
                        "sectors": "38907904",
                        "sectorsize": 512,
                        "size": "18.55 GB",
                        "start": "1922138112",
                        "uuid": "78d180fd-5b45-4aef-9304-ac4e6368bb18"
                    },
                    "nvme0n1p7": {
                        "holders": [],
                        "links": {
                            "ids": [
                                "nvme-INTEL_SSDPEKNW010T8_BTNH95151RLT1P0B-part7",
                                "nvme-eui.0000000001000000e4d25c1886c45101-part7"
                            ],
                            "labels": [],
                            "masters": [],
                            "uuids": [
                                "0c7e5d80-1f7d-4a21-960e-18abb6ccc3a4"
                            ]
                        },
                        "sectors": "1500006400",
                        "sectorsize": 512,
                        "size": "715.26 GB",
                        "start": "422131712",
                        "uuid": "0c7e5d80-1f7d-4a21-960e-18abb6ccc3a4"
                    }
                },
                "removable": "0",
                "rotational": "0",
                "sas_address": null,
                "sas_device_handle": null,
                "scheduler_mode": "none",
                "sectors": "2000409264",
                "sectorsize": "512",
                "size": "953.87 GB",
                "support_discard": "512",
                "vendor": null,
                "virtual": 1
            }
        },
        "ansible_distribution": "Archlinux",
        "ansible_distribution_file_path": "/etc/arch-release",
        "ansible_distribution_file_variety": "Archlinux",
        "ansible_distribution_major_version": "20",
        "ansible_distribution_release": "Mikah",
        "ansible_distribution_version": "20.1.1",
        "ansible_dns": {
            "nameservers": [
                "192.168.0.101",
                "192.168.1.100"
            ]
        },
        "ansible_docker0": {
            "active": true,
            "device": "docker0",
            "id": "8000.0242718abca5",
            "interfaces": [
                "vethff599cd"
            ],
            "ipv4": {
                "address": "172.17.0.1",
                "broadcast": "172.17.255.255",
                "netmask": "255.255.0.0",
                "network": "172.17.0.0"
            },
            "ipv6": [
                {
                    "address": "fe80::42:71ff:fe8a:bca5",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "02:42:71:8a:bc:a5",
            "mtu": 1500,
            "promisc": false,
            "speed": 10000,
            "stp": false,
            "type": "bridge"
        },
        "ansible_domain": "",
        "ansible_effective_group_id": 1000,
        "ansible_effective_user_id": 1000,
        "ansible_enp2s0": {
            "active": false,
            "device": "enp2s0",
            "macaddress": "a8:5e:45:38:28:b4",
            "module": "r8169",
            "mtu": 1500,
            "pciid": "0000:02:00.0",
            "promisc": false,
            "speed": -1,
            "type": "ether"
        },
        "ansible_env": {
            "COLORTERM": "truecolor",
            "DBUS_SESSION_BUS_ADDRESS": "unix:path=/run/user/1000/bus",
            "DESKTOP_SESSION": "xfce",
            "DISPLAY": ":0.0",
            "EDITOR": "/usr/bin/nano",
            "GDMSESSION": "xfce",
            "GOPATH": "/home/user/SoftwareDevelopment/GoStudy",
            "GTK2_RC_FILES": "/home/user/.gtkrc-2.0",
            "GTK_MODULES": "canberra-gtk-module:canberra-gtk-module",
            "HOME": "/home/user",
            "LANG": "C",
            "LC_ADDRESS": "pl_PL.UTF-8",
            "LC_ALL": "C",
            "LC_IDENTIFICATION": "pl_PL.UTF-8",
            "LC_MEASUREMENT": "pl_PL.UTF-8",
            "LC_MONETARY": "pl_PL.UTF-8",
            "LC_NAME": "pl_PL.UTF-8",
            "LC_NUMERIC": "C",
            "LC_PAPER": "pl_PL.UTF-8",
            "LC_TELEPHONE": "pl_PL.UTF-8",
            "LC_TIME": "pl_PL.UTF-8",
            "LOGNAME": "user",
            "LS_COLORS": "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:",
            "MAIL": "/var/spool/mail/user",
            "MOTD_SHOWN": "pam",
            "PATH": "/home/user/SoftwareDevelopment/GoStudy/bin:/home/user/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/var/lib/snapd/snap/bin",
            "PWD": "/home/user",
            "QT_AUTO_SCREEN_SCALE_FACTOR": "0",
            "QT_QPA_PLATFORMTHEME": "qt5ct",
            "SESSION_MANAGER": "local/user-lap:@/tmp/.ICE-unix/1380,unix/user-lap:/tmp/.ICE-unix/1380",
            "SHELL": "/bin/bash",
            "SHLVL": "2",
            "SSH_AGENT_PID": "1433",
            "SSH_AUTH_SOCK": "/tmp/ssh-ZkqlgnzwCpR7/agent.1432",
            "TERM": "xterm-256color",
            "USER": "user",
            "VTE_VERSION": "6200",
            "WINDOWID": "88080395",
            "XAUTHORITY": "/home/user/.Xauthority",
            "XDG_CONFIG_DIRS": "/etc/xdg",
            "XDG_CURRENT_DESKTOP": "XFCE",
            "XDG_DATA_DIRS": "/home/user/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share:/var/lib/snapd/desktop:/usr/share",
            "XDG_GREETER_DATA_DIR": "/var/lib/lightdm-data/user",
            "XDG_MENU_PREFIX": "xfce-",
            "XDG_RUNTIME_DIR": "/run/user/1000",
            "XDG_SEAT": "seat0",
            "XDG_SEAT_PATH": "/org/freedesktop/DisplayManager/Seat0",
            "XDG_SESSION_CLASS": "user",
            "XDG_SESSION_DESKTOP": "xfce",
            "XDG_SESSION_ID": "2",
            "XDG_SESSION_PATH": "/org/freedesktop/DisplayManager/Session0",
            "XDG_SESSION_TYPE": "x11",
            "XDG_VTNR": "7",
            "_": "/usr/bin/python"
        },
        "ansible_fibre_channel_wwn": [],
        "ansible_fips": false,
        "ansible_form_factor": "Notebook",
        "ansible_fqdn": "user-lap",
        "ansible_hostname": "user-lap",
        "ansible_hostnqn": "",
        "ansible_interfaces": [
            "vethff599cd",
            "wlp3s0",
            "lo",
            "enp2s0",
            "docker0"
        ],
        "ansible_is_chroot": false,
        "ansible_iscsi_iqn": "",
        "ansible_kernel": "5.8.11-1-MANJARO",
        "ansible_kernel_version": "#1 SMP PREEMPT Wed Sep 23 14:35:40 UTC 2020",
        "ansible_lo": {
            "active": true,
            "device": "lo",
            "ipv4": {
                "address": "127.0.0.1",
                "broadcast": "",
                "netmask": "255.0.0.0",
                "network": "127.0.0.0"
            },
            "ipv6": [
                {
                    "address": "::1",
                    "prefix": "128",
                    "scope": "host"
                }
            ],
            "mtu": 65536,
            "promisc": false,
            "type": "loopback"
        },
        "ansible_local": {},
        "ansible_lsb": {
            "codename": "Mikah",
            "description": "Manjaro Linux",
            "id": "ManjaroLinux",
            "major_release": "20",
            "release": "20.1.1"
        },
        "ansible_machine": "x86_64",
        "ansible_machine_id": "056a6cd7ddf74c4e98e75c80d8b9cc30",
        "ansible_memfree_mb": 3859,
        "ansible_memory_mb": {
            "nocache": {
                "free": 8958,
                "used": 6466
            },
            "real": {
                "free": 3859,
                "total": 15424,
                "used": 11565
            },
            "swap": {
                "cached": 0,
                "free": 18997,
                "total": 18997,
                "used": 0
            }
        },
        "ansible_memtotal_mb": 15424,
        "ansible_mounts": [
            {
                "block_available": 157840340,
                "block_size": 4096,
                "block_total": 184295396,
                "block_used": 26455056,
                "device": "/dev/nvme0n1p7",
                "fstype": "ext4",
                "inode_available": 46135880,
                "inode_total": 46882816,
                "inode_used": 746936,
                "mount": "/",
                "options": "rw,noatime",
                "size_available": 646514032640,
                "size_total": 754873942016,
                "uuid": "0c7e5d80-1f7d-4a21-960e-18abb6ccc3a4"
            },
            {
                "block_available": 59024,
                "block_size": 4096,
                "block_total": 65536,
                "block_used": 6512,
                "device": "/dev/nvme0n1p1",
                "fstype": "vfat",
                "inode_available": 0,
                "inode_total": 0,
                "inode_used": 0,
                "mount": "/boot/efi",
                "options": "rw,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro",
                "size_available": 241762304,
                "size_total": 268435456,
                "uuid": "4E4C-AEF5"
            }
        ],
        "ansible_nodename": "user-lap",
        "ansible_os_family": "Archlinux",
        "ansible_pkg_mgr": "pacman",
        "ansible_proc_cmdline": {
            "BOOT_IMAGE": "/boot/vmlinuz-5.8-x86_64",
            "apparmor": "1",
            "quiet": true,
            "resume": "UUID=78d180fd-5b45-4aef-9304-ac4e6368bb18",
            "root": "UUID=0c7e5d80-1f7d-4a21-960e-18abb6ccc3a4",
            "rw": true,
            "security": "apparmor",
            "udev.log_priority": "3"
        },
        "ansible_processor": [
            "0",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "1",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "2",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "3",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "4",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "5",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "6",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "7",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "8",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "9",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "10",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "11",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "12",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "13",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "14",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics",
            "15",
            "AuthenticAMD",
            "AMD Ryzen 7 4800H with Radeon Graphics"
        ],
        "ansible_processor_cores": 8,
        "ansible_processor_count": 1,
        "ansible_processor_nproc": 16,
        "ansible_processor_threads_per_core": 2,
        "ansible_processor_vcpus": 16,
        "ansible_product_name": "TUF Gaming FA706IU_FA706IU",
        "ansible_product_serial": "NA",
        "ansible_product_uuid": "NA",
        "ansible_product_version": "1.0",
        "ansible_python": {
            "executable": "/usr/bin/python",
            "has_sslcontext": true,
            "type": "cpython",
            "version": {
                "major": 3,
                "micro": 5,
                "minor": 8,
                "releaselevel": "final",
                "serial": 0
            },
            "version_info": [
                3,
                8,
                5,
                "final",
                0
            ]
        },
        "ansible_python_version": "3.8.5",
        "ansible_real_group_id": 1000,
        "ansible_real_user_id": 1000,
        "ansible_selinux": {
            "status": "Missing selinux Python library"
        },
        "ansible_selinux_python_present": false,
        "ansible_service_mgr": "systemd",
        "ansible_swapfree_mb": 18997,
        "ansible_swaptotal_mb": 18997,
        "ansible_system": "Linux",
        "ansible_system_capabilities": [
            ""
        ],
        "ansible_system_capabilities_enforced": "True",
        "ansible_system_vendor": "ASUSTeK COMPUTER INC.",
        "ansible_uptime_seconds": 26189,
        "ansible_user_dir": "/home/user",
        "ansible_user_gecos": "user",
        "ansible_user_gid": 1000,
        "ansible_user_id": "user",
        "ansible_user_shell": "/bin/bash",
        "ansible_user_uid": 1000,
        "ansible_userspace_architecture": "x86_64",
        "ansible_userspace_bits": "64",
        "ansible_vethff599cd": {
            "active": true,
            "device": "vethff599cd",
            "ipv6": [
                {
                    "address": "fe80::f875:48ff:fef5:fe31",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "fa:75:48:f5:fe:31",
            "mtu": 1500,
            "promisc": true,
            "speed": 10000,
            "type": "ether"
        },
        "ansible_virtualization_role": "host",
        "ansible_virtualization_type": "kvm",
        "ansible_wlp3s0": {
            "active": true,
            "device": "wlp3s0",
            "ipv4": {
                "address": "192.168.1.108",
                "broadcast": "192.168.1.255",
                "netmask": "255.255.255.0",
                "network": "192.168.1.0"
            },
            "ipv6": [
                {
                    "address": "fe80::77bf:672c:a294:41f8",
                    "prefix": "64",
                    "scope": "link"
                }
            ],
            "macaddress": "70:66:55:5b:36:1b",
            "module": "rtw88_8822ce",
            "mtu": 1280,
            "pciid": "0000:03:00.0",
            "promisc": false,
            "type": "ether"
        },
        "gather_subset": [
            "all"
        ],
        "module_setup": true
    },
    "changed": false
}
```