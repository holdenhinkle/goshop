class Product < ApplicationRecord
  acts_as_tenant :account
  # To-do:
  # Delete sales_price_currency or sale_price_currency. Which is correct?

  # enum unit_of_measure: InventoryManagement::UnitOfMeasure::UNITS, _prefix: :unit

  enum unit_of_measure: { 
    piece: 'piece',
    gallon: 'gallon',
    quart: 'quart',
    pint: 'pint',
    cup: 'cup',
    fluid_once: 'fluid_once',
    tablespoon: 'tablespoon',
    teaspoon: 'teaspoon',
    pound: 'pound',
  }, _prefix: :type

  monetize :regular_price_cents
  monetize :sale_price_cents, allow_nil: true

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :product_categories
  has_many :categories, through: :product_categories

  validates_presence_of :name, :description, :type, :regular_price_cents, :unit_of_measure, :categories
  validates_uniqueness_to_tenant :name
  validates :regular_price_cents, numericality: { greater_than: 0 }

  def category_slugs(slugs)
    categories = slugs.map { |slug| Category.find_by(slug: slug) }
                      .filter { |category| category }

    self.categories << categories if categories.present?
  end

  def component_slugs(slugs)
    components = slugs.map { |slug| Component.find_by(slug: slug) }
                      .filter { |component| component }

    self.components << components if components.present?
  end

  # if you try to create a new category with a category name that already exists
  # a relationship with the existing category of the same name is created.
  # a new category is not created.
  def categories_attributes=(category_attributes)
    nested_attributes(nested_attributes: category_attributes,
                      model: Category,
                      collection: categories)
  end

  # def unit_of_measure
  #   @unit_of_measure ||= InventoryManagement::UnitOfMeasure.new(read_attribute(:unit_of_measure))
  # end

  private

  def nested_attributes(nested_attributes:, model:, collection:)
    nested_attributes.each do |attributes|
      name = attributes[:name]

      if record = model.find_by(name: name)
        collection << record unless collection.map { |c| c[:name] }.include?(name)
      else
        collection << model.create(attributes)
      end
    end
  end
end