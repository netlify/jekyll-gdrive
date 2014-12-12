module Jekyll
  module Gdrive
    class Generator < Jekyll::Generator
      def generate(site)
        sheet_name = site.config['gdrive'] && site.config['gdrive']['sheet']
        credentials = ENV['GDRIVE'] && ENV['GDRIVE'].split(":")

        raise "No sheet specified for the GDrive Data Plugin\nSet 'gdrive.sheet' in your '_config.yml'" unless sheet_name
        raise "No credentials specified for the GDrive Data Plugin\nSet it in a GRDIVE environment variable\nEg.: export GDRIVE_TOKEN=<client_id>:<client_secret>:<refresh_token>\nRun 'jekyll gdrive' to get an export statement you can cut and past" unless credentials

        client = Google::APIClient.new(
          :application_name => "Jekyll GDrive Plugin",
          :application_version => Jekyll::Gdrive::VERSION
        )
        auth = client.authorization
        auth.client_id     = credentials[0]
        auth.client_secret = credentials[1]
        auth.refresh_token = credentials[2]
        auth.fetch_access_token!()

        session = GoogleDrive.login_with_oauth(auth.access_token)

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