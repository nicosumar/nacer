class SolicitudesAddendasController < ApplicationController
  include ActionView::Helpers::NumberHelper
  def index
    # Verificar los permisos del usuario
    if cannot? :read, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
    
    @estados_solicitudes = EstadoSolicitudAddenda.all.collect{|p|[p.nombre, p.id]}

    #Determino si el que accede es efector
    if !params[:convenio_de_gestion_sumar_id]
      #Determino si el que accede es efector
      if current_user.in_group?:gestion_addendas_uad and !(current_user.in_group?([:auditoria_medica,:convenios]))
        redirect_to( convenios_de_gestion_sumar_url,
          :flash => { :tipo => :advertencia, :titulo => "No se ha seleccionado un convenio de gestión",
            :mensaje => [ "Para poder realizar altas de solicitudes de adendas, debe hacerlo accediendo antes a la página " +
                "del convenio de gestión que va a modificarse.",
              "Seleccione el convenio de gestión del listado, o realice una búsqueda para encontrarlo."
            ]
          }
        )
        return
      end
      # Obtener el convenio de gestión asociado

      # El que accede no es un efector necesariamente. Veo que adendas peude ver.
      # Obtener el listado de addendas
      estados_ids = []
      #En teoria no se deberian superponer los permisos
      if current_user.in_group?:gestion_addendas_uad
        estados_ids = [EstadosSolicitudAddenda::GENERADA,EstadosSolicitudAddenda::ANULACION_EFECTOR]
      end
      if current_user.in_group?:auditoria_medica  
        estados_ids =estados_ids +  [EstadosSolicitudAddenda::EN_REVISION_TECNICA,EstadosSolicitudAddenda::ANULACION_TECNICA]
      end
  
      if current_user.in_group?:convenios
        estados_ids = estados_ids + [EstadosSolicitudAddenda::EN_REVISION_LEGAL,EstadosSolicitudAddenda::APROBACION_LEGAL]
      end
      
      if !params[:estado_id].nil?
        @filtro_estado = params[:estado_id]
        @solicitudes_addendas =
          SolicitudAddenda.accessible_by(current_ability).where( estado_solicitud_addenda_id: params[:estado_id].to_i).paginate(:page => params[:page], :per_page => 20, :include =>[:estado_solicitud_addenda,{:convenio_de_gestion_sumar => :efector}],
          :order => "updated_at DESC")
          
      else
        
        #Viene sin filtro
        @solicitudes_addendas =
          SolicitudAddenda.accessible_by(current_ability).where("estado_solicitud_addenda_id in #{estados_ids.to_s.gsub('[','(').gsub(']',')')}").paginate(:page => params[:page], :per_page => 20, :include =>[:estado_solicitud_addenda,{:convenio_de_gestion_sumar => :efector}],
          :order => "updated_at DESC"
        )
         
      end
      
    else
      
      begin
        @convenio_de_gestion = ConvenioDeGestionSumar.find(params[:convenio_de_gestion_sumar_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(
          root_url,
          :flash => {:tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre el incidente."
          }
        )
        return
      end
      
      if !params[:estado_id].nil?
        @filtro_estado = params[:estado_id]
        # Obtener el listado de addendas
        @solicitudes_addendas =
          SolicitudAddenda.where("convenio_de_gestion_sumar_id == #{@convenio_de_gestion.id} and estado_solicitud_addenda_id == #{@filtro_estado}" ).paginate(:page => params[:page], :per_page => 20, :include =>[:estado_solicitud_addenda,{:convenio_de_gestion_sumar => :efector}],
          :order => "updated_at DESC"
        )
      else
        # Obtener el listado de addendas
        @solicitudes_addendas =
          SolicitudAddenda.where(convenio_de_gestion_sumar_id:@convenio_de_gestion.id).paginate(:page => params[:page], :per_page => 20, :include =>[:estado_solicitud_addenda,{:convenio_de_gestion_sumar => :efector}],
          :order => "updated_at DESC"
        )
      end
       
    end
    
  end

  def new
    
    # Verificar los permisos del usuario
    if cannot? :create, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
    
    # Para crear addendas, debe accederse desde la página del convenio que se modificará
    if !params[:convenio_de_gestion_sumar_id]
      redirect_to( convenios_de_gestion_sumar_url,
        :flash => { :tipo => :advertencia, :titulo => "No se ha seleccionado un convenio de gestión",
          :mensaje => [ "Para poder realizar altas de solicitudes de adendas, debe hacerlo accediendo antes a la página " +
              "del convenio de gestión que va a modificarse.",
            "Seleccione el convenio de gestión del listado, o realice una búsqueda para encontrarlo."
          ]
        }
      )
      return
    end

    # Obtener el convenio de gestión asociado
    begin
      @convenio_de_gestion = ConvenioDeGestionSumar.find(params[:convenio_de_gestion_sumar_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        root_url,
        :flash => {:tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
   
    
    # Crear los objetos necesarios para la vista
    @solicitud_addenda = SolicitudAddenda.new   
    @prestaciones_principales_autorizadas = PrestacionPrincipalAutorizada.efector_y_fecha(@convenio_de_gestion.efector_id)
    @solicitudes_prestaciones_principales = @prestaciones_principales_autorizadas.collect{ |p|  [  p['id'].to_s  , (p[:prestaciones_principales][0]["Autorizada"] == 't') ? p['id'].to_s : '' ] }
    @solicitudes_prestaciones_principales_aptecnica = []
    @solicitud_addenda.estado_solicitud_addenda = EstadoSolicitudAddenda.find(EstadosSolicitudAddenda::GENERADA);

  end
  
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda
    begin
      @solicitud_addenda = SolicitudAddenda.find( params[:id],
        
        :include => [
          {:solicitudes_addendas_prestaciones_principales => :prestacion_principal},
          :estado_solicitud_addenda,
          {:convenio_de_gestion_sumar => :efector}
        ]
      )
      
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    # Crear los objetos necesarios para la vista
    @convenio_de_gestion = @solicitud_addenda.convenio_de_gestion_sumar
    @efector = @convenio_de_gestion.efector
    @prestaciones_principales_autorizadas = PrestacionPrincipalAutorizada.efector_solicitud_y_fecha(@convenio_de_gestion.efector_id,@solicitud_addenda.id)

    
    @solicitudes_prestaciones_principales = @prestaciones_principales_autorizadas.collect{ |p|  [  p['id'].to_s  , (p[:prestaciones_principales][0]["checkeada_efector"] == 't') ? p['id'].to_s : '' ] }
    @solicitudes_prestaciones_principales_aptecnica =@prestaciones_principales_autorizadas.collect{ |p|  [  p['id'].to_s  , (p[:prestaciones_principales][0]["checkeada_medica"] == 't') ? p['id'].to_s : '' ] }
  
    
    
    
    #    @solicitudes_prestaciones_principales = @solicitud_addenda.solicitudes_addendas_prestaciones_principales.collect{|p| [p.prestacion_principal_id.to_s,( p.es_autorizacion ? p.prestacion_principal_id.to_s : '' )] }
    #   
    #    
    #    @solicitudes_prestaciones_principales_aptecnica = @solicitud_addenda.solicitudes_addendas_prestaciones_principales.collect{|p| [p.prestacion_principal_id.to_s,( p.aprobado_por_medica ? p.prestacion_principal_id.to_s : '' )] }
    #  

  end
  

  def show
    # Verificar los permisos del usuario
    if cannot? :read, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda solicitada
    begin

      @solicitud_addenda =
        SolicitudAddenda.find( params[:id],
        :include => [ {:solicitudes_addendas_prestaciones_principales => :prestacion_principal} , {:convenio_de_gestion_sumar => :efector},:estado_solicitud_addenda]
      )
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
    end
    @convenio_de_gestion =@solicitud_addenda.convenio_de_gestion_sumar
    
    respond_to do |format|
      format.odt do
        report = ODFReport::Report.new("lib/tasks/datos/plantillas/Modelo de solicitud adenda prestacional.odt") do |r|
          r.add_field :cgs_sumar_numero, @convenio_de_gestion.numero
          if @convenio_de_gestion.efector.grupo_de_efectores.tipo_de_efector == "PSB"
            r.add_field :efector_articulo, "la"
            r.add_field :o_a, "a"
          else
            r.add_field :efector_articulo, "el"
            r.add_field :o_a, "o"
          end
          r.add_field :efector_nombre, @convenio_de_gestion.efector.nombre
          referente = @convenio_de_gestion.efector.referente_al_dia(@solicitud_addenda.fecha_solicitud)
          if referente.present?
            if referente.contacto.sexo.present?
              if referente.contacto.sexo.codigo == "F"
                r.add_field :articulo_contacto, "la"
              else
                r.add_field :articulo_contacto, "el"
              end
            end
            r.add_field :contacto_mostrado, referente.contacto.mostrado
            if referente.contacto.tipo_de_documento.present?
              r.add_field :tipo_de_documento_codigo, referente.contacto.tipo_de_documento.codigo
            end
            if !referente.contacto.dni.blank?
              r.add_field :contacto_dni, number_with_delimiter(referente.contacto.dni, {:delimiter => "."})
            end
            if !referente.contacto.firma_primera_linea.blank?
              r.add_field :contacto_firma_primera_linea, referente.contacto.firma_primera_linea.strip
            end
            if !referente.contacto.firma_segunda_linea.blank?
              r.add_field :contacto_firma_segunda_linea, referente.contacto.firma_segunda_linea.strip
            end
            if !referente.contacto.firma_tercera_linea.blank?
              r.add_field :contacto_firma_tercera_linea, referente.contacto.firma_tercera_linea.strip
            end
          end
          if !@convenio_de_gestion.efector.domicilio.blank?
            r.add_field :efector_domicilio, @convenio_de_gestion.efector.domicilio.to_s.strip.gsub(".", ",")
          end
    
          @bajas_de_prestaciones =
              
            @solicitud_addenda.solicitudes_addendas_prestaciones_principales.
            select{|sapp| sapp[:aprobado_por_medica]==false }.map{|pa| {codigo: pa.prestacion_principal.codigo, nombre: pa.prestacion_principal.nombre}  }
    
          
          r.add_table("Bajas", @bajas_de_prestaciones, header: true) do |t|
            t.add_column(:prestacion_codigo, :codigo)
            t.add_column(:prestacion_nombre, :nombre)

          end

          @altas_de_prestaciones = 
            @solicitud_addenda.solicitudes_addendas_prestaciones_principales.
            select{|sapp| sapp[:aprobado_por_medica]==true }.map{|pa| {codigo: pa.prestacion_principal.codigo, nombre: pa.prestacion_principal.nombre} }
    
             
          

          r.add_table("Altas", @altas_de_prestaciones, header: true) do |t|
            t.add_column(:prestacion_codigo, :codigo)
            t.add_column(:prestacion_nombre, :nombre)
          end

          #          r.add_field :suscripcion_mes_y_anio, I18n.l(@solicitud_addenda.fecha_revision_medica, :format => :month_and_year)

        end

        archivo = report.generate("lib/tasks/datos/documentos/Adenda prestacional #{@solicitud_addenda.numero} - #{@convenio_de_gestion.efector.nombre.gsub("/", "_")}.odt")

        File.chmod(0644, "lib/tasks/datos/documentos/Adenda prestacional #{@solicitud_addenda.numero} - #{@convenio_de_gestion.efector.nombre.gsub("/", "_")}.odt")

        send_file(archivo)
      end

      format.html do
      end
    end
    
    
    
    @puede_editar = 
      (
      (EstadosSolicitudAddenda::GENERADA == @solicitud_addenda.estado_solicitud_addenda_id and current_user.in_group?:gestion_addendas_uad) or
        (EstadosSolicitudAddenda::EN_REVISION_TECNICA == @solicitud_addenda.estado_solicitud_addenda_id and current_user.in_group?:auditoria_medica) or
        (EstadosSolicitudAddenda::EN_REVISION_LEGAL == @solicitud_addenda.estado_solicitud_addenda_id and current_user.in_group?:convenios)
    )
    @puede_anular =  (
      (EstadosSolicitudAddenda::GENERADA == @solicitud_addenda.estado_solicitud_addenda_id and current_user.in_group?:gestion_addendas_uad) or
        (EstadosSolicitudAddenda::EN_REVISION_TECNICA == @solicitud_addenda.estado_solicitud_addenda_id and current_user.in_group?:auditoria_medica) 
    )
     
    @puede_confirmar_efector = (@solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::GENERADA and current_user.in_group?:gestion_addendas_uad)
    @puede_confirmar_tecnica = (@solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::EN_REVISION_TECNICA and current_user.in_group?:auditoria_medica)
    @puede_confirmar_legal = (@solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::EN_REVISION_LEGAL and current_user.in_group?:convenios)
    
    @puede_generar_documento = 
      (@solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::EN_REVISION_LEGAL and current_user.in_group?:gestion_addendas_uad )
    @convenio_de_gestion_sumar = @solicitud_addenda.convenio_de_gestion_sumar
   
    
    

  end
  
  
  def create
    # Verificar los permisos del usuario
    if cannot? :create, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:solicitud_addenda] || !params[:solicitud_addenda][:convenio_de_gestion_sumar_id]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    
    #obtengo las prestaciones principales a autorizar o desautorizar...
    @solicitudes_prestaciones_principales = (params[:solicitud_addenda][:prestacion_principal_id])
   
    # Obtener el convenio de gestión asociado
    begin
      @convenio_de_gestion = ConvenioDeGestionSumar.find(params[:solicitud_addenda][:convenio_de_gestion_sumar_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    
    
    
    fecha_actual = Time.now
   
    @solicitud_addenda = SolicitudAddenda.new()
        
    unless @solicitud_addenda.validar_existencia_de_solicitud_addenda_previa (@convenio_de_gestion.id)
      redirect_to(solicitudes_addendas_path(:convenio_de_gestion_sumar_id => @convenio_de_gestion.id),
        :flash => { :tipo => :advertencia, :titulo => "No es posible registrar la solicitud de adenda",
          :mensaje => [ "Para poder realizar altas de solicitudes de adendas, debe hacerlo sin tener otras solicitudes " +
              "en curso."
          ]
        }
      )
      return    
    end
    
    @solicitud_addenda.convenio_de_gestion_sumar = @convenio_de_gestion
    @solicitud_addenda.numero_addenda = @convenio_de_gestion.generar_numero_addenda_sumar_solicitud_addenda
    @solicitud_addenda.firmante = @convenio_de_gestion.obtener_nombre_firmante
    @solicitud_addenda.fecha_solicitud = fecha_actual
    @solicitud_addenda.observaciones = params[:solicitud_addenda][:observaciones]
    @solicitud_addenda.estado_solicitud_addenda = EstadoSolicitudAddenda.find(EstadosSolicitudAddenda::GENERADA); #Estado Registrada
    @solicitud_addenda.user_creator_id = current_user.id
   
    numero =
      ActiveRecord::Base.connection.exec_query(
    
      " SELECT 
  
     COALESCE (

	     max( 
		cast(
			replace ( sa.numero,'#{@convenio_de_gestion.numero}' || '-SA-','') as int 
		) + 1
	     ) , 1 
     )
     
     from solicitudes_addendas sa
     
     where sa.numero like '%#{@convenio_de_gestion.numero}%'"
    ).rows[0].collect{ |v| v.to_i}
    
    
    
    @solicitud_addenda.numero =  @convenio_de_gestion.numero+ '-SA-' +  numero[0].to_s
    #  @solicitud_addenda.numero = @solicitud_addenda.numero_addenda
    
    
    @prestaciones_principales_autorizadas = PrestacionPrincipalAutorizada.efector_y_fecha(@convenio_de_gestion.efector_id)
    
    #if  @solicitud_addenda.save     
    @solicitudes_prestaciones_principales.each do |pres|  
      #pres[0] es la key
      #pres[1] es el value
      #tambien podria ocupar |key,value|
        
      
      if( @prestaciones_principales_autorizadas.any?{|p| p["id"].to_s == pres[0] and 
              ( 
              (p[:prestaciones_principales][0]["Autorizada"] == 't' and !pres[1].blank?) or
                (p[:prestaciones_principales][0]["Autorizada"] == 'f' and pres[1].blank?)
            )   
          
          })
        #Ya esta autorizada y ademas el check realizado es igual a la condicion actual....No hago nada
          
      else
         
        @solicitud_addenda_prestacion_principal =  SolicitudAddendaPrestacionPrincipal.new do |sapp|
          sapp.es_autorizacion = pres[1].length  > 0 
          sapp.prestacion_principal_id =  pres[0].to_i
          # sapp.solicitud_addenda = @solicitud_addenda
          @solicitud_addenda.solicitudes_addendas_prestaciones_principales << sapp
          # sapp.save
        end
      
        
      end
        
     
      
    end
    
    #Valido que al menos se realize una modificacion para que la solicitud de adenda tenga sentido.
    if @solicitud_addenda.solicitudes_addendas_prestaciones_principales.empty?
      #No hay modificaciones 
     
      redirect_to(new_solicitud_addenda_path(:convenio_de_gestion_sumar_id => @convenio_de_gestion.id),
        :flash => { :tipo => :advertencia, :titulo => "La solicitud de adenda debe incluir al menos una alta/baja de prestación." ,
          :mensaje => [ "Para poder realizar solicitudes de adendas, debe hacerlo tildando o destildando al menos una prestacion respecto de la condicion actual " +
              "de prestaciones autorizadas del plan de salud"
          ]
          
        }
         
      )
      return
    end
    
    @solicitud_addenda.save
    
    redirect_to(@solicitud_addenda,
      :flash => { :tipo => :ok, :titulo => "La solicitud de adenda #{@solicitud_addenda.numero} se creó correctamente." }
    
         
    )
  

  end
  
  
  def update
    # Verificar los permisos del usuario
    if cannot? :update, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar si la petición contiene los parámetros esperados
    if !params[:solicitud_addenda]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener la solicitud que se actualizará y su convenio de gestión
    begin
      @solicitud_addenda = 
        SolicitudAddenda.find(params[:id], :include => [
          :solicitudes_addendas_prestaciones_principales,
          {:convenio_de_gestion_sumar => :efector}
        ])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end
    
    @convenio_de_gestion = @solicitud_addenda.convenio_de_gestion_sumar
    
    # Actualizar los valores 
    @solicitud_addenda.observaciones = params[:solicitud_addenda][:observaciones]

    
    if @solicitud_addenda.estado_solicitud_addenda_id ==  EstadosSolicitudAddenda::EN_REVISION_LEGAL
      
      @solicitud_addenda.firmante = params[:solicitud_addenda][:firmante]
      @solicitud_addenda.fecha_de_inicio =  parametro_fecha(params[:solicitud_addenda], :fecha_de_inicio)
      @solicitud_addenda.fecha_de_suscripcion =  parametro_fecha(params[:solicitud_addenda], :fecha_de_suscripcion)
 
      
    end

  
    
    @prestaciones_principales_autorizadas = PrestacionPrincipalAutorizada.efector_y_fecha(@convenio_de_gestion.efector_id)
    @detalles_prestaciones_principales_eliminados = []
    
    # solo manejo los estados de la aprobacion tecnica si la solicitud en revision tecnica o enviada al efector
    if (@solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::EN_REVISION_TECNICA    )
      @solicitudes_prestaciones_principales_aptecnica = params[:solicitud_addenda][:prestacion_principal_tecnica_id]
      #
      #Actualizo los atributos de la aprobacion medica
      @solicitudes_prestaciones_principales_aptecnica.each do |presat|  
       
        #me fijo si no existe el detalle sino lo creo. 
        if( @prestaciones_principales_autorizadas.any?{|p| p["id"].to_s == presat[0] and 
                ( 
                (p[:prestaciones_principales][0]["Autorizada"] == 't' and !presat[1].blank?) or
                  (p[:prestaciones_principales][0]["Autorizada"] == 'f' and presat[1].blank?)
              )   
          
            })
          
             
          @detail = @solicitud_addenda.solicitudes_addendas_prestaciones_principales.select{|p| p.prestacion_principal_id.to_s == presat[0]}
        
          unless @detail.empty?
            @solicitud_addenda.solicitudes_addendas_prestaciones_principales.delete_if{|p| p.prestacion_principal_id.to_s == pres[0]}
            @detalles_prestaciones_principales_eliminados << @detail[0]
          end
        else
          existe = false
          @solicitud_addenda.solicitudes_addendas_prestaciones_principales.each  do |sapp| 
            if sapp.prestacion_principal_id.to_s == presat[0]
              existe = true           
              sapp.aprobado_por_medica = presat[1].length  > 0             
              break
            end
          end
          unless existe
            @solicitud_addenda_prestacion_principal =  SolicitudAddendaPrestacionPrincipal.new do |sapp|  
              sapp.es_autorizacion = presat[1].length  > 0 
              sapp.aprobado_por_medica = presat[1].length  > 0   
              sapp.prestacion_principal_id =  presat[0].to_i
              @solicitud_addenda.solicitudes_addendas_prestaciones_principales << sapp
            end
          end
        end
        
        
        
        
        
      end
    end
     
    
    if (@solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::GENERADA    )
      #Actualizo los atributos de la es_autorizacion de la solicitud
      @solicitudes_prestaciones_principales = params[:solicitud_addenda][:prestacion_principal_id]
      @solicitudes_prestaciones_principales.each do |pres|  
        
        
        if( @prestaciones_principales_autorizadas.any?{|p| p["id"].to_s == pres[0] and 
                ( 
                (p[:prestaciones_principales][0]["Autorizada"] == 't' and !pres[1].blank?) or
                  (p[:prestaciones_principales][0]["Autorizada"] == 'f' and pres[1].blank?)
              )   
          
            })
       
          #-->No hay que tratarla. 
          ##-->Pero ademas si esta la elimino.
        
          @detail = @solicitud_addenda.solicitudes_addendas_prestaciones_principales.select{|p| p.prestacion_principal_id.to_s == pres[0]}
        
          unless @detail.empty?
            @solicitud_addenda.solicitudes_addendas_prestaciones_principales.delete_if{|p| p.prestacion_principal_id.to_s == pres[0]}
            @detalles_prestaciones_principales_eliminados << @detail[0]
          end
            
          
        else
          
          #-->SI hay que tratarla. 
          existe = false
          @solicitud_addenda.solicitudes_addendas_prestaciones_principales.each  do |sapp| 
            if sapp.prestacion_principal_id.to_s == pres[0]
              existe = true
              sapp.es_autorizacion = pres[1].length  > 0        
              break
            end
          end
          unless existe
            @solicitud_addenda_prestacion_principal =  SolicitudAddendaPrestacionPrincipal.new do |sapp|
              sapp.es_autorizacion = pres[1].length  > 0 
              sapp.prestacion_principal_id =  pres[0].to_i

              @solicitud_addenda.solicitudes_addendas_prestaciones_principales << sapp
              
            end
          end
        end
      end
    end
    
    #Valido que al menos se realize una modificacion para que la solicitud de adenda tenga sentido.
    if @solicitud_addenda.solicitudes_addendas_prestaciones_principales.empty?

      #No hay modificaciones 
     
      redirect_to(edit_solicitud_addenda_path(@solicitud_addenda),
        :flash => { :tipo => :advertencia, :titulo => "La solicitud de adenda debe incluir al menos una alta/baja de prestación." ,
          :mensaje => [ "Para poder realizar solicitudes de adendas, debe hacerlo tildando o destildando al menos una prestacion respecto de la condicion actual " +
              "de prestaciones autorizadas del plan de salud"
          ]
          
        }
         
      )
      return
    end
    #  
    
    if  @solicitud_addenda.save
      # Redirigir a la adenda modificada
      @detalles_prestaciones_principales_eliminados.each{|p| p.destroy}
      redirect_to(@solicitud_addenda,
        :flash => { :tipo => :ok, :titulo => 'Las modificaciones a la solicitud de adenda se guardaron correctamente.' }
      )
    end

  end
    
  def aprobacion_tecnica
    # Verificar los permisos del usuario
    # 
    if cannot? :update, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
 
    # Obtener la adenda solicitada
    begin

      @solicitud_addenda =
        SolicitudAddenda.find( params[:id], :include => :estado_solicitud_addenda)
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente.",
        }
      )
      return
    end
     

    #valido el cambio de estado 
    if @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::EN_REVISION_TECNICA or @solicitud_addenda.estado_solicitud_addenda_id  == EstadosSolicitudAddenda::EN_REVISION_LEGAL #Este ultimo lo dejo por el doble post de Firefox
      
      @solicitud_addenda.estado_solicitud_addenda_id  = EstadosSolicitudAddenda::EN_REVISION_LEGAL
      
      @solicitud_addenda.fecha_revision_medica = Time.now
      @solicitud_addenda.user_tecnica_id = current_user.id
      if  @solicitud_addenda.save
        notificar_efector
        redirect_to(@solicitud_addenda,
          :flash => { :tipo => :ok, :titulo => 'Las modificaciones a la solicitud de adenda se guardaron correctamente.' }
        )
       
      else
        redirect_to(@solicitud_addenda,
          :flash => { :tipo => :error, :titulo => 'Ocurrio un error al modificar la solicitud de adenda.' })
      end
   
      
    else 
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda es incorrecta",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
   
    end
  end
  
  def aprobacion_legal
    # Verificar los permisos del usuario
    if cannot? :update, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda solicitada
    begin

      @solicitud_addenda =
        SolicitudAddenda.find( params[:id], :include => :estado_solicitud_addenda)
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
    

    #valido el cambio de estado 
    if (@solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::EN_REVISION_LEGAL or @solicitud_addenda.estado_solicitud_addenda_id  == EstadosSolicitudAddenda::APROBACION_LEGAL) #Este ultimo lo dejo por el doble post de Firefox
      
      @solicitud_addenda.estado_solicitud_addenda_id  = EstadosSolicitudAddenda::APROBACION_LEGAL
      @solicitud_addenda.fecha_revision_legal = Time.now
      @solicitud_addenda.user_legal_id = current_user.id
      #valido los datos obligatorios de la futura addenda.
      if !(@solicitud_addenda.fecha_de_inicio.nil? or @solicitud_addenda.numero_addenda.nil?)
        
        if  @solicitud_addenda.save
          generar_adenda
          redirect_to(@solicitud_addenda,
            :flash => { :tipo => :ok, :titulo => 'Las modificaciones a la solicitud de adenda se guardaron correctamente.' }
          )
       
        else
          redirect_to(@solicitud_addenda,
            :flash => { :tipo => :error, :titulo => 'Ocurrio un error al modificar la solicitud de adenda.' })
        end
   
         
      
      
      else
        redirect_to(@solicitud_addenda,
          :flash => { :tipo => :advertencia, :titulo => 'Antes de aprobar la solicitud, complete los datos necesarios para la adenda.' })
      
      
      end
      
      
      
      

      
    else 
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda es incorrecta",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
   
    end
  end
  
  def anular_solicitud
    # Verificar los permisos del usuario
    if cannot? :update, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda solicitada
    begin

      @solicitud_addenda =
        SolicitudAddenda.find( params[:id], :include => :estado_solicitud_addenda)
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
    

    #valido el cambio de estado 
    if  [EstadosSolicitudAddenda::EN_REVISION_TECNICA, EstadosSolicitudAddenda::GENERADA,EstadosSolicitudAddenda::ANULACION_EFECTOR ,EstadosSolicitudAddenda::ANULACION_TECNICA].include?(@solicitud_addenda.estado_solicitud_addenda_id)
      
      @solicitud_addenda.estado_solicitud_addenda_id  = (@solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::GENERADA ? EstadosSolicitudAddenda::ANULACION_EFECTOR : EstadosSolicitudAddenda::ANULACION_TECNICA)
      if  @solicitud_addenda.save
      
        redirect_to(@solicitud_addenda,
          :flash => { :tipo => :ok, :titulo => 'Las modificaciones a la solicitud de adenda se guardaron correctamente.' }
        )
       
      else
        redirect_to(@solicitud_addenda,
          :flash => { :tipo => :error, :titulo => 'Ocurrio un error al modificar la solicitud de adenda.' })
      end
   
      
    else 
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda es incorrecta",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
   
    end
  end
  
  def confirmar_solicitud
    # Verificar los permisos del usuario
    if cannot? :update, SolicitudAddenda
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener la adenda solicitada
    begin

      @solicitud_addenda =
        SolicitudAddenda.find( params[:id], :include => [ :solicitudes_addendas_prestaciones_principales , :estado_solicitud_addenda])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda solicitada no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
    

    #valido el cambio de estado 
    if @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::GENERADA or  @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::EN_REVISION_TECNICA
      
      @solicitud_addenda.estado_solicitud_addenda_id  = EstadosSolicitudAddenda::EN_REVISION_TECNICA
      
      #Por defecto medica le da el ok a todo despues lo edita si quiere 
      @solicitud_addenda.solicitudes_addendas_prestaciones_principales.each do |sapp|
        sapp.aprobado_por_medica = sapp.es_autorizacion    
      end
      
      if  @solicitud_addenda.save
      
        redirect_to(@solicitud_addenda,
          :flash => { :tipo => :ok, :titulo => 'Las modificaciones a la solicitud de adenda se guardaron correctamente.' }
        )
       
      else
        redirect_to(@solicitud_addenda,
          :flash => { :tipo => :error, :titulo => 'Ocurrio un error al modificar la solicitud de adenda.' })
      end
   
      
    else 
  
      
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La solicitud de adenda es incorrecta",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
        
     
  
   
    end
  end
  
  
  
  private
  
  
  
  
  
  def actualiza_fechas_por_cambio_de_estado 
    fecha_actual = Time.now
    if @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::GENERADA && @solicitud_addenda.fecha_solicitud.nil? 
      @solicitud_addenda.fecha_solicitud = fecha_actual
    elsif @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::APROBACION_TECNICA && @solicitud_addenda.fecha_envio_efector.nil? 
      @solicitud_addenda.fecha_revision_medica = fecha_actual
    elsif @solicitud_addenda.estado_solicitud_addenda_id == EstadosSolicitudAddenda::APROBACION_LEGAL && @solicitud_addenda.fecha_revision_legal.nil? 

      @solicitud_addenda.fecha_revision_legal = fecha_actual
    else
    end
  end
   

  def generar_adenda 
    
    
    fecha_actual = Time.now
    @addenda = AddendaSumar.new
    @addenda.creator_id = current_user.id
    @addenda.updater_id = current_user.id
    @addenda.convenio_de_gestion_sumar_id = @solicitud_addenda.convenio_de_gestion_sumar_id
   
    #datos del firmante y fechas
    @addenda.firmante = @solicitud_addenda.firmante
    @addenda.fecha_de_suscripcion = @solicitud_addenda.fecha_de_suscripcion
    @addenda.fecha_de_inicio = @solicitud_addenda.fecha_de_inicio
    @addenda.observaciones = @solicitud_addenda.observaciones  
    @addenda.observaciones += "\n" + "Addenda Creada a partir de la solicitud de addenda: #{@solicitud_addenda.numero}"
    @addenda.numero = @solicitud_addenda.numero_addenda
   
    if @addenda.save
       
      #Por cada 
      @solicitud_addenda.solicitudes_addendas_prestaciones_principales.each  do |sapp| 
     
      
      
      
      
        # Obtener la adenda
        begin
          @prestacion_principal = PrestacionPrincipal.find(sapp.prestacion_principal_id ,:include =>[ {:prestaciones => :prestaciones_pdss}])
    
      
        rescue ActiveRecord::RecordNotFound
          redirect_to( root_url,
            :flash => { :tipo => :error, :titulo => "La petición no es válida",
              :mensaje => "Se informará al administrador del sistema sobre el incidente."
            }
          )
          return
        end
      
      
      
        @prestacion_principal.prestaciones_pdss.each do |p|
          actual = PrestacionPdssAutorizada.pres_autorizadas_para_solicitud(@solicitud_addenda.convenio_de_gestion_sumar.efector_id, fecha_actual, p.id.to_s)
              
    
       
          if not actual.first
          
            #no se encontro la prestacion por lo que el efector no la tiene autorizada
            #hacemos un insert de la prestacion nueva siempre que se encuentre seleccionada
            
            if  sapp.aprobado_por_medica?
              CustomQuery.ejecutar(
                {
                  sql: " 
                                          INSERT INTO prestaciones_pdss_autorizadas
                                          (efector_id, prestacion_pdss_id, fecha_de_inicio, autorizante_al_alta_type, autorizante_al_alta_id,created_at,updated_at)
                                          VALUES
                                          (#{@solicitud_addenda.convenio_de_gestion_sumar.efector_id}, #{p.id.to_s}, '#{ @addenda.fecha_de_inicio.strftime('%Y-%m-%d')}', 'AddendaSumar', #{ @addenda.id },'#{ fecha_actual.strftime('%Y-%m-%d') }' ,'#{ fecha_actual.strftime('%Y-%m-%d') }')",

                }) 
            end
            
          else   
            
            #si esta y esta deseleccionada es que la da de baja
            if  !sapp.aprobado_por_medica?  # autorizante a la baja type
              #la doy de baja solo si esta pero no esta dada de baja
              
              CustomQuery.ejecutar(
                {
                  sql: "
                        UPDATE  prestaciones_pdss_autorizadas SET fecha_de_finalizacion = '#{ @addenda.fecha_de_inicio.strftime('%Y-%m-%d')}',
                                                                            autorizante_de_la_baja_type= 'AddendaSumar' 
                                                                            , autorizante_de_la_baja_id=  #{ @addenda.id}
                                                                            , updated_at = '#{ fecha_actual.strftime('%Y-%m-%d') }'  
                                                                        WHERE efector_id = #{@solicitud_addenda.convenio_de_gestion_sumar.efector_id} AND
                                                                              prestacion_pdss_id = #{actual.first["prestacion_pdss_id"]}",
                                 
                }) 
           
              
              
            end
          
       
            
            
            
            
            
            
            #si esta y esta seleccionada no hacemos nada. Siempre y cuando no este como baja
            
        
        
          end
  
        end
    
    
    
      end
      
    end
    
   
  end
    
  def notificar_efector
       
    #         begin
    #      UserMailer.welcome_email(@user).deliver
    #      flash[:success] = "#{@user.name} created"
    #      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
    #        flash[:success] = "Utente #{@user.name} creato. Problems sending mail"
    #      end
    #   SolicitudesAddendasMailer.notificar_solicitud_addenda(@solicitud_addenda).deliver_later
    
    
    
  end
    
end
