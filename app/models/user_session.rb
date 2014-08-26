class UserSession
  #inclui para utlização de callbacks, validações, internacionalização e etc
  include ActiveModel::Model

  #cria os atributos para serem utilizados no formulario
  attr_accessor :email, :password
  #faz as validacoes necessarias
  validates_presence_of :email, :password
  
  #Construtuor que recebe a session do controller e os parametros do form
  def initialize(session, attributes={})
    @session = session
    @email = attributes[:email]
    @password = attributes[:password]
  end
  
  #metodo que realiza a autenticacao do usuário
  def authenticate!
    #Faz a autenticacao com base no usuario e senha(delegando para a classe usuario)
    user = User.authenticate(@email, @password)
    
    if user.present?
      #caso o login esteja correto armazena na sessão
      store(user)
    else
      #ou adiciona uma mensagem de erro para exibir no formulário
      errors.add(:base, :invalid_login)
      false
    end
  end
  
  #método para destruir a sessao do usuario
  def destroy
    @session[:user_id] = nil
  end
  
  #Método responsavel por armazenar na sessao do usuario o ID
  def store(user)
    @session[:user_id] = user.id
  end
  
  #método que recupera o usuario que esteja logado e na sessao
  def current_user
    User.find(@session[:user_id])
  end
  
  #verifica se a sessao do usuário é valida, se o id dele esta na sessao
  def user_signed_in?
    @session[:user_id].present?
  end
end