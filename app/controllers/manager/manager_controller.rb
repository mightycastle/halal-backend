module Manager

  class ManagerController < ApplicationController
    layout 'manager_application'
    helper_method :current_restaurant_id
    helper_method :current_restaurant
    helper_method :get_current_restaurant_reviews

    before_filter :required_user_login
    before_filter :required_restaurant_owner_role
    #before_filter :required_restaurant_select
    before_filter :owns_restaurant

    def pull_data
      restaurant_id = params[:restaurant_id]

      respond_to do |format|
        format.json do
          render json: get_data_series_function(params[:source], restaurant_id, params).to_json
        end
      end
    end

    protected

      def current_restaurant_id
        return params[:restaurant_id]
      end

      def current_restaurant
        @current_restaurant ||= Restaurant.find params[:restaurant_id]
      end

      def get_current_restaurant_reviews
        @current_restaurant_reviews = current_restaurant.reviews.order('created_at DESC')
      end

    private

      # # Make owner choose which restaurant to manage.
      # def required_restaurant_select
      #   if !session.has_key?(:managing_restaurant_id)
      #     session[:managing_restaurant_id] = current_user.restaurants[0].id
      #   end
      # end

      def owns_restaurant
        restaurant_id = params[:restaurant_id]

        if current_user.restaurants.where(id: restaurant_id).length == 0
          redirect_to root_path
        end
      end

      ##### DATA HANDLING ######

      def get_data_series_function(series, restaurant_id, params)
        data_series_functions = {
          "checkins_per_day" => Proc.new do |restaurant_id, args|
            start_date = args[:start_date].to_date
            days = args[:days].to_i
            end_date = start_date + days - 1

            checkins = current_restaurant.checkins.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)

            checkins_per_day = Array.new(days) { 0 }

            checkins.each do |r|
              diff = r.created_at.to_date - start_date
              checkins_per_day[diff.to_i] += 1
            end

            return checkins_per_day
          end,
          "reviews_and_ratings_average_service" => Proc.new do |restaurant_id, args|
            start_date = args[:start_date].to_date
            days = args[:days].to_i
            end_date = start_date + days - 1

            reviews = current_restaurant.reviews.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)

            averages = Array.new(days) { [] }

            reviews.each do |r|
              diff = r.created_at.to_date - start_date
              averages[diff.to_i].push(r.service)
            end

            puts "AAAAAAAAAAAAAAAAAA"
            puts averages.length
            averages.each { |r| puts r }

            for i in 0..(averages.length-1)
              if averages[i].length != 0
                averages[i] = averages[i].sum / averages[i].length.to_f
              else
                averages[i] = -1
              end
            end

            return averages
          end,
          "reviews_and_ratings_average_quality" => Proc.new do |restaurant_id, args|
            start_date = args[:start_date].to_date
            days = args[:days].to_i
            end_date = start_date + days - 1

            reviews = current_restaurant.reviews.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)

            averages = Array.new(days) { [] }

            reviews.each do |r|
              diff = r.created_at.to_date - start_date
              averages[diff.to_i].push(r.quality)
            end

            for i in 0..(averages.length-1)
              if averages[i].length != 0
                averages[i] = averages[i].sum / averages[i].length.to_f
              else
                averages[i] = -1
              end
            end

            return averages
          end,
          "reviews_and_ratings_average_value" => Proc.new do |restaurant_id, args|
            start_date = args[:start_date].to_date
            days = args[:days].to_i
            end_date = start_date + days - 1

            reviews = current_restaurant.reviews.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)

            averages = Array.new(days) { [] }

            reviews.each do |r|
              diff = r.created_at.to_date - start_date
              averages[diff.to_i].push(r.value)
            end

            for i in 0..(averages.length-1)
              if averages[i].length != 0
                averages[i] = averages[i].sum / averages[i].length.to_f
              else
                averages[i] = -1
              end
            end

            return averages
          end,
          "number_of_ratings" => Proc.new do |restaurant_id, args|
            start_date = args[:start_date].to_date
            days = args[:days].to_i
            end_date = start_date + days - 1
            reviews = current_restaurant.reviews.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)

            num_of_ratings = Array.new(0) { [] }

            date = start_date
            c = 0
            while c < days
              num_of_ratings[c] = reviews.where(:created_at => date.beginning_of_day..date.end_of_day).count
              date += 1
              c += 1
            end

            return num_of_ratings
          end,
          "satisfaction_over_time" => Proc.new do |restaurant_id, args|
            start_time = args[:time_range][0].to_date
            end_time = args[:time_range][1].to_date

            reviews = current_restaurant.reviews.where(:created_at => start_time..end_time)

            satisfied_count = reviews.satisfied_ratings.count

            return {
              satisfied: satisfied_count,
              unsatisfied: reviews.count - satisfied_count
            }
          end
        }

        return data_series_functions[series].call(restaurant_id, params)
      end
  end

end


#
#       def get_data_series_function(series, restaurant_id, params)
#         data_series_functions = {
#           "reviews_and_ratings_average_service" => Proc.new do |restaurant_id, args|
#             start_date = args[:start_date].to_date
#             days = args[:days].to_i
#             end_date = start_date + days - 1
#
#             reviews = current_restaurant.reviews.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)
#             ratings = current_restaurant.ratings.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)
#             revs_n_rats = reviews + ratings
#
#             puts revs_n_rats
#
#             averages = Array.new(days) { [] }
#
#             revs_n_rats.each do |r|
#               diff = r.created_at.to_date - start_date
#               puts diff
#               averages[diff.to_i].push(r.service)
#             end
#
#             for i in 0..(averages.length-1)
#               if averages[i].length != 0
#                 averages[i] = averages[i].sum / averages[i].length.to_f
#               else
#                 averages[i] = -1
#               end
#             end
#
#             return averages
#           end,
#           "reviews_and_ratings_average_quality" => Proc.new do |restaurant_id, args|
#             start_date = args[:start_date].to_date
#             days = args[:days].to_i
#             end_date = start_date + days - 1
#
#             reviews = current_restaurant.reviews.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)
#             ratings = current_restaurant.ratings.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)
#             revs_n_rats = reviews + ratings
#
#             puts revs_n_rats
#
#             averages = Array.new(days) { [] }
#
#             revs_n_rats.each do |r|
#               diff = r.created_at.to_date - start_date
#               puts diff
#               averages[diff.to_i].push(r.quality)
#             end
#
#             for i in 0..(averages.length-1)
#               if averages[i].length != 0
#                 averages[i] = averages[i].sum / averages[i].length.to_f
#               else
#                 averages[i] = -1
#               end
#             end
#
#             return averages
#           end,
#           "reviews_and_ratings_average_value" => Proc.new do |restaurant_id, args|
#             start_date = args[:start_date].to_date
#             days = args[:days].to_i
#             end_date = start_date + days - 1
#
#             reviews = current_restaurant.reviews.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)
#             ratings = current_restaurant.ratings.where(:created_at => start_date.beginning_of_day..end_date.end_of_day)
#             revs_n_rats = reviews + ratings
#
#             puts revs_n_rats
#
#             averages = Array.new(days) { [] }
#
#             revs_n_rats.each do |r|
#               diff = r.created_at.to_date - start_date
#               puts diff
#               averages[diff.to_i].push(r.value)
#             end
#
#             for i in 0..(averages.length-1)
#               if averages[i].length != 0
#                 averages[i] = averages[i].sum / averages[i].length.to_f
#               else
#                 averages[i] = -1
#               end
#             end
#
#             return averages
#           end
#         }
#
#         return data_series_functions[series].call(restaurant_id, params)
#       end
#   end
#
# end
