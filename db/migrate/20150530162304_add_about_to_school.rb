class AddAboutToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :about, :text
  end
end
