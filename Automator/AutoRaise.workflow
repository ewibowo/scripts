on run {input, parameters}
    tell application "Finder"
        if exists of application process "AutoRaise.app" then
            quit application "/Applications/AutoRaise.app"
            display notification "AutoRaise Stopped"
        else
            launch application "/Applications/AutoRaise.app"
            display notification "AutoRaise Started"
        end if
    end tell
    return input
end run
