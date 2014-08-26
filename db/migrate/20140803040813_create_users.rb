class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.string :password
      t.string :location
      t.text :bio
      
      #Cria indice para a tabela e torna o email uma UK
      t.index :email, unique: true
      
      # Os campos timestamps created_at, updated_at
      # são gerenciados pelo rails
      # created_at atualizado qdo o registro é inserido no BD
      # updated_at atualizado quando o registro é atualizado no BD
      t.timestamps
    end
  end
end
