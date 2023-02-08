require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end

  describe 'instance methods' do
    describe '.check_invoice' do
      it 'is triggered before destroy' do
        invoice_item = create(:invoice_item)
        expect(invoice_item).to receive(:check_invoice)
        invoice_item.destroy
      end

      it 'destroys parent invoice if only invoice item left' do
        items = create_list(:item, 2)
        invoice = create(:invoice)
        create(:invoice_item, item: items[0], invoice: invoice)
        create_list(:invoice_item, 2, item: items[1], invoice: invoice)
  
        items[0].destroy
  
        expect(Invoice.count).to eq(1)
  
        items[1].destroy
  
        expect(Invoice.count).to eq(0)
      end
    end
  end
end
