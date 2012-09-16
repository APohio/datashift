# Copyright:: (c) Autotelik Media Ltd 2011
# Author ::   Tom Statter
# Date ::     Jan 2011
# License::   MIT. Free, Open Source.
#
require 'loader_base'
require 'paperclip/attachment_loader'

module DataShift


  module SpreeHelper
     
    # TODO - extract this out of SpreeHelper to create  a general paperclip loader
    class ImageLoader < LoaderBase

#      include DataShift::SpreeImageLoading
      include DataShift::CsvLoading
      include DataShift::ExcelLoading
      
      def initialize(image = nil, options = {})
        
        opts = options.merge(:load => false)  # Don't need operators and no table Spree::Image

        super( SpreeHelper::get_spree_class('Image'), image, opts )
        
        if(SpreeHelper::version.to_f > 1.0 )
          @attachment_klazz  = DataShift::SpreeHelper::get_spree_class('Variant' )
        else
          @attachment_klazz  = DataShift::SpreeHelper::get_spree_class('Product' )
        end
        
        puts "Attachment Class is #{@attachment_klazz}" if(@verbose)
          
        raise "Failed to create Image for loading" unless @load_object
      end
      
      def process()

        if(current_value && @current_method_detail.operator?('attachment') )
          
          # assign the image file data as an attachment
          @load_object.attachment = get_file(current_value)
          
          puts "Image attachment created : #{@load_object.inspect}"
              
        elsif(current_value && @current_method_detail.operator )    
          
          # find the db record to assign our Image to
          add_record( get_record_by(@attachment_klazz, @current_method_detail.operator, current_value) )
                
        end
          
      end
    
      def add_record(record)
        if(record)
          if(SpreeHelper::version.to_f > 1 )
            @load_object.viewable = record
          else
            @load_object.viewable = record.product   # SKU stored on Variant but we want it's master Product
          end
          @load_object.save
          puts "Image viewable set : #{record.inspect}"
          
        else
          puts "WARNING - Cannot set viewable - No matching record supplied"
          logger.error"Failed to find a matching record"
        end
      end
    end
          
  end
end