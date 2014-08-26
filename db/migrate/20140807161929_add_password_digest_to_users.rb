class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    #Adiciona a coluna password_digest tipo String no modelo user
    add_column :users, :password_digest, :string
  end
end
