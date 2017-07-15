class Schedule < ActiveRecord::Base
  # ============================================================================
  # ACSOCIATION
  # ============================================================================   
  belongs_to :restaurant

  belongs_to :restaurant_temp

  # ============================================================================
  # CLASS - ATTRIBUTES
  # ============================================================================   
  attr_accessible :day_of_week, :restaurant_id, :time_closed, :time_open, :restaurant_id, :schedule_type

  # ============================================================================
  # CLASS - SCOPE
  # ============================================================================ 
  scope :is_set, where("time_closed IS NOT NULL and time_open IS NOT NULL")
  scope :is_set_daily, where("schedule_type = 'daily' and time_closed IS NOT NULL and time_open IS NOT NULL")
  scope :is_set_evening, where("schedule_type = 'evening' and time_closed IS NOT NULL and time_open IS NOT NULL")
  scope :is_daily, where("schedule_type = 'daily'")
  scope :is_evening, where("schedule_type = 'evening'")
  default_scope {order('day_of_week ASC')}


  # ============================================================================
  # CLASS - ENUM
  # ============================================================================ 
  TIME_SHEET_DATE = {
    "600" => "6:00 AM",
    "630" => "6:30 AM",
    "700" => "7:00 AM",
    "730" => "7:30 AM",
    "800" => "8:00 AM",
    "830" => "8:30 AM",
    "900" => "9:00 AM",
    "930" => "9:30 AM",
    "1000" => "10:00 AM",
    "1030" => "10:30 AM",
    "1100" => "11:00 AM",
    "1130" => "11:30 AM",
    "1200" => "12:00 PM",
    "1230" => "12:30 PM",
    "1300" => "1:00 PM",
    "1330" => "1:30 PM",
    "1400" => "2:00 PM",
    "1430" => "2:30 PM",
    "1500" => "3:00 PM",
    "1530" => "3:30 PM",
    "1600" => "4:00 PM",
    "1630" => "4:30 PM",
    "1700" => "5:00 PM",
    "1730" => "5:30 PM"
  }
  TIME_SHEET_EVENING = {
    "1700" => "5:00 PM",
    "1730" => "5:30 PM",
    "1800" => "6:00 PM",
    "1830" => "6:30 PM",
    "1900" => "7:00 PM",
    "1930" => "7:30 PM",
    "2000" => "8:00 PM",
    "2030" => "8:30 PM",
    "2100" => "9:00 PM",
    "2130" => "9:30 PM",
    "2200" => "10:00 PM",
    "2230" => "10:30 PM",
    "2300" => "11:00 PM",
    "2330" => "11:30 PM",
    "0" => "12:00 AM",
    "30" => "12:30 AM",
    "100" => "1:00 AM",
    "130" => "1:30 AM",
    "200" => "2:00 AM",
    "230" => "2:30 AM",
    "300" => "3:00 AM",
    "330" => "3:30 AM",
    "400" => "4:00 AM",
    "430" => "4:30 AM",
    "500" => "5:00 AM",
    "530" => "5:30 AM",
    "600" => "6:00 AM",
    "630" => "6:30 AM",
    "700" => "7:00 AM",
    "730" => "7:30 AM",
    "800" => "8:00 AM",
    "830" => "8:30 AM",
    "900" => "9:00 AM",
    "930" => "9:30 AM",
    "1000" => "10:00 AM",
    "1030" => "10:30 AM",
    "1100" => "11:00 AM",
    "1130" => "11:30 AM",
    "1200" => "12:00 PM",
    "1230" => "12:30 PM",
    "1300" => "1:00 PM",
    "1330" => "1:30 PM",
    "1400" => "2:00 PM",
    "1430" => "2:30 PM",
    "1500" => "3:00 PM",
    "1530" => "3:30 PM",
    "1600" => "4:00 PM",
    "1630" => "4:30 PM"

  }
  TIME_SHEET = {
    "1200" => "12:00 PM",
    "1230" => "12:30 PM",
    "1300" => "1:00 PM",
    "1330" => "1:30 PM",
    "1400" => "2:00 PM",
    "1430" => "2:30 PM",
    "1500" => "3:00 PM",
    "1530" => "3:30 PM",
    "1600" => "4:00 PM",
    "1630" => "4:30 PM",
    "1700" => "5:00 PM",
    "1730" => "5:30 PM",
    "1800" => "6:00 PM",
    "1830" => "6:30 PM",
    "1900" => "7:00 PM",
    "1930" => "7:30 PM",
    "2000" => "8:00 PM",
    "2030" => "8:30 PM",
    "2100" => "9:00 PM",
    "2130" => "9:30 PM",
    "2200" => "10:00 PM",
    "2230" => "10:30 PM",
    "2300" => "11:00 PM",
    "2330" => "11:30 PM",
    "0" => "12:00 AM",
    "30" => "12:30 AM",
    "100" => "1:00 AM",
    "130" => "1:30 AM",
    "200" => "2:00 AM",
    "230" => "2:30 AM",
    "300" => "3:00 AM",
    "330" => "3:30 AM",
    "400" => "4:00 AM",
    "430" => "4:30 AM",
    "500" => "5:00 AM",
    "530" => "5:30 AM",
    "600" => "6:00 AM",
    "630" => "6:30 AM",
    "700" => "7:00 AM",
    "730" => "7:30 AM",
    "800" => "8:00 AM",
    "830" => "8:30 AM",
    "900" => "9:00 AM",
    "930" => "9:30 AM",
    "1000" => "10:00 AM",
    "1030" => "10:30 AM",
    "1100" => "11:00 AM",
    "1130" => "11:30 AM"
  }

  CONVERT_TIME = {
    "12:00 AM" =>"0",
    "12:30 AM" =>"30",
    "1:00 AM" => "100",
    "1:30 AM" =>"130",
    "2:00 AM" =>"200",
    "2:30 AM" =>"230",
    "3:00 AM" =>"300",
    "3:30 AM" =>"330",
    "4:00 AM" =>"400",
    "4:30 AM" =>"430",
    "5:00 AM" =>"500",
    "5:30 AM" =>"530",
    "6:00 AM" =>"600",
    "6:30 AM" =>"630",
    "7:00 AM" =>"700",
    "7:30 AM" =>"730",
    "8:00 AM" =>"800",
    "8:30 AM" =>"830",
    "9:00 AM" =>"900",
    "9:30 AM" =>"930",
    "10:00 AM" =>"1000",
    "10:30 AM" =>"1030",
    "11:00 AM" =>"1100",
    "11:30 AM" =>"1130",
    "12:00 PM" =>"1200",
    "12:30 PM" =>"1230",
    "1:00 PM" =>"1300",
    "1:30 PM" =>"1330",
    "2:00 PM" =>"1400",
    "2:30 PM" =>"1430",
    "3:00 PM" =>"1500",
    "3:30 PM" =>"1530",
    "4:00 PM" =>"1600",
    "4:30 PM" =>"1630",
    "5:00 PM" =>"1700",
    "5:30 PM" =>"1730",
    "6:00 PM" =>"1800",
    "6:30 PM" =>"1830",
    "7:00 PM" =>"1900",
    "7:30 PM" =>"1930",
    "8:00 PM" =>"2000",
    "8:30 PM" =>"2030",
    "9:00 PM" =>"2100",
    "9:30 PM" =>"2130",
    "10:00 PM" =>"2200",
    "10:30 PM" =>"2230",
    "11:00 PM" =>"2300",
    "11:30 PM" =>"2330"
  }

  DAY_SHEET = { "1"=>"Mon", "2"=>"Tue", "3"=>"Wed", "4"=>"Thu", "5"=>"Fri", "6"=>"Sat", "7"=>"Sun" }
  CONVERT_DAY = { "Mon"=>1, "Tue"=>2, "Wed"=>3, "Thu"=>4, "Fri"=>5, "Sat" => 6, "Sun" => 7 }
