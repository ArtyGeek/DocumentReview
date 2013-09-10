class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :document_id
      t.string :integer

      t.timestamps
    end
  end
end
