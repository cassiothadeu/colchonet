class UserSessionsController < ApplicationController
  #cria o filtro que para que a pagina do formulario(new) e o create nao precise estar logado
  before_action :require_no_authentication, only: [:new, :create]
  #cria o filtro para que somente faça o logout quem estiver logado
  before_action :require_authentication, only: :destroy
  
  def new
    @user_session = UserSession.new(session)
  end

  def create
    #Cria o objeto user_session com base na sessão do controller + os parametros do form
    @user_session = UserSession.new(session, params[:user_session])
    if @user_session.authenticate!
      # Não esqueça de adicionar a chave no i18n!
      redirect_to root_path, notice: t('flash.notice.signed_in')
    else
      render :new
    end
  end

  def destroy
    #utiliza o método criado no applicationController
    user_session.destroy
    redirect_to root_path, notice: t('flash.notice.signed_out')
  end
end