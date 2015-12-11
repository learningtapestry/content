class RemoveNullConstraintForStandardFrameworkIdFromStandards < ActiveRecord::Migration
  def change
    change_column_null :standards, :standard_framework_id, true
  end
end
