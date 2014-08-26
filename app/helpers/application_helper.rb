module ApplicationHelper
  #Classe que pode ser utlizada para auxiliar a View - ViewHelper
  def error_tag(model, attribute)
    if model.errors.has_key? attribute
      #Helper do Rails para criar a tag DIV com o erro
      content_tag(:div,
        model.errors[attribute].first,
        class: 'error_message'
    )
    end
  end
end
