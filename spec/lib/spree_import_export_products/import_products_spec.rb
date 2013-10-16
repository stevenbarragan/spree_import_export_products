require 'spec_helper'

module SpreeImportExportProducts
  describe ImportProducts do
    describe '#parse_file' do
      it 'parse a csv file' do
        subject.parse_file(Rails.root.join('spec','test.csv'))
        expect(subject.instance_variable_get(:@products)).to eq [{ name: 'Test name', price: '20', shipping_category_id: '1'}]
        expect(subject.instance_variable_get(:@associations)).to eq [{ taxons: 'brand:test_brand'}]
      end
    end

    describe '#load' do
      it 'creates a new product' do
        expect do
          subject.load(Rails.root.join('spec','test.csv'))
        end.to change{Spree::Product.count}.from(0).to(1)
      end
    end

    describe '#create_taxon' do
      let(:product){ FactoryGirl.create :product }

      before do
        subject.create_taxon([product], 'brand:test_brand')
      end

      it 'creates a taxonomy' do
        expect(Spree::Taxonomy.count).to eq 1
      end

      it 'creates a taxon' do
        expect(Spree::Taxon.count).to eq 1
      end
    end
  end
end
