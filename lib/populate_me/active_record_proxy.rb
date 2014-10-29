require 'populate_me/utils'


module PopulateMe
  class MissingDocumentError < StandardError; end

  module ActiveRecordProxy

    def self.included base

      base.const_set :Proxy, Class.new {

        def initialize(*args)
           @target = self::Target.new(*args)
        end

        def self.[] id
          self::Target.find(id)
        end

        def to_s
          @target.to_s
        end

        def to_s_plural; "#{@target.to_s}s"; end

        def self.all 
          self::Target.all
        end

        
      }

      base::Proxy.const_set :Target, base

      def to_admin_list_item o={}
        {
          class_name: self::Target.name,
          id: self.id,
          admin_url: to_admin_url,
          title: to_s
        }
      end

      def to_admin_url
        "#{Utils.dasherize_class_name(self::Target.class.name)}/#{id}".sub(/\/$/,'')
      end
    end
  end
end