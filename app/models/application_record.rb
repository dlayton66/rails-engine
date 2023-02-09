class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.passed_params(params)
    params.except("controller", "action")
  end
end
