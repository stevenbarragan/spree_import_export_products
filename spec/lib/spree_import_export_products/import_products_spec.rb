require 'spec_helper'

module SpreeImportExportProducts
  describe ImportProducts do
    describe '#parse_file' do
      it 'parse a csv file' do
        file_parsed = subject.parse_file(Rails.root.join('spec','test.csv'))
        expect(file_parsed).to eq [{ name: 'Test name', price: '20', shipping_category_id: '1'}]
      end
    end

    describe '#load' do
      it 'creates a new product' do
        expect do
          subject.load(Rails.root.join('spec','test.csv'))
        end.to change{Spree::Product.count}.from(0).to(1)
      end
    end
  end
end
