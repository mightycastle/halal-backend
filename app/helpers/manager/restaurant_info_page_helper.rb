module Manager
  module RestaurantInfoPageHelper
    def formatInfo(info)
      if info == nil or info == ""
        info = "(not assigned)"
      end

      return info
    end
  end
end