#  validate :close_time_must_after_open_time
  # before_save :close_time_must_after_open_time


  # ============================================================================
  # CLASS - CHECK
  # ============================================================================ 
  def time_is_set?
    (self.time_open != nil && self.time_closed != nil)
  end

  def is_all_days(ids)
    ids.count == 7
  end
  # ============================================================================
  # CLASS - GET
  # ============================================================================ 
  def time_closed
    t = read_attribute(:time_closed)
    t.to_i > 2400 ? (t - 2400).to_s : t.to_s
  end

  def day_formated
    DAY_SHEET[self.day_of_week.to_s]
  end
  
  def time_open_formated
    if TIME_SHEET[self.time_open.to_s]
      TIME_SHEET[self.time_open.to_s].downcase.delete(' ').sub(':00', '')
    else
      ''
    end
  end
  
  def time_closed_formated
    if TIME_SHEET[self.time_closed.to_s]
      TIME_SHEET[self.time_closed.to_s].downcase.delete(' ').sub(':00', '')
    else ''
    end
  end

  def evening_time_formated
    str = "#{self.time_open_formated}-#{self.time_closed_formated}"
    str.remove('-') if self.time_open.blank? || self.time_closed.blank?
    
    str
  end
  
  def close_time_must_after_open_time
    self.time_closed = time_closed.to_i + 2400 if time_closed.to_i < time_open.to_i
  end

  # ============================================================================
  # INSTANCE - ACTION
  # ============================================================================ 
  def self.evening_schedule_by_dow(day_of_week)
    find_by_day_of_week(day_of_week);
  end
  
  
  def self.get_group_time(res_id)
    schedules = Schedule.where("restaurant_id = ? and time_open is not null and time_closed is not null", res_id).order("day_of_week")
    ret = []
    schedules.each do |sdl|
      t_open =  TIME_SHEET["#{sdl.time_open}"]
      t_closed = TIME_SHEET["#{sdl.time_closed}"] 
      ret << "#{t_open} - #{t_closed}"
    end
    ret.uniq
  end

  def self.restaurant_group_open_hours(res_id)
    ret = self.get_group_time(res_id)
    group_hours = []
    if ret.size == 1

      schedules = Schedule.where("restaurant_id = ? and time_open is not null and time_closed is not null", res_id).order("day_of_week")
      v1 = []
      schedules.each do |sdl|      
        t_open =  Schedule::TIME_SHEET["#{sdl.time_open}"]
        t_closed = Schedule::TIME_SHEET["#{sdl.time_closed}"]       
        
        v1 << sdl.day_of_week if "#{t_open} - #{t_closed}" == ret[0].to_s
        
      end
      v1.sort!
      day = v1.first == v1.last ? DAY_SHEET["#{v1.first}"] : [DAY_SHEET["#{v1.first}"], DAY_SHEET["#{v1.last}"]]
      result = [day, ret[0]].join(" - ")
      
      group_hours << result
            
    elsif ret.size == 2
      schedules = Schedule.where("restaurant_id = ? and time_open is not null and time_closed is not null", res_id).order("day_of_week")
      v1 = []
      v2 = []
      schedules.each do |sdl|      
        t_open =  Schedule::TIME_SHEET["#{sdl.time_open}"]
        t_closed = Schedule::TIME_SHEET["#{sdl.time_closed}"]       
        
        v1 << sdl.day_of_week if "#{t_open} - #{t_closed}" == ret[0].to_s
        
        v2 << sdl.day_of_week if "#{t_open} - #{t_closed}" == ret[1].to_s
        
      end
      v1.sort!
      v2.sort!
      group_hours << [DAY_SHEET["#{v1.first}"], DAY_SHEET["#{v1.last}"], ret[0]].join(" - ")
      group_hours << [DAY_SHEET["#{v2.first}"], DAY_SHEET["#{v2.last}"], ret[1]].join(" - ")

    elsif ret.size == 3
      schedules = Schedule.where("restaurant_id = ? and time_open is not null and time_closed is not null", res_id).order("day_of_week")
      v1, v2, v3 = [[]]*3
      schedules.each do |sdl|      
        t_open =  Schedule::TIME_SHEET["#{sdl.time_open}"]
        t_closed = Schedule::TIME_SHEET["#{sdl.time_closed}"]       
        
        v1 << sdl.day_of_week if "#{t_open} - #{t_closed}" == ret[0].to_s
        
        v2 << sdl.day_of_week if "#{t_open} - #{t_closed}" == ret[1].to_s
       
        v3 << sdl.day_of_week if "#{t_open} - #{t_closed}" == ret[2].to_s
        
      end
      v1.sort!
      v2.sort!
      v3.sort!
      group_hours << [DAY_SHEET["#{v1.first}"], DAY_SHEET["#{v1.last}"], ret[0]].join(" - ")
      group_hours << [DAY_SHEET["#{v2.first}"], DAY_SHEET["#{v2.last}"], ret[1]].join(" - ")
      group_hours << [DAY_SHEET["#{v3.first}"], DAY_SHEET["#{v3.last}"], ret[2]].join(" - ")

    else
      schedules = Schedule.where("restaurant_id = ? and time_open is not null and time_closed is not null", res_id).order("day_of_week")
      v1, v2, v3, v4 = [[]]*4
      schedules.each do |sdl|      
        t_open =  Schedule::TIME_SHEET["#{sdl.time_open}"]
        t_closed = Schedule::TIME_SHEET["#{sdl.time_closed}"]       
        
        v1 << sdl.day_of_week if "#{t_open} - #{t_closed}" == ret[0].to_s
        
        v2 << sdl.day_of_week if "#{t_open} - #{t_closed}" == ret[1].to_s
       
        v3 << sdl.day_of_week if "#{t_open} - #{t_closed}" == ret[2].to_s
       
        v4 << sdl.day_of_week if "#{t_open} - #{t_closed}" == ret[3].to_s
        
      end
      v1.sort!
      v2.sort!
      v3.sort!
      v4.sort!
      group_hours << [DAY_SHEET["#{v1.first}"], DAY_SHEET["#{v1.last}"], ret[0]].join(" - ")
      group_hours << [DAY_SHEET["#{v2.first}"], DAY_SHEET["#{v2.last}"], ret[1]].join(" - ")
      group_hours << [DAY_SHEET["#{v3.first}"], DAY_SHEET["#{v3.last}"], ret[2]].join(" - ")
    end
    group_hours
  end
  
  def self.to_dow_time(filter_time="")
    day_of_week = filter_time.split("-")[0]
    day_of_week =  8 if day_of_week.blank?
    time_of_day = filter_time.split("-")[1]
    time_of_day = 2500 if time_of_day.blank?
    [day_of_week, time_of_day]
  end
  
  def self.get_restaunt_ids_for_filter_time(filter_time="")
    day_of_week = filter_time.split("-")[0]
    day_of_week =  8 if day_of_week.blank?
    time_of_day = filter_time.split("-")[1]
    time_of_day =  2500 if time_of_day.blank?
    schedules = Schedule.all(:conditions=>["day_of_week = ? and time_open <= ? and time_closed >= ?", day_of_week, time_of_day, time_of_day ])
    restaurant_ids = []
    schedules.each do |s|
      restaurant_ids <<  s.restaurant_id
    end
    restaurant_ids.uniq
  end

end
