require 'rack-plastic'
require 'etc'

module Rack

  class Serverinfo < Plastic

    DatabaseYamlPath = 'config/database.yml'

    def change_nokogiri_doc(doc)
      return doc if request.xhr?

      badge = doc.create_element 'div', style: badge_style

      badge.add_child(doc.create_element('pre', server_info_text, style: pre_style))

      if db_connection_config.empty?
        badge.add_child(doc.create_element('pre', "DB: database.yml does not exist", style: pre_style))
      else
        db_detail_container = doc.create_element 'details'

        db_detail_container.add_child(doc.create_element('summary', "DB: #{db_connection_config['database']}"))

        db_connection_config.each do |key, value|
          db_detail_container.add_child(doc.create_element('p', "#{key}: #{value}", style: "padding-left: 9.5px;margin: 0;"))
        end

        badge.add_child(db_detail_container)
      end

      append_to_body(doc, badge)

      doc
    end

    private

    def server_info_text
      @server_info_text ||= [
        "Hostname:  #{hostname}",
        "User:      #{user.name}",
        "RAILS_ENV: #{rails_env}",
      ].join("\n")
    end

    def pre_style
      @pre_style ||= <<-pre_style
display: block;
padding: 0 0 0 9.5px;
margin: 0;
font-size: 10px;
line-height: 12px;
word-break: break-all;
word-wrap: break-word;
white-space: pre;
white-space: pre-wrap;
background-color: black;
pre_style
    end

    def badge_style
      @badge_style ||= [
        'position: absolute',
        'bottom: 10px',
        'right: 10px',
        'border: 4px solid red',
        'padding: 5px',
        'border-radius: 5px',
        'background-color: black',
        'opacity: 0.5',
        'color: white',
        'font-size: 10px',
        'font-family: monospace',
      ].join(';')
    end

    def db_name
      @db_name ||= db_connection_config['database']
    end

    def db_connection_config
      @db_connection_config ||= if ::File.file?(DatabaseYamlPath)
        YAML.load_file(DatabaseYamlPath)[rails_env]
      else
        {}
      end
    end

    def user
     @user ||= Etc.getpwuid(Process.uid)
    end

    def rails_env
      @rails_env ||= (ENV['RAILS_ENV'] || 'not set')
    end

    def hostname
      @hostname ||= Socket.gethostname
    end

    def append_to_body(doc, node)
      doc.at_css('body').add_next_sibling(node)
    end

  end

end
