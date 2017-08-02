class CargaMasiva < ActiveRecord::Base
  belongs_to :efector
  belongs_to :unidad_de_alta_de_datos
  belongs_to :estado_del_proceso
  belongs_to :user

  #belongs_to :attachment

  attr_accessible :numero, :archivo, :fecha_de_proceso,:observaciones
  attr_accessible :archivo_file_name#,:archivo_content_type,:archivo_file_size,:archivo_update_at

  #validates_presence_of :attachment

  has_attached_file :archivo, :url => "/public/paperclip/archivos/:basename.:extension",:path => ":rails_root/public/paperclip/archivos/:basename.:extension"


validates_presence_of :archivo
validates_attachment :archivo,
:content_type => { :content_type => ["text/csv"],:message => "Solo se adminten archivos con formato .csv"},
:size => { :in => 0..15.megabytes, :message => "El archivo no puede ser mayor de 15 megabytes" }


end
