namespace :pages do
  desc 'Add codes, specified as a comma-separated list via CODES, to a given page, specified via PAGE_ID.'
  task :add_codes_to_page => :environment do
    codes = ENV['CODES'].split(',').collect(&:strip)
    page_id = ENV['PAGE_ID']
    page = Page.find(page_id)
    codes.each do |code_value|
      AddCodeToPage.call(page_id, code_value)
    end
  end
end