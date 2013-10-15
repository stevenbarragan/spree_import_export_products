require 'CSV'

module SpreeImportExportProducts
  class ImportProducts
    def initilize
      @associations_keys = [:taxons]
    end

    def parse_file(file)
      csv = CSV.read(file)
      head = csv.shift.map{ |key| key.to_sym }
      @product = []
      @associations = []
      csv.each do |row|
        hash = Hash[head.zip(row)]
        @products << hash.select{ |key,value| !@associations_keys.include?(key) }
        @associations << hash.select{ |key,value| @associations_keys.include?(key) }
      end
    end

    def load(file)
      parse_file(file)
      products = Spree::Product.create(@products)
      products.each_with_index do |index,product|
        @associations[index].each do |association|
          association.each do |key,value|
            parent, value = value.split ':'
            if value
              taxonomy_id = Spree::Taxonomy.find_or_create(parent)
              product.taxons << Spree::Taxon.create taxonomy_id: taxonomy_id, name: value
            else
              product.update key,elements[0]
            end
          end
        end
      end
    end
  end
end
