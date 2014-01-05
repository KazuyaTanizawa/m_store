class Book < ActiveRecord::Base
  validates :title,:presence => {:message => "  入力が必須です"}
end
