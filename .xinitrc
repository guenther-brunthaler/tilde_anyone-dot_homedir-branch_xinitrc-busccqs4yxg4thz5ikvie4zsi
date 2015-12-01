#! /bin/sh
# (c) 2013 by Guenther Brunthaler.
# This script is free software.
# Distribution is permitted under the terms of the GPLv3.

# Prepare environment.
set .bash_profile .bash_login .profile .bashrc
test -n "$BASH_VERSION" && test -n "$BASH_ENV" && set "$@" "$BASH_ENV"
test -n "$ENV" && set "$@" "$ENV"
for unnll50vwub2yhksp08ygh9hm
do
	unnll50vwub2yhksp08ygh9hm=$HOME/$unnll50vwub2yhksp08ygh9hm
	if test -f "$unnll50vwub2yhksp08ygh9hm"
	then
		. "$unnll50vwub2yhksp08ygh9hm"
		break
	fi
done
unset unnll50vwub2yhksp08ygh9hm

# Start X clipboard / X selection transfer helper.
if vncconfig -iconic 2> /dev/null &
then
	helper_pid=$!
else
	helper_pid=
fi

# Ensure that the WM or SM instances started for the new VNC server are
# independent from those running at the host. Clear out the environment
# variables WM and SM uses to locate already-running instances, hopefully
# allowing us to start new independent instances.
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# SuSE specific stuff.
OS=`uname -s`
if test x"$OS" = x"Linux"
then
	case $WINDOWMANAGER in
		*gnome*)
			if test -e /etc/SuSE-release && test -d /opt/gnome/bin
			then
				PATH=$PATH:/opt/gnome/bin
				export PATH
			fi
	esac
fi

# Merge preset X resources.
if test -f "$HOME/.Xresources"
then
	xrdb "$HOME/.Xresources"
fi

# Set a gray background as default. Fancy WMs and SMs will replace the
# background with their own wallpapers anyway.
xsetroot -solid grey

# Find the WM or SM to execute. A user-provided XSESSION has the highest
# priority.
if test -n "$XSESSION"
then
	set -- "$XSESSION"
else
	set --
fi
# Add some additional sane choices as fallback.
set -- "$@" icewm fluxbox jwm blackbox mwm twm
CMD=/bin/false
for xs
do
	if
		test x"${xs%/*}" != x"$xs" && test -x "$xs"
	then
		CMD=$xs
		test -n "$XSESSION" && XSESSION=$xs
		break
	fi
	for bindir in /etc/X11/Sessions /usr/bin
	do
		cmd=$bindir/$xs
		if test -x "$cmd"
		then
			CMD=$cmd
			test -n "$XSESSION" && XSESSION=$xs
			break 2
		fi
	done
done
test -n "$XSESSION" && export XSESSION

# Run window manager.
"$CMD" || xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop"

# Stop X11 server.
if test -n "$helper_pid"
then
	kill "$helper_pid"
	sleep 1
fi
exec vncserver -kill "$DISPLAY"