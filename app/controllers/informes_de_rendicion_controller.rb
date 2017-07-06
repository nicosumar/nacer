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

    @efector_local = @uad_actual.efector

    if @efector_local.unidad_de_alta_de_datos == nil
      redirect_to( root_url,
        :flash => {:tipo => :error, :titulo => "Unidad de Alta de Datos no habilitada para esta operación",
          :mensaje => "La UAD actual no puede realizar esta operación."
        }
      )
      return
    end

    if @efector_local.unidad_de_alta_de_datos.facturacion == false
      redirect_to( root_url,
        :flash => {:tipo => :error, :titulo => "Unidad de Alta de Datos no habilitada para esta operación",
          :mensaje => "La UAD actual no puede realizar esta operación."
        }
      )
      return
    end

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

    @operacion = -1

    # Obtener el listado de informes de rendicion

    if current_user.in_group? [:administradores]
      @permiso = "puede_confirmar"
    else 
      @permiso = "no_puede_confirmar"
    end

    @convenios_administracion = ConvenioDeAdministracionSumar.where(:administrador_id => @uad_actual.efector.id)

    if @convenios_administracion.count > 0

      #en este caso seria un area o un municipio
      ids_administrados = @convenios_administracion.map{|convenio| convenio.efector_id}

      @efectores_administrados = Efector.where(:id => ids_administrados)

    else
      
      #en este caso sería un hospital o un centro de salud

      @informes_de_rendicion =
        InformeDeRendicion.where(:efector_id => @uad_actual.efector.id, :estado_del_proceso_id => [2,3,4]).paginate(:page => params[:page], :per_page => 12, 
          :include => [:estado_del_proceso, :efector], :order => "fecha_informe ASC")
    
    end

    if params[:date] == nil
      return;
    end

    @convenios_administracion = ConvenioDeAdministracionSumar.where(:administrador_id => @uad_actual.efector.id)

    @administrador = @uad_actual.efector

    ids_administrados = @convenios_administracion.map{|convenio| convenio.efector_id}

    @efectores_administrados = Efector.where(:id => ids_administrados)

    @informes_de_rendicion_compuesto = InformeDeRendicion.where("date_part('year',fecha_informe) = ? 
      and date_part('month',fecha_informe) = ? 
      and efector_id in (?) 
      and estado_del_proceso_id >= 3", params[:date][:year].to_s, params[:date][:month].to_s, ids_administrados)

    fecha = params[:date][:month].to_s + " - " + params[:date][:year].to_s

    total_servicios = 0
    total_obras = 0
    total_ctes = 0
    total_capital = 0
    total_final = 0

    @informes_de_rendicion_compuesto.each do |informe|

      total_servicios += informe.get_total_servicios
      total_obras += informe.get_total_obras
      total_ctes += informe.get_total_ctes
      total_capital += informe.get_total_capital

    end

    total_final = total_servicios + total_obras + total_ctes + total_capital

    respond_to do |format|
      
      format.odt do

        report = ODFReport::Report.new("lib/tasks/datos/plantillas/Modelo de informe de rendicion y compra compuesto.odt") do |r|
            
          r.add_field :codigo_informe, @administrador.cuie + "-" + params[:date][:year] + "-" + params[:date][:month]
          r.add_field :efector_nombre, @administrador.nombre
          r.add_field :referente_al_dia, @administrador.referente_al_dia.contacto.nombres + " " + @administrador.referente_al_dia.contacto.apellidos
          r.add_field :banco_cuenta_principal, @administrador.banco_cuenta_principal
          r.add_field :banco_denominacion, @administrador.denominacion_cuenta_principal

          r.add_field :fecha_informe, params[:date][:month].to_s + "/" + params[:date][:year].to_s
          
          r.add_field :departamento, @administrador.departamento.nombre
          r.add_field :banco_numero_cuenta, @administrador.numero_de_cuenta_principal
          r.add_field :banco_numero_cuit, @administrador.cuit
          
          r.add_field :mes_informe, params[:date][:month].to_s
          r.add_field :anio_informe, params[:date][:year].to_s

          r.add_field :total_final, total_final.to_f
          r.add_field :servicios, total_servicios.to_f
          r.add_field :obras, total_obras.to_f
          r.add_field :corrientes, total_ctes.to_f
          r.add_field :capital, total_capital.to_f

          if @informes_de_rendicion_compuesto == []
            r.add_field :data, "Ninguno de los efectores administrados posee un informe de rendición y compras cargado y finalizado en el sistema."
          else
            r.add_field :data, ""
          end

          r.add_section("Cuerpo", @informes_de_rendicion_compuesto, header: false) do |s|

            s.add_field :nombre, :get_nombre_efector
            s.add_field (:codigo) {|informe| informe.get_cuie_efector + "-" + params[:date][:year].to_s + "-" + params[:date][:month].to_s}

            s.add_table("Detalles", :detalles_informe_de_rendicion, header: false) do |t|

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

              t.add_column(:cuenta, :cuenta)

            end

            s.add_field :total, :get_total
            s.add_field :total_servicios, :get_total_servicios
            s.add_field :total_obras, :get_total_obras
            s.add_field :total_ctes, :get_total_ctes
            s.add_field :total_capital, :get_total_capital

          end 
          
        end

        archivo = report.generate("lib/tasks/datos/documentos/Informe de Rendicion y Compra #{fecha} - #{@administrador.nombre.gsub("/", "_")}.odt")

        File.chmod(0644, "lib/tasks/datos/documentos/Informe de Rendicion y Compra #{fecha} - #{@administrador.nombre.gsub("/", "_")}.odt")

        send_file(archivo)

        return

      end

      format.odt2 do

        report = ODFReport::Report.new("lib/tasks/datos/plantillas/Modelo de aplicacion de fondos compuesto.odt") do |r|

          r.add_field :nombre_efector, @administrador.nombre
          r.add_field :cuie, @administrador.cuie
          r.add_field :mes, params[:date][:month].to_s
          r.add_field :anio, params[:date][:year].to_s

          OJO! --> ACA FALTA LO DEL ADMINISTRADOR (que es como un valor global de cada informe especifico) y tambien
          me falta poner los nombres de los efectores y cuies en los particulares

          r.add_table("EfectorAdministrado", @informes_de_rendicion_compuesto, header: false) do |t|

            t.add_field :global, :get_total

            t.add_field :total1, :get_total_1
            
            t.add_field :val11, :get_total_11
            t.add_field :val12, :get_total_12
            t.add_field :val13, :get_total_13

            t.add_field :total2, :get_total_2

            t.add_field :val21, :get_total_21
            t.add_field :val22, :get_total_22
            t.add_field :val23, :get_total_23

            t.add_field :total3, :get_total_3

            t.add_field :val31, :get_total_31
            t.add_field :val32, :get_total_32

            t.add_field :total4, :get_total_4

            t.add_field :val41, :get_total_41
            t.add_field :val42, :get_total_42
            t.add_field :val43, :get_total_43

            t.add_field :total5, :get_total_5

            t.add_field :val51, :get_total_51
            t.add_field :val52, :get_total_52
            t.add_field :val53, :get_total_53

            t.add_field :total6, :get_total_6

            t.add_field :val61, :get_total_61
            t.add_field :val62, :get_total_62
            t.add_field :val63, :get_total_63

            t.add_field :total7, :get_total_7

            t.add_field :val71, :get_total_71

          end
          
        end

        archivo = report.generate("lib/tasks/datos/documentos/Reporte de Uso de Fondos #{fecha} - #{@administrador.nombre.gsub("/", "_")}.odt")

        File.chmod(0644, "lib/tasks/datos/documentos/Reporte de Uso de Fondos #{fecha} - #{@administrador.nombre.gsub("/", "_")}.odt")

        send_file(archivo)

        return

      end

      format.html do
      end

    end

  end

  # GET /informe_de_rendicion/new
  def new

    if cannot? :manage, InformeDeRendicion
      redirect_to( root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    id_efector = params[:efector]

    if id_efector != nil

      @efector_local = Efector.find(id_efector, :include => [:unidad_de_alta_de_datos])

    else 

      @efector_local = @uad_actual.efector

    end

    if @efector_local.unidad_de_alta_de_datos == nil
      redirect_to( root_url,
        :flash => {:tipo => :error, :titulo => "Unidad de Alta de Datos no habilitada para esta operación",
          :mensaje => "La UAD actual no puede realizar esta operación."
        }
      )
      return
    end

    if @efector_local.unidad_de_alta_de_datos.facturacion == false
      redirect_to( root_url,
        :flash => {:tipo => :error, :titulo => "Unidad de Alta de Datos no habilitada para esta operación",
          :mensaje => "La UAD actual no puede realizar esta operación."
        }
      )
      return
    end

    if @efector_local.referente_al_dia.nil? 
      redirect_to( informes_de_rendicion_path,
        :flash => { :tipo => :advertencia, :titulo => "No hay un referente activo en esta unidad de alta de datos",
          :mensaje => "Para continuar usted deberá actualizar los datos de su referente. 
          Para hacerlo siga las instrucciones en este enlace."
        }
      )
      return
  	end

    if current_user.in_group? [:administradores]
      @permiso = "puede_clasificar"
    else 
      @permiso = "no_puede_clasificar"
    end

    # Crear los objetos necesarios para la vista
    @operacion = 0
    @informe_de_rendicion = InformeDeRendicion.new
    @clases_de_gasto = ClaseDeGasto.all
    @tipos_de_gasto = TipoDeGasto.all
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

    if cannot? :read, InformeDeRendicion
      redirect_to( root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    if current_user.in_group? [:administradores]
      @permiso = "puede_clasificar"
    else 
      @permiso = "no_puede_clasificar"
    end

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

    begin

      @operacion = 1

      @informe_de_rendicion = InformeDeRendicion.find(params[:id], :include => [:detalles_informe_de_rendicion, :estado_del_proceso, :efector])
      @tipos_de_gasto_por_detalle = get_tipos_de_gasto_por_detalle

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
            
            r.add_field :codigo_informe, @informe_de_rendicion.codigo
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

              t.add_column(:cuenta, :cuenta)

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

      format.odt2 do
          
          report = ODFReport::Report.new("lib/tasks/datos/plantillas/Modelo de aplicacion de fondos.odt") do |r|
            
            r.add_field :nombre_efector, @informe_de_rendicion.efector.nombre
            r.add_field :cuie, @informe_de_rendicion.efector.cuie
            r.add_field :mes, @informe_de_rendicion.fecha_informe.month.to_s
            r.add_field :anio, @informe_de_rendicion.fecha_informe.year.to_s

            r.add_field :global, @informe_de_rendicion.get_total

            r.add_field :total1, @informe_de_rendicion.get_total_1
            
            r.add_field :val11, @informe_de_rendicion.get_total_11
            r.add_field :val12, @informe_de_rendicion.get_total_12
            r.add_field :val13, @informe_de_rendicion.get_total_13

            r.add_field :total2, @informe_de_rendicion.get_total_2

            r.add_field :val21, @informe_de_rendicion.get_total_21
            r.add_field :val22, @informe_de_rendicion.get_total_22
            r.add_field :val23, @informe_de_rendicion.get_total_23

            r.add_field :total3, @informe_de_rendicion.get_total_3

            r.add_field :val31, @informe_de_rendicion.get_total_31
            r.add_field :val32, @informe_de_rendicion.get_total_32

            r.add_field :total4, @informe_de_rendicion.get_total_4

            r.add_field :val41, @informe_de_rendicion.get_total_41
            r.add_field :val42, @informe_de_rendicion.get_total_42
            r.add_field :val43, @informe_de_rendicion.get_total_43

            r.add_field :total5, @informe_de_rendicion.get_total_5

            r.add_field :val51, @informe_de_rendicion.get_total_51
            r.add_field :val52, @informe_de_rendicion.get_total_52
            r.add_field :val53, @informe_de_rendicion.get_total_53

            r.add_field :total6, @informe_de_rendicion.get_total_6

            r.add_field :val61, @informe_de_rendicion.get_total_61
            r.add_field :val62, @informe_de_rendicion.get_total_62
            r.add_field :val63, @informe_de_rendicion.get_total_63

            r.add_field :total7, @informe_de_rendicion.get_total_7

            r.add_field :val71, @informe_de_rendicion.get_total_71

          end

        archivo = report.generate("lib/tasks/datos/documentos/Reporte de Uso De Fondos #{@informe_de_rendicion.id} - #{@informe_de_rendicion.efector.nombre.gsub("/", "_")}.odt")

        File.chmod(0644, "lib/tasks/datos/documentos/Reporte de Uso De Fondos #{@informe_de_rendicion.id} - #{@informe_de_rendicion.efector.nombre.gsub("/", "_")}.odt")

        send_file(archivo)

      end

      # format.ods do
          
      #     report = ODSReport::Report.new("lib/tasks/datos/plantillas/Modelo aplicación de fondos.ods") do |r|
            
      #       r.add_field :nombre_area, @informe_de_rendicion.codigo
            
      #     end

      #   archivo = report.generate("lib/tasks/datos/documentos/Aplicación de Fondos #{@informe_de_rendicion.id} - #{@informe_de_rendicion.efector.nombre.gsub("/", "_")}.ods")

      #   File.chmod(0644, "lib/tasks/datos/documentos/Aplicación de Fondos #{@informe_de_rendicion.id} - #{@informe_de_rendicion.efector.nombre.gsub("/", "_")}.ods")

      #   send_file(archivo)

      # end

      format.html do
      end

    end

  end

  def edit
    # Verificar los permisos del usuario
    if cannot? :manage, InformeDeRendicion
      redirect_to( root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    if current_user.in_group? [:administradores]
      @permiso = "puede_clasificar"
    else 
      @permiso = "no_puede_clasificar"
    end

    # Crear los objetos necesarios para la vista
    @operacion = 2
    @informe_de_rendicion = InformeDeRendicion.find(params[:id], :include => [:detalles_informe_de_rendicion => [ :tipo_de_gasto => [:clase_de_gasto] ] ] )

    @efector_local = Efector.find(@informe_de_rendicion.efector_id)

    @tipos_de_gasto_por_detalle = get_tipos_de_gasto_por_detalle

    @clases_de_gasto = ClaseDeGasto.all
    @tipos_de_gasto = TipoDeGasto.all
  end

  def update

    if cannot? :manage, InformeDeRendicion
      redirect_to( root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    url_destino = ""
    respuesta = {}
    status = :ok

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

    elsif tipo_de_operacion == "reject"

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
        @informe_de_rendicion.estado_del_proceso_id = 2

        if @informe_de_rendicion.save!
          redirect_to( informes_de_rendicion_path,
            :flash => { :tipo => :ok, :titulo => "EXITO",
              :mensaje => "El informe se ha rechazado correctamente, ahora el usuario podrá editarlo nuevamente."
            }
          )
          return
        else
          redirect_to( informes_de_rendicion_path,
            :flash => { :tipo => :error, :titulo => "ERROR",
              :mensaje => "No se ha podido rechazar este informe. Por favor, vuelva a intentarlo nuevamente."
            }
          )
          return
        end

    else #EDITAR INFORME

      if current_user.in_group? [:administradores]
        @permiso = "puede_clasificar"
      else 
        @permiso = "no_puede_clasificar"
      end

      #PARAMETROS QUE USO PARA OTRA COSILLA

      cantidad_detalles = params[:cantidad_detalles]

      #PARAMETROS PARA CREAR UN NUEVO INFORME DE RENDICION

      informe_de_rendicion = InformeDeRendicion.find(params[:id], :include => [:detalles_informe_de_rendicion])

      informe_de_rendicion.fecha_informe = DateTime.strptime(params[:dia_informe] +"/"+ params[:mes_informe] +"/"+ params[:anio_informe],"%d/%m/%Y")
      
      informes_con_esta_fecha = InformeDeRendicion.where(:efector_id => informe_de_rendicion.efector.id, :fecha_informe => informe_de_rendicion.fecha_informe)

      if informes_con_esta_fecha.count > 0 && informes_con_esta_fecha[0].id != informe_de_rendicion.id

        #Ya existe un informe con esta fecha! No puede ser, debe haber solo uno por mes
        url_destino = ""
        respuesta = { :url => url_destino, :tipo => :ok, :titulo => "Ya existe un informe de este mes en el año seleccionado.\nPor favor, controle que todos los datos ingresados sean correctos." }
        status = :ok

      else #Si la fecha es única, entonces sigo con el resto de la creacion, sino la termino ahí nomás

        informe_de_rendicion.codigo = informe_de_rendicion.efector.cuie.to_s + "-" +  params[:anio_informe] + "-" + params[:mes_informe]

        informe_de_rendicion.total = params[:total_informe]

        informe_de_rendicion.detalles_informe_de_rendicion.destroy_all; #ELIMINO TODOS LOS DETALLES y luego los agrego editados

        con_movimientos = true

        todo_ok = true;

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
              detalle_informe_de_rendicion.cuenta = params[:cuentas][$i]

              clase_de_gasto = ClaseDeGasto.where(:numero => params[:clases_de_gasto][$i]).first
              tipo_de_gasto = TipoDeGasto.where(:numero => params[:tipos_de_gasto][$i], :clase_de_gasto_id => clase_de_gasto.id).first

              detalle_informe_de_rendicion.tipo_de_gasto_id = tipo_de_gasto.id

            end

            if detalle_informe_de_rendicion.save!
              puts("SE ACTUALIZO EL DETALLE N° #$i CORRECTAMENTE")
            else 
              
              todo_ok = false;

            end

            $i +=1;

          end until $i > cantidad_detalles.to_i - 1

          if(todo_ok)

            url_destino = informe_de_rendicion_path(informe_de_rendicion) + "?result=ok"
            respuesta = { :url => url_destino, :tipo => :ok, :titulo => "Se completó la operación correctamente." }
            status = :ok

          else

            url_destino = ""
            respuesta = { :url => url_destino, :tipo => :ok, :titulo => "Falló al actualizar el informe.\nPor favor, controle los datos modificados e intentelo nuevamente más tarde." }
            status = :ok

          end

        else

          url_destino = ""
          respuesta = { :url => url_destino, :tipo => :ok, :titulo => "Falló al actualizar el informe.\nPor favor, controle los datos modificados e intentelo nuevamente más tarde." }
          status = :ok

        end

      end

    end

    respond_to do |format|
      format.json { render json: respuesta.to_json, status: status }
    end

    return

  end

  def create

    if cannot? :manage, InformeDeRendicion
      redirect_to( root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    #params[:nombre]
    #params[:array][index]

    url_destino = ""
    respuesta = {}
    status = :ok

    #PARAMETROS QUE USO PARA OTRA COSILLA

    cantidad_detalles = params[:cantidad_detalles]

    #PARAMETROS PARA CREAR UN NUEVO INFORME DE RENDICION
    informe_de_rendicion = InformeDeRendicion.new

    this_efector = Efector.find(params[:efector_id])
    informe_de_rendicion.codigo =  this_efector.cuie.to_s + "-" +  params[:anio_informe] + "-" + params[:mes_informe]
    informe_de_rendicion.efector_id = this_efector.id
    
    informe_de_rendicion.fecha_informe = DateTime.strptime(params[:dia_informe] +"/"+ params[:mes_informe] +"/" + params[:anio_informe],"%d/%m/%Y")
    
    informes_con_esta_fecha = InformeDeRendicion.where(:efector_id => informe_de_rendicion.efector.id, :fecha_informe => informe_de_rendicion.fecha_informe)

    if informes_con_esta_fecha.count > 0

      #Ya existe un informe con esta fecha! No puede ser, debe haber solo uno por mes
      url_destino = ""
      respuesta = { :url => url_destino, :tipo => :ok, :titulo => "Ya existe un informe de este mes en el año seleccionado.\nPor favor, controle que todos los datos ingresados sean correctos." }
      status = :ok

    else #Si la fecha es única, entonces sigo con el resto de la creacion, sino la termino ahí nomás

      informe_de_rendicion.total = params[:total_informe]
      informe_de_rendicion.estado_del_proceso_id = 2 #EN CURSO

      con_movimientos = true

      if informe_de_rendicion.save!

        todo_ok = true

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
            detalle_informe_de_rendicion.cuenta = params[:cuentas][$i]

            clase_de_gasto = ClaseDeGasto.where(:numero => params[:clases_de_gasto][$i]).first
            tipo_de_gasto = TipoDeGasto.where(:numero => params[:tipos_de_gasto][$i], :clase_de_gasto_id => clase_de_gasto.id).first

            detalle_informe_de_rendicion.tipo_de_gasto_id = tipo_de_gasto.id

          end

          if detalle_informe_de_rendicion.save!
            
            #TODO OKU, ENTONCES SIGO!

          else 

            todo_ok = false
            
            url_destino = ""
            respuesta = { :url => url_destino, :tipo => :ok, :titulo => "No se pudo crear el nuevo informe. Por favor, inténtelo nuevamente más tarde." }
            status = :ok

            break

          end

          $i +=1;

        end until $i > cantidad_detalles.to_i - 1

        if(todo_ok)

          url_destino = informe_de_rendicion_path(informe_de_rendicion) + "?result=ok"
          respuesta = { :url => url_destino, :tipo => :ok, :titulo => "Se completó la operación correctamente." }
          status = :ok

        else

          #borro el informe creado porque algo salió mal!
          informe_de_rendicion.destroy

        end

      else

        url_destino = ""
        respuesta = { :url => url_destino, :tipo => :ok, :titulo => "No se pudo crear el nuevo informe. Por favor, inténtelo nuevamente más tarde." }
        status = :ok

      end

    end

    respond_to do |format|
      format.json { render json: respuesta.to_json, status: status }
    end

    return

  end

  private

  def get_tipos_de_gasto_por_detalle
    
    result = @informe_de_rendicion.detalles_informe_de_rendicion.map do |d|
      
      { :tipo => (d.tipo_de_gasto != nil) ? d.tipo_de_gasto.clase_de_gasto.numero + '.' + d.tipo_de_gasto.numero : ""}
    
    end
    
    return result

  end

end
