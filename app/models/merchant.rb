class Merchant < ActiveRecord::Base

  validates :name,    presence: true, uniqueness: true

  # We're requiring address to be present here since the exericse
  # specifies that it will always be provided.
  # However, from a design standpoint, its possible these objects
  # may be used in other contexts than just importing, so it may
  # become necessary to relax this constraint.
  validates :address, presence: true
end
