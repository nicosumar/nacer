class InformesDeRendicionController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_filter :authenticate_user!

  # GET /informes_de_rendicion
  def index

    # Verificar los permisos del usuario
    # if cannot? :read, InformeDeRendicion
    #   redirect_to( root_url,
    #     :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
    #       :mensaje => "Se informará al administrador del sistema sobre este incidente."
    #     }
    #   )
    #   return
    # end

    resultado = params[:result]

    if resultado == 'ok'

      flash[:tipo] = :ok
      flash[:titulo] = "ÉXITO"
      flash[:mensaje] = "La operación se realizó correctamente."

    elsif resultado == 'error'

      flash[:tipo] = :error
      flash[:titulo] = "ERROR"
      flash[:mensaje] = "La operación falló. Por favor, intente nuevamente. Si el problema persiste comuniquesé con el administrador."
      
    else

      flash[:tipo] = nil

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

  # def show
  #   # Verificar los permisos del usuario
  #   if cannot? :create, InformeDeRendicion
  #     redirect_to( root_url,
  #       :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
  #         :mensaje => "Se informará al administrador del sistema sobre este incidente."
  #       }
  #     )
  #     return
  #   end

  #   # Crear los objetos necesarios para la vista
  #   @operacion = 1
  #   @informe_de_rendicion = InformeDeRendicion.find(params[:id])
  # end

  # GET /addendas_sumar/:id
  def show

    resultado = params[:result]

    if resultado == 'ok'

      flash[:tipo] = :ok
      flash[:titulo] = "ÉXITO"
      flash[:mensaje] = "La operación se realizó correctamente."

    elsif resultado == 'error'

      flash[:tipo] = :error
      flash[:titulo] = "ERROR"
      flash[:mensaje] = "La operación falló. Por favor, intente nuevamente. Si el problema persiste comuniquesé con el administrador."
      
    else

      flash[:tipo] = nil

    end

    # # Verificar los permisos del usuario
    # if cannot? :read, AddendaSumar
    #   redirect_to( root_url,
    #     :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
    #       :mensaje => "Se informará al administrador del sistema sobre este incidente."
    #     }
    #   )
    #   return
    # end

    # Obtener la adenda solicitada
    begin

      @operacion = 1
      @informe_de_rendicion = InformeDeRendicion.find(params[:id], :include => [:detalles_informe_de_rendicion, :estado_del_proceso, :efector])

    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "El informe de rendición y compras solicitado no existe",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
    end

    respond_to do |format|
      
      format.odt do
          
          report = ODFReport::Report.new("lib/tasks/datos/plantillas/Modelo de informe de rendicion y compra.odt") do |r|
            
            r.add_field :id_informe, @informe_de_rendicion.id
            r.add_field :efector_nombre, @informe_de_rendicion.efector.nombre
            r.add_field :referente_al_dia, @informe_de_rendicion.efector.referente_al_dia.contacto.nombres + " " + @informe_de_rendicion.efector.referente_al_dia.contacto.apellidos
            r.add_field :banco_cuenta_principal, @informe_de_rendicion.efector.banco_cuenta_principal
            r.add_field :banco_denominacion, @informe_de_rendicion.efector.denominacion_cuenta_principal
            r.add_field :fecha_informe, @informe_de_rendicion.fecha_informe.day.to_s + "/" + @informe_de_rendicion.fecha_informe.month.to_s + "/" + @informe_de_rendicion.fecha_informe.year.to_s
            r.add_field :departamento, @informe_de_rendicion.efector.departamento.nombre
            r.add_field :banco_numero_cuenta, @informe_de_rendicion.efector.numero_de_cuenta_principal
            r.add_field :banco_numero_cuit, @informe_de_rendicion.efector.cuit
            r.add_field :mes_informe, @informe_de_rendicion.fecha_informe.month
            r.add_field :anio_informe, @informe_de_rendicion.fecha_informe.year

            @detalles_informe_de_rendicion = @informe_de_rendicion.detalles_informe_de_rendicion

            r.add_table("Detalles", @detalles_informe_de_rendicion, header: false) do |t|
              
              t.add_column(:numero, :numero)
              t.add_column(:fecha_factura, :fecha_factura.to_s)
              t.add_column(:numero_factura, :numero_factura)
              t.add_column(:detalle, :detalle)
              t.add_column(:cantidad, :cantidad)
              t.add_column(:numero_cheque, :numero_cheque)
              
              t.add_column(:importe_servicios, :importe_servicios)
              t.add_column(:importe_obras, :importe_obras)
              t.add_column(:importe_ctes, :importe_ctes)
              t.add_column(:importe_capital, :importe_capital)

            end
            
            r.add_field :total, @informe_de_rendicion.get_total
            r.add_field :total_servicios, @informe_de_rendicion.get_total_servicios
            r.add_field :total_obras, @informe_de_rendicion.get_total_obras
            r.add_field :total_ctes, @informe_de_rendicion.get_total_ctes
            r.add_field :total_capital, @informe_de_rendicion.get_total_capital
            
          end

        archivo = report.generate("lib/tasks/datos/documentos/Informe de Rendicion y Compra #{@informe_de_rendicion.id} - #{@informe_de_rendicion.efector.nombre.gsub("/", "_")}.odt")

        File.chmod(0644, "lib/tasks/datos/documentos/Informe de Rendicion y Compra #{@informe_de_rendicion.id} - #{@informe_de_rendicion.efector.nombre.gsub("/", "_")}.odt")

        send_file(archivo)

      end

        format.html do
        end

    end

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

    # Cuando se crea el informe lo pone en estado 2
    # luego cuando se cierra por parte del efector queda en estado 3
    # y finalmente cuando el adminsitrador recibe el documento firmado y está todo ok, lo deja en estado 4
    # Deberia permitir que este lo cambie nuevamente a estado 2 para que se edite en caso de que lo necesite, no?

    tipo_de_operacion = params[:operacion]

    if tipo_de_operacion == "delete"
      #ELIMINAR INFORME

      @informe_de_rendicion = InformeDeRendicion.find(params[:id])
      #@informe_de_rendicion.estado_del_proceso_id = 1; --> PUEDO HACER ESTO SI QUIERO NO BORRARLO DEL TODO
      
      if @informe_de_rendicion.estado_del_proceso_id == 2

        @informe_de_rendicion.destroy

        redirect_to( informes_de_rendicion_path,
            :flash => { :tipo => :ok, :titulo => "EXITO",
              :mensaje => "El informe se ha eliminado exitosamente."
            }
          )
        return

      else

        redirect_to( informes_de_rendicion_path,
            :flash => { :tipo => :error, :titulo => "ERROR",
              :mensaje => "No se ha podido borrar este informe. Por favor, controle que se encuentre en un estado habilitado y vuelva a intentarlo nuevamente."
            }
          )
        return

      end

    elsif tipo_de_operacion == "close"

      @informe_de_rendicion = InformeDeRendicion.find(params[:id])

      @informe_de_rendicion.estado_del_proceso_id = 3;

      if @informe_de_rendicion.save!
        redirect_to( informe_de_rendicion_path(@informe_de_rendicion),
            :flash => { :tipo => :ok, :titulo => "EXITO",
              :mensaje => "Se cerró el informe correctamente. Ahora puedes imprimirlo."
            }
          )
        return
      else 
        redirect_to( informe_de_rendicion_path(@informe_de_rendicion),
            :flash => { :tipo => :error, :titulo => "ERROR",
              :mensaje => "No se ha podido cerrar correctamente el informe. Vuelva a intentarlo nuevamente."
            }
          )
        return
      end

    elsif tipo_de_operacion == "confirm"

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
          redirect_to( informes_de_rendicion_path,
            :flash => { :tipo => :ok, :titulo => "EXITO",
              :mensaje => "El informe se ha confirmado exitosamente."
            }
          )
          return
        else
          redirect_to( informes_de_rendicion_path,
            :flash => { :tipo => :error, :titulo => "ERROR",
              :mensaje => "No se ha podido confirmar este informe. Por favor, vuelva a intentarlo nuevamente."
            }
          )
          return
        end

    else #EDITAR INFORME

      #PARAMETROS QUE USO PARA OTRA COSILLA

      cantidad_detalles = params[:cantidad_detalles]

      #PARAMETROS PARA CREAR UN NUEVO INFORME DE RENDICION

      informe_de_rendicion = InformeDeRendicion.find(params[:id], :include => [:detalles_informe_de_rendicion])

      informe_de_rendicion.fecha_informe = DateTime.strptime(params[:dia_informe] +"/"+ params[:mes_informe] +"/"+ params[:anio_informe],"%d/%m/%Y")
      
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

        respond_to do |format|
          format.json {
            render json: {redirect_to: informe_de_rendicion_path(informe_de_rendicion)}, status: :ok
          }
        end #end response

      else
         puts('FALLÓ AL ACTUALIZAR EL INFORME')
      end

    end

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

      respond_to do |format|
            format.json {
              render json: {redirect_to: informe_de_rendicion_path(informe_de_rendicion)}, status: :ok
            }
      end #end response

    else
       puts('FALLÓ AL CREAR EL INFORME')
    end

    #redirect_to informes_de_rendicion_path
    #return

  end

end
