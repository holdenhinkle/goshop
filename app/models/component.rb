class Component < ApplicationRecord
  validates_presence_of :name, :description, :min_quantity
  validates :name, uniqueness: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :product_components
  has_many :composite_products, through: :product_components, source: :composite

  has_many :component_product_options
  has_many :options, through: :component_product_options, source: :product

  def product_option_ids=(product_option_ids)
    product_option_ids.uniq.each do |id|
      product = Simple.find(id)
      options << product if product && product_not_an_option?(product)
    end
  end

  private
  
  def product_not_an_option?(product)
    options.none? { |option| option.name == product.name}
  end
end