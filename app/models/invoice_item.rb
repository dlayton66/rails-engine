class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  before_destroy :check_invoice
  after_destroy :destroy_invoice, if: -> { @invoice }

  private

    def check_invoice
      if invoice.invoice_items.count == 1
        @invoice = invoice
      end
    end

    def destroy_invoice
      @invoice.destroy
    end
end
