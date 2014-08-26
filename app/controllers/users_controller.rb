class UsersController < ApplicationController
  #cria o filtro que para que a pagina de cadastro nao precise estar logado
  before_action :require_no_authentication, only: [:new, :create]
  #utiliza o filtro can_change para verificar se o usuario esta logado e 
  #se é o mesmo que estamos querendo editar, para as ações edit e update
  before_action :can_change, only: [:edit, :update]
  
  #Todas as variaveis de instancia são compartilhadas com o template renderizado pela ação
  #O Rails por padrao busca o template com o nome da Ação exe. new = new.html.erb
  #Ação de Cadastro, cria um novo objeto usuário
  def new
    # Cria um novo objeto Usuario e atribui a variável de instancia @user
    @user = User.new
  end

  #Ação para salvar o usuários no banco de dados com base nos parametros enviados do Formulario
  def create
    # params - retorna um hash com todos os parametros enviados pela requisição
    # mass-assignment - associacao de parametros a variaveis
    @user = User.new(user_params)
    if @user.save
      #Chama a classe mailer para enviar o email de confirmacao
      SignupMailer.confirm_email(@user).deliver
      
      # redirect_to - envia ao browser do usuário um código de resposta
      # “302” que significa “Moved Temporarily”, dizendo ao navegador que ele deve ir para
      # outro endereço
      # irá redirecionar para a ação "show com o id do objeto @user", pois o form_for sabe montar a URL correta
      # irá adicionar a mensagem ao flash com a chave :notice
      redirect_to @user, notice: 'Cadastro criado com sucesso!'
    else
    #A ação create não possui template padrão, por isso é utilizado a ação :new
    #render - não redireciona e não executa a ação por completo somente utiliza o template
      render action: :new
    end
  end

  # Ação para exibir os dados de um Usuário a partir do ID,
  # sendo utilizado no redirect do :new, ou na exibição do registro
  def show
    #Utiliza o id passado na Rota {/user/:id}, {/user/:id.format} para buscar o objeto no BD
    @user = User.find(params[:id])
  end

  # Ação para exibir os dados no formaulario para possibilitar a edição
  def edit
    #Utiliza o id passado na Rota {/user/:id}, {/user/:id.format} para buscar o objeto no BD
    @user = User.find(params[:id])
  end

  # Ação que será utilizada para Atualizar o objeto User no BD
  def update
    @user = User.find(params[:id])
    # Utiliza o método :update que atualiza o objeto através do mass-assignement
    if @user.update(user_params)
      redirect_to @user, notice: 'Cadastro atualizado com sucesso!'
    else
      render action: :edit
    end
  end

  private

  #Proteção com white-list para o mass-assignment
  def user_params
    params.require(:user).permit(:email, :full_name, :location, :password,
    :password_confirmation, :bio)
  end
  
  #método que sera executado no filtro
  def can_change
    unless user_signed_in? && current_user == user
      redirect_to user_path(params[:id])
    end
  end
  
  #método que recupera o usuario com base na sessao caso ele seja nulo
  def user
    @user ||= User.find(params[:id])
  end

end