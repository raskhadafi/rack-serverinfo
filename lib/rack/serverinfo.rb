require 'rack-plastic'
require 'etc'

module Rack

  class Serverinfo < Plastic

    def change_nokogiri_doc(doc)
      badge = doc.create_element 'div', style: style

      server_info_text.each do |info|
        badge.add_child(doc.create_element('p', info, style: 'margin: 0'))
      end

      append_to_body(doc, badge)

      doc
    end

    private

    def server_info_text
      @server_info_text ||= [
        "Hostname: #{hostname}",
        "User: #{user.name}",
        "Rails-Env: #{rails_env}",
      ]
    end

    def style
      @style ||= [
        'position: absolute;',
        'bottom: 10px;',
        'right: 10px;',
        'border: 4px solid red;',
        'padding: 5px;',
        'border-radius: 5px;',
        'background-color: black;',
        'opacity: 0.5;',
        'color: white;',
        'font-size: 10px;',
      ].join
    end

    def user
     @user ||= Etc.getpwuid(Process.uid)
    end

    def rails_env
      @rails_env ||= ENV['RAILS_ENV']
    end

    def hostname
      @hostname ||= Socket.gethostname
    end

    def append_to_body(doc, node)
      doc.at_css('body').add_next_sibling(node)
    end

  end

end
