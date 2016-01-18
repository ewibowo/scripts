#!/usr/bin/env sh

####################
# START: New stuff #
####################
# ~/.osx — https://mths.be/osx
##############################

echo "Ask for the administrator password upfront"
sudo -v

echo "Keep-alive: update existing sudo time stamp until tweekosx has finished"
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

#echo "Disable Notification Center and remove the menu bar icon"
#launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

#echo "Fix MacVim black lines at top and bottom of Fullscreen"
#defaults write org.vim.MacVim MMNativeFullScreen 0

#echo "Show remaining battery time; hide percentage"
#defaults write com.apple.menuextra.battery ShowPercent -string "NO"
#defaults write com.apple.menuextra.battery ShowTime -string "YES"

#echo "Disable local Time Machine backups"
#hash tmutil &> /dev/null && sudo tmutil disablelocal

#echo "Display ASCII control characters using caret notation in standard text views"
#echo "Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`"
#defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

echo "Increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

#echo "only use UTF-8 in Terminal.app"
#defaults write com.apple.terminal StringEncodings -array 4

echo "expand save dialog by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

#echo "disable resume system wide"
#defaults write NSGlobalDomainNSQuitAlwaysKeepWindows -bool false

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

echo "Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

#echo "Trackpad: map bottom right corner to right-click"
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
#defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
#defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

#echo "Always show scrollbars"
#defaults write NSGlobalDomain AppleShowScrollBars -string "Auto"

#echo "Disable “natural” (Lion-style) scrolling"
#defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "Increase sound quality for Bluetooth headphones/headsets"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

echo "Enable full keyboard access for all controls"
echo "(e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "Use scroll gesture with the Ctrl (^) modifier key to zoom"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

echo "Follow the keyboard focus while zoomed in"
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

echo "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "Set a shorter Delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 0.5

#echo "Set language and text formats"
#echo "Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with"
#echo "`Inches`, `en_GB` with `en_US`, and `true` with `false`."
#defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
#defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
#defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
#defaults write NSGlobalDomain AppleMetricUnits -bool false

#echo "Set the timezone; see `sudo systemsetup -listtimezones` for other values"
#sudo systemsetup -settimezone "Europe/Brussels" > /dev/null

echo "Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

#echo "Stop iTunes from responding to the keyboard media keys"
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

echo "Enable iTunes track notifications in the Dock"
defaults write com.apple.dock itunes-notifications -bool true

#echo "Disable the Ping sidebar in iTunes"
#defaults write com.apple.iTunes disablePingSidebar -bool true

#echo "Disable all the other Ping stuff in iTunes"
#defaults write com.apple.iTunes disablePing -bool true

#echo "Disable send and reply animations in Mail.app"
#defaults write com.apple.Mail DisableReplyAnimations -bool true
#defaults write com.apple.Mail DisableSendAnimations -bool true

###############################################################################
# Screen                                                                      #
###############################################################################

#echo "Require password immediately after sleep or screen saver begins"
#defaults write com.apple.screensaver askForPassword -int 1
#defaults write com.apple.screensaver askForPasswordDelay -int 0

#echo "Save screenshots to the desktop"
#defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

#echo "Disable shadow in screenshots"
#defaults write com.apple.screencapture disable-shadow -bool true

echo "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo "Enable HiDPI display modes (requires restart)"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

#echo "Disable menu bar transparency"
#defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

###############################################################################
# Finder                                                                      #
###############################################################################

echo "Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons"
defaults write com.apple.finder QuitMenuItem -bool true

#echo "Finder: disable window animations and Get Info animations"
#defaults write com.apple.finder DisableAllAnimations -bool true

#echo "Set Desktop as the default location for new Finder windows"
#echo "For other paths, use `PfLo` and `file:///full/path/here/`"
#defaults write com.apple.finder NewWindowTarget -string "PfDe"
#defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

