class AddUserIdToRooms < ActiveRecord::Migration
  #cria uma coluna na tabela de rooms referenciando o id da user(FK)
  def change
    add_reference :rooms, :user, index: true
  end
end
