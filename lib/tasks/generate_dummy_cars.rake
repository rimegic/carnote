# lib/tasks/generate_dummy_cars.rake
begin
  require 'faker'
rescue LoadError
  # Faker is not available in production
end
require 'open-uri'

namespace :db do
  desc "Generate 20 dummy cars with unique images"
  task generate_dummy_cars: :environment do
    unless defined?(Faker)
      puts "Faker gem is not available. This task is only available in development/test environments."
      exit
    end

    puts "Generating 20 dummy cars..."

    # Ensure there's at least one user to assign cars to
    user = User.first_or_create!(email: "dummy_user@example.com", password: "password", password_confirmation: "password")

    20.times do |i|
      begin
        car = Car.new(
          make: Faker::Vehicle.make,
          model: Faker::Vehicle.model,
          year: Faker::Number.between(from: 2000, to: 2023),
          price: Faker::Commerce.price(range: 10000.0..50000.0),
          mileage: Faker::Number.between(from: 1000, to: 200000),
          color: Faker::Color.color_name,
          description: Faker::Lorem.paragraph(sentence_count: 5),
          user: user # Assign the car to the dummy user
        )

        # Generate a unique image using picsum.photos with a seed
        image_url = "https://picsum.photos/seed/#{Time.now.to_i + i}/600/400"
        
        # Attach the image using open-uri
        downloaded_image = URI.open(image_url)
        car.images.attach(io: downloaded_image, filename: "car_#{i}.jpg", content_type: "image/jpeg")

        if car.save
          puts "Created car: #{car.make} #{car.model} (ID: #{car.id})"
        else
          puts "Failed to create car: #{car.errors.full_messages.to_sentence}"
        end
      rescue OpenURI::HTTPError => e
        puts "Failed to download image from #{image_url}: #{e.message}"
      rescue StandardError => e
        puts "An error occurred: #{e.message}"
      end
    end

    puts "Dummy car generation complete."
  end
end
