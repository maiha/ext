require 'application'

module Ext::Controllers end

ApplicationController.class_eval do
  helper  Ext::Helper
  include Ext::Controllers::Paginate
end
