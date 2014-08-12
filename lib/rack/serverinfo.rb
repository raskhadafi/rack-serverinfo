require 'rack-plastic'

module Rack

  class Serverinfo < Plastic

    def change_nokogiri_doc(doc)
      h1          = create_node(doc, "div", "Hostname: #{hostname}")
      h1['style'] = style

      append_to_body(doc, h1)

      doc
    end

    private

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
      ].join
    end

    def hostname
      @hostname ||= Socket.gethostname
    end

    def append_to_body(doc, node)
      doc.at_css('body').add_next_sibling(node)
    end

  end

end
