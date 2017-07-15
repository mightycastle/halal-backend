#encoding: utf-8
namespace :db do
  task :phase3 => :environment do
    Rake::Task["db:edit_filter_name_phase3"].invoke
    Rake::Task["db:edit_price_phase3"].invoke
    Rake::Task["db:index_order_filter_phase3"].invoke
    Rake::Task["db:fix_code_phase3"].invoke
    BasicsPage.find_or_create_by_page_name("Footer")
  end
end
