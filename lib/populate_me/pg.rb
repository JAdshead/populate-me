require 'populate_me/document'
require 'pg'

module PopulateMe

  module Pg
    include Document 

    def self.included base 
      Document.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      include Document::ClassMethods

      # def [] theid

      # end

      # def all
        
      # end

    end

    attr_accessor :_id

    # def id; @_id; end
    # def id= value; @_id = value; end
  
    # def persistent_instance_variables
    #   if instance_variable_get(:@_id).nil?
    #     super
    #   else
    #     [:@_id]+super
    #   end
    # end

    # def perform_create
    # end

    # def perform_update
    # end

    # def perform_delete
    # end
    
  end
end