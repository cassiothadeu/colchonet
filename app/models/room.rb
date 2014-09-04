class Room < ActiveRecord::Base
  #Cria o relacionamento que um quarto possui muitas reviews
  #dependend-destroy executa  calback destroy para remover todos objetos
  #Relacionados ao quarto quando ele for removido(CASCADE)
  has_many :reviews, dependent: :destroy
  #cria o relacionamento para que o usuario possa buscar 
  #todos os quartos que possuem avaliações
  has_many :reviewed_rooms, through: :reviews, source: :room
  #Faz o mapeamento para que o quarto pertenca a um usuario(USER)
  #sempre presente do lado que possui a FK
  belongs_to :user
  
  #cria o escopo para listar os quartos pelo mais recente
  scope :most_recent, -> { order('created_at DESC') }
  
  #Estenderemos o modulo da gem Friendly_id
  extend FriendlyId
  
  #Definimos validacoes
  validates_presence_of :title
  validates_presence_of :slug
  #configurar o módulo friendly_id ,
  # para usar as funcionalidades :slugged , que é o modo padrão de operação da gem
  # e a :history , para gravar o histórico de slugs  friendly_id :title, use: [:slugged, :history]
  #Utiliza o Title para ser usado como slug
  friendly_id :title, use: [:slugged, :history]
  
  #Criação do método para a view acessar e exibir o nome completo do quarto
  #a view deve saber o minimo possivel sobre o model
  def complete_name
    "#{title}, #{location}"
  end
  
  #Método de pesquisa para a busca textual
  def self.search(query)
    if query.present?
      where(['location LIKE :query OR
        title LIKE :query OR
        description LIKE :query', query: "%#{query}%"])
    else
      #Retorna o escopo atual
      scoped
    end
  end
end
