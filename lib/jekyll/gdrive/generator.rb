module Jekyll
  module Gdrive
    class Generator < Jekyll::Generator
      def generate(site)
        sheet_name   = site.config['gdrive'] && site.config['gdrive']['sheet']
        cache_period = site.config['gdrive'] && site.config['gdrive']['cache_period']
        credentials  = ENV['GDRIVE'] && ENV['GDRIVE'].split(":")

        raise "No sheet specified for the GDrive Data Plugin\nSet 'gdrive.sheet' in your '_config.yml'" unless sheet_name
        raise "No credentials specified for the GDrive Data Plugin\nSet it in a GRDIVE environment variable\nEg.: export GDRIVE_TOKEN=<client_id>:<client_secret>:<refresh_token>\nRun 'jekyll gdrive' to get an export statement you can cut and past" unless credentials

        data = load_from_cache(cache_period)
        unless data
          sheet = load_from_sheet(sheet_name, credentials)

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

          store_in_cache(data) if cache_period
        end

        site.data['google_sheet'] = data
      end

      def load_from_sheet(sheet_name, credentials)
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
        session.file_by_title(sheet_name).worksheets.first
      end

      def store_in_cache(data)
        File.open("_gdrive_cache", "w") do |file|
          file.write YAML.dump({
            "ts" => Time.now.to_i,
            "data" => data
          })
        end
      end

      def load_from_cache(cache_period)
        cache_seconds = period_to_seconds(cache_period)
        return nil unless cache_seconds
        return nil unless cache_seconds > 0

        cache = YAML.load(File.read("_gdrive_cache")) rescue nil
        return nil unless cache
        return nil if Time.at(cache['ts'].to_i) + period_to_seconds(cache_period) < Time.now

        cache['data']
      end

      def period_to_seconds(period)
        return nil unless period

        _, value, unit = *period.match(/(\d+)\s*(s|second|seconds|m|minute|minutes|h|hour|hours)/)

        return puts "Bad time period for GDrive cache '#{period}'" unless value && unit

        multiplier = case unit
        when "s", "second", "seconds"
          1
        when "m", "minute", "minutes"
          60
        when "h", "hour", "hours"
          60 * 60
        end

        multiplier * value.to_i
      end
    end
  end
end