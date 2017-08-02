class AddAttachmentArchivoToArchivos < ActiveRecord::Migration
  def self.up
    change_table :archivos do |t|
      t.attachment :archivo
    end
  end

  def self.down
    remove_attachment :archivos, :archivo
  end
end
