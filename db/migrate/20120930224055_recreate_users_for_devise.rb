class RecreateUsersForDevise < ActiveRecord::Migration
  def change
    # Eliminamos las tablas anteriores
    drop_table :user_groups_users
    drop_table :users

    # Creamos la tabla con la nueva estructura
    create_table :users do |t|
      # Datos controlados por el usuario
      t.string :nombre, :null => false
      t.string :apellido, :null => false
      t.date :fecha_de_nacimiento
      t.references :sexo
      t.text :observaciones

      # Autorización otorgada por un administrador
      t.boolean :authorized, :default => false, :null => false
      t.datetime :authorized_at
      t.integer :authorized_by

      # Campos requeridos por la configuración de la gema 'Devise'

      ## Database authenticatable
      t.string :email, :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Lockable
      t.integer  :failed_attempts, :default => 0
      t.string   :unlock_token
      t.datetime :locked_at
    end

    add_index :users, :email, :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token, :unique => true
    add_index :users, :unlock_token, :unique => true

    create_table :user_groups_users, :id => false do |t|
      t.references :user_group
      t.references :user
      t.integer :creator_id
      t.integer :updater_id
      t.timestamps
    end
    add_index :user_groups_users, [:user_group_id, :user_id], :unique => true
  end

end
