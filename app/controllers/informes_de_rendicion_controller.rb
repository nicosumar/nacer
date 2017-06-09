class InformesDeRendicionController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_filter :authenticate_user!

  # GET /informes_de_rendicion
  def index
  	
    # Verificar los permisos del usuario
    if cannot? :read, InformeDeRendicion
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de addendas
    @informes_de_rendicion =
      InformeDeRendicion.paginate(:page => params[:page], :per_page => 20,
        :order => "updated_at DESC"
      )
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
    @informe_de_rendicion = InformeDeRendicion.new
  end

  def show
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
    @informe_de_rendicion = InformeDeRendicion.find(params[:id])
  end

  def update
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

    if informe_de_rendicion.save!

      puts('SE CREÓ CORRECTAMENTE EL INFORME, AHORA SE VAN A ASOCIAR LOS DETALLES')

      $i = 0
      begin

        detalle_informe_de_rendicion = DetalleInformeDeRendicion.new
        
        #PARAMETROS PARA CREAR LOS DETALLES ASOCIADOS AL NUEVO INFORME DE RENDICION  

        detalle_informe_de_rendicion.informe_de_rendicion_id = informe_de_rendicion.id
        
        detalle_informe_de_rendicion.numero = params[:numeros][$i]
        detalle_informe_de_rendicion.fecha_factura = params[:fechas_factura][$i]
        detalle_informe_de_rendicion.numero_factura = params[:numeros_factura][$i]
        detalle_informe_de_rendicion.detalle = params[:detalles][$i]
        detalle_informe_de_rendicion.cantidad = params[:cantidades][$i]
        detalle_informe_de_rendicion.numero_cheque = params[:numeros_cheque][$i]
        
        detalle_informe_de_rendicion.tipo_de_importe_id = params[:tipos_de_importe][$i]

        detalle_informe_de_rendicion.importe = params[:importes][$i].to_f

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

      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "Hola loco",
          :mensaje => "todo bien?"
        }
      )
      return

  end
end
