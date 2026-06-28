// Tokyo Night (macOS) - desktop & panel layout
// Self-contained: no Panel Colorizer / Material You dependency.
// Panels get their color from the Tokyo Night Plasma theme (stylesheet),
// transparency from the theme's translucent panel-background, and blur from
// the Better Blur DX effect (BlurDocks). The bottom dock uses native floating.

var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [],
            "config": {
                "/": {
                    "ItemGeometries-2048x1280": "",
                    "ItemGeometriesHorizontal": "",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                },
                "/ConfigDialog": {
                    "DialogHeight": "786",
                    "DialogWidth": "810"
                },
                "/Wallpaper/org.kde.image/General": {
                    "DynamicMode": "2",
                    "Image": "file:///usr/share/wallpapers/DarkestHour/",
                    "SlidePaths": "/home/mario/.local/share/wallpapers/,/usr/share/wallpapers/"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        }
    ],
    "panels": [
        {
            "alignment": "center",
            "applets": [
                {
                    "config": {
                        "/": {
                            "popupHeight": "601",
                            "popupWidth": "749"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "favoritesPortedToKAstats": "true",
                            "icon": "fedora-logo-icon",
                            "systemFavorites": "suspend\\,hibernate\\,reboot\\,shutdown"
                        }
                    },
                    "plugin": "org.kde.plasma.kickoff"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.marginsseparator"
                },
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "631",
                            "DialogWidth": "810"
                        }
                    },
                    "plugin": "org.kde.plasma.appmenu"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.panelspacer"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.systemtray"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "566",
                            "popupWidth": "786"
                        }
                    },
                    "plugin": "org.kde.plasma.digitalclock"
                },
                {
                    "config": {},
                    "plugin": "org.kde.plasma.showdesktop"
                },
                {
                    "config": {
                        "/": {
                            "popupHeight": "550",
                            "popupWidth": "770"
                        },
                        "/General": {
                            "history": "#383c51"
                        }
                    },
                    "plugin": "org.kde.plasma.colorpicker"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                }
            },
            "height": 1.5833333333333333,
            "hiding": "normal",
            "lengthMode": "fill",
            "location": "top",
            "maximumLength": 85.33333333333333,
            "minimumLength": 85.33333333333333,
            "offset": 0,
            "opacity": "translucent"
        },
        {
            "alignment": "center",
            "applets": [
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "630",
                            "DialogWidth": "810"
                        },
                        "/General": {
                            "iconSpacing": "3",
                            "launchers": "preferred://filemanager,applications:systemsettings.desktop,applications:org.kde.discover.desktop,applications:org.kde.konsole.desktop,applications:google-chrome.desktop,applications:code.desktop,applications:1password.desktop"
                        }
                    },
                    "plugin": "org.kde.plasma.icontasks"
                }
            ],
            "config": {
                "/": {
                    "formfactor": "2",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                },
                "/General": {
                    "floating": "1"
                }
            },
            "height": 2.9166666666666665,
            "hiding": "normal",
            "lengthMode": "fit",
            "location": "bottom",
            "maximumLength": 85.33333333333333,
            "minimumLength": 85.33333333333333,
            "offset": 0,
            "opacity": "translucent"
        }
    ],
    "serializationFormatVersion": "1"
}
;

plasma.loadSerializedLayout(layout);
