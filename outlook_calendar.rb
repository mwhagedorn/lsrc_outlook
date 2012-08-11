framework 'Foundation'
framework 'ScriptingBridge'

require 'json'
require "s_b_element"
require "hp_object_storage"

class Time
  def beginning_of_day
      Time.mktime(year, month, day).send(gmt? ? :gmt : :localtime)
  end
end

class OutlookCalendar
  attr_accessor :ol
  # To change this template use File | Settings | File Templates.
  def initialize()
    @ol  = SBApplication.applicationWithBundleIdentifier("com.microsoft.Outlook")
    @swift = HPObjectStorage.new
    load_bridge_support_file 'Outlook.bridgesupport'
  end

  def recurring_meetings
    events = []
    @ol.calendars.get.each do |cal|
      events.push(cal.calendarEvents.get.select{|i| i.isRecurring})
    end
    events.flatten
  end

  def beginning_of_workday
      #i.e. 9 am
      Time.new.beginning_of_day()+(60*60*8)
  end


  def next_meeting(current_date=beginning_of_workday)
   outside_date = current_date + 8*60*60 #8 hours from now
   events = []
   ol.calendars.get.last.calendarEvents.get.each do |e|
     if (e.startTime > current_date-300 && e.startTime < outside_date)
      events.push(e)
     end
   end
   events
  end

  def formatted_calendar(current_day=beginning_of_workday)
       events = next_meeting(current_day)
       agenda = {}
       agenda[:day]=beginning_of_workday.strftime("%a %b %e")
       event_list = []
       index = 0
       events.each do |event|
           event_list << {:summary  => event.subject,
                          :location => event.location,
                          :start    => {:dateTime => event.startTime},
                          :end      => {:dateTime => event.endTime},
                          :id       => event.id
                          }
       end
       agenda[:items] = event_list
       agenda.to_json
  end

  def save_agenda
     @swift.update_calendar_file(formatted_calendar)
  end

  def calendar_list
    cals = {}
    cal_array= []
    ol.calendars.get.each do |c|
      cal_array << {:summary => c.name, :id=>c.id} if c.name
    end
    #only the last calendar is valid
    cals[:items]=[cal_array.last]
    cals.to_json
  end

  def save_calendar_list
    @swift.update_calendar_list(calendar_list)
  end


end



@calendar = OutlookCalendar.new

