class RoomPresenter
  #Delega para o modelo Room
  delegate :user, :created_at, :description, :location, :title,
    :to_param, :reviews, to: :@room
  def self.model_name
    Room.model_name
  end

  def initialize(room, context, show_form=true)
    @context = context
    @room = room
    @show_form = show_form
  end

  def can_review?
    @context.user_signed_in?
  end

  def show_form?
    @show_form
  end

  def review
    #Cria uma review caso nao exista no banco de dados com base
    #no current_user do contexto seja Controller ou Template
    @review ||= @room.reviews.
    find_or_initialize_by(user_id: @context.current_user.id)
  end

  def review_route
    [@room, review]
  end

  def route
    @room
  end

  def review_points
    Review::POINTS
  end

  #Método que retorna a média de avaliações
  def stars
    @room.reviews.stars
  end

  #método que retorna o total das avaliações
  def total_reviews
    @room.reviews.size
  end

  # Faz com que a partial 'room' seja renderizada quando chamamos o 'render'
  # com o objeto da classe room presenter.
  def to_partial_path
    'room'
  end

  #método que retorna a url da imagem
  def picture_url
    @room.picture_url
  end

  #método que retorna a url do thumbnail
  def thumb_url
    @room.picture.thumb.url
  end
  
  #método que verifica se o quarto possui email
  def has_picture?
    @room.picture?
  end
end