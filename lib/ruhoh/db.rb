require "observer"

class Ruhoh
  
  # Public: Database class for interacting with "data" in Ruhoh.
  #
  class DB
    
    class << self
      include Observable
      attr_reader :site, :routes, :posts, :pages, :layouts, :partials

      # Note this is class-level so you have to call it manually.
      def initialize
        @site       =  ''
        @routes       =  ''
        @posts        =  ''
        @pages        =  ''
        @layouts      =  ''
        @partials     =  ''
        self.update!
      end
      
      def update(name)
        self.instance_variable_set("@#{name}", 
          case name
          when :site
            Ruhoh::Parsers::Site.generate
          when :routes
            Ruhoh::Parsers::Routes.generate
          when :posts
            Ruhoh::Parsers::Posts.generate
          when :pages
            Ruhoh::Parsers::Pages.generate
          when :layouts
            Ruhoh::Parsers::Layouts.generate
          when :partials
            Ruhoh::Parsers::Partials.generate
          else
            raise "Data type: '#{name}' is not a valid data type."
          end
        )
        changed
        notify_observers(name)
      end

      def update!
        self.instance_variables.each { |var|
          self.__send__ :update, var.to_s.gsub('@', '').to_sym
        }
      end
      
    end #self
    
  end #DB
  
end #Ruhoh