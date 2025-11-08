# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "🗑️  Limpando banco de dados..."
CartItem.destroy_all
Cart.destroy_all
Product.destroy_all

puts "📦 Criando produtos..."
products = [
  { name: "Notebook Dell Inspiron", price: 3500.00 },
  { name: "Mouse Logitech MX Master", price: 450.00 },
  { name: "Teclado Mecânico Keychron", price: 650.00 },
  { name: "Monitor LG 27 polegadas", price: 1200.00 },
  { name: "Webcam Logitech C920", price: 380.00 },
  { name: "Headset HyperX Cloud", price: 420.00 },
  { name: "SSD Samsung 1TB", price: 580.00 },
  { name: "Mousepad Gamer RGB", price: 89.90 }
]

products.each do |product_data|
  Product.create!(product_data)
end

puts "✅ #{Product.count} produtos criados!"
puts "\n📋 Lista de produtos:"
Product.all.each do |p|
  puts "  - #{p.name}: #{p.formatted_price}"
end
