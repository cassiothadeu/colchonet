class ApplicationController < ActionController::Base
  #cria metodos na classe(current_user,user_signetd_id?) que sera delegado
  #a classe UserSession com base nos respectivos métodos
  delegate :current_user, :user_signed_in?, to: :user_session
  #disponibiliza um método do controller no template
  helper_method :current_user, :user_signed_in?
  
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  # Faz com que todos os controllers exijam uma chave de autenticação
  # em ações de alteração de dados (create, update e destroy) de modo a evitar ataques
  # de falsificação de requisição (Request Forgery)
  protect_from_forgery with: :exception
  
  #Calback são executados antes das ações
  
  #Filtros são criados atraves da classe macro 'before_action' para metodos executados antes da acao
  # e after_action para métodos executados depois da acao, ou around_action executados em volta da acao
  #Pega o locale do segmento ou o default definido no application.rb
  before_action do
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  #define o :locale como o default caso nao seja definido ou o idioma definido na url
  def default_url_options
    { locale: I18n.locale }
  end
  
  #Cria uma UserSession com base na sessao do usuario
  def user_session
    UserSession.new(session)
  end
  
  # se o filtro executar uma
  # redireção ou alguma renderização de template (via redirect_to ou render ), a
  # ação e filtros seguintes não serão executados #Redireciona o usuario para a pagina de login caso nao esteja logado
  def require_authentication
    unless user_signed_in?
      redirect_to new_user_sessions_path,
      alert: t('flash.alert.needs_login')
    end
  end
  
  #Redireciona para a pagina principal se o usuario estiver logado
  def require_no_authentication
    if user_signed_in?
      redirect_to root_path,
      notice: t('flash.notice.already_logged_in')
    end
  end
  
end
