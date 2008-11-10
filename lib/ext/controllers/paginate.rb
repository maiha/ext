module Ext::Controllers::Paginate
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def ext_paginate(*args)
      options = Options.parse(*args)
      dsl_accessor :ext_paginate_options, :default=>options
      include InstanceMethods
    end
  end


  module InstanceMethods

  public
    def index
      @opts = index_options
      render :inline=>"<%= ext_include %><%= ext_paginate @opts %><%= ext_grid %>"
    end

    def list
      opts = {
        :select => options[:select],
        :offset => [params[:start].to_i-1, 0].max,
        :limit  => [params[:limit].to_i, options[:limit]].max,
        :order  => sorts.blank? ? nil : sorts.map{|i| "%s %s" % [i, params[:dir]]}.join(', '),
      }
      json = {
        "count" => count.to_s,
        "items" => search(opts).map{|item| data(item)},
      }.to_json
      render :text=>json
    end

    def show
      record = options[:model].find(params[:id])
      render :text=>data(record).to_json
    end

    def update
      pkey = options[:model].primary_key
      attributes = CGIMethods.parse_request_parameters(request.cgi.params)
      options[:model].update(params[pkey], attributes)
      render :nothing=>true
    end

  private
    def count
      options[:model].count
    end

    def search(opts)
      options[:model].find(:all, opts)
    end

    def data(record)
      options[:model].columns.each do |column|
        case column.type
        when :datetime, :time, :date
          record[column.name] = record[column.name].to_i unless record[column.name].blank?
        end
      end
      record.attributes
    end

    def options
      self.class.ext_paginate_options
    end

    def sorts
      key = params[:sort].to_s
      key = options[:model].primary_key if key.blank?
      [key]
    end

    def index_options
      options.merge(:class=>options[:model])
    end

    def rescue_action(err)
      return super unless params.has_key?('ext')

      logger.warn err.inspect

      @title = err.class.name
      @body  = "%s<BR>%s" % [err.message, err.application_backtrace.first]

      render :update do |page|
        title = escape_javascript(@title)
        body  = escape_javascript(@body)
        page << "Ext.MessageBox.alert('#{ title }', '#{body}')"
      end
      response.headers['Status'] = 500
    end

  end


  module Options
    module_function
    def parse(*args)
      options = args.optionize(:model, :limit)

      options[:ds_class]   ||= Ext::Data::ActiveStore
      options[:cm_class]   ||= Ext::Grid::ActiveRecord
      options[:grid_class] ||= options[:edit] ? Ext::Grid::EditorGrid : Ext::Grid::Grid

      options[:limit] = [options[:limit].to_i, 10].max
      options[:model] =
        case (model = options[:model])
        when Class then model
        when String, Symbol then model.to_s.classify.constantize
        else raise ArgumentError, "ext_paginate needs a class but got `#{model.class}'"
        end
      options[:select] =
        case (select = options[:select])
        when NilClass then "*"
        when Array    then select.join(', ')
        else select.to_s
        end

      return options
    end
  end

end
