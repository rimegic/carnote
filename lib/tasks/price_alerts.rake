namespace :price_alerts do
  desc "Check for price drops and send notifications"
  task check: :environment do
    puts "Checking price alerts..."
    
    alerts_triggered = 0
    PriceAlert.active.includes(:user, :car).find_each do |alert|
      if alert.car.price <= alert.target_price
        alert.trigger_notification
        alert.update(active: false, triggered_at: Time.current)
        alerts_triggered += 1
        puts "Alert triggered for #{alert.user.email} - #{alert.car.display_name}"
      end
    end
    
    puts "#{alerts_triggered} price alerts triggered."
  end
end