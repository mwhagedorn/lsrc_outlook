#!/usr/local/bin/macruby

require "outlook_calendar"

@ol = OutlookCalendar.new
@ol.save_agenda

`osascript -e 'tell application "Microsoft Outlook" to quit'`






