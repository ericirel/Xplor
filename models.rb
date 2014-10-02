class User < ActiveRecord::Base
  has_many :posts
  has_one :account
end

class Post < ActiveRecord::Base
  belongs_to :user
end

class Account < ActiveRecord::Base
  belongs_to :user
end
