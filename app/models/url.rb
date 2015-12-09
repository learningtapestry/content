class Url < ActiveRecord::Base
  acts_as_tree
  
  has_many :documents

  def self.find_root(url)
    node = find_by(url: url)
    node.root
  end
end
