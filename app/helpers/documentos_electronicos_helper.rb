# -*- encoding : utf-8 -*-
module DocumentosElectronicosHelper

  def render_arbol(nodo)
    if nodo.is_a? Array
      nodo.each do |n|
        haml_tag "ul" do
          haml_tag "li",{id: "#{n[:id]}", :data => {jstree: '{"icon": "'+ image_path(n[:imagen]) +'"}'} } do
            haml_concat(render_rotulo(n))
            if n[:hijos].present? and n[:hijos].size > 0
              render_arbol(n[:hijos])
            end
          end
        end
      end
    elsif nodo.is_a? Hash
      haml_tag "ul" do
        haml_tag "li",{id: "#{nodo[:id]}", :data => {jstree: '{"icon": "'+ image_path(nodo[:imagen]) +'"}'} } do
          haml_concat(render_rotulo(nodo))
          if nodo[:hijos].present? and nodo[:hijos].size > 0
            render_arbol(nodo[:hijos])
          end
        end
      end
    end
  end

  def render_rotulo(nodo)
    id = nodo[:tipo_id]

    case nodo[:tipo]
    when 'Cuasifactura'
      link_to nodo[:rotulo], liquidacion_sumar_cuasifactura_path(id, format: 'pdf')
    when 'DetalleDeCuasifactura'
      link_to(nodo[:rotulo], detalle_prestaciones_cuasifactura_liquidacion_sumar_cuasifactura_path(id, format: 'pdf'))
    when 'ConsolidadoSumar'
      link_to nodo[:rotulo], consolidado_sumar_path(id, format: 'pdf')
    else
      nodo[:rotulo]
    end
  end

end


