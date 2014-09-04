class RoomsController < ApplicationController
  #cria o filtro que o usuario esteja logado para as ações do roons controller
  before_action :require_authentication, only: [:new, :edit, :create, :update, :destroy]
  
  #Define o numero de registros por pagina
  PER_PAGE = 2

  def index
    #Recupera o valor da query da requisicao
    @search_query = params[:q]
    #Realiza a busca com base na query
    rooms = Room.search(@search_query)
                .most_recent
                .page(params[:page])
                .per(PER_PAGE)
    # Utiliza o presenter para retornar a lista de Rooms 
    @rooms = RoomCollectionPresenter.new(rooms.most_recent, self)
  end

  def show
    room_model = Room.friendly.find(params[:id])
    #Cria o Presenter com o model recuperado pelo id da request
    @room = RoomPresenter.new(room_model, self)
  end

  def new
    @room = current_user.rooms.build
  end

  def edit
    @room = current_user.rooms.find(params[:id])
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      redirect_to @room, notice: t('flash.notice.room_created')
    else
      render action: "new"
    end
  end

  def update
    #faz a busca do quarto pelo id do quarto para o usuario logado
    @room = current_user.rooms.friendly.find(params[:id])
    if @room.update(room_params)
      redirect_to @room, notice: t('flash.notice.room_updated')
    else
      render action: "edit"
    end
  end

  def destroy
    @room = current_user.rooms.friendly.find(params[:id])
    @room.destroy
    redirect_to rooms_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:title, :location, :description)
    end
end
