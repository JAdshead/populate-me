require 'populate_me/utils'

module PopulateMe
  class MissingDocumentError < StandardError; end

  module ActiveRecordProxy

    def self.included base

      base.const_set :Proxy, Class.new {

        attr_writer :fields
        attr_accessor :target, :label_field
        

        def initialize active_record_object=nil
          self.target = active_record_object || self.class::Target.new
        end

        def self.[] id
          self.new self::Target.find(id)
        end

        def to_s
          @target.attributes.detect { |k,v| k.to_s != "id"}[1]
        end

        def self.to_s
          self::Target.to_s.gsub(/[A-Z]/, ' \&')[1..-1].gsub('::','')
        end

        def self.to_s_plural; "#{self.to_s}s"; end

        def self.all 
          self::Target.all.map { |obj| self.new obj }
        end

        def new?
          @target.new_record?
        end


        def self.to_admin_list o={}
          {
            template: 'template_list',
            page_title: self.to_s_plural,
            dasherized_class_name: PopulateMe::Utils.dasherize_class_name(self.name),
            # 'sortable'=> self.sortable_on_that_page?(@r),
            # 'command_plus'=> !self.populate_config[:no_plus],
            # 'command_search'=> !self.populate_config[:no_search],
            items: self.all.map {|d| d.to_admin_list_item },
          }
        end

        def to_admin_list_item o={}
          {
            class_name: self.class::Target.name,
            id: @target.id,
            admin_url: to_admin_url,
            title: to_s
          }
        end

        def to_admin_url
          "#{Utils.dasherize_class_name(self.class.name)}/#{@target.id}".sub(/\/$/,'')
        end


        def self.create_fields active_record_object
          active_record_object.reject{|k,v| k == "id"}.as_json
        end

        def self.fields 
          @fields ||= create_fields(self::Target.columns_hash)
        end

        # def field name, attributes={}
        #   if attributes[:type]==:list
        #     define_method(name) do
        #       var = "@#{name}"
        #       instance_variable_set(var, instance_variable_get(var)||[])
        #     end
        #   else
        #     attr_accessor name
        #   end
        #   self.fields[name] = attributes
        # end

        # def label_field
        #   @label_field || self.fields.keys[0]
        # end

        def to_admin_form o={}
          input_name_prefix = o[:input_name_prefix]||'data'
          items = [{
            field_name: :_class,
            type: :hidden,
            wrap: false,
            input_name: "#{input_name_prefix}[_class]",
            input_value: self.class.name,
            input_attributes: {
              type: 'hidden',
              name: "#{input_name_prefix}[_class]",
              value: self.class.name
            }
          }]
          if self.class.respond_to? :fields
            self.class.fields.each do |k,v|
              unless v[:form_field]==false
                settings = v.dup
                settings[:field_name] = k
                settings[:wrap] ||= true
                settings[:wrap] = false if [:hidden,:list].include?(settings[:type])
                settings[:label] ||= PopulateMe::Utils.label_for_field k
                settings[:input_name] = "#{input_name_prefix}[#{k}]"
                if settings[:type]==:list
                  unless settings[:class].nil?
                    settings[:dasherized_class_name] = PopulateMe::Utils.dasherize_class_name(settings[:class].to_s)
                  end
                  settings[:items] = @target.__send__(k).map {|embeded|
                   embeded.to_admin_form(o.merge(input_name_prefix: settings[:input_name]+'[]'))
                  }
                else
                  settings[:input_value] = @target.__send__ k
                  settings[:input_attributes] = {
                    type: 'text', name: settings[:input_name],
                    value: settings[:input_value], required: settings[:required]
                  }.merge(settings[:input_attributes]||{})
                end
                items << settings
              end
            end
          end
          {
            template: "template#{'_embeded' if o[:embeded]}_form",
            page_title: self.new? ? "New #{self.class.name}" : self.to_s,
            admin_url: self.to_admin_url,
            is_new: self.new?,
            fields: items
          }
        end


        def to_h
          persistent_instance_variables.inject({'_class'=>self::Target.name}) do |h,var|
            k = var.to_s[1..-1]
            v = instance_variable_get var
            if v.is_a? Array
              h[k] = v.map(&:to_h)
            else
              h[k] = v
            end
            h
          end
        end
        alias_method :to_hash, :to_h


        def set_from_hash hash, o={}
          raise(TypeError, "#{hash} is not a Hash") unless hash.is_a? Hash
          hash = hash.dup # Leave original untouched
          hash.delete('_class')
          hash.each do |k,v|
            if v.is_a? Array
              __send__(k.to_sym).clear
              v.each do |d|
                obj =  Utils.resolve_class_name(d['_class']).new.set_from_hash(d)
                __send__(k.to_sym) << obj
              end
            else
              v = Utils.automatic_typecast(v) if o[:typecast]
              set k.to_sym => v
            end
          end
          self
        end

        def set attributes
          attributes.dup.each do |k,v| 
            @target.__send__ "#{k}=", v
          end
          self
        end

        def persistent_instance_variables
          @target.instance_variables.select{|k| k !~ /^@_/ }
        end

        def valid?
          @target.valid?
        end


        def save
          @target.save
        end

        def delete
          @target.delete
        end

      }
      base::Proxy.const_set :Target, base
    end
  end
end