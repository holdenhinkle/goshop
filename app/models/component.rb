class Component < ApplicationRecord
  validates_presence_of :name, :description, :min_quantity
  validates :name, uniqueness: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :product_components
  has_many :products, through: :product_components

  has_many :component_product_options
  has_many :product_options, through: :component_product_options, source: :product

  def product_option_ids=(product_option_ids)
    product_option_ids.uniq.each do |id|
      product = Product.find(id)

      if product && product.product_type == 'simple'
        product_options << product
      end
    end
  end
end