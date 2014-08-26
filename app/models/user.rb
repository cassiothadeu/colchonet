class User < ActiveRecord::Base
  EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  #configura o relacionamento um p/muitos( objeto deve estar no plural)
  has_many :rooms
  
  #cria o escopo para filtrar usuarios confirmados
  scope :confirmed, -> { where.not(confirmed_at: nil) }
  
  #validações utilizam a Class Macros
  #QUando ocorre erros na validação o rails, popula o atributo errors com as mensagens legiveis
  # Faz a validação de Presença(notNull,empty) dos campos informados
  validates_presence_of :email, :full_name, :location
  # Valida a confirmação do campo senha, se as 2 senhas informadas sao iguais
  # É adicionado um atributo 'VIRTUAL' password_confirmation para validar igualdade entre os atributos
  #validates_confirmation_of :password
  # Valida o tamanho e que ele nao pode ser branco, com espaços vazios
  validates_length_of :bio, minimum: 30, allow_blank: false
  # Valida se nao ja existe email cadastrado
  validates_uniqueness_of :email
  # Realiza a validação customizada utilizando o método abaixo 
  validate :email_format
  
  #Essa class macro já nos dá as valida ções de con�rmação de senha e a presença de senha. 
  #Além disso, ela cria dois novos atributos virtuais, o password e password_confirmation
  # Requer password_digest no banco de dados
  has_secure_password
  
  # chama o callback executado 'Antes de criar' o objeto
  before_create do |user|
    user.confirmation_token = SecureRandom.urlsafe_base64
  end
  
  def confirm!
    #Chama o método para verificar se o usuário ja foi confirmado
    return if confirmed?
    
    self.confirmed_at = Time.current
    self.confirmation_token = ''
    save!
  end

  #verifica se o objeto ja possui a data de confirmação
  def confirmed?
    confirmed_at.present?
  end
  
  #método para fazer o login do usuario
  def self.authenticate(email, password)
    #realiza a busca por usuario e caso encontre
    #faz a autenticacao por senha(has_secure_password)
    # faz a chamada para o escopo da consulta que retorna os 
    #usuario confirmados
    user = confirmed.find_by(email: email)
              .try(:authenticate, password)
  end
  
  private
  # Essa validação pode ser representada da seguinte forma:
  # validates_format_of :email, with: EMAIL_REGEXP
  def email_format
    errors.add(:email, :invalid) unless email.match(EMAIL_REGEXP)
  end
  #OU
  #validate do
    #errors.add(:email, :invalid) unless email.match(EMAIL_REGEXP)
  #end
  
end
