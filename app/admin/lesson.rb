ActiveAdmin.register Lesson do
  permit_params :name, :duration, :body, :topic_id
  belongs_to :topic
end
