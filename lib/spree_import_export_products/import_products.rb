require 'csv'

module SpreeImportExportProducts
  class ImportProducts
    def initialize
      @association_keys = [:taxons]
      @products = []
      @associations = []
    end

    def parse_file(file)
      csv = CSV.read(file)
      head = csv.shift.map{ |key| key.to_sym }

      csv.each do |row|
        hash = Hash[head.zip(row)]
        @products << hash.select{ |key,value| !@association_keys.include?(key) }
        @associations << hash.select{ |key,value| @association_keys.include?(key) }
      end
    end

    def load(file)
      parse_file(file)
      Spree::Product.create(@products)
    end

    def load_associations(products)
      products.each_with_index do |product,index|
        @associations[index].each do |association|
          send("create_#{association.keys.first}(product,association.values.first)")
        end
      end
    end

    def create_taxon(products, association)
      products.each do |product|
        taxonomy_name,taxon_name = association.split(':')
        taxonomy = Spree::Taxonomy.find_by_name(taxonomy_name) || Spree::Taxonomy.create(name: taxonomy_name)
        product.taxons << Spree::Taxon.create(name: taxon_name, taxonomy_id: taxonomy.id)
      end
    end
  end
end
