class AddStatusManagementToSurveys < ActiveRecord::Migration[8.0]
  def change
    # Add timestamp columns for tracking survey publication status
    # published_at: when the survey was published (status changed to published)
    # unpublished_at: when the survey was unpublished (status changed to draft)
    add_column :surveys, :published_at, :datetime, null: true
    add_column :surveys, :unpublished_at, :datetime, null: true
  end
end
