# A set of models and associations we can use in our specs to test
# basic database columns and also relationships

# See Companion migration spec/db/migrate for latest def

#     create_table :projects do |t|
#       t.string   :title
#       t.string   :value_as_string
#       t.text     :value_as_text
#       t.boolean  :value_as_boolean, :default => false
#       t.datetime :value_as_datetime, :default => nil
#       t.integer  :value_as_integer, :default => 0
#       t.decimal  :value_as_double, :precision => 8, :scale => 2, :default => 0.0
#       t.references :user
#       t.timestamps
#     end

class Project < ActiveRecord::Base

  belongs_to :user

  has_one :owner

  has_many :milestones

  has_many :loader_releases
  has_many :versions, through: :loader_releases

  # has_many :release_versions, :through => :loader_releases, :source => :versions

  has_and_belongs_to_many :categories

  # Rails 4 move to Controller
  # attr_accessible  :value_as_string, :value_as_boolean, :value_as_double

  def multiply
    10 * value_as_double
  end

end

module DataShift
  class AClassInAModule
  end
end