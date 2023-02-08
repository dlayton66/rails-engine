class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  before_destroy :check_invoice

  private

    def check_invoice
      if invoice.invoice_items.count == 1
        invoice.destroy
      end
    end
end
