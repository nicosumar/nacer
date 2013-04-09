# -*- encoding : utf-8 -*-
class EfectoresController < ApplicationController
  before_filter :authenticate_user!

  # GET /efectores
  def index
    # Verificar los permisos del usuario
    if cannot? :read, Efector
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el listado de efectores
    @efectores =
      Efector.paginate(:page => params[:page], :per_page => 20,
        :include => [:convenio_de_gestion, :convenio_de_administracion, :convenio_de_gestion_sumar,
          :convenio_de_administracion_sumar
        ], :order => :cuie
      )
  end

  # GET /efectores/:id
  def show
    # Verificar los permisos del usuario
    if cannot? :read, Efector
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el efector
    begin
      @efector =
        Efector.find(params[:id],
          :include => [:departamento, :distrito, :convenio_de_gestion, :convenio_de_administracion,
            :convenio_de_gestion_sumar, :convenio_de_administracion_sumar
          ]
        )
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

  # GET /efectores/new
  def new
    # Verificar los permisos del usuario
    if cannot? :create, Efector
      redirect_to(root_url,
        :flash => {:tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para la vista
    @efector = Efector.new
    @departamentos = Departamento.de_esta_provincia.collect{ |d| [d.nombre_corto, d.id] }
    @distritos = []
    @grupos_de_efectores = GrupoDeEfectores.find(:all).collect{ |g| [g.nombre_corto, g.id] }
    @areas_de_prestacion = AreaDePrestacion.find(:all).collect{ |a| [a.nombre_corto, a.id] }
    @dependencias_administrativas = DependenciaAdministrativa.find(:all).collect{ |d| [d.nombre_corto, d.id] }
  end

  # GET /efectores/:id/edit
  def edit
    # Verificar los permisos del usuario
    if cannot? :update, Efector
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el efector
    begin
      @efector = Efector.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos necesarios para generar la vista
    @departamentos = Departamento.de_esta_provincia.collect{ |d| [d.nombre_corto, d.id] }
    @distritos = Distrito.where(:departamento_id => @efector.departamento_id).collect{ |d| [d.nombre_corto, d.id] }
    @grupos_de_efectores = GrupoDeEfectores.find(:all).collect{ |g| [g.nombre_corto, g.id] }
    @areas_de_prestacion = AreaDePrestacion.find(:all).collect{ |a| [a.nombre_corto, a.id] }
    @dependencias_administrativas = DependenciaAdministrativa.find(:all).collect{ |d| [d.nombre_corto, d.id] }
  end

  # POST /efectores
  def create
    # Verificar los permisos del usuario
    if cannot? :create, Efector
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:efector]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Guardar el CUIE ingresado (si existe) ya que no puede asignarse en forma masiva
    cuie = params[:efector].delete(:cuie)

    # Crear un nuevo convenio desde los parámetros
    @efector = Efector.new(params[:efector])

    # Establecer el CUIE si se pasó el parámetro
    @efector.cuie = cuie unless cuie.blank?

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @departamentos = Departamento.de_esta_provincia.collect{ |d| [d.nombre_corto, d.id] }
    @distritos = Distrito.where(:departamento_id => @efector.departamento_id).collect{ |d| [d.nombre_corto, d.id] }
    @grupos_de_efectores = GrupoDeEfectores.find(:all).collect{ |g| [g.nombre_corto, g.id] }
    @areas_de_prestacion = AreaDePrestacion.find(:all).collect{ |a| [a.nombre_corto, a.id] }
    @dependencias_administrativas = DependenciaAdministrativa.find(:all).collect{ |d| [d.nombre_corto, d.id] }

    # Verificar la validez del objeto
    if @efector.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @efector.departamento_id && !@departamentos.collect{ |i| i[1] }.member?(@efector.departamento_id) ||
           @efector.distrito_id && !@distritos.collect{ |i| i[1] }.member?(@efector.distrito_id) ||
           @efector.grupo_de_efectores_id && !@grupos_de_efectores.collect{ |i| i[1] }.member?(@efector.grupo_de_efectores_id) ||
           @efector.area_de_prestacion_id && !@areas_de_prestacion.collect{ |i| i[1] }.member?(@efector.area_de_prestacion_id) ||
           @efector.dependencia_administrativa_id &&
           !@dependencias_administrativas.collect{ |i| i[1] }.member?(@efector.dependencia_administrativa_id) )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la creación
      @efector.creator_id = current_user.id
      @efector.updater_id = current_user.id

      # Guardar el nuevo efector
      @efector.save
      redirect_to(@efector,
        :flash => { :tipo => :ok, :titulo => 'El efector se creó correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "new"
    end
  end

  # PUT /convenios_de_gestion/:id
  def update
    # Verificar los permisos del usuario
    if cannot? :update, Efector
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que la petición contenga los parámetros esperados
    if !params[:efector]
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre el incidente."
        }
      )
      return
    end

    # Obtener el efector
    begin
      @efector = Efector.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Guardar el CUIE ingresado si aún no se le había asignado uno al efector
    cuie = params[:efector].delete(:cuie) if @efector.cuie.blank?

    # Actualizar los valores de los atributos para validar el registro antes de guardarlo
    @efector.attributes = params[:efector]

    # Establecer el CUIE si se pasó el parámetro
    @efector.cuie = cuie unless cuie.blank?

    # Crear los objetos necesarios para regenerar la vista si hay algún error
    @departamentos = Departamento.de_esta_provincia.collect{ |d| [d.nombre_corto, d.id] }
    @distritos = Distrito.where(:departamento_id => @efector.departamento_id).collect{ |d| [d.nombre_corto, d.id] }
    @grupos_de_efectores = GrupoDeEfectores.find(:all).collect{ |g| [g.nombre_corto, g.id] }
    @areas_de_prestacion = AreaDePrestacion.find(:all).collect{ |a| [a.nombre_corto, a.id] }
    @dependencias_administrativas = DependenciaAdministrativa.find(:all).collect{ |d| [d.nombre_corto, d.id] }

    # Verificar la validez del objeto
    if @efector.valid?
      # Verificar que las selecciones de los parámetros coinciden con los valores permitidos
      if ( @efector.departamento_id && !@departamentos.collect{ |i| i[1] }.member?(@efector.departamento_id) ||
           @efector.distrito_id && !@distritos.collect{ |i| i[1] }.member?(@efector.distrito_id) ||
           @efector.grupo_de_efectores_id && !@grupos_de_efectores.collect{ |i| i[1] }.member?(@efector.grupo_de_efectores_id) ||
           @efector.area_de_prestacion_id && !@areas_de_prestacion.collect{ |i| i[1] }.member?(@efector.area_de_prestacion_id) ||
           @efector.dependencia_administrativa_id &&
           !@dependencias_administrativas.collect{ |i| i[1] }.member?(@efector.dependencia_administrativa_id) )
        redirect_to(root_url,
          :flash => { :tipo => :error, :titulo => "La petición no es válida",
            :mensaje => "Se informará al administrador del sistema sobre este incidente."
          }
        )
        return
      end

      # Registrar el usuario que realiza la modificación
      @efector.updater_id = current_user.id

      # Guardar el efector
      @efector.save
      redirect_to(@efector,
        :flash => {:tipo => :ok, :titulo => 'Las modificaciones al efector se guardaron correctamente.' }
      )
    else
      # Si no pasa las validaciones, volver a mostrar el formulario con los errores
      render :action => "edit"
    end
  end

  # GET /efectores/:id/prestaciones_autorizadas
  def prestaciones_autorizadas
    # Verificar los permisos del usuario
    if cannot? :read, PrestacionAutorizada
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el efector
    begin
      @efector =
        Efector.find(params[:id], :include => { :prestaciones_autorizadas => [:autorizante_al_alta, :prestacion] })
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Verificar que el efector tenga un convenio de gestión suscrito
    if !@efector.convenio_de_gestion_sumar && !@efector.convenio_de_gestion
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end
  end

  # GET /efectores/:id/referentes
  def referentes
    # Verificar los permisos del usuario
    if cannot? :read, Referente
      redirect_to( root_url,
        :flash => { :tipo => :error, :titulo => "No está autorizado para acceder a esta página",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Obtener el efector
    begin
      @efector =
        Efector.find(params[:id], :include => { :referentes => :contacto })
    rescue ActiveRecord::RecordNotFound
      redirect_to(root_url,
        :flash => { :tipo => :error, :titulo => "La petición no es válida",
          :mensaje => "Se informará al administrador del sistema sobre este incidente."
        }
      )
      return
    end

    # Crear los objetos para la vista
    @referentes = @efector.referentes
  end

end
