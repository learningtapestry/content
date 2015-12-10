class CreateReviewStatuses < ActiveRecord::Migration
  def change
    create_table :review_statuses do |t|
      t.string :value, null: false, index: true
      t.string :description
    end

    add_reference :grades, :review_status, foreign_key: true, index: true, null: false
    add_reference :identities, :review_status, foreign_key: true, index: true, null: false
    add_reference :languages, :review_status, foreign_key: true, index: true, null: false
    add_reference :resource_types, :review_status, foreign_key: true, index: true, null: false
    add_reference :standards, :review_status, foreign_key: true, index: true, null: false
    add_reference :subjects, :review_status, foreign_key: true, index: true, null: false
  end
end