#echo "Show icons for hard drives, servers, and removable media on the desktop"
#defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
#defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
#defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
#defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "Finder: show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "Finder: show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "Finder: show path bar"
defaults write com.apple.finder ShowPathbar -bool true

#echo "Display full POSIX path as Finder window title"
#defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

echo "Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0

echo "Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

echo "Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

#echo "Show item info near icons on the desktop and in other icon views"
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

#echo "Show item info to the right of the icons on the desktop"
#/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

#echo "Enable snap-to-grid for icons on the desktop and in other icon views"
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

#echo "Increase grid spacing for icons on the desktop and in other icon views"
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

#echo "Increase the size of icons on the desktop and in other icon views"
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

echo "Use list view in all Finder windows by default"
echo "Four-letter codes for the other view modes: icnv, clmv, Flwv"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

#echo "Empty Trash securely by default"
#defaults write com.apple.finder EmptyTrashSecurely -bool true

echo "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "Enable the MacBook Air SuperDrive on any Mac"
sudo nvram boot-args="mbasd=1"

echo "Show the ~/Library folder"
chflags nohidden ~/Library

#echo "Remove Dropbox’s green checkmark icons in Finder"
#file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
#[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

echo "Expand the following File Info panes:"
echo "“General”, “Open with”, and “Sharing & Permissions”"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

echo "Enable highlight hover effect for the grid view of a stack (Dock)"
defaults write com.apple.dock mouse-over-hilite-stack -bool true

#echo "Set the icon size of Dock items to 36 pixels"
#defaults write com.apple.dock tilesize -int 36

echo "Change minimize/maximize window effect"
defaults write com.apple.dock mineffect -string "scale"

echo "Minimize windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true

echo "Enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

echo "Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true

#echo "Wipe all (default) app icons from the Dock"
#echo "This is only really useful when setting up a new Mac, or if you don’t use"
#echo "the Dock to launch apps."
#defaults write com.apple.dock persistent-apps -array

#echo "Don’t animate opening applications from the Dock"
#defaults write com.apple.dock launchanim -bool false

#echo "Remove the auto-hiding Dock delay"
#defaults write com.apple.dock autohide-delay -float 0

#echo "Remove the animation when hiding/showing the Dock"
#defaults write com.apple.dock autohide-time-modifier -float 0

#echo "Automatically hide and show the Dock"
#defaults write com.apple.dock autohide -bool true

#echo "Make Dock icons of hidden applications translucent"
#defaults write com.apple.dock showhidden -bool true

#echo "Enable the 2D Dock"
#defaults write com.apple.dock no-glass -bool true

#echo "Enable the 3D Dock"
#defaults write com.apple.dock no-glass -bool false

#echo "Add a spacer to the left side of the Dock (where the applications are)"
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'

#echo "Add a spacer to the right side of the Dock (where the Trash is)"
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

echo "Add a new stack to the Dock which will display recently used Applications"
defaults write com.apple.dock persistent-others -array-add '{"tile-data" = {"list-type" = 1;}; "tile-type" = "recents-tile";}'

#echo "Add a spacer to the Dock"
#defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'

echo "Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1

#echo "Don’t group windows by application in Mission Control"
#echo "(i.e. use the old Exposé behavior instead)"
#defaults write com.apple.dock expose-group-by-app -bool false

#echo "Disable Dashboard"
#defaults write com.apple.dashboard mcx-disabled -bool true

#echo "Don’t show Dashboard as a Space"
#defaults write com.apple.dock dashboard-in-overlay -bool true

#echo "Don’t automatically rearrange Spaces based on most recent use"
#defaults write com.apple.dock mru-spaces -bool false

#echo "Disable the Launchpad gesture (pinch with thumb and three fingers)"
#defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

echo "Reset Launchpad, but keep the desktop wallpaper intact"
find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

echo "Add iOS Simulator to Launchpad"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/iOS Simulator.app" "/Applications/iOS Simulator.app"

