module Manager
  module ManagerHelper
    def timestamp_to_string(t)
      "%s/%s/%i %s:%s:%s" % [t.day.to_s.rjust(2, "0"), t.month.to_s.rjust(2, "0"), t.year, t.hour.to_s.rjust(2, "0"), t.min.to_s.rjust(2, "0"), t.sec.to_s.rjust(2, "0")]
    end
  end
end
