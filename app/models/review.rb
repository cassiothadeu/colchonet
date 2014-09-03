class Review < ActiveRecord::Base
  # Criamos um Array de 5 elementos, ao invés de range.
  POINTS = (1..5).to_a
  
  belongs_to :user
  #rails guarda o valor pŕe-calculado do numero de quartos automaticamente
  #em uma coluna do Banco de Dados 
  belongs_to :room, counter_cache: true
  
  #verifica unicidade user_id no scopo de Room
  #O user id pode se repetir se o room_id for diferente
  validates_uniqueness_of :user_id, scope: :room_id
  validates_presence_of :points, :user_id, :room_id
  validates_inclusion_of :points, in: POINTS
  
  #Método para calcular a média das avaliações
  def self.stars
    #Calcula a media das avaliações ou retorna zero
    #Arredondando para inteiro
    (average(:points) || 0).round
  end
    
end
