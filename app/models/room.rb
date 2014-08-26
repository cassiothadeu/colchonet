class Room < ActiveRecord::Base
  #Faz o mapeamento para que o quarto pertenca a um usuario(USER)
  #sempre presente do lado que possui a FK
  belongs_to :user
  
  #cria o escopo para listar os quartos pelo mais recente
  scope :most_recent, -> { order('created_at DESC') }
  
  #Criação do método para a view acessar e exibir o nome completo do quarto
  #a view deve saber o minimo possivel sobre o model
  def complete_name
    "#{title}, #{location}"
  end
end
