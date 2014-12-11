module Jekyll
  module Commands
    class Gdrive < Jekyll::Command
      class << self
        def init_with_program(prog)
          prog.command(:gdrive) do |c|
            c.syntax "gdrive"
            c.description "Create a new Google Drive Access Token"

            c.action do |args, options|
              generate_access_token
            end
          end
        end

        def generate_access_token
          require "highline/import"

          puts "To use data from Google drive:"
          puts "Create a new project with Google's Developer Platform:"
          puts "https://console.developers.google.com/project"
          puts
          puts "Go to the project, select APIs & Auth > Credentials from left menu"
          puts "Create new OAuth Client ID"
          puts "Pick 'Installed Application' and fill out information"

          client = Google::APIClient.new(:application_name => "Jekyll GDrive", :application_version => Jekyll::Gdrive::VERSION)
          auth = client.authorization
          auth.client_id = ask "Enter your Google Drive API Client ID: "
          auth.client_secret = ask "Enter your Google Drive API Client Secret: "
          auth.scope = 
              "https://www.googleapis.com/auth/drive " +
              "https://docs.google.com/feeds/ " +
              "https://docs.googleusercontent.com/ " +
              "https://spreadsheets.google.com/feeds/"
          
          auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"

          unless system("open '#{auth.authorization_uri}'")
            puts "Open this page in your browser:"
            puts auth.authorization_uri
            puts 
          end
          auth.code = ask "Enter he authorization code shown in the page: "
          auth.fetch_access_token!
          access_token = auth.access_token

          puts 
          puts "You now have a Google Drive Access token:"
          puts
          puts access_token
          puts
          puts "Remember, this token gives access to all the files in your drive"
          puts "So keep it safe"
          puts "To use with the Jekyll GDrive plugin:"
          puts "Set a GDRIVE_TOKEN environment variable"
          puts 
          puts "export GDRIVE_TOKEN=#{access_token}"
        end
      end
    end
  end
end

