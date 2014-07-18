# -*- encoding : utf-8 -*-
class DocumentosElectronicosController < ApplicationController

	before_filter :authenticate_user!
  
  def index

    # Valores para los dropdown
    # Verifico si ya hizo el filtro o no
    if params[:efector_id].blank? 
      @efector_id = -1
      @efector = ""
    else
      @efector_id = params[:efector_id]
      @efector = Efector.find(@efector_id)
    end

    if current_user.in_group? [:administradores, :facturacion, :auditoria_medica, :coordinacion, :planificacion, :auditoria_control, :capacitacion]
      @efectores = Efector.order("nombre desc").collect {|c| [c.nombre, c.id]}
      if @efector.present?
        if @efector.es_administrador? 
          @arbol_de_efectores = crear_arbol(@efector, @efector.efectores_administrados.order("nombre desc"), true )
        elsif @efector.es_administrado?
          @arbol_de_efectores = crear_arbol(@efector.administrador_sumar, @efector.administrador_sumar.efectores_administrados.order("nombre desc"), true )
        elsif uad.efector.es_autoadministrado?
          @arbol_de_efectores = crear_arbol(uad.efector, [], true)
        end
      end
    elsif current_user.in_group? [:liquidacion_adm]
      uad = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual])
      @arbol_de_efectores = crear_arbol(uad.efector.administrador_sumar, uad.efector.administrador_sumar.efectores_administrados.order("nombre desc"), true )
    elsif current_user.in_group? [:facturacion_uad] 
      uad = UnidadDeAltaDeDatos.find_by_codigo(session[:codigo_uad_actual])
      if uad.efector.es_administrador? 
        @arbol_de_efectores = crear_arbol(uad.efector, uad.efector.efectores_administrados.order("nombre desc"), true )
      elsif uad.efector.es_autoadministrado?
        @arbol_de_efectores = crear_arbol(uad.efector, [], true)
      elsif uad.efector.es_administrado? 
        @arbol_de_efectores = crear_arbol(uad.efector.administrador_sumar, 
          Efector.where("unidad_de_alta_de_datos_id = '?' OR id = '?'", uad.id, uad.efector.id).order("nombre desc"), 
          false )
      end
    end
  end

  private

  def crear_arbol(efector_raiz, nodos_efectores = [], incluir_documentos_administrador = false)
    
    administrados = []
    documentos = []
    nodo_efectores = []

    nodos_efectores.each do |ea|
      administrados << crear_nodo_efector(ea, true)
    end 

    if administrados.present?
      nodo_efectores << {
            rotulo: "Efectores",
            tipo: "NodoEfectores",
            hijos: administrados,
            imagen: "building-o.png"
          }
    end

    if incluir_documentos_administrador
      administrador = crear_nodo_efector(efector_raiz, true)
    else
      administrador = crear_nodo_efector(efector_raiz, false)
    end

    administrador[:hijos] = administrador[:hijos] + nodo_efectores
    return administrador

  end

  def crear_nodo_efector(efector, incluir_documentos = true)
    
    conceptos = []
    periodos = []
    documentos = []
    imagen = ""

    if incluir_documentos
     
      efector.conceptos_facturados_o_consolidados.each do |concepto|
        efector.periodos_facturados_o_consoliados([concepto.id]).each do |periodo|
          # ---------------------------------------------------------------
          # Iterar para obtener los documentos referentes a este periodo.
          # ---------------------------------------------------------------
          # Consolidado
          # Cuasifacturas - (muchas x periodo y concepto) para un efector
          # Detalle de Cuasifactura - (muchas x periodo y concepto) para un efector

          efector.cuasifacturas_de_un_periodo(periodo).each do |cuasi|
            documentos << {
              rotulo:  "Cuasifactura N° #{cuasi.numero_cuasifactura}",
              tipo:    'Cuasifactura',
              tipo_id: "#{cuasi.id}",
              imagen:  "file-pdf-o.png"
            }

            documentos << {
              rotulo:  "Detalle de Cuasifactura N° #{cuasi.numero_cuasifactura}",
              tipo:    'DetalleDeCuasifactura',
              tipo_id: "#{cuasi.id}",
              imagen:  "file-pdf-o.png"
            }
          end #end cuasifacturas y detalles
          
          efector.consolidado_de_periodo(periodo).each do |consolidado|
                      #raise 'lña'
            documentos << {
              rotulo: "Consolidado N° #{consolidado.numero_de_consolidado}",
              tipo:   'ConsolidadoSumar',
              tipo_id: "#{consolidado.id}",
              imagen: "file-pdf-o.png"
            }
          end

          periodos << {
            rotulo: periodo.periodo,
            tipo:    'Periodo',
            tipo_id: "#{periodo.id}",
            imagen:  "calendar.png",
            hijos:   documentos
          }
          documentos = []
        end #end each periodo

        case concepto.id
        when 1    
          imagen = "stethoscope.png"
        when 2..3 
          imagen = "suero.png"
        when 4..5 
          imagen = "heart-o.png"
        end

        conceptos << {
          rotulo: concepto.concepto,
          tipo: 'Concepto',
          tipo_id: "#{concepto.id}",
          hijos: periodos,
          imagen: imagen
        }
        periodos = []
      end #end each concepto de facturacion
    end # end incluir documentos

    tipo = ""
    if efector.es_administrador?
      tipo = "EfectorAdministrador"
      imagen = "building.png"
    elsif efector.es_administrado?
      tipo = "EfectorAdministrado"
      imagen = "building-o.png"
    else
      tipo = "EfectorAutoadministrado"
      imagen = "building.png"
    end

    nodo_efector = {
      rotulo: efector.nombre,
      tipo: tipo ,
      tipo_id: "#{efector.id}",
      hijos: conceptos,
      imagen: imagen
    }
    return nodo_efector
  end 


end
