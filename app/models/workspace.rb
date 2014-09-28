class Workspace
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title,       type: String
  field :description, type: String
  field :sequence,    type: Integer, 
                      default: 1000

  belongs_to  :project
  has_many    :updates 

  slug :title, scope: :project, 
               history: true
end
