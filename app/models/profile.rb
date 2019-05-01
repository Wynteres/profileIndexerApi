class Profile < ActiveRecord::Base
    #creates validations for every field for every data manipulation action
    validates :name,
        :presence => {:message => "O nome deve estar preenchido"},
        :format => {:with => /^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$/, :multiline => true, :message => "O nome deve conter apenas letras"},
        :length => { :minimum => 2, :maximum => 255, 
            :too_short => "O nome deve ter pelo menos %{count} caracteres", 
            :too_long => "O nome deve ter no maximo %{count} caracteres" }
    
    validates :twitterUrl, 
        :presence => {:message => "A URL do perfil do twitter deve estar preenchida"},
        :format => { :with => /(?:http(?:s)?:\/\/)?(?:www\.)?twitter\.com\/([a-zA-Z0-9_]+)/, 
            :message => "A URL deve ser uma url válida do twitter" },
            :length => { :maximum => 255, :too_long => "O nome deve ter no maximo %{count} caracteres" }
    
    validates :twitterUsername, 
        :allow_blank => true,
        :length => { :maximum => 15, :too_long => "Seu nome do twitter deve ter no máximo %{count} caracteres" }
            
    validates :twitterDescription, 
        :allow_blank => true,
        :length => { :maximum => 15, :too_long => "Sua descrição do twitter deve ter no máximo %{count} caracteres" }

end
