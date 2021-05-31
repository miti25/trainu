class AddOrderNumberToHowtos < ActiveRecord::Migration[5.2]
  def up
    add_column :howtos, :order_num, :integer
  end

  def down
    remove_column :howtos, :order_num, :integer
  end
end
