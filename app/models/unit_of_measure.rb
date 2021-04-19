module InventoryManagement
  class UnitOfMeasure
    UNITS = { 
      piece: 'piece',
      gallon: 'gallon',
      quart: 'quart',
      pint: 'pint',
      cup: 'cup',
      fluid_once: 'fluid_once',
      tablespoon: 'tablespoon',
      teaspoon: 'teaspoon',
      pound: 'pound',
    }.freeze

    attr_reader :unit

    def initialize(unit)
      @unit = unit
    end
  end
end