#echo "Hot corners"
#echo "Possible values:"
#echo  "0: no-op"
#echo  "2: Mission Control"
#echo  "3: Show application windows"
#echo  "4: Desktop"
#echo  "5: Start screen saver"
#echo  "6: Disable screen saver"
#echo  "7: Dashboard"
#echo "10: Put display to sleep"
#echo "11: Launchpad"
#echo "12: Notification Center"
#echo "Top left screen corner → Mission Control"
#defaults write com.apple.dock wvous-tl-corner -int 2
#defaults write com.apple.dock wvous-tl-modifier -int 0

#echo "Top right screen corner → Desktop"
#defaults write com.apple.dock wvous-tr-corner -int 4
#defaults write com.apple.dock wvous-tr-modifier -int 0

#echo "Bottom left screen corner → Start screen saver"
#defaults write com.apple.dock wvous-bl-corner -int 5
#defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

echo "Privacy: don’t send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo "Press Tab to highlight each item on a web page"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

echo "Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo "Set Safari’s home page to about:blank for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank"

echo "Prevent Safari from opening ‘safe’ files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

echo "Allow hitting the Backspace key to go to the previous page in history"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

#echo "Hide Safari’s bookmarks bar by default"
#defaults write com.apple.Safari ShowFavoritesBar -bool false

#echo "Hide Safari’s sidebar in Top Sites"
#defaults write com.apple.Safari ShowSidebarInTopSites -bool false

echo "Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

echo "Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

#echo "Disable Safari’s thumbnail cache for History and Top Sites"
#defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

echo "Enable Safari’s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

echo "Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

echo "Remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

echo "Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true


###############################################################################
# Activity Monitor                                                            #
###############################################################################

echo "Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo "Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo "Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

echo "Enable the debug menu in Address Book"
defaults write com.apple.addressbook ABShowDebugMenu -bool true

echo "Enable Dashboard dev mode (allows keeping widgets on the desktop)"
defaults write com.apple.dashboard devmode -bool true

echo "Enable the debug menu in iCal (pre-10.8)"
defaults write com.apple.iCal IncludeDebugMenu -bool true

echo "Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0

echo "Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

echo "Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

###############################################################################
# Mac App Store                                                               #
###############################################################################

echo "Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo "Enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################

echo "Allow installing user scripts via GitHub Gist or Userscripts.org"
defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"
defaults write com.google.Chrome.canary ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

#echo "Disable the all too sensitive backswipe on trackpads"
#defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
#defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

#echo "Disable the all too sensitive backswipe on Magic Mouse"
#defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
#defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

echo "Use the system-native print preview dialog"
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

echo "Expand the print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

###############################################################################
# Opera & Opera Developer                                                     #
###############################################################################

echo "Expand the print dialog by default"
defaults write com.operasoftware.Opera PMPrintingExpandedStateForPrint2 -boolean true
defaults write com.operasoftware.OperaDeveloper PMPrintingExpandedStateForPrint2 -boolean true

###############################################################################
# Transmission, QuickLook, & All Other Apps                                   #
###############################################################################

echo "Use ~/Documents/Torrents to store incomplete downloads"
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"

echo "Don’t prompt for confirmation before downloading"
defaults write org.m0k.transmission DownloadAsk -bool false

echo "Trash original torrent files"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

echo "Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false

echo "Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false

#Fix for the ancient UTF-8 bug in QuickLook (http://mths.be/bbo)
#echo "Commented out, as this is known to cause problems when saving files in Adobe Illustrator CS5 :("
#echo "0x08000100:0" > ~/.CFUserTextEncoding

#echo "Setting Dock back to default"
#defaults delete com.apple.dock

###############################################################################
# Kill affected applications                                                  #
###############################################################################

echo "Killing affected applications"
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
	"Dock" "Finder" "Google Chrome" "Google Chrome Canary" "Mail" "Messages" \
	"Opera" "Safari" "SizeUp" "Spectacle" "SystemUIServer" "Transmission" \
	"Tweetbot" "Twitter" "iCal";
    do killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."

##################
# END: New stuff #
##################
