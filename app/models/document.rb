class Document < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
end
