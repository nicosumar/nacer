# -*- encoding : utf-8 -*-
Nacer::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w(  
    entradas.css efectores.js novedades_de_los_afiliados.js users_sign_in.js verificacion.js prestaciones_ajax.js reportes.js auto_grow_input.js
    jquery.chained.min.js liquidacion_sumar.js ver_prestaciones_liquidadas.js convenios_de_gestion_sumar.js convenios_de_administracion_sumar.js
    liquidaciones_informes.js liquidaciones_sumar_anexos_administrativos.js liquidaciones_sumar_anexos_medicos.js informes.js notas_de_debito.js
    detalles_de_debitos_prestacionales.js block_ui_sumar.js documentos_electronicos.js documentos_generables_por_conceptos.js jquery.blockUI.min.js
    jstree.min.js jstree/style.min.css efectores_form.js prestaciones/_form.js prestaciones/_index.js addendas_sumar/_form_masivo.js prestaciones_principales/_form.js
    asistentes_taller.js
  )

  # Enable delivery errors
  config.action_mailer.raise_delivery_errors = true

  # SMTP server configuration
  config.action_mailer.smtp_settings = {
    :address => "",
    :domain => "",
    :user_name => "",
    :password => "",
    :authentication => "login",
    :enable_starttls_auto => false
  }

  # Default URL for application links written into mails (needed for Devise)
  config.action_mailer.default_url_options = { :host => "" }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  Paperclip::Attachment.default_options[:path] = ":rails_root/public:url"
  Paperclip::Attachment.default_options[:url] = "/paperclip/:hash.:extension" 
  Paperclip::Attachment.default_options[:hash_secret] = "PasswordEjemplo"

end
