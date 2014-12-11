module Jekyll
  module Gdrive
    class Generator < Jekyll::Generator
      def generate(site)
        sheet_name = site.config['gdrive'] && site.config['gdrive']['sheet']
        access_token = ENV['GDRIVE_TOKEN']

        raise "No sheet specified for the GDrive Data Plugin\nSet 'gdrive.sheet' in your '_config.yml'" unless sheet_name
        raise "No access token specified for the GDrive Data Plugin\nSet it in a GRDIVE_TOKEN environment variable\nEg.: export GDRIVE_TOKEN=my-long-token\nRun 'jekyll gdrive' to get an access token" unless access_token
        
        session = GoogleDrive.login_with_oauth(access_token)

        sheet = session.file_by_title(sheet_name).worksheets.first

        data = []

        (0..sheet.num_rows).each do |row|
          data[row] = []
          (0..sheet.num_cols).each do |col|
            data[row][col] = sheet[row+1, col+1]
          end
        end

        # remove empty rows
        while data.last.all? {|c| c == "" || c.nil? }
          data.pop
        end

        puts "Site data for google sheet: #{data}"
        site.data['google_sheet'] = data
      end
    end
  end
end