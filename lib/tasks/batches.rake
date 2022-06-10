namespace :codes do

  # Change Batch of Codes From CSV Data
  # ===========

  # The CSV file should be formatted like:
  #
  # value,product_id
  # DDB13,52a14bb3d2a0e5ce21000008
  # D34A1,52a14bb3d2a0e5ce21000008
  # B9120,52a14bb3d2a0e5ce21000008
  # 9524E,52a14bb3d2a0e5ce21000008
  # 385F3,52a14bb3d2a0e5ce21000008
  # etc.

  # ``` bash
  # # Create new batches for the codes in the given CSV based on the product id
  # # associated with them.
  # bundle exec rake codes:change_batches  CSV_FILE='first-associations-only.csv' BATCH_NOTE='Code/Batch Re-associations 2014-06-25 (first-associations-only.csv)'
  # ```

  # The above command will take a CSV file called `first-associations-only.csv`
  # that lives in the `data` directory.
  task :change_batches => :environment do
    puts '---------------------------'
    puts "Chipp'd Code/Batch Adjuster"
    puts '---------------------------'
    puts

    filename = ENV['CSV_FILE']
    data_file = Rails.root.join("data/#{filename}").to_s
    data = CSV.read(data_file, :headers => true)
    codes_grouped_by_product_id = data.group_by { |row| row['product_id'] }

    product_ids = codes_grouped_by_product_id.keys.dup

    puts "Taking #{data.length} codes and breaking them into #{product_ids.length} new batches."
    puts

    batch_ids = {}

    puts '=> Creating new batches based on unique product ids in CSV:'
    product_ids.each do |product_id|
      begin
        product = Product.find(product_id)
        batch = Batch.create(:retail => true, :product_id => product_id, :code_count => 1, :notes => ENV['BATCH_NOTE'])
        batch_ids[product_id] = batch.to_param
        print '.'
      rescue
        print 'X'
      end
    end

    puts
    puts

    codes_grouped_by_product_id.each do |product_id, row|
      batch = Batch.find(batch_ids[product_id])
      puts "=> Batch ##{batch.number} <="
      puts "=> Associating codes with batch..."
      codes = row.collect { |r| r['value'] }
      codes.each do |code_value|
        code = Code.where(:value => code_value).first
        code.batch = batch
        code.save
        print '.'
      end
      batch.save
      puts
      puts "=> Writing manifest for batch..."
      BatchManifestWriter.write(batch.to_param)
      puts
    end

    puts '=> Refreshing all batch code counts:'
    Batch.all.each do |b|
      b.code_count = b.codes.length
      b.save
      print '.'
    end
    puts
    puts
    puts 'Done!'
  end

  # Add redeem to all codes that don't have them
  # ===========
  # ``` bash
  # bundle exec rake codes:add_redeems
  # ```
  task :add_redeems => :environment do
    puts '-------------------------------------------------'
    puts "Add redeem value to all codes that don't have one"
    puts '-------------------------------------------------'
    puts

    codes = Code.where(:redeem => nil).all
    puts "=> Adding redeem values to #{codes.length} codes."
    puts

    redeems = CodeRedeemGenerator.call(codes.length)
    codes.each do |code|
      code.update_attribute(:redeem, redeems.pop)
      print '.'
    end

    puts
    puts
    puts 'Done!'
  end

  # Refresh all batch manifests
  # ===========
  # ``` bash
  # bundle exec rake codes:refresh_batch_manifests
  # ```
  task :refresh_batch_manifests => :environment do
    puts '---------------------------'
    puts "Refresh All Batch Manifests"
    puts '---------------------------'
    puts

    puts '=> Refreshing all batch manifests:'
    puts
    Batch.all.each do |batch|
      BatchManifestWriter.write(batch.to_param)
      print '.'
    end
    puts
    puts
    puts 'Done!'
  end
end