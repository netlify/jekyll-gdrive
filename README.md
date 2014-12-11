# Jekyll Gdrive Plugin

Access data from a Google Drvie Spreadsheet in your Jekyll sites

## Installation

Add these lines to your Gemfile:

```ruby
group :jekyll_plugins do
  gem 'jekyll-gdrive'
end
```

And then execute:

    $ bundle install

## Usage

Before you can access any data from GDrive you need to get an access token. After installing the plugin, run:

    $ bundle exec jekyll gdrive

And follow the instructions to create an application in Google's developer console and generate an access token.

Once you have to token, you need to set it up as an environment variable before running `jekyll build`.

    $ export GDRIVE_TOKEN=<your ned gdrive token>

You'll also need to configure the plugin to use the right spreadsheet.

Add this to your `_config.yml`:

```yaml
gdrive:
  sheet: "title of my spreadsheey"
```

## Accessing your Google Sheet data

In any Liquid template you can now use: `site.data.google_sheet` to access your sheet data.

Example:

```html
<table>
    <thead>
      {% for row in site.data.google_sheet limit: 1 %}
        <tr>
          {% for col in row %}<th>{{col}}</th>{% endfor %}
        </tr>
      {% endfor %}
    </thead>
    <tbody>
      {% for row in site.data.google_sheet offset: 1 %}
        <tr>
          {% for col in row %}<td>{{col}}</td>{% endfor %}
        </tr>
      {% endfor %}  
    </tbody>
  </table>
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/jekyll-gdrive/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
