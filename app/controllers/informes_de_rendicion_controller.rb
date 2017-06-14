class InformesDeRendicionController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_filter :authenticate_user!

  # GET /informes_de_rendicion
  def index

    # Verificar los permisos del usuario
    if cannot? :read, InformeDeRendicion
      redirect_to( root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de informes de rendicion

    if current_user.in_group? [:administradores]
      @permiso = "puede_confirmar"
    else 
      @permiso = "no_puede_confirmar"
    end

    @informes_de_rendicion =
      InformeDeRendicion.where(:efector_id => @uad_actual.efector.id, :estado_del_proceso_id => [2,3,4]).paginate(:page => params[:page], :per_page => 12, 
        :include => [:estado_del_proceso, :efector], :order => "updated_at DESC")

  end

  # GET /informe_de_rendicion/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, InformeDeRendicion
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    if @uad_actual.efector.referente_al_dia.nil? 
      redirect_to( informes_de_rendicion_path,
        :flash => { :tipo => :advertencia, :titulo => "No hay un referente activo en esta unidad de alta de datos",
          :mensaje => "Para continuar usted deberá actualizar los datos de su referente. 
          Para hacerlo siga las instrucciones en este enlace."
        }
      )
      return
  	end

    # Crear los objetos necesarios para la vista
    @operacion = 0
    @informe_de_rendicion = InformeDeRendicion.new
  end

  def show
    # Verificar los permisos del usuario
    if cannot? :create, InformeDeRendicion
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @operacion = 1
    @informe_de_rendicion = InformeDeRendicion.find(params[:id])
  end

  def edit
    # Verificar los permisos del usuario
    if cannot? :create, InformeDeRendicion
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @operacion = 2
    @informe_de_rendicion = InformeDeRendicion.find(params[:id], :include => [:detalles_informe_de_rendicion])
  end

  def update

    tipo_de_operacion = params[:operacion]

    if tipo_de_operacion == "delete"
      #ELIMINAR INFORME

      @informe_de_rendicion = InformeDeRendicion.find(params[:id])
      #@informe_de_rendicion.estado_del_proceso_id = 1; --> PUEDO HACER ESTO SI QUIERO NO BORRARLO DEL TODO
      @informe_de_rendicion.destroy

    else 

      if tipo_de_operacion == "confirm"

        #Por acá también debería controlar que se encuentra con las credenciales adecuadas

        if not current_user.in_group? [:administradores]
          redirect_to( root_url,
            :flash => { :tipo => :error, :titulo => "No está autorizado para realizar esa acción",
              :mensaje => "Se informará al administrador del sistema sobre este incidente."
            }
          )
          return
        end

        @informe_de_rendicion = InformeDeRendicion.find(params[:id])
        @informe_de_rendicion.estado_del_proceso_id = 4

        if @informe_de_rendicion.save!
          puts('INFORME CONFIRMADO CON EXITO')
        else
          puts('EL INFORME NO PUDO CONFIRMARSE CORRECTAMENTE')
        end

      else
        #EDITAR INFORME

        #PARAMETROS QUE USO PARA OTRA COSILLA

        cantidad_detalles = params[:cantidad_detalles]

        #PARAMETROS PARA CREAR UN NUEVO INFORME DE RENDICION

        informe_de_rendicion = InformeDeRendicion.find(params[:id], :include => [:detalles_informe_de_rendicion])
        informe_de_rendicion.fecha_informe = DateTime.strptime(params[:dia_informe] +"/"+ params[:mes_informe] +"/" + params[:anio_informe],"%d/%m/%Y")
        informe_de_rendicion.total = params[:total_informe]

        informe_de_rendicion.detalles_informe_de_rendicion.destroy_all; #ELIMINO TODOS LOS DETALLES y luego los agrego editados

        con_movimientos = true

        if informe_de_rendicion.save!

          puts('SE ACTUALIZÓ CORRECTAMENTE EL INFORME, AHORA SE VAN A ASOCIAR LOS DETALLES')

          if cantidad_detalles == "1"

            if params[:detalles][0] == 'SIN MOVIMIENTOS'

              #Existe un único caso en el que los valores puedan ser nulos y es cuando
              #no hay ningún detalle "nuevo" sino que hay uno solo que dice SIN MOVIMIENTOS
              con_movimientos = false

            end

          end 

          $i = 0

          begin

            detalle_informe_de_rendicion = DetalleInformeDeRendicion.new
            
            #PARAMETROS PARA CREAR LOS DETALLES ASOCIADOS AL NUEVO INFORME DE RENDICION  

            detalle_informe_de_rendicion.informe_de_rendicion_id = informe_de_rendicion.id
            detalle_informe_de_rendicion.detalle = params[:detalles][$i]

            if con_movimientos

              detalle_informe_de_rendicion.numero = params[:numeros][$i]
              detalle_informe_de_rendicion.fecha_factura = params[:fechas_factura][$i]
              detalle_informe_de_rendicion.numero_factura = params[:numeros_factura][$i]
              detalle_informe_de_rendicion.cantidad = params[:cantidades][$i]
              detalle_informe_de_rendicion.numero_cheque = params[:numeros_cheque][$i]
              detalle_informe_de_rendicion.tipo_de_importe_id = params[:tipos_de_importe][$i]
              detalle_informe_de_rendicion.importe = params[:importes][$i].to_f

            end

            if detalle_informe_de_rendicion.save!
              puts("SE ACTUALIZO EL DETALLE N° #$i CORRECTAMENTE")
            else 
              puts("FALLÓ AL ACTUALIZAR EL DETALLE N° #$i")
            end

            $i +=1;

          end until $i > cantidad_detalles.to_i - 1

        else
           puts('FALLÓ AL ACTUALIZAR EL INFORME')
        end

        redirect_to informes_de_rendicion_path
        return

      end

    end 

    redirect_to informes_de_rendicion_path
    return

  end

  def imprimirInforme

    #respond_to do |format|
      #format.pdf { send_data render_to_string, filename: "detalle_de_prestaciones_#{@periodo.periodo}_#{@efector.nombre}.pdf", 
      #type: 'application/pdf', disposition: 'attachment'}

      #format.xlsx {
        #render xlsx: 'detalle_de_prestaciones_liquidadas_por_efector',
        #filename:  "detalle_de_prestaciones_#{@liquidacion_sumar.periodo.periodo}_#{@liquidacion_sumar.concepto_de_facturacion.codigo}.xlsx"
      #}
      
    #end

  end

  def create

    #params[:nombre]
    #params[:array][index]

    #PARAMETROS QUE USO PARA OTRA COSILLA

    cantidad_detalles = params[:cantidad_detalles]

    #PARAMETROS PARA CREAR UN NUEVO INFORME DE RENDICION

    informe_de_rendicion = InformeDeRendicion.new
    informe_de_rendicion.efector_id = params[:efector_id]
    informe_de_rendicion.fecha_informe = DateTime.strptime(params[:dia_informe] +"/"+ params[:mes_informe] +"/" + params[:anio_informe],"%d/%m/%Y")
    informe_de_rendicion.total = params[:total_informe]
    informe_de_rendicion.estado_del_proceso_id = 2 #EN CURSO

    con_movimientos = true

    if informe_de_rendicion.save!

      puts('SE CREÓ CORRECTAMENTE EL INFORME, AHORA SE VAN A ASOCIAR LOS DETALLES')

      if cantidad_detalles == "1"

        if params[:detalles][0] == 'SIN MOVIMIENTOS'

          #Existe un único caso en el que los valores puedan ser nulos y es cuando
          #no hay ningún detalle "nuevo" sino que hay uno solo que dice SIN MOVIMIENTOS
          con_movimientos = false

        end

      end 

      $i = 0

      begin

        detalle_informe_de_rendicion = DetalleInformeDeRendicion.new
        
        #PARAMETROS PARA CREAR LOS DETALLES ASOCIADOS AL NUEVO INFORME DE RENDICION  

        detalle_informe_de_rendicion.informe_de_rendicion_id = informe_de_rendicion.id
        detalle_informe_de_rendicion.detalle = params[:detalles][$i]

        if con_movimientos

          detalle_informe_de_rendicion.numero = params[:numeros][$i]
          detalle_informe_de_rendicion.fecha_factura = params[:fechas_factura][$i]
          detalle_informe_de_rendicion.numero_factura = params[:numeros_factura][$i]
          detalle_informe_de_rendicion.cantidad = params[:cantidades][$i]
          detalle_informe_de_rendicion.numero_cheque = params[:numeros_cheque][$i]
          detalle_informe_de_rendicion.tipo_de_importe_id = params[:tipos_de_importe][$i]
          detalle_informe_de_rendicion.importe = params[:importes][$i].to_f

        end

        if detalle_informe_de_rendicion.save!
          puts("SE CREÓ EL DETALLE N° #$i CORRECTAMENTE")
        else 
          puts("FALLÓ AL CREAR EL DETALLE N° #$i")
        end

        $i +=1;

      end until $i > cantidad_detalles.to_i - 1

    else
       puts('FALLÓ AL CREAR EL INFORME')
    end

    redirect_to informes_de_rendicion_path
    return

  end

end
