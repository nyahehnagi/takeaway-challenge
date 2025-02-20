require_relative '../lib/order_manager'
require 'time'

describe OrderManager do

# Mock Dishes 
  let(:dish_one) { double(:dish_one, :name => "Spagbol", :price => 7.5) }
  let(:dish_class) { double(:dish_class, :new => dish_one) }

# Mock Menu
  let(:formatted_menu) { "Curry, Price: £6.50\nSpagbol, Price: £7.50\nCottage Pie, Price: £8.00" }
  let(:menu) { double(:menu, :select_dish => dish_one, :show_menu => formatted_menu, :load_menu => nil) }
  let(:menu_class) { double(:menu_class, :new => menu) }
  let(:menu_file) { double() }

# Mock Order
  let(:order) { double(:order, :order_dish => nil, :show_order => "Dish: Spagbol, Qty: 2\nDish: Cottage Pie, Qty: 1\nTotal Price: £23.00") }
  let(:order_class) { double(:order_class, :new => order) }
  let(:ordered_dishes) { "Spagbol,2,Cottage Pie,1" }

  subject(:order_manager) { described_class.new(menu_file, menu_class, order_class, dish_class) }

  describe "creates an order from a string input" do
    it "generates an order" do
      expect(order_manager.generate_order(ordered_dishes)).to eq order
    end

    it "creates a nil object if string empty" do
      expect(order_manager.generate_order("")).to be_nil
    end
  end

  describe "#order_history" do
    it "shows the order history" do
      order_manager.generate_order(ordered_dishes)
      expect(order_manager.order_history).to eq [order]
    end
  end

  describe "#initialise_menu" do
    it "creates the menu" do
      expect{ order_manager.initialise_menu("test") }.to_not raise_error
    end
  end

  describe "#load_remote_orders" do
    it "gets orders from database" do
      remote_order_file = "remote_orders.txt"
      allow(File).to receive(:read).and_return("Spagbol,2,Cottage Pie,1\n")
      expect(order_manager.load_remote_orders(remote_order_file)).to eq "Spagbol,2,Cottage Pie,1\n"
    end
  end
end
